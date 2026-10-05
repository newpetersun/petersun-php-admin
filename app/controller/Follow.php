<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 用户关注控制器（需登录）
 */
class Follow extends BaseController
{
    /**
     * 关注 / 取消关注（幂等切换）
     */
    public function toggle(Request $request): Response
    {
        try {
            $followerId = $request->userId ?? '';
            if (!$followerId) {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $followingId = trim($request->param('following_id', ''));
            if (!$followingId) {
                return json(['code' => 400, 'message' => '缺少被关注用户ID']);
            }
            if ($followingId === $followerId) {
                return json(['code' => 400, 'message' => '不能关注自己']);
            }

            $exists = Db::name('user_follows')
                ->where('follower_id', $followerId)
                ->where('following_id', $followingId)
                ->find();

            if ($exists) {
                Db::name('user_follows')->where('id', $exists['id'])->delete();
                return json(['code' => 200, 'message' => '已取消关注', 'data' => ['followed' => false]]);
            }

            Db::name('user_follows')->insert([
                'id'           => uuid(),
                'follower_id'  => $followerId,
                'following_id' => $followingId,
                'create_time'  => date('Y-m-d H:i:s')
            ]);

            return json(['code' => 200, 'message' => '关注成功', 'data' => ['followed' => true]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 查询当前用户是否已关注某用户
     */
    public function status(Request $request): Response
    {
        try {
            $followerId = $request->userId ?? '';
            if (!$followerId) {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $followingId = trim($request->param('following_id', ''));
            if (!$followingId) {
                return json(['code' => 400, 'message' => '缺少被关注用户ID']);
            }

            $exists = Db::name('user_follows')
                ->where('follower_id', $followerId)
                ->where('following_id', $followingId)
                ->find();

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => ['followed' => (bool) $exists]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
