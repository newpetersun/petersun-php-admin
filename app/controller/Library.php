<?php

declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;
use app\service\PostService;

/**
 * 个人内容库：已购内容 / 收藏夹 / 浏览历史
 *
 * 路由分组（均需登录）：
 *   - GET  purchased        已购内容列表
 *   - GET  favorites        收藏列表
 *   - POST favorite         收藏 / 取消收藏（toggle）
 *   - GET  history          浏览历史列表
 *   - POST record-history   记录一次浏览（同帖去重，仅保留最近一条）
 *   - POST clear-history    清空浏览历史
 */
class Library extends BaseController
{
    private PostService $svc;

    public function __construct()
    {
        $this->svc = new PostService();
    }

    /**
     * 生成 UUID v4（与 Post 控制器实现一致）
     */
    private function uuidV4(): string
    {
        return sprintf(
            '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0xffff)
        );
    }

    /**
     * 已购内容（forum_post_purchases 中本人购买记录，关联帖子详情）
     */
    public function purchased(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }

            $rows = Db::name('forum_post_purchases')
                ->where('user_id', $userId)
                ->order('create_time', 'desc')
                ->field('post_id, coins, create_time as purchased_at')
                ->select()
                ->toArray();

            $list = [];
            foreach ($rows as $r) {
                $post = Db::name('forum_posts')->where('id', $r['post_id'])->find();
                if (!$post) {
                    continue;
                }
                $item               = $this->svc->formatPost($post);
                $item['purchasedAt'] = (string) $r['purchased_at'];
                $item['coins']       = (int) $r['coins'];
                $list[]             = $item;
            }

            return json(['code' => 200, 'message' => '获取成功', 'data' => ['list' => $list]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 收藏列表
     */
    public function favorites(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }

            $rows = Db::name('user_favorites')
                ->where('user_id', $userId)
                ->order('create_time', 'desc')
                ->field('post_id, create_time as favorited_at')
                ->select()
                ->toArray();

            $list = [];
            foreach ($rows as $r) {
                $post = Db::name('forum_posts')->where('id', $r['post_id'])->find();
                if (!$post) {
                    continue;
                }
                $item               = $this->svc->formatPost($post);
                $item['favoritedAt'] = (string) $r['favorited_at'];
                $list[]             = $item;
            }

            return json(['code' => 200, 'message' => '获取成功', 'data' => ['list' => $list]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 收藏 / 取消收藏（toggle）
     */
    public function favorite(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }

            $postId = (string) $request->param('post_id', '');
            if (empty($postId)) {
                return json(['code' => 400, 'message' => '帖子ID不能为空']);
            }

            $post = Db::name('forum_posts')->where('id', $postId)->where('status', 'approved')->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }

            $exist = Db::name('user_favorites')
                ->where('user_id', $userId)
                ->where('post_id', $postId)
                ->find();

            if ($exist) {
                Db::name('user_favorites')->where('id', $exist['id'])->delete();
                $favorited = false;
            } else {
                Db::name('user_favorites')->insert([
                    'id'          => $this->uuidV4(),
                    'user_id'     => $userId,
                    'post_id'     => $postId,
                    'create_time' => date('Y-m-d H:i:s'),
                ]);
                $favorited = true;
            }

            return json([
                'code'    => 200,
                'message' => $favorited ? '已收藏' : '已取消收藏',
                'data'    => ['favorited' => $favorited],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 浏览历史列表
     */
    public function history(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }

            $rows = Db::name('user_view_history')
                ->where('user_id', $userId)
                ->order('create_time', 'desc')
                ->field('post_id, create_time as viewed_at')
                ->select()
                ->toArray();

            $list = [];
            foreach ($rows as $r) {
                $post = Db::name('forum_posts')->where('id', $r['post_id'])->find();
                if (!$post) {
                    continue;
                }
                $item           = $this->svc->formatPost($post);
                $item['viewedAt'] = (string) $r['viewed_at'];
                $list[]         = $item;
            }

            return json(['code' => 200, 'message' => '获取成功', 'data' => ['list' => $list]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 记录一次浏览（同用户+同帖去重，仅保留最近一条）
     */
    public function recordHistory(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }

            $postId = (string) $request->param('post_id', '');
            if (empty($postId)) {
                return json(['code' => 400, 'message' => '帖子ID不能为空']);
            }

            Db::name('user_view_history')
                ->where('user_id', $userId)
                ->where('post_id', $postId)
                ->delete();
            Db::name('user_view_history')->insert([
                'id'          => $this->uuidV4(),
                'user_id'     => $userId,
                'post_id'     => $postId,
                'create_time' => date('Y-m-d H:i:s'),
            ]);

            return json(['code' => 200, 'message' => 'ok']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 清空浏览历史
     */
    public function clearHistory(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }

            Db::name('user_view_history')->where('user_id', $userId)->delete();

            return json(['code' => 200, 'message' => '已清空']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
