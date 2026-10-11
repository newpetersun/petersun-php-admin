<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 用户认证控制器
 */
class Certification extends BaseController
{
    // 允许的认证类型
    private const TYPES = ['personal', 'enterprise', 'official'];

    /**
     * 提交认证申请（需登录）
     */
    public function submit(Request $request): Response
    {
        try {
            $userId = $request->userId;
            $type = $request->param('type', '');
            $certName = trim($request->param('cert_name', ''));
            $description = trim($request->param('description', ''));
            $materials = $request->param('materials', []);

            // 验证认证类型
            if (!in_array($type, self::TYPES, true)) {
                return json(['code' => 400, 'message' => '认证类型不正确']);
            }

            // 验证认证名称
            if ($certName === '') {
                return json(['code' => 400, 'message' => '认证名称不能为空']);
            }
            if (mb_strlen($certName) > 100) {
                return json(['code' => 400, 'message' => '认证名称不能超过100个字符']);
            }

            // 验证认证简介
            if (mb_strlen($description) > 200) {
                return json(['code' => 400, 'message' => '认证简介不能超过200个字符']);
            }

            // 验证证明材料（最多3张）
            if (!is_array($materials)) {
                $materials = [];
            }
            $materials = array_values(array_filter(array_slice($materials, 0, 3)));
            $materialsJson = json_encode($materials, JSON_UNESCAPED_SLASHES);

            // 实名信息：个人认证需姓名+身份证号，企业认证需企业名+统一社会信用代码
            $realName    = trim((string) $request->param('real_name', ''));
            $idCard      = trim((string) $request->param('id_card', ''));
            $companyName = trim((string) $request->param('company_name', ''));
            $licenseNo   = trim((string) $request->param('license_no', ''));

            if ($type === 'personal') {
                if ($realName === '') {
                    return json(['code' => 400, 'message' => '请填写真实姓名']);
                }
                if ($idCard === '') {
                    return json(['code' => 400, 'message' => '请填写身份证号']);
                }
                if (!preg_match('/^\d{17}[\dXx]$/', $idCard)) {
                    return json(['code' => 400, 'message' => '身份证号格式不正确']);
                }
            }
            if ($type === 'enterprise' && ($companyName === '' || $licenseNo === '')) {
                return json(['code' => 400, 'message' => '请填写企业名称与统一社会信用代码']);
            }

            // 存在进行中的申请（待审核/已通过）时禁止重复提交
            $existing = Db::name('user_certifications')
                ->where('user_id', $userId)
                ->whereIn('status', ['pending', 'approved'])
                ->find();

            if ($existing) {
                $message = $existing['status'] === 'pending' ? '已有待审核的认证申请' : '您已通过认证，无需重复申请';
                return json(['code' => 400, 'message' => $message]);
            }

            $result = Db::name('user_certifications')->insert([
                'id'            => uuid(),
                'user_id'       => $userId,
                'type'          => $type,
                'cert_name'     => $certName,
                'status'        => 'pending',
                'real_name'     => $realName,
                'id_card'       => $idCard,
                'company_name'  => $companyName,
                'license_no'    => $licenseNo,
                'contact_phone' => $request->param('contact_phone', ''),
                'materials'     => $materialsJson,
                'description'   => $description,
                'create_time'   => date('Y-m-d H:i:s'),
                'update_time'   => date('Y-m-d H:i:s')
            ]);

            if ($result) {
                return json(['code' => 200, 'message' => '认证申请提交成功']);
            }
            return json(['code' => 500, 'message' => '认证申请提交失败']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 我的认证申请（需登录）
     */
    public function mine(Request $request): Response
    {
        try {
            $userId = $request->userId;

            $record = Db::name('user_certifications')
                ->where('user_id', $userId)
                ->order('create_time', 'desc')
                ->find();

            if (!$record) {
                return json(['code' => 200, 'message' => '获取成功', 'data' => null]);
            }

            $record['materials'] = json_decode($record['materials'] ?: '[]', true) ?: [];

            return json(['code' => 200, 'message' => '获取成功', 'data' => $record]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 按 userId 查询某用户的认证状态与类型（公开，用于主页徽章展示）
     */
    public function status(Request $request): Response
    {
        try {
            $userId = $request->param('user_id', '');
            if (empty($userId)) {
                return json(['code' => 400, 'message' => '缺少用户ID']);
            }

            $cert = Db::name('user_certifications')
                ->where('user_id', $userId)
                ->order('create_time', 'desc')
                ->field('type, status')
                ->find();

            $data = $cert
                ? ['type' => $cert['type'], 'status' => $cert['status']]
                : ['type' => '', 'status' => 'none'];

            return json(['code' => 200, 'message' => '获取成功', 'data' => $data]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 认证申请列表（后台；支持 status 筛选 pending/approved/rejected/all）
     */
    public function list(Request $request): Response
    {
        try {
            $status = $request->param('status', '');
            $page = (int)$request->param('page', 1);
            $limit = (int)$request->param('limit', 10);

            $where = [];
            if ($status && $status !== 'all') {
                $where[] = ['c.status', '=', $status];
            }

            $query = Db::name('user_certifications')->alias('c')
                ->leftJoin('users u', 'u.id = c.user_id')
                ->field('c.*, u.nickname as user_name, u.avatar as user_avatar')
                ->where($where);

            $paginate = $query->order('c.create_time', 'desc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            $list = $paginate->items();
            foreach ($list as &$item) {
                $item['materials'] = json_decode($item['materials'] ?: '[]', true) ?: [];
            }

            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list' => $list,
                    'total' => $paginate->total(),
                    'page' => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 审核认证申请（通过 / 驳回）
     */
    public function review(Request $request): Response
    {
        try {
            $id = $request->param('id', '');
            $action = $request->param('action', '');
            $reason = trim($request->param('reason', ''));

            if (empty($id)) {
                return json(['code' => 400, 'message' => '缺少申请ID']);
            }
            if (!in_array($action, ['approve', 'reject'], true)) {
                return json(['code' => 400, 'message' => '操作类型不正确']);
            }
            if ($action === 'reject' && $reason === '') {
                return json(['code' => 400, 'message' => '请填写驳回原因']);
            }

            $status = $action === 'approve' ? 'approved' : 'rejected';
            Db::name('user_certifications')->where('id', $id)->update([
                'status'        => $status,
                'reject_reason' => $action === 'reject' ? $reason : null,
                'audit_time'    => date('Y-m-d H:i:s'),
                'update_time'   => date('Y-m-d H:i:s')
            ]);

            return json([
                'code' => 200,
                'message' => $action === 'approve' ? '已通过认证' : '已驳回申请'
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
