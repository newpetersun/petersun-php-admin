<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use app\service\NotificationService;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 后台审核：封面审核 / 资料审核
 * （从 User.php 拆分，职责单一化）
 */
class UserReviewAdmin extends BaseController
{
    /**
     * 后台：封面审核列表（user_covers）
     */
    public function coverList(Request $request): Response
    {
        try {
            $status  = $request->param('status', 'all');
            $keyword = $request->param('keyword', '');
            $page    = (int) $request->param('page', 1);
            $limit   = (int) $request->param('limit', 10);

            $query = Db::name('user_covers')->alias('c')
                ->leftJoin('users u', 'u.id = c.user_id')
                ->field('c.id, c.user_id, c.image, c.status, c.reject_reason, c.create_time, u.nickname as user_name, u.avatar as user_avatar');

            if ($status && $status !== 'all') {
                $query->where('c.status', $status);
            }
            if ($keyword) {
                $query->where('u.nickname', 'like', "%$keyword%");
            }

            $list = $query->order('c.create_time', 'desc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => [
                    'list'  => $list->items(),
                    'total' => $list->total(),
                    'page'  => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 后台：封面审核通过 / 驳回
     */
    public function coverReview(Request $request): Response
    {
        try {
            $coverId = $request->param('cover_id', '');
            $action  = $request->param('action', '');
            $reason  = $request->param('reason', '');

            if (!$coverId || !in_array($action, ['approve', 'reject'])) {
                return json(['code' => 400, 'message' => '参数错误']);
            }
            $cover = Db::name('user_covers')->where('id', $coverId)->find();
            if (!$cover) {
                return json(['code' => 404, 'message' => '封面记录不存在']);
            }

            if ($action === 'approve') {
                Db::name('user_covers')->where('id', $coverId)->update([
                    'status'      => 'approved',
                    'audit_time'  => date('Y-m-d H:i:s'),
                    'update_time' => date('Y-m-d H:i:s')
                ]);
                $msg = '已通过';
                // 通知封面所属用户（隔离异常，失败不影响审核）
                try {
                    (new NotificationService())->systemNotify((string) $cover['user_id'], '封面审核已通过', '你的封面已通过审核并展示');
                } catch (\Throwable $e) {
                }
            } else {
                if (!$reason) {
                    return json(['code' => 400, 'message' => '请填写驳回原因']);
                }
                Db::name('user_covers')->where('id', $coverId)->update([
                    'status'        => 'rejected',
                    'reject_reason' => $reason,
                    'audit_time'    => date('Y-m-d H:i:s'),
                    'update_time'   => date('Y-m-d H:i:s')
                ]);
                $msg = '已驳回';
                try {
                    (new NotificationService())->systemNotify((string) $cover['user_id'], '封面审核未通过', '驳回原因：' . $reason);
                } catch (\Throwable $e) {
                }
            }

            return json(['code' => 200, 'message' => $msg]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 后台：资料审核列表（users.profile_status + 待审快照）
     */
    public function profileReviewList(Request $request): Response
    {
        try {
            $status  = $request->param('status', 'pending');
            $keyword = $request->param('keyword', '');
            $page    = (int) $request->param('page', 1);
            $limit   = (int) $request->param('limit', 10);

            $where = [];
            if ($status && $status !== 'all') {
                $where[] = ['u.profile_status', '=', $status];
            }
            if ($keyword) {
                $where[] = ['u.nickname', 'like', "%$keyword%"];
            }

            $rows = Db::name('users')->alias('u')
                ->leftJoin('user_profile_pending p', 'p.user_id = u.id')
                ->where($where)
                ->field([
                    'u.id', 'u.nickname as current_nickname', 'u.avatar as current_avatar',
                    'u.gender as current_gender', 'u.profile_status', 'u.profile_reject_reason',
                    'u.profile_audit_time',
                    'p.nickname as new_nickname', 'p.avatar as new_avatar', 'p.gender as new_gender',
                    'p.country as new_country', 'p.province as new_province', 'p.city as new_city',
                    'p.code_age as new_code_age', 'p.address as new_address',
                    'p.github as new_github', 'p.web_url as new_web_url',
                    'p.status as pending_status', 'p.reject_reason as pending_reason',
                    'p.create_time as submit_time'
                ])
                ->order('p.create_time', 'desc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => [
                    'list'  => $rows->items(),
                    'total' => $rows->total(),
                    'page'  => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 后台：资料审核通过 / 驳回
     * 通过：将待审快照覆盖到 users，资料对外生效；
     * 驳回：标记 users.profile_status=rejected 并记录原因（users 资料保持原样）。
     */
    public function profileReview(Request $request): Response
    {
        try {
            $userId = $request->param('user_id', '');
            $action = $request->param('action', '');
            $reason = $request->param('reason', '');

            if (!$userId || !in_array($action, ['approve', 'reject'])) {
                return json(['code' => 400, 'message' => '参数错误']);
            }
            $user = Db::name('users')->where('id', $userId)->find();
            if (!$user) {
                return json(['code' => 404, 'message' => '用户不存在']);
            }
            $pending = Db::name('user_profile_pending')->where('user_id', $userId)->find();

            if ($action === 'approve') {
                if (!$pending) {
                    return json(['code' => 400, 'message' => '该用户暂无待审资料']);
                }
                $upd = [];
                foreach (['nickname', 'avatar', 'gender', 'country', 'province', 'city', 'code_age', 'address', 'github', 'web_url'] as $f) {
                    if (isset($pending[$f]) && $pending[$f] !== null && $pending[$f] !== '') {
                        $upd[$f] = $pending[$f];
                    }
                }
                $upd['profile_status']     = 'approved';
                $upd['profile_audit_time'] = date('Y-m-d H:i:s');
                $upd['update_time']        = date('Y-m-d H:i:s');
                Db::name('users')->where('id', $userId)->update($upd);
                Db::name('user_profile_pending')->where('user_id', $userId)
                    ->update(['status' => 'approved', 'update_time' => date('Y-m-d H:i:s')]);
                $msg = '已通过，资料已生效';
                // 通知被审核用户（隔离异常，失败不影响审核）
                try {
                    (new NotificationService())->systemNotify((string) $userId, '资料审核已通过', '新的个人资料已生效');
                } catch (\Throwable $e) {
                }
            } else {
                if (!$reason) {
                    return json(['code' => 400, 'message' => '请填写驳回原因']);
                }
                Db::name('users')->where('id', $userId)->update([
                    'profile_status'        => 'rejected',
                    'profile_reject_reason' => $reason,
                    'profile_audit_time'    => date('Y-m-d H:i:s'),
                    'update_time'           => date('Y-m-d H:i:s')
                ]);
                if ($pending) {
                    Db::name('user_profile_pending')->where('user_id', $userId)->update([
                        'status'        => 'rejected',
                        'reject_reason' => $reason,
                        'update_time'   => date('Y-m-d H:i:s')
                    ]);
                }
                $msg = '已驳回';
                try {
                    (new NotificationService())->systemNotify((string) $userId, '资料审核未通过', '驳回原因：' . $reason);
                } catch (\Throwable $e) {
                }
            }

            return json(['code' => 200, 'message' => $msg]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 
