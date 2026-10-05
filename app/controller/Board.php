<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 论坛板块接口
 */
class Board extends BaseController
{
    // 默认头像（与前端 DEFAULT_AVATAR 对应）
    private const DEFAULT_AVATAR = '/static/images/default-avatar.jpg';

    /**
     * 板块列表
     */
    public function list(): Response
    {
        try {
            $boards = Db::name('forum_boards')
                ->where('status', 1)
                ->order('sort_order', 'asc')
                ->order('id', 'asc')
                ->select()
                ->toArray();

            // 一次性查出所有板块的版主，按 board_id 分组（避免 N+1）
            $boardIds = array_column($boards, 'id');
            $moderatorMap = [];
            if ($boardIds) {
                $moderators = Db::name('forum_board_moderators')
                    ->alias('m')
                    ->join('users u', 'm.user_id = u.id', 'left')
                    ->whereIn('m.board_id', $boardIds)
                    ->field('m.board_id, m.id, m.user_id, m.role, u.user_key, u.nickname, u.avatar')
                    ->order('m.id', 'asc')
                    ->select()
                    ->toArray();
                foreach ($moderators as $mod) {
                    $mod['name']     = $mod['nickname'] ?: '匿名用户';
                    $mod['avatar']   = $mod['avatar'] ?: self::DEFAULT_AVATAR;
                    $mod['followed'] = false;
                    unset($mod['nickname']);
                    $moderatorMap[$mod['board_id']][] = $mod;
                }
            }

            foreach ($boards as &$board) {
                $board['moderators'] = $moderatorMap[$board['id']] ?? [];
            }

            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $boards
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 板块详情（含公告、版主、置顶、最新帖子）
     * 支持 ?key=java 或 ?id=1
     */
    public function detail(Request $request): Response
    {
        try {
            $key = $request->param('key', '');
            $id  = $request->param('id', 0);

            $where = [];
            if (!empty($key)) {
                $where[] = ['board_key', '=', $key];
            } elseif (!empty($id)) {
                $where[] = ['id', '=', $id];
            }

            $board = Db::name('forum_boards')->where($where)->find();
            if (!$board) {
                return json(['code' => 404, 'message' => '板块不存在']);
            }

            // 版主
            $moderators = Db::name('forum_board_moderators')
                ->alias('m')
                ->join('users u', 'm.user_id = u.id', 'left')
                ->where('m.board_id', $board['id'])
                ->field('m.id, m.user_id, m.role, u.nickname, u.avatar')
                ->order('m.id', 'asc')
                ->select()
                ->toArray();
            foreach ($moderators as &$mod) {
                $mod['name']   = $mod['nickname'] ?: '匿名用户';
                $mod['avatar'] = $mod['avatar'] ?: self::DEFAULT_AVATAR;
                $mod['followed'] = false;
                unset($mod['nickname']);
            }

            // 最新帖子
            $posts = Db::name('forum_posts')
                ->where('board_id', $board['id'])
                ->where('status', 1)
                ->order('create_time', 'desc')
                ->limit(20)
                ->select()
                ->toArray();
            $posts = array_map([$this, 'formatPost'], $posts);

            // 置顶帖子
            $pinned = Db::name('forum_posts')
                ->where('board_id', $board['id'])
                ->where('is_pinned', 1)
                ->where('status', 1)
                ->order('create_time', 'desc')
                ->limit(5)
                ->select()
                ->toArray();
            $pinnedList = array_map(function ($p) {
                return [
                    'id'    => $p['id'],
                    'title' => $p['title'],
                    'date'  => date('Y-m-d', strtotime($p['create_time']))
                ];
            }, $pinned);

            $data = $board;
            $data['moderators'] = $moderators;
            $data['pinned']     = $pinnedList;
            $data['posts']      = $posts;

            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $data
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 加入 / 退出板块（需登录）
     */
    public function join(Request $request): Response
    {
        try {
            $userId  = $request->userId;
            $boardId = $request->param('board_id', 0);
            $key     = $request->param('key', '');

            if (empty($boardId) && !empty($key)) {
                $board = Db::name('forum_boards')->where('board_key', $key)->find();
                $boardId = $board ? $board['id'] : '';
            }
            if (empty($boardId)) {
                return json(['code' => 400, 'message' => '板块参数不能为空']);
            }

            $exist = Db::name('forum_board_members')
                ->where('board_id', $boardId)
                ->where('user_id', $userId)
                ->find();

            Db::startTrans();
            try {
                if ($exist) {
                    Db::name('forum_board_members')
                        ->where('board_id', $boardId)
                        ->where('user_id', $userId)
                        ->delete();
                    Db::name('forum_boards')->where('id', $boardId)->dec('member_count')->update();
                    $joined = false;
                } else {
                    Db::name('forum_board_members')->insert([
                        'board_id'    => $boardId,
                        'user_id'     => $userId,
                        'create_time' => date('Y-m-d H:i:s')
                    ]);
                    Db::name('forum_boards')->where('id', $boardId)->inc('member_count')->update();
                    $joined = true;
                }
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                throw $e;
            }

            return json([
                'code' => 200,
                'message' => $joined ? '已加入板块' : '已退出板块',
                'data' => ['joined' => $joined]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 关注 / 取消关注版主（需登录）
     * 说明：前端以本地状态维护关注态，此处仅作成功回执；
     * 如需持久化，可新增 forum_moderator_follow 表。
     */
    public function follow(Request $request): Response
    {
        try {
            $request->userId; // 鉴权已确保登录
            $followed = (int)$request->param('followed', 0);
            return json([
                'code' => 200,
                'message' => $followed ? '已关注' : '已取消关注',
                'data' => ['followed' => (bool)$followed]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 将帖子行格式化为前端所需结构（解析作者、封面、标签）
     */
    /**
     * 管理端：板块列表（含禁用，支持关键词搜索）
     */
    public function adminList(Request $request): Response
    {
        try {
            $keyword = $request->param('keyword', '');
            $where = [];
            if (!empty($keyword)) {
                $where[] = ['name|board_key|description', 'like', "%$keyword%"];
            }
            $boards = Db::name('forum_boards')
                ->where($where)
                ->order('sort_order', 'asc')
                ->order('id', 'asc')
                ->select()
                ->toArray();
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => ['list' => $boards, 'total' => count($boards)]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 管理端：创建板块
     */
    public function create(Request $request): Response
    {
        try {
            $data = $request->only([
                'board_key', 'name', 'icon_text', 'description',
                'color_fg', 'color_bg', 'cover_image', 'announcement',
                'sort_order', 'status'
            ]);
            if (empty($data['name']) || empty($data['board_key'])) {
                return json(['code' => 400, 'message' => '板块名称和标识不能为空']);
            }
            $exists = Db::name('forum_boards')->where('board_key', $data['board_key'])->find();
            if ($exists) {
                return json(['code' => 400, 'message' => '板块标识已存在']);
            }
            $data['sort_order'] = $data['sort_order'] ?? 0;
            $data['status'] = isset($data['status']) ? (int)$data['status'] : 1;
            $id = Db::name('forum_boards')->insertGetId(array_merge(['id' => uuid()], $data));
            return json(['code' => 200, 'message' => '创建成功', 'data' => ['id' => $id]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 管理端：更新板块
     */
    public function update(Request $request, $id): Response
    {
        try {
            $data = $request->only([
                'board_key', 'name', 'icon_text', 'description',
                'color_fg', 'color_bg', 'cover_image', 'announcement',
                'sort_order', 'status'
            ]);
            if (empty($data['name']) || empty($data['board_key'])) {
                return json(['code' => 400, 'message' => '板块名称和标识不能为空']);
            }
            $exists = Db::name('forum_boards')
                ->where('board_key', $data['board_key'])
                ->where('id', '<>', $id)
                ->find();
            if ($exists) {
                return json(['code' => 400, 'message' => '板块标识已存在']);
            }
            Db::name('forum_boards')->where('id', $id)->update($data);
            return json(['code' => 200, 'message' => '更新成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 管理端：删除板块（存在帖子则禁止，并清理版主/成员关联）
     */
    public function delete($id): Response
    {
        try {
            $count = Db::name('forum_posts')->where('board_id', $id)->count();
            if ($count > 0) {
                return json(['code' => 400, 'message' => '该板块下还有 ' . $count . ' 篇帖子，无法删除']);
            }
            Db::name('forum_board_moderators')->where('board_id', $id)->delete();
            Db::name('forum_board_members')->where('board_id', $id)->delete();
            Db::name('forum_boards')->where('id', $id)->delete();
            return json(['code' => 200, 'message' => '删除成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 管理端：更新板块状态
     */
    public function status(Request $request, $id): Response
    {
        try {
            $status = $request->param('status', 0);
            Db::name('forum_boards')->where('id', $id)->update(['status' => (int)$status]);
            return json(['code' => 200, 'message' => '状态更新成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    private function formatPost(array $post): array
    {
        $author = Db::name('users')
            ->where('id', $post['user_id'])
            ->field('nickname, avatar')
            ->find();

        $cover = [];
        if (!empty($post['cover_images'])) {
            $decoded = json_decode($post['cover_images'], true);
            if (is_array($decoded)) {
                $cover = $decoded;
            }
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
            'category'     => $post['category'],
            'tags'         => array_values($tags),
            'createdAt'    => $post['create_time'],
            'views'        => (int)$post['views'],
            'comments'     => (int)$post['comment_count'],
            'likes'        => (int)$post['like_count'],
            'isEssence'    => (bool)$post['is_essence'],
            'coverImages'  => array_slice($cover, 0, 9)
        ];
    }
}
