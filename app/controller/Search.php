<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 综合搜索：文章 / 板块 / 用户
 */
class Search extends BaseController
{
    private const DEFAULT_AVATAR = '/static/images/default-avatar.jpg';

    /**
     * 综合搜索（GET ?keyword=）
     * 返回 posts（按 formatPost 结构，可直接喂给前端 PostCard）、boards、users
     */
    public function index(Request $request): Response
    {
        try {
            $keyword = trim((string)$request->param('keyword', ''));

            if ($keyword === '') {
                return json([
                    'code'    => 200,
                    'message' => '获取成功',
                    'data'    => ['posts' => [], 'boards' => [], 'users' => []]
                ]);
            }

            $like = '%' . $keyword . '%';

            // ---------- 文章 ----------
            $posts = Db::name('forum_posts')
                ->where('status', 1)
                ->where(function ($q) use ($like) {
                    $q->where('title', 'like', $like)
                        ->whereOr('summary', 'like', $like)
                        ->whereOr('content', 'like', $like)
                        ->whereOr('tags', 'like', $like);
                })
                ->order('create_time', 'desc')
                ->limit(20)
                ->select()
                ->toArray();

            $authorMap = [];
            if (!empty($posts)) {
                $userIds = array_column($posts, 'user_id');
                $authors = Db::name('users')
                    ->where('id', 'in', $userIds)
                    ->field('id, nickname, avatar')
                    ->select()
                    ->toArray();
                foreach ($authors as $a) {
                    $authorMap[$a['id']] = $a;
                }
            }
            $postList = array_map(function ($p) use ($authorMap) {
                return $this->formatPost($p, $authorMap[$p['user_id']] ?? null);
            }, $posts);

            // ---------- 板块 ----------
            $boards = Db::name('forum_boards')
                ->where('status', 1)
                ->where(function ($q) use ($like) {
                    $q->where('name', 'like', $like)
                        ->whereOr('description', 'like', $like);
                })
                ->order('sort_order', 'asc')
                ->limit(20)
                ->select()
                ->toArray();
            $boardList = array_map([$this, 'formatBoard'], $boards);

            // ---------- 用户 ----------
            $users = Db::name('users')
                ->where('nickname', 'like', $like)
                ->order('id', 'asc')
                ->limit(20)
                ->field('id, nickname, avatar')
                ->select()
                ->toArray();
            $userList = array_map(function ($u) {
                return [
                    'id'       => $u['id'],
                    'nickname' => $u['nickname'] ?? '',
                    'avatar'   => $u['avatar'] ?: self::DEFAULT_AVATAR
                ];
            }, $users);

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => [
                    'posts'  => $postList,
                    'boards' => $boardList,
                    'users'  => $userList
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 帖子格式化（与 Post 控制器 formatPost 保持一致，输出可直接喂给前端 PostCard）
     */
    private function formatPost(array $post, ?array $author): array
    {
        $author = $author ?: ['nickname' => '匿名用户', 'avatar' => self::DEFAULT_AVATAR];

        $cover = [];
        if (!empty($post['cover_images'])) {
            $decoded = json_decode($post['cover_images'], true);
            if (is_array($decoded)) {
                $cover = $decoded;
            }
        }
        if (empty($cover) && !empty($post['content'])) {
            $cover = $this->extractImagesFromContent($post['content']);
        }

        $tags = [];
        if (!empty($post['tags'])) {
            $tags = array_filter(explode(',', $post['tags']));
        }

        return [
            'id'           => $post['id'],
            'title'        => $post['title'],
            'summary'      => $post['summary'] ?? '',
            'author'       => $author['nickname'] ?? '匿名用户',
            'authorAvatar' => $author['avatar'] ?? self::DEFAULT_AVATAR,
            'userId'       => $post['user_id'] ?? '',
            'category'     => $post['category'],
            'tags'         => array_values($tags),
            'createdAt'    => $post['create_time'],
            'views'        => (int)$post['views'],
            'comments'     => (int)$post['comment_count'],
            'likes'        => (int)$post['like_count'],
            'isEssence'    => (bool)$post['is_essence'],
            'isPaid'       => (bool)($post['is_paid'] ?? 0),
            'coverImages'  => array_slice($cover, 0, 9)
        ];
    }

    /**
     * 板块格式化（与前端 mapBoard 字段对齐）
     */
    private function formatBoard(array $board): array
    {
        return [
            'id'       => $board['id'],
            'value'    => $board['board_key'] ?? $board['key'] ?? '',
            'name'     => $board['name'] ?? '',
            'iconText' => $board['icon_text'] ?? '',
            'desc'     => $board['description'] ?? '',
            'members'  => (int)($board['member_count'] ?? 0),
            'posts'    => (int)($board['post_count'] ?? 0),
            'color'    => [
                'fg' => $board['color_fg'] ?? '#0f172a',
                'bg' => $board['color_bg'] ?? '#f1f5f9'
            ]
        ];
    }

    /**
     * 从帖子正文中提取图片地址（兼容 Markdown ![](url) 与 HTML <img src>）
     */
    private function extractImagesFromContent(string $content): array
    {
        $urls = [];

        if (preg_match_all('/!\[[^\]]*\]\(([^)\s]+)\)/', $content, $m)) {
            $urls = array_merge($urls, $m[1]);
        }
        if (preg_match_all('/<img[^>]+src=["\']([^"\']+)["\']/i', $content, $m)) {
            $urls = array_merge($urls, $m[1]);
        }

        $urls = array_filter($urls, function ($u) {
            return strpos($u, 'data:') !== 0;
        });

        return array_values(array_unique($urls));
    }
}
