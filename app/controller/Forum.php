<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 论坛首页聚合接口（热门话题 / 推荐阅读 / 活跃作者）
 * 均为只读公开接口，无数据时返回空数组，前端据此隐藏对应模块
 */
class Forum extends BaseController
{
    private const DEFAULT_AVATAR = '/static/images/default-avatar.jpg';

    /**
     * 热门话题：按分类（板块）聚合帖子数，取最热的若干分类
     * 返回 id(板块id) / name(板块名) / category(板块key) / count
     */
    public function hotTopics(Request $request): Response
    {
        try {
            $limit = (int)$request->param('limit', 10);

            $rows = Db::name('forum_posts')
                ->where('status', 1)
                ->group('category')
                ->field('category, count(*) as count')
                ->order('count', 'desc')
                ->limit($limit)
                ->select()
                ->toArray();

            $keys = array_column($rows, 'category');
            $boards = Db::name('forum_boards')
                ->whereIn('board_key', $keys)
                ->column('*', 'board_key');

            $list = [];
            foreach ($rows as $r) {
                $b = $boards[$r['category']] ?? [];
                $list[] = [
                    'id'       => $b['id'] ?? '',
                    'name'     => $b['name'] ?? $r['category'],
                    'category' => $r['category'],
                    'count'    => (int)$r['count']
                ];
            }

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => $list
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 推荐阅读：按浏览量排序的热门帖子
     * 返回 id / title / date / views
     */
    public function recommended(Request $request): Response
    {
        try {
            $limit = (int)$request->param('limit', 6);

            $posts = Db::name('forum_posts')
                ->where('status', 1)
                ->order('views', 'desc')
                ->order('create_time', 'desc')
                ->limit($limit)
                ->select()
                ->toArray();

            $list = array_map(function ($p) {
                return [
                    'id'    => $p['id'],
                    'title' => $p['title'],
                    'date'  => date('Y-m-d', strtotime($p['create_time'])),
                    'views' => (int)$p['views']
                ];
            }, $posts);

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => $list
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 活跃作者：按发帖数排行的用户
     * 返回 userId / nickname / avatar / articles / rank
     */
    public function activeAuthors(Request $request): Response
    {
        try {
            $limit = (int)$request->param('limit', 10);

            $rows = Db::name('forum_posts')
                ->where('status', 1)
                ->group('user_id')
                ->field('user_id, count(*) as post_count')
                ->order('post_count', 'desc')
                ->limit($limit)
                ->select()
                ->toArray();

            $userIds = array_column($rows, 'user_id');
            $users = Db::name('users')
                ->whereIn('id', $userIds)
                ->column('*', 'id');

            $list = [];
            foreach ($rows as $i => $r) {
                $u = $users[$r['user_id']] ?? [];
                $list[] = [
                    'userId'   => $r['user_id'],
                    'nickname' => $u['nickname'] ?? '匿名用户',
                    'avatar'   => $u['avatar'] ?: self::DEFAULT_AVATAR,
                    'articles' => (int)$r['post_count'],
                    'rank'     => $i + 1
                ];
            }

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => $list
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
