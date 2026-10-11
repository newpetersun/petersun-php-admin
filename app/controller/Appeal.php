<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 违规申诉控制器
 *
 * 创作者对被处罚的内容发起申诉；status：processing 处理中 / approved 通过 / rejected 驳回。
 * 仅 processing 状态可撤销。
 */
class Appeal extends BaseController
{
    private const STATUS_TEXT = [
        'processing' => '处理中',
        'approved'   => '已通过',
        'rejected'   => '已驳回',
    ];

    /** 申诉列表 */
    public function list(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $status = trim((string) $request->param('status', ''));
            if ($status !== '' && !isset(self::STATUS_TEXT[$status])) {
                return json(['code' => 400, 'message' => '状态值不正确']);
            }
            [$page, $limit] = $this->paging($request);

            $where = [['user_id', '=', $uid]];
            if ($status !== '') {
                $where[] = ['status', '=', $status];
            }

            $rows = Db::name('appeals')->where($where)
                ->order('create_time', 'desc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            $list = [];
            foreach ($rows->items() as $r) {
                $list[] = [
                    'id'           => $r['id'],
                    'post'         => (string) $r['target_title'],
                    'targetId'     => (string) $r['target_id'],
                    'type'         => (string) $r['reason'],
                    'punish'       => (string) $r['punish'],
                    'description'  => (string) ($r['description'] ?? ''),
                    'submittedAt'  => (string) $r['create_time'],
                    'state'        => (string) $r['status'],
                    'stateText'    => self::STATUS_TEXT[(string) $r['status']] ?? '',
                    'result'       => (string) ($r['result'] ?? ''),
                    'canCancel'    => (string) $r['status'] === 'processing',
                ];
            }

            return $this->ok(['list' => $list, 'total' => $rows->total(), 'page' => $page, 'limit' => $limit]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /**
     * 发起申诉
     * @param target_id    被处罚内容ID
     * @param reason       违规类型 / 申诉理由
     * @param punish       处罚措施
     * @param description  补充说明
     */
    public function create(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $targetId    = trim((string) $request->param('target_id', ''));
            $reason      = trim((string) $request->param('reason', ''));
            $punish      = trim((string) $request->param('punish', ''));
            $description = trim((string) $request->param('description', ''));

            if ($targetId === '') {
                return json(['code' => 400, 'message' => '请选择申诉内容']);
            }
            if ($reason === '') {
                return json(['code' => 400, 'message' => '请填写违规类型或申诉理由']);
            }
            if (mb_strlen($reason) > 500) {
                return json(['code' => 400, 'message' => '申诉理由不能超过500个字符']);
            }
            if ($punish === '') {
                return json(['code' => 400, 'message' => '请填写处罚措施']);
            }

            $article = Db::name('forum_posts')->where('id', $targetId)->find();
            if (!$article) {
                return json(['code' => 404, 'message' => '申诉内容不存在']);
            }
            if ($article['user_id'] !== $uid) {
                return json(['code' => 403, 'message' => '只能对自己的内容发起申诉']);
            }

            // 同一内容仅允许一条处理中的申诉
            $exists = Db::name('appeals')->where('user_id', $uid)
                ->where('target_id', $targetId)->where('status', 'processing')->count();
            if ($exists > 0) {
                return json(['code' => 400, 'message' => '该内容已有处理中的申诉，请等待结果']);
            }

            $id = uuid();
            Db::name('appeals')->insert([
                'id'           => $id,
                'user_id'      => $uid,
                'target_type'  => $article['type'] === 'video' ? 'video' : 'post',
                'target_id'    => $targetId,
                'target_title' => (string) $article['title'],
                'punish'       => $punish,
                'reason'       => $reason,
                'description'  => $description !== '' ? mb_substr($description, 0, 1000) : null,
                'status'       => 'processing',
                'create_time'  => date('Y-m-d H:i:s'),
            ]);

            return $this->ok(['id' => $id], '申诉已提交，请等待处理');
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 撤销申诉（仅处理中可撤销） */
    public function cancel(Request $request, $id): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $row = Db::name('appeals')->where('id', $id)->find();
            if (!$row) {
                return json(['code' => 404, 'message' => '申诉记录不存在']);
            }
            if ($row['user_id'] !== $uid) {
                return json(['code' => 403, 'message' => '无权撤销该申诉']);
            }
            if ($row['status'] !== 'processing') {
                return json(['code' => 400, 'message' => '仅处理中的申诉可撤销']);
            }

            Db::name('appeals')->where('id', $id)->delete();

            return $this->ok(null, '申诉已撤销');
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 可申诉的内容列表（本人已发布内容） */
    public function targetList(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $rows = Db::name('forum_posts')->where('user_id', $uid)
                ->whereIn('status', ['approved', 'offline', 'rejected'])
                ->field('id, title, type, status')
                ->order('update_time', 'desc')
                ->limit(50)
                ->select()
                ->toArray();

            $list = [];
            foreach ($rows as $r) {
                $list[] = [
                    'id'    => $r['id'],
                    'title' => (string) $r['title'],
                    'type'  => $r['type'],
                ];
            }

            return $this->ok($list);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    // ========================================================
    // 内部方法
    // ========================================================

    /** 当前登录用户ID */
    private function uid(Request $request): string
    {
        return (string) ($request->userId ?? '');
    }

    /** 分页参数 [page, limit] */
    private function paging(Request $request): array
    {
        $page  = max(1, (int) $request->param('page', 1));
        $limit = min(50, max(1, (int) $request->param('limit', 10)));
        return [$page, $limit];
    }

    /** 统一成功响应 */
    private function ok($data = null, string $message = '获取成功'): Response
    {
        return json(['code' => 200, 'message' => $message, 'data' => $data]);
    }

    /** 统一异常响应 */
    private function err(\Exception $e): Response
    {
        return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
    }
}
