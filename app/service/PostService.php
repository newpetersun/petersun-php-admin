<?php
declare(strict_types=1);

namespace app\service;

use think\facade\Db;

/**
 * 内容（帖子）统一服务层
 *
 * 设计前提：forum_posts 是「图文 / 视频 / 论坛帖子」的唯一载体（type 仅 image_text|video），
 * 所有读写都必须经过本服务，禁止在控制器里再写一遍直连 forum_posts 的逻辑，
 * 以避免 Article/Post 两套控制器逻辑漂移。
 *
 * 状态机（5 态）：
 *   draft -> pending（提交发布）-> approved（通过）/ rejected（驳回）
 *   approved <-> offline（下架/上架）；rejected -> pending（重新提交）
 */
class PostService
{
    public const DEFAULT_AVATAR = '/static/images/default-avatar.jpg';

    public const TYPES = ['image_text', 'video'];

    public const STATUS_TEXT = [
        'draft'    => '草稿',
        'pending'  => '待审核',
        'approved' => '已发布',
        'rejected' => '已驳回',
        'offline'  => '已下架',
    ];

    // ========================================================
    // 列表 / 详情 / 格式化
    // ========================================================

    /**
     * 列表分页（调用方负责拼 where；按 sort 排序）
     */
    public function listPosts(array $where, int $page, int $limit, string $sort = 'latest'): array
    {
        $query = Db::name('forum_posts')->where($where);
        if ($sort === 'hot') {
            $query->order('like_count', 'desc')->order('create_time', 'desc');
        } else {
            $query->order('is_pinned', 'desc')->order('create_time', 'desc');
        }

        $paginate = $query->paginate(['list_rows' => $limit, 'page' => $page]);
        $list = array_map([$this, 'formatPost'], $paginate->items());

        return [
            'list'  => $list,
            'total' => $paginate->total(),
            'page'  => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 统一格式化（图文/视频/论坛帖子共用，camelCase 对外字段）
     */
    public function formatPost(array $r): array
    {
        $author = Db::name('users')
            ->where('id', $r['user_id'])
            ->field('nickname, avatar')
            ->find();

        // 板块信息（含主题色背景 color_bg），供列表/详情展示板块标签
        $board = !empty($r['board_id'])
            ? Db::name('forum_boards')->where('id', $r['board_id'])->field('id, name, color_bg')->find()
            : null;

        $cover = [];
        if (!empty($r['cover_images'])) {
            $decoded = json_decode($r['cover_images'], true);
            if (is_array($decoded)) {
                $cover = $decoded;
            }
        }
        // 封面为空时从正文提取内嵌图片作为缩略图
        if (empty($cover) && !empty($r['content'])) {
            $cover = $this->extractImagesFromContent($r['content']);
        }

        $tags = [];
        if (!empty($r['tags'])) {
            $tags = array_values(array_filter(explode(',', $r['tags'])));
        }

        $status = (string) ($r['status'] ?? 'approved');
        $type   = (string) ($r['type'] ?? 'image_text');

        return [
            'id'           => $r['id'],
            'type'         => $type,
            'typeText'     => $type === 'video' ? '视频' : '图文',
            'title'        => (string) ($r['title'] ?? ''),
            'summary'      => (string) ($r['summary'] ?? ''),
            'cover'        => $cover[0] ?? '',
            'coverImages'  => array_slice($cover, 0, 9),
            'category'     => (string) ($r['category'] ?? ''),
            'boardId'      => $board['id'] ?? '',
            'boardName'    => $board['name'] ?? '',
            'boardColorBg' => $board['color_bg'] ?? '',
            'tags'         => $tags,
            'author'       => $author['nickname'] ?? '匿名用户',
            'authorAvatar' => $author['avatar'] ?? self::DEFAULT_AVATAR,
            'userId'       => (string) ($r['user_id'] ?? ''),
            'createdAt'    => (string) ($r['create_time'] ?? ''),
            'updatedAt'    => (string) ($r['update_time'] ?? ''),
            'views'        => (int) ($r['views'] ?? 0),
            'comments'     => (int) ($r['comment_count'] ?? 0),
            'likes'        => (int) ($r['like_count'] ?? 0),
            'isEssence'    => (bool) ($r['is_essence'] ?? 0),
            'isPinned'     => (bool) ($r['is_pinned'] ?? 0),
            'isPaid'       => (int) ($r['is_paid'] ?? 0) === 1,
            'coinPrice'    => (int) ($r['coin_price'] ?? 0),
            'price'        => (float) ($r['coin_price'] ?? 0),
            'duration'     => (int) ($r['duration'] ?? 0),
            'videoUrl'     => (string) ($r['video_url'] ?? ''),
            'status'       => $status,
            'statusText'   => self::STATUS_TEXT[$status] ?? $status,
            'rejectReason' => (string) ($r['reject_reason'] ?? ''),
            'auditTime'    => (string) ($r['audit_time'] ?? ''),
            'fans'         => 0,
        ];
    }

    /**
     * 取帖子评论（供详情接口复用）
     */
    public function getComments($postId, $limit = 50): array
    {
        $rows = Db::name('forum_post_comments')
            ->where('post_id', $postId)
            ->where('status', 1)
            ->order('create_time', 'asc')
            ->limit($limit)
            ->select()
            ->toArray();

        return array_map(function ($c) {
            $author = Db::name('users')
                ->where('id', $c['user_id'])
                ->field('nickname, avatar')
                ->find();
            return [
                'id'           => $c['id'],
                'content'      => $c['content'],
                'author'       => $author['nickname'] ?? '匿名用户',
                'authorAvatar' => $author['avatar'] ?? self::DEFAULT_AVATAR,
                'replyTo'      => (int) $c['parent_id'],
                'likeCount'    => (int) $c['like_count'],
                'createdAt'    => $c['create_time'],
            ];
        }, $rows);
    }

    // ========================================================
    // 创建 / 更新 / 删除（唯一写入入口）
    // ========================================================

    /**
     * 构建规范化保存数据（论坛发帖 / 创作者发布 共用）
     * 失败时返回 ['__error' => 原因]
     */
    public function buildSaveData($request, string $uid): array
    {
        $type = trim((string) $request->param('type', 'image_text'));
        if (!in_array($type, self::TYPES, true)) {
            $type = 'image_text';
        }

        $boardId = trim((string) $request->param('board_id', ''));
        $key     = $request->param('key', '');
        if (empty($boardId) && !empty($key)) {
            $board   = Db::name('forum_boards')->where('board_key', $key)->find();
            $boardId = $board ? $board['id'] : '';
        }
        if (empty($boardId)) {
            return ['__error' => '所属板块不能为空'];
        }

        $title = trim((string) $request->param('title', ''));
        if ($title === '') {
            return ['__error' => '标题不能为空'];
        }
        if (mb_strlen($title) > 60) {
            return ['__error' => '标题不能超过60个字符'];
        }

        $content = (string) $request->param('content', '');
        if (trim($content) === '') {
            return ['__error' => '正文不能为空'];
        }

        $isPaid    = (int) $request->param('is_paid', 0) === 1 ? 1 : 0;
        $coinPrice = (int) round((float) $request->param('coin_price', $request->param('price', 0)));
        if ($isPaid === 1 && $coinPrice <= 0) {
            return ['__error' => '付费内容需填写有效的金币价格'];
        }

        $tags = $request->param('tags', []);
        if (is_string($tags)) {
            $tags = explode(',', $tags);
        }
        $tags = array_values(array_filter(array_map(
            static fn($t) => trim((string) $t),
            is_array($tags) ? $tags : []
        )));
        if (count($tags) > 10) {
            return ['__error' => '标签最多10个'];
        }

        // 摘要未填时由后端从正文自动提取
        $summary = trim((string) $request->param('summary', ''));
        if ($summary === '') {
            $plain = preg_replace('/[#*`>\-\[\]()!_]/u', '', $content) ?? '';
            $plain = preg_replace('/\s+/u', ' ', $plain) ?? '';
            $summary = mb_substr(trim($plain), 0, 100);
        }

        // 封面：优先 cover_images(JSON)，否则单张 cover 自动包装为数组
        $coverImages = $request->param('cover_images', '');
if (!is_string($coverImages)) {
            $coverImages = json_encode(
                array_values(array_filter((array) $coverImages)),
                JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
            );
        }
        if (($coverImages === '' || $coverImages === '[]' || $coverImages === '""')
            && $cover = trim((string) $request->param('cover', ''))) {
            $coverImages = json_encode([$cover], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }

        // 分类：未显式传则取板块 board_key
        $category = trim((string) $request->param('category', ''));
        if ($category === '') {
            $b = Db::name('forum_boards')->where('id', $boardId)->field('board_key')->find();
            $category = $b ? (string) $b['board_key'] : '';
        }

        return [
            'board_id'     => $boardId,
            'user_id'      => $uid,
            'type'         => $type,
            'title'        => $title,
            'content'      => $content,
            'summary'      => $summary,
            'category'     => mb_substr($category, 0, 32),
            'tags'         => mb_substr(implode(',', $tags), 0, 255),
            'cover_images' => $coverImages,
            'is_paid'      => $isPaid,
            'coin_price'   => $isPaid === 1 ? $coinPrice : 0,
            'video_url'    => mb_substr(trim((string) $request->param('video_url', '')), 0, 500),
            'duration'     => max(0, (int) $request->param('duration', 0)),
        ];
    }

    /**
     * 创建帖子（唯一 insert 入口）
     * @return array ['id'=>...] 或 ['__error'=>...]
     */
    public function createPost($request, string $uid, string $status): array
    {
        $data = $this->buildSaveData($request, $uid);
        if (isset($data['__error'])) {
            return $data;
        }
        $data['status']        = $status;
        $data['reject_reason'] = null;
        $data['create_time']   = date('Y-m-d H:i:s');
        $data['update_time']   = date('Y-m-d H:i:s');
        $data['id']            = uuid();

        Db::name('forum_posts')->insert($data);

        // 仅已发布帖子计入板块帖子数
        if ($status === 'approved') {
            Db::name('forum_boards')->where('id', $data['board_id'])->inc('post_count')->update();
        }

        return ['id' => $data['id']];
    }

    /**
     * 更新帖子（唯一 update 入口；board 变更时同步板块帖子数）
     */
    public function updatePost(string $id, array $data, ?string $oldBoardId = null): void
    {
        $data['update_time'] = date('Y-m-d H:i:s');
        Db::name('forum_posts')->where('id', $id)->update($data);

        if ($oldBoardId !== null && isset($data['board_id']) && $data['board_id'] !== $oldBoardId) {
            Db::name('forum_boards')->where('id', $oldBoardId)->dec('post_count')->update();
            Db::name('forum_boards')->where('id', $data['board_id'])->inc('post_count')->update();
        }
    }

    /**
     * 删除帖子（唯一 delete 入口：级联评论/点赞/购买，扣减板块帖子数）
     */
    public function deletePost(string $id): void
    {
        $row = Db::name('forum_posts')->where('id', $id)->find();
        if (!$row) {
            return;
        }
        Db::name('forum_posts')->where('id', $id)->delete();
        Db::name('forum_post_comments')->where('post_id', $id)->delete();
        Db::name('forum_post_likes')->where('post_id', $id)->delete();
        Db::name('forum_post_purchases')->where('post_id', $id)->delete();

        if (($row['status'] ?? '') === 'approved') {
            Db::name('forum_boards')->where('id', $row['board_id'])->dec('post_count')->update();
        }
    }

    /**
     * 审核：approve 通过 / reject 驳回
     */
    public function review(string $id, string $action, string $reason): void
    {
        Db::name('forum_posts')->where('id', $id)->update([
            'status'        => $action === 'approve' ? 'approved' : 'rejected',
            'audit_time'    => date('Y-m-d H:i:s'),
            'reject_reason' => $action === 'reject' ? $reason : null,
            'update_time'   => date('Y-m-d H:i:s'),
        ]);
    }

    /**
     * 状态流转应用（创作者自助：上下架 / 重新提交）
     */
    public function applyStatus(string $id, string $to, bool $toPending): void
    {
        $update = ['status' => $to, 'update_time' => date('Y-m-d H:i:s')];
        if ($toPending) {
            $update['audit_time']    = date('Y-m-d H:i:s');
            $update['reject_reason'] = null;
        }
        Db::name('forum_posts')->where('id', $id)->update($update);
    }

    /**
     * 批量操作（创作者自助；逐条校验归属与状态）
     * action: offline|approve|submit|delete
     */
    public function batch(array $ids, string $action, string $uid): array
    {
        $rules = [
            'offline' => ['from' => ['approved'], 'to' => 'offline'],
            'approve' => ['from' => ['offline'], 'to' => 'approved'],
            'submit'  => ['from' => ['draft', 'rejected'], 'to' => 'pending'],
        ];
        $isDelete = $action === 'delete';

        $rows = Db::name('forum_posts')
            ->where('id', 'in', $ids)
            ->where('user_id', $uid)
            ->select()
            ->toArray();
        $rowMap = [];
        foreach ($rows as $r) {
            $rowMap[(string) $r['id']] = $r;
        }

        $now     = date('Y-m-d H:i:s');
        $success = [];
        $failed  = [];

        Db::startTrans();
        try {
            foreach ($ids as $id) {
                $id    = (string) $id;
                $row   = $rowMap[$id] ?? null;
                $title = $row ? (string) ($row['title'] ?? '') : '';

                if (!$row) {
                    $failed[] = ['id' => $id, 'title' => '', 'reason' => '内容不存在或无权操作'];
                    continue;
                }
                $from = (string) $row['status'];

                if ($isDelete) {
                    if (in_array($from, ['pending', 'approved'], true)) {
                        $failed[] = [
                            'id'     => $id,
                            'title'  => $title,
                            'reason' => '「' . $title . '」' . (self::STATUS_TEXT[$from] ?? $from) . '状态不可删除，请先下架',
                        ];
                        continue;
                    }
                    $this->deletePost($id);
                    $success[] = ['id' => $id, 'title' => $title];
                    continue;
                }

                $rule = $rules[$action];
                if (!in_array($from, $rule['from'], true)) {
                    $failed[] = [
                        'id'     => $id,
                        'title'  => $title,
                        'reason' => '「' . $title . '」当前为' . (self::STATUS_TEXT[$from] ?? $from) . '，不支持该操作',
                    ];
                    continue;
                }

                $update = ['status' => $rule['to'], 'update_time' => $now];
                if ($rule['to'] === 'pending') {
                    $update['audit_time']    = $now;
                    $update['reject_reason'] = null;
                }
                Db::name('forum_posts')->where('id', $id)->update($update);
                $success[] = ['id' => $id, 'title' => $title, 'status' => $rule['to']];
            }
            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            throw $e;
        }

        return ['success' => $success, 'failed' => $failed];
    }

    // ========================================================
    // 私有工具
    // ========================================================

    /**
     * 从帖子正文中提取图片地址（兼容 Markdown ![](url) 与 HTML <img src>）
     */
    public function extractImagesFromContent(string $content): array
    {
        $urls = [];
        if (preg_match_all('/!\[[^\]]*\]\(([^)\s]+)\)/', $content, $m)) {
            $urls = array_merge($urls, $m[1]);
        }
        if (preg_match_all('/<img[^>]+src=["\']([^"\']+)["\']/i', $content, $m)) {
            $urls = array_merge($urls, $m[1]);
        }

        $filtered = [];
        foreach ($urls as $u) {
            if (strpos($u, 'data:') === 0) {
                continue;
            }
            if (!in_array($u, $filtered, true)) {
                $filtered[] = $u;
            }
        }
        return $filtered;
    }
} 
