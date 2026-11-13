<?php

declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;
use app\service\PostService;
use app\service\PosterService;
use app\service\VirtualPayService;
use app\service\JwtService;
use app\service\NotificationService;

/**
 * 内容（帖子）统一控制器
 *
 * 一切皆为 forum_posts 一行（type 仅 image_text|video），本控制器通过 PostService 统一读写。
 * 路由分组：
 *   - 公开读：list / detail / comments / poster-code
 *   - 登录写：create / upload-image / like / comment / buy / report / update / delete
 *            + 创作者：creator-list / drafts / save / toggle-status / batch / upload-video / categories
 *   - 管理端：admin-list / review
 *
 * 越权修复：update/delete 必须由「作者本人」或「管理员」操作（原先任意登录用户可删改任意帖子）。
 */
class Post extends BaseController
{
    private PostService $svc;
    private NotificationService $noti;

    public function __construct()
    {
        $this->svc  = new PostService();
        $this->noti = new NotificationService();
    }

    // ========================================================
    // 公开读：论坛 feed / 详情 / 评论 / 小程序码
    // ========================================================

    /**
     * 帖子列表（论坛 feed）
     * 支持 board_id / boards / key 过滤，keyword 搜索，is_essence 筛选，sort=latest|hot
     * 注：原 category 参数已废弃，统一改用 boards（板块）过滤
     */
    public function list(Request $request): Response
    {
        try {
            $boardId   = (string) $request->param('board_id', '');
            $key       = $request->param('key', '');
            $boards    = (string) $request->param('boards', '');
            $keyword   = $request->param('keyword', '');
            $isEssence = $request->param('is_essence', '');
            $sort      = $request->param('sort', 'latest');
            $page      = (int) $request->param('page', 1);
            $limit     = (int) $request->param('limit', 10);
            $status    = $request->param('status', 'approved');

            $where = [];
            if ($status !== 'all') {
                $where[] = ['status', '=', $status];
            }
            if ($boardId) {
                $where[] = ['board_id', '=', $boardId];
            } elseif (!empty($boards) && $boards !== 'all') {
                // boards 接受 board_id 或 board_key，统一解析为 board_id 过滤
                $board = is_numeric($boards)
                    ? Db::name('forum_boards')->where('id', $boards)->find()
                    : Db::name('forum_boards')->where('board_key', $boards)->find();
                if ($board) {
                    $where[] = ['board_id', '=', $board['id']];
                }
            } elseif (!empty($key)) {
                $board = Db::name('forum_boards')->where('board_key', $key)->find();
                if ($board) {
                    $where[] = ['board_id', '=', $board['id']];
                }
            }
            if (!empty($keyword)) {
                $where[] = ['title|summary', 'like', "%$keyword%"];
            }
            if ($isEssence !== '') {
                $where[] = ['is_essence', '=', (int) $isEssence];
            }

            $data = $this->svc->listPosts($where, $page, $limit, $sort);

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => $data,
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 帖子详情（含正文、评论、当前用户点赞态、付费解锁态）
     */
    public function detail(Request $request, $id): Response
    {
        try {
            $post = Db::name('forum_posts')->where('id', $id)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }

            $viewerId = $this->resolveUserId($request);
            $isOwner  = $viewerId !== '' && $viewerId === (string) $post['user_id'];
            $isAdmin  = (bool) ($request->isAdmin ?? false);
            if ((string) $post['status'] !== 'approved' && !$isOwner && !$isAdmin) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }

            // 浏览量 +1（仅已发布内容计入）
            if ((string) $post['status'] === 'approved') {
                Db::name('forum_posts')->where('id', $id)->inc('views')->update();
            }

            // 付费内容解锁判定：作者本人 / 管理员始终可见；已登录用户存在购买记录视为已购
            $isPaid    = !empty($post['is_paid']);
            $purchased = false;
            if ($viewerId !== '') {
                if ($isOwner || $isAdmin) {
                    $purchased = true;
                } else {
                    $bought = Db::name('forum_post_purchases')
                        ->where('post_id', $id)
                        ->where('user_id', $viewerId)
                        ->find();
                    $purchased = !empty($bought);
                }
            }

            $data             = $this->svc->formatPost($post);
            $data['content']  = ($isPaid && !$purchased) ? '' : (string) ($post['content'] ?? '');
            $data['purchased'] = $purchased;

            // 当前用户点赞态
            $liked = false;
            if ($viewerId !== '') {
                $like = Db::name('forum_post_likes')
                    ->where('post_id', $id)
                    ->where('user_id', $viewerId)
                    ->find();
                $liked = !empty($like);
            }
            $data['liked'] = $liked;

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => $data,
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 评论列表
     */
    public function comments(Request $request, $id): Response
    {
        try {
            $page  = (int) $request->param('page', 1);
            $limit = (int) $request->param('limit', 50);

            $paginate = Db::name('forum_post_comments')
                ->where([['post_id', '=', $id], ['status', '=', 1]])
                ->order('create_time', 'asc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => [
                    'list'  => $this->svc->getComments($id, $limit),
                    'total' => $paginate->total(),
                    'page'  => $page,
                    'limit' => $limit,
                ],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 生成帖子分享小程序码（用于分享海报）
     */
    public function posterCode(Request $request): Response
    {
        try {
            $path = ltrim((string) $request->param('path', 'subpkg/forum/detail'), '/');
            $id   = (string) $request->param('id', '');
            if (!preg_match('/^[\w\/]+$/', $path)) {
                return json(['code' => 400, 'message' => '非法的页面路径']);
            }
            if ($id !== '') {
                if (!preg_match('/^[\w\-]+$/', $id)) {
                    return json(['code' => 400, 'message' => '非法的帖子ID']);
                }
                $path .= '?id=' . $id;
            }

            $accessToken = VirtualPayService::getAccessToken();
            $url  = 'https://api.weixin.qq.com/wxa/getwxacode?access_token=' . $accessToken;
            $raw  = json_encode([
                'path'       => $path,
                'width'      => 430,
                'auto_color' => false,
                'line_color' => ['r' => 37, 'g' => 99, 'b' => 235],
                'is_hyaline' => true,
            ]);

            $img = $this->httpPostRaw($url, $raw);
            if (substr(trim($img), 0, 1) === '{') {
                $err = json_decode($img, true);
                return json([
                    'code'    => 500,
                    'message' => '生成小程序码失败：' . ($err['errmsg'] ?? 'unknown'),
                ]);
            }

            return json([
                'code' => 200,
                'data' => ['image' => 'data:image/png;base64,' . base64_encode($img)],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 帖子分享海报（后端合成）
     *  - 套用「默认/指定」海报模板，将帖子标题/摘要/封面 + 小程序码合成一张图
     *  - 返回 base64 PNG，前端直接展示/保存
     */
    public function poster(Request $request): Response
    {
        try {
            $id = (string) $request->param('id', '');
            if ($id === '' || !preg_match('/^[\w\-]+$/', $id)) {
                return json(['code' => 400, 'message' => '缺少或非法的帖子ID']);
            }
            $row = Db::name('forum_posts')
                ->where('id', $id)
                ->field('id,title,summary,cover_images,type,update_time')
                ->find();
            if (!$row) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }

            $cover = '';
            $covers = json_decode((string) ($row['cover_images'] ?? ''), true);
            if (is_array($covers) && !empty($covers)) {
                $first = $covers[0];
                $cover = is_array($first) ? (string) ($first['url'] ?? '') : (string) $first;
            }

            $post = [
                'title'     => $row['title'] ?? '',
                'content'   => $row['summary'] ?? '',
                'cover'     => $cover,
                'code_path' => 'subpkg/forum/detail?id=' . $id,
            ];

            $designId = (int) $request->param('design_id', 0);
            $postType = (string) ($row['type'] ?? '');
            $config   = PosterService::getDesignConfig($designId, $postType);

            // 简单文件缓存：模板不变且帖子未更新时不重复合成
            $cacheKey  = md5($id . '|' . $designId . '|' . $postType . '|' . ($row['update_time'] ?? ''));
            $cacheFile = runtime_path() . 'poster/' . $cacheKey . '.png';
            if (is_file($cacheFile)) {
                $png = file_get_contents($cacheFile);
            } else {
                $png = PosterService::render($config, $post);
                $dir = dirname($cacheFile);
                if (!is_dir($dir)) {
                    mkdir($dir, 0755, true);
                }
                file_put_contents($cacheFile, $png);
            }

            return json([
                'code' => 200,
                'data' => ['image' => 'data:image/png;base64,' . base64_encode($png)],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    // ========================================================
    // 登录写：发帖 / 点赞 / 评论 / 购买 / 举报 / 上传 / 更新 / 删除
    // ========================================================

    /**
     * 发布帖子（论坛 / 创作者 共用入口；论坛默认直接 approved，创作者走 /post/save 走草稿/审核）
     */
    public function create(Request $request): Response
    {
        try {
            $uid = $request->userId ?? '';
            if (empty($uid)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $res = $this->svc->createPost($request, $uid, 'approved');
            if (isset($res['__error'])) {
                return json(['code' => 400, 'message' => $res['__error']]);
            }
            return json([
                'code'    => 200,
                'message' => '发布成功',
                'data'    => ['id' => $res['id']],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 帖子图片上传（保存至 /static/images/forum/）
     */
    public function uploadImage(Request $request): Response
    {
        try {
            $file = $request->file('image');
            if (!$file) {
                return json(['code' => 400, 'message' => '未上传文件']);
            }

            $validate = validate(['image' => [
                'fileSize' => 5 * 1024 * 1024,
                'fileExt'  => 'jpg,jpeg,png,gif,webp',
                'fileMime' => 'image/jpeg,image/png,image/gif,image/webp',
            ]]);
            if (!$validate->check(['image' => $file])) {
                return json(['code' => 400, 'message' => $validate->getError()]);
            }

            $savePath = '/static/images/forum/';
            $fullPath = public_path() . $savePath;
            if (!is_dir($fullPath)) {
                mkdir($fullPath, 0755, true);
            }

            $fileName = 'forum_' . uniqid() . '.' . $file->getOriginalExtension();
            $file->move($fullPath, $fileName);
            return json([
                'code'    => 200,
                'message' => '上传成功',
                'data'    => [
                    'url'  => $savePath . $fileName,
                    'name' => $fileName,
                ],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 点赞 / 取消点赞
     */
    public function like(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $postId = (string) $request->param('post_id', '');
            if (empty($postId)) {
                return json(['code' => 400, 'message' => '帖子参数不能为空']);
            }

            $exist = Db::name('forum_post_likes')
                ->where('post_id', $postId)
                ->where('user_id', $userId)
                ->find();

            Db::startTrans();
            try {
                if ($exist) {
                    Db::name('forum_post_likes')
                        ->where('post_id', $postId)
                        ->where('user_id', $userId)
                        ->delete();
                    Db::name('forum_posts')->where('id', $postId)->dec('like_count')->update();
                    $liked = false;
                } else {
                    Db::name('forum_post_likes')->insert([
                        'post_id'     => $postId,
                        'user_id'     => $userId,
                        'create_time' => date('Y-m-d H:i:s'),
                    ]);
                    Db::name('forum_posts')->where('id', $postId)->inc('like_count')->update();
                    $liked = true;
                    $likePost = Db::name('forum_posts')->where('id', $postId)
                        ->field('user_id, title')->find();
                }
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                throw $e;
            }

            // 点赞成功 -> 通知帖子作者（与主流程隔离，失败不影响点赞）
            if ($liked && isset($likePost) && (string) $likePost['user_id'] !== $userId) {
                try {
                    $this->noti->likeNotify(
                        (string) $likePost['user_id'],
                        $userId,
                        $postId,
                        (string) ($likePost['title'] ?? '')
                    );
                } catch (\Throwable $e) {
                    // 忽略通知异常
                }
            }

            $likes = (int) Db::name('forum_posts')->where('id', $postId)->value('like_count');

            return json([
                'code'    => 200,
                'message' => $liked ? '点赞成功' : '已取消点赞',
                'data'    => ['liked' => $liked, 'likes' => $likes],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 发表评论
     */
    public function comment(Request $request): Response
    {
        try {
            $userId  = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $postId  = (string) $request->param('post_id', '');
            $content = trim($request->param('content', ''));
            $replyTo = (string) $request->param('reply_to', '');

            if (empty($postId)) {
                return json(['code' => 400, 'message' => '帖子参数不能为空']);
            }
            if (empty($content)) {
                return json(['code' => 400, 'message' => '评论内容不能为空']);
            }

            // 校验 reply_to：必须是本帖内存在的评论，否则降级为一级评论，避免外键 500
            if ($replyTo !== '') {
                $parent = Db::name('forum_post_comments')
                    ->where('id', $replyTo)
                    ->where('post_id', $postId)
                    ->where('status', 1)
                    ->find();
                if (!$parent) {
                    $replyTo = '';
                }
            }

            $commentId = $this->uuidV4();
            Db::name('forum_post_comments')->insert([
                'id'          => $commentId,
                'post_id'     => $postId,
                'user_id'     => $userId,
                'parent_id'   => $replyTo !== '' ? $replyTo : null,
                'content'     => $content,
                'status'      => 1,
                'create_time' => date('Y-m-d H:i:s'),
            ]);

            Db::name('forum_posts')->where('id', $postId)->inc('comment_count')->update();

            // 评论 / 回复成功 -> 通知相关人员（与主流程隔离，失败不影响评论）
            try {
                $post = Db::name('forum_posts')->where('id', $postId)
                    ->field('user_id, title')->find();
                $postAuthor = $post ? (string) $post['user_id'] : '';
                if ($postAuthor !== '' && $postAuthor !== $userId) {
                    // 顶层评论：通知帖子作者
                    $this->noti->commentNotify($postAuthor, $userId, $content, $postId, (string) ($post['title'] ?? ''));
                }
                if ($replyTo !== '') {
                    // 回复：通知被回复的评论作者（避免与帖子作者重复通知）
                    $parent = Db::name('forum_post_comments')->where('id', $replyTo)
                        ->field('user_id')->find();
                    $parentAuthor = $parent ? (string) $parent['user_id'] : '';
                    if ($parentAuthor !== '' && $parentAuthor !== $userId && $parentAuthor !== $postAuthor) {
                        $this->noti->replyNotify($parentAuthor, $userId, $content, $commentId);
                    }
                }
            } catch (\Throwable $e) {
                // 忽略通知异常
            }

            return json([
                'code'    => 200,
                'message' => '评论成功',
                'data'    => ['id' => $commentId],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 金币购买解锁付费帖正文
     */
    public function buy(Request $request): Response
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

            if ($userId === (string) ($post['user_id'] ?? '')) {
                return json(['code' => 200, 'message' => '您是作者，已自动解锁', 'data' => ['purchased' => true]]);
            }

            $exist = Db::name('forum_post_purchases')
                ->where('post_id', $postId)
                ->where('user_id', $userId)
                ->find();
            if ($exist) {
                return json(['code' => 200, 'message' => '已解锁', 'data' => ['purchased' => true]]);
            }

            if (empty($post['is_paid']) || (int) ($post['coin_price'] ?? 0) <= 0) {
                return json(['code' => 400, 'message' => '该帖子无需购买']);
            }

            $price    = (int) $post['coin_price'];
            $authorId = (string) ($post['user_id'] ?? '');
            $author   = Db::name('users')->where('id', $authorId)->field('openid')->find();
            $authorOpenid = $author ? (string) ($author['openid'] ?? '') : '';

            $this->ensureWallet($userId);
            $this->ensureWallet($authorId);

            $balance = (int) Db::name('user_wallet')->where('user_id', $userId)->value('balance');
            if ($balance < $price) {
                return json(['code' => 402, 'message' => '金币不足，请先充值']);
            }

            Db::startTrans();
            try {
                Db::name('user_wallet')->where('user_id', $userId)
                    ->inc('total_spent', $price)
                    ->dec('balance', $price)
                    ->update();
                Db::name('user_wallet')->where('user_id', $authorId)
                    ->inc('total_earned', $price)
                    ->inc('balance', $price)
                    ->update();
                Db::name('forum_post_purchases')->insert([
                    'id'            => $this->uuidV4(),
                    'post_id'       => $postId,
                    'user_id'       => $userId,
                    'coins'         => $price,
                    'settle_status' => 1,
                    'settle_amount' => $price,
                    'settle_time'   => date('Y-m-d H:i:s'),
                    'create_time'   => date('Y-m-d H:i:s'),
                ]);
                if ($authorOpenid !== '') {
                    Db::name('virtual_pay_orders')->insert([
                        'id'             => $this->uuidV4(),
                        'out_trade_no'   => 'A' . date('YmdHis') . str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT),
                        'wx_order_id'    => null,
                        'openid'         => $authorOpenid,
                        'product_id'     => 'article_income',
                        'product_name'   => mb_substr('文章收益 《' . $post['title'] . '》', 0, 120),
                        'quantity'       => $price,
                        'goods_price'    => 0,
                        'pay_fee'        => 0,
                        'attach'         => json_encode([
                            'post_id'  => $postId,
                            'buyer_id' => $userId,
                            'type'     => 'article_income',
                        ], JSON_UNESCAPED_UNICODE),
                        'env'            => 0,
                        'status'         => 'paid',
                        'deliver_status' => 1,
                        'paid_time'      => date('Y-m-d H:i:s'),
                        'deliver_time'   => date('Y-m-d H:i:s'),
                        'create_time'    => date('Y-m-d H:i:s'),
                        'update_time'    => date('Y-m-d H:i:s'),
                    ]);
                }
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                return json(['code' => 500, 'message' => '购买失败：' . $e->getMessage()]);
            }

            return json(['code' => 200, 'message' => '解锁成功', 'data' => ['purchased' => true]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 举报帖子
     */
    public function report(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $postId = (string) $request->param('post_id', '');
            $reason = trim($request->param('reason', ''));
            $desc   = trim($request->param('desc', ''));

            if (empty($postId)) {
                return json(['code' => 400, 'message' => '帖子ID不能为空']);
            }
            if (empty($reason)) {
                return json(['code' => 400, 'message' => '请选择举报原因']);
            }

            $post = Db::name('forum_posts')->where('id', $postId)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }
            if ((string) ($post['user_id'] ?? '') === (string) $userId) {
                return json(['code' => 400, 'message' => '不能举报自己的帖子']);
            }

            Db::name('forum_reports')->insert([
                'id'          => $this->uuidV4(),
                'post_id'     => $postId,
                'reporter_id' => $userId,
                'reason'      => $reason,
                'desc'        => $desc,
                'status'      => 0,
                'create_time' => date('Y-m-d H:i:s'),
            ]);

            return json(['code' => 200, 'message' => '举报已提交，感谢反馈']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新帖子（作者本人或管理员；作者仅可编辑非 pending/approved 的内容）
     * 兼容路由 update/:id 与 body.id 两种传参
     */
    public function update(Request $request, $id = 0): Response
    {
        try {
            if (empty($id)) {
                $id = $request->param('id', '');
            }
            if (empty($id)) {
                return json(['code' => 400, 'message' => '缺少帖子ID']);
            }
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $isAdmin = (bool) ($request->isAdmin ?? false);

            $post = Db::name('forum_posts')->where('id', $id)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }
            if (!$isAdmin && (string) $post['user_id'] !== (string) $userId) {
                return json(['code' => 403, 'message' => '无权操作该内容']);
            }
            if (!$isAdmin && in_array((string) $post['status'], ['pending', 'approved'], true)) {
                return json(['code' => 400, 'message' => '审核中或已发布的内容不可编辑，请先下架']);
            }

            $oldBoardId = ((string) $post['status'] === 'approved') ? (string) $post['board_id'] : null;
            $data = [];
            $title    = trim($request->param('title', ''));
            $content  = trim($request->param('content', ''));
            $key      = $request->param('key', '');
            if ($title !== '') {
                $data['title'] = $title;
            }
            if ($content !== '') {
                $data['content'] = $content;
                $plain           = trim(preg_replace('/\s+/', ' ', preg_replace('/^[#>+\-*`]+/m', '', $content)));
                $data['summary'] = mb_substr($plain, 0, 120);
            }
            if ($key !== '') {
                $board = Db::name('forum_boards')->where('board_key', $key)->find();
                if ($board) {
                    $data['board_id'] = $board['id'];
                    $data['category'] = $board['board_key'];
                }
            } elseif ($request->has('board_id')) {
                $data['board_id'] = (string) $request->param('board_id', '');
                if ($data['board_id'] !== '') {
                    $b = Db::name('forum_boards')->where('id', $data['board_id'])->field('board_key')->find();
                    $data['category'] = $b ? (string) $b['board_key'] : '';
                }
            }
            if ($request->has('is_paid')) {
                $data['is_paid']    = (int) $request->param('is_paid', 0);
                $data['coin_price'] = $data['is_paid'] ? (int) $request->param('coin_price', 0) : 0;
            }
            if ($request->has('status')) {
                $data['status'] = (string) $request->param('status', 'approved');
            }
            if ($request->has('tags')) {
                $tags       = $request->param('tags', '');
                $data['tags'] = is_array($tags) ? implode(',', $tags) : $tags;
            }
            if ($request->has('video_url')) {
                $data['video_url'] = mb_substr(trim((string) $request->param('video_url', '')), 0, 500);
            }
            if ($request->has('duration')) {
                $data['duration'] = max(0, (int) $request->param('duration', 0));
            }
            if ($request->has('cover_images')) {
                $ci = $request->param('cover_images', '');
                $data['cover_images'] = is_string($ci) ? $ci : json_encode(array_values(array_filter((array) $ci)), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            }

            $this->svc->updatePost($id, $data, $oldBoardId);
            return json(['code' => 200, 'message' => '更新成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除帖子（作者本人或管理员；作者仅可删除非 pending/approved 的内容）
     * 兼容路由 delete/:id 与 body.id 两种传参
     */
    public function delete(Request $request, $id = 0): Response
    {
        try {
            if (empty($id)) {
                $id = input('id', '');
            }
            if (empty($id)) {
                return json(['code' => 400, 'message' => '缺少帖子ID']);
            }
            $userId = $request->userId ?? '';
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $isAdmin = (bool) ($request->isAdmin ?? false);

            $post = Db::name('forum_posts')->where('id', $id)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }
            if (!$isAdmin && (string) $post['user_id'] !== (string) $userId) {
                return json(['code' => 403, 'message' => '无权操作该内容']);
            }
            if (!$isAdmin && in_array((string) $post['status'], ['pending', 'approved'], true)) {
                return json(['code' => 400, 'message' => '审核中或已发布的内容不可删除，请先下架']);
            }

            $this->svc->deletePost($id);
            return json(['code' => 200, 'message' => '删除成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    // ========================================================
    // 创作者（登录）：我的内容 / 草稿 / 发布 / 上下架 / 批量 / 视频上传 / 分类
    // ========================================================

    /**
     * 我的内容列表（图文 / 视频 / 发布管理 共用；默认排除草稿）
     */
    public function creatorList(Request $request): Response
    {
        try {
            $uid = $request->userId ?? '';
            if (empty($uid)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $type    = trim((string) $request->param('type', ''));
            $status  = trim((string) $request->param('status', ''));
            $keyword = trim((string) $request->param('keyword', ''));
            [$page, $limit] = $this->paging($request);

            $where = [['user_id', '=', $uid]];
            if (in_array($type, PostService::TYPES, true)) {
                $where[] = ['type', '=', $type];
            }
            if (isset(PostService::STATUS_TEXT[$status])) {
                $where[] = ['status', '=', $status];
            } else {
                $where[] = ['status', '<>', 'draft'];
            }
            if ($keyword !== '') {
                $where[] = ['title', 'like', "%{$keyword}%"];
            }

            $data = $this->svc->listPosts($where, $page, $limit, 'latest');
            return json(['code' => 200, 'message' => '获取成功', 'data' => $data]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 草稿箱列表（含字数）
     */
    public function drafts(Request $request): Response
    {
        try {
            $uid = $request->userId ?? '';
            if (empty($uid)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            [$page, $limit] = $this->paging($request);

            $rows = Db::name('forum_posts')->where('user_id', $uid)->where('status', 'draft')
                ->order('update_time', 'desc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            $list = [];
            foreach ($rows->items() as $r) {
                $plain = preg_replace('/\s+/u', '', (string) ($r['content'] ?? '')) ?? '';
                $list[] = [
                    'id'        => $r['id'],
                    'title'     => (string) ($r['title'] ?? ''),
                    'type'      => $r['type'],
                    'typeText'  => $r['type'] === 'video' ? '视频' : '图文',
                    'words'     => mb_strlen($plain),
                    'updatedAt' => (string) ($r['update_time'] ?? ''),
                ];
            }
            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => ['list' => $list, 'total' => $rows->total(), 'page' => $page, 'limit' => $limit],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 新建内容（创作者）：submit=1 直接提交审核，否则仅存草稿
     */
    public function save(Request $request): Response
    {
        try {
            $uid = $request->userId ?? '';
            if (empty($uid)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $submit = (bool) $request->param('submit', 0);
            $res = $this->svc->createPost($request, $uid, $submit ? 'pending' : 'draft');
            if (isset($res['__error'])) {
                return json(['code' => 400, 'message' => $res['__error']]);
            }
            return json([
                'code'    => 200,
                'message' => $submit ? '已提交发布' : '草稿已保存',
                'data'    => ['id' => $res['id'], 'status' => $submit ? 'pending' : 'draft'],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 上下架 / 重新提交（创作者本人）
     */
    public function toggleStatus(Request $request, $id): Response
    {
        try {
            $uid = $request->userId ?? '';
            if (empty($uid)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $post = Db::name('forum_posts')->where('id', $id)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '内容不存在']);
            }
            if ((string) $post['user_id'] !== (string) $uid) {
                return json(['code' => 403, 'message' => '无权操作该内容']);
            }

            $map = [
                'approved' => 'offline',
                'offline'  => 'approved',
                'draft'    => 'pending',
                'rejected' => 'pending',
            ];
            $from = (string) $post['status'];
            if (!isset($map[$from])) {
                return json(['code' => 400, 'message' => '当前状态不支持该操作']);
            }
            $to        = $map[$from];
            $toPending = $to === 'pending';
            $this->svc->applyStatus($id, $to, $toPending);

            return json([
                'code' => 200,
                'data' => [
                    'id'         => $id,
                    'status'     => $to,
                    'statusText' => PostService::STATUS_TEXT[$to],
                ],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 批量操作（创作者本人）：offline|approve|submit|delete
     */
    public function batch(Request $request): Response
    {
        try {
            $uid = $request->userId ?? '';
            if (empty($uid)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $ids = $request->param('ids', []);
            if (is_string($ids)) {
                $ids = explode(',', $ids);
            }
            $ids = array_values(array_unique(array_filter((array) $ids, function ($v) {
                return $v !== '' && $v !== null;
            })));
            if (!$ids) {
                return json(['code' => 400, 'message' => '请先选择要操作的内容']);
            }
            if (count($ids) > 100) {
                return json(['code' => 400, 'message' => '单次最多操作 100 条']);
            }
            $action = trim((string) $request->param('action', ''));
            $allowed = ['offline', 'approve', 'submit', 'delete'];
            if (!in_array($action, $allowed, true)) {
                return json(['code' => 400, 'message' => '不支持的批量操作']);
            }

            $res = $this->svc->batch($ids, $action, $uid);

            $data = ['success' => $res['success'], 'failed' => $res['failed']];
            if (!$res['success']) {
                return json([
                    'code'    => 400,
                    'message' => '没有可操作的' . $this->actionText($action) . '内容',
                    'data'    => $data,
                ]);
            }
            $msg = '已' . $this->actionText($action) . ' ' . count($res['success']) . ' 条';
            if ($res['failed']) {
                $msg .= '，' . count($res['failed']) . ' 条未处理';
            }
            return json(['code' => 200, 'message' => $msg, 'data' => $data]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 上传视频（创作者；保存至 /static/videos/article/）
     */
    public function uploadVideo(Request $request): Response
    {
        try {
            $file = $request->file('file');
            if (!$file) {
                return json(['code' => 400, 'message' => '未上传文件']);
            }
            $ext = strtolower((string) $file->getOriginalExtension());
            $allow = ['mp4', 'mov', 'avi', 'mkv', 'webm', 'm4v'];
            if (!in_array($ext, $allow, true)) {
                return json(['code' => 400, 'message' => '仅支持 ' . implode('/', $allow) . ' 格式']);
            }
            $maxMb = (int) $request->param('max_mb', 200);
            if ($file->getSize() > $maxMb * 1024 * 1024) {
                return json(['code' => 400, 'message' => "视频大小不能超过{$maxMb}MB"]);
            }

            $savePath = '/static/videos/article/';
            $fullPath = public_path() . $savePath;
            if (!is_dir($fullPath)) {
                mkdir($fullPath, 0755, true);
            }
            $filename = uniqid('video_') . '.' . $ext;
            $file->move($fullPath, $filename);

            return json([
                'code' => 200,
                'data' => [
                    'url'      => $savePath . $filename,
                    'size'     => $file->getSize(),
                    'duration' => max(0, (int) $request->param('duration', 0)),
                ],
                'message' => '上传成功',
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 内容分类字典（编辑器分类下拉；沿用 article_categories 字典表）
     */
    public function categories(): Response
    {
        try {
            $names = Db::name('article_categories')->where('status', 1)
                ->order('sort', 'asc')->column('name');
            return json(['code' => 200, 'message' => '获取成功', 'data' => array_values($names)]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    // ========================================================
    // 管理端（管理员）：列表 / 审核
    // ========================================================

    /**
     * 管理端内容列表（全部内容）
     */
    public function adminList(Request $request): Response
    {
        try {
            $type    = trim((string) $request->param('type', ''));
            $status  = trim((string) $request->param('status', ''));
            $keyword = trim((string) $request->param('keyword', ''));
            [$page, $limit] = $this->paging($request);

            $where = [];
            if (in_array($type, PostService::TYPES, true)) {
                $where[] = ['type', '=', $type];
            }
            if (isset(PostService::STATUS_TEXT[$status])) {
                $where[] = ['status', '=', $status];
            }
            if ($keyword !== '') {
                $where[] = ['title', 'like', "%{$keyword}%"];
            }

            $data = $this->svc->listPosts($where, $page, $limit, 'latest');

            // 批量附加作者信息
            $items   = $data['list'];
            $userIds = array_values(array_unique(array_column($items, 'userId')));
            $authors = [];
            if ($userIds !== []) {
                $authors = Db::name('users')->whereIn('id', $userIds)
                    ->column('nickname, avatar', 'id');
            }
            foreach ($items as &$it) {
                $it['author']       = $authors[$it['userId']]['nickname'] ?? '';
                $it['authorAvatar'] = $authors[$it['userId']]['avatar'] ?? '';
            }
            unset($it);
            $data['list'] = $items;

            return json(['code' => 200, 'message' => '获取成功', 'data' => $data]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 管理端审核：approve 通过 / reject 驳回
     */
    public function review(Request $request, $id): Response
    {
        try {
            $action = trim((string) $request->param('action', ''));
            $reason = trim((string) $request->param('reason', ''));
            if (!in_array($action, ['approve', 'reject'], true)) {
                return json(['code' => 400, 'message' => '审核动作不正确']);
            }
            $post = Db::name('forum_posts')->where('id', $id)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '内容不存在']);
            }
            if ((string) $post['status'] !== 'pending') {
                return json(['code' => 400, 'message' => '仅待审核内容可执行审核']);
            }
            if ($action === 'reject' && $reason === '') {
                return json(['code' => 400, 'message' => '驳回原因不能为空']);
            }
            $this->svc->review($id, $action, $reason);

            // 审核结果通知作者（与主流程隔离，失败不影响审核结果）
            try {
                $authorId = (string) ($post['user_id'] ?? '');
                if ($authorId !== '') {
                    $actionText = $action === 'approve' ? '你的帖子已通过审核' : '你的帖子未通过审核';
                    $snippet    = $action === 'reject'
                        ? ('原因：' . $reason)
                        : ((string) ($post['title'] ?? ''));
                    $this->noti->systemNotify($authorId, $actionText, $snippet);
                }
            } catch (\Throwable $e) {
                // 忽略通知异常
            }

            return json(['code' => 200, 'message' => $action === 'approve' ? '已通过' : '已驳回']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    // ========================================================
    // 私有助手
    // ========================================================

    private function paging(Request $request): array
    {
        $page  = max(1, (int) $request->param('page', 1));
        $limit = min(50, max(1, (int) $request->param('limit', 10)));
        return [$page, $limit];
    }

    private function actionText(string $action): string
    {
        return [
            'offline' => '下架',
            'approve' => '上架',
            'submit'  => '提交审核',
            'delete'  => '删除',
        ][$action] ?? '处理';
    }

    /**
     * 从请求中解析当前用户ID（公开接口未挂 JwtAuth 时，尝试从 Authorization 头解析）
     */
    private function resolveUserId(Request $request): string
    {
        $userId = $request->userId ?? '';
        if (!empty($userId)) {
            return (string) $userId;
        }
        $token = $request->header('Authorization');
        if (!$token) {
            return '';
        }
        $token = str_replace('Bearer ', '', $token);
        try {
            $payload = (new JwtService())->verifyToken($token);
            $uid = $payload->user_id ?? null;
            return $uid !== null ? (string) $uid : '';
        } catch (\Exception $e) {
            return '';
        }
    }

    private function ensureWallet(string $userId): void
    {
        $exist = Db::name('user_wallet')->where('user_id', $userId)->find();
        if (!$exist) {
            Db::name('user_wallet')->insert([
                'id'           => $this->uuidV4(),
                'user_id'      => $userId,
                'balance'      => 0,
                'frozen'       => 0,
                'total_earned' => 0,
                'total_spent'  => 0,
                'create_time'  => date('Y-m-d H:i:s'),
                'update_time'  => date('Y-m-d H:i:s'),
            ]);
        }
    }

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

    private function httpPostRaw(string $url, string $rawBody, int $timeout = 10): string
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $rawBody,
            CURLOPT_HTTPHEADER     => ['Content-Type: application/json'],
            CURLOPT_TIMEOUT        => $timeout,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_SSL_VERIFYHOST => 2,
        ]);
        $res = curl_exec($ch);
        if ($res === false) {
            $err = curl_error($ch);
            curl_close($ch);
            throw new \Exception('HTTP POST 失败：' . $err);
        }
        curl_close($ch);
        return (string) $res;
    }
}
