<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;
use app\service\VirtualPayService;

/**
 * 论坛帖子接口
 */
class Post extends BaseController
{
    private const DEFAULT_AVATAR = '/static/images/default-avatar.jpg';

    /**
     * 帖子列表
     * 支持 board_id / key / category 过滤，keyword 搜索，is_essence 筛选，sort=latest|hot
     */
    public function list(Request $request): Response
    {
        try {
            $boardId = (string)$request->param('board_id', '');
            $key     = $request->param('key', '');
            $category = $request->param('category', '');
            $keyword = $request->param('keyword', '');
            $isEssence = $request->param('is_essence', '');
            $sort    = $request->param('sort', 'latest');
            $page    = (int)$request->param('page', 1);
            $limit   = (int)$request->param('limit', 10);
            $status  = $request->param('status', '1');

            $where = [];
            if ($status !== 'all') {
                $where[] = ['status', '=', (int)$status];
            }

            if ($boardId) {
                $where[] = ['board_id', '=', $boardId];
            } elseif (!empty($category) && $category !== 'all') {
                $where[] = ['category', '=', $category];
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
                $where[] = ['is_essence', '=', (int)$isEssence];
            }

            $query = Db::name('forum_posts')->where($where);
            if ($sort === 'hot') {
                $query->order('like_count', 'desc')->order('create_time', 'desc');
            } else {
                $query->order('is_pinned', 'desc')->order('create_time', 'desc');
            }

            $paginate = $query->paginate(['list_rows' => $limit, 'page' => $page]);
            $list = array_map([$this, 'formatPost'], $paginate->items());

            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list'  => $list,
                    'total' => $paginate->total(),
                    'page'  => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 帖子详情（含正文、评论、当前用户点赞态）
     */
    public function detail(Request $request, $id): Response
    {
        try {
            $post = Db::name('forum_posts')->where('id', $id)->where('status', 1)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }

            // 浏览量 +1
            Db::name('forum_posts')->where('id', $id)->inc('views')->update();

            // 付费内容解锁判定：作者本人始终可见；已登录用户存在购买记录视为已购
            $isPaid = !empty($post['is_paid']);
            $purchased = false;
            $userId = $this->resolveUserId($request);
            if ($userId) {
                if ($userId === (string)($post['user_id'] ?? '')) {
                    $purchased = true;
                } else {
                    $bought = Db::name('forum_post_purchases')
                        ->where('post_id', $id)
                        ->where('user_id', $userId)
                        ->find();
                    $purchased = !empty($bought);
                }
            }

            $data = $this->formatPost($post);
            // 付费且未购买：不返回正文（防止抓包泄露），仅保留摘要等公开信息
            $data['content'] = ($isPaid && !$purchased) ? '' : ($post['content'] ?? '');
            $data['purchased'] = $purchased;

            // 当前用户点赞态
            $liked = false;
            if (!empty($userId)) {
                $like = Db::name('forum_post_likes')
                    ->where('post_id', $id)
                    ->where('user_id', $userId)
                    ->find();
                $liked = !empty($like);
            }
            $data['liked'] = $liked;

            // 评论
            $data['comments'] = $this->getComments($id);

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
     * 金币购买解锁付费帖正文
     * 校验余额 -> 扣减金币 -> 写入 forum_post_purchases（结算状态 0，待结算给作者）
     */
    public function buy(Request $request): Response
    {
        try {
            $userId = $request->userId;
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }

            $postId = (string)$request->param('post_id', '');
            if (empty($postId)) {
                return json(['code' => 400, 'message' => '帖子ID不能为空']);
            }

            $post = Db::name('forum_posts')->where('id', $postId)->where('status', 1)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }

            // 作者本人无需购买，直接视为已解锁
            if ($userId === (string)($post['user_id'] ?? '')) {
                return json(['code' => 200, 'message' => '您是作者，已自动解锁', 'data' => ['purchased' => true]]);
            }

            // 幂等：已购买直接返回成功
            $exist = Db::name('forum_post_purchases')
                ->where('post_id', $postId)
                ->where('user_id', $userId)
                ->find();
            if ($exist) {
                return json(['code' => 200, 'message' => '已解锁', 'data' => ['purchased' => true]]);
            }

            if (empty($post['is_paid']) || (int)($post['coin_price'] ?? 0) <= 0) {
                return json(['code' => 400, 'message' => '该帖子无需购买']);
            }

            $price = (int)$post['coin_price'];
            $authorId = (string)($post['user_id'] ?? '');

            // 作者 openid（用于把文章收益写入 virtual_pay_orders，便于作者查看/对账）
            $author = Db::name('users')->where('id', $authorId)->field('openid')->find();
            $authorOpenid = $author ? (string)($author['openid'] ?? '') : '';

            // 确保买卖双方钱包行存在（无则初始化 0 余额）
            $this->ensureWallet($userId);
            $this->ensureWallet($authorId);

            // 余额校验（从钱包表读取）
            $balance = (int)Db::name('user_wallet')->where('user_id', $userId)->value('balance');
            if ($balance < $price) {
                // 402 Payment Required：金币余额不足，前端据此跳转到钱包充值
                return json(['code' => 402, 'message' => '金币不足，请先充值']);
            }

            Db::startTrans();
            try {
                // 扣减买家金币
                Db::name('user_wallet')->where('user_id', $userId)
                    ->inc('total_spent', $price)
                    ->dec('balance', $price)
                    ->update();
                // 增加作者金币（即时入账）
                Db::name('user_wallet')->where('user_id', $authorId)
                    ->inc('total_earned', $price)
                    ->inc('balance', $price)
                    ->update();
                // 写入购买记录
                Db::name('forum_post_purchases')->insert([
                    'id'            => $this->uuidV4(),
                    'post_id'       => $postId,
                    'user_id'       => $userId,
                    'coins'         => $price,
                    'settle_status' => 1,
                    'settle_amount' => $price,
                    'settle_time'   => date('Y-m-d H:i:s'),
                    'create_time'   => date('Y-m-d H:i:s')
                ]);
                // 记录作者文章收益到虚拟支付订单表：标明哪篇文章获得金币（作者 openid 维度，便于对账/钱包明细展示）
                if ($authorOpenid !== '') {
                    Db::name('virtual_pay_orders')->insert([
                        'id'             => $this->uuidV4(),
                        'out_trade_no'   => 'A' . date('YmdHis') . str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT),
                        'wx_order_id'    => null,
                        'openid'         => $authorOpenid,
                        'product_id'     => 'article_income',
                        'product_name'   => mb_substr('文章收益 《'.$post['title'].'》'?? '文章', 0, 120),
                        'quantity'       => $price,
                        'goods_price'    => 0,
                        'pay_fee'        => 0,
                        'attach'         => json_encode([
                            'post_id'  => $postId,
                            'buyer_id' => $userId,
                            'type'     => 'article_income'
                        ], JSON_UNESCAPED_UNICODE),
                        'env'            => 0,
                        'status'         => 'paid',
                        'deliver_status' => 1,
                        'paid_time'      => date('Y-m-d H:i:s'),
                        'deliver_time'   => date('Y-m-d H:i:s'),
                        'create_time'    => date('Y-m-d H:i:s'),
                        'update_time'    => date('Y-m-d H:i:s')
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
     * 举报帖子（需登录）
     * 校验登录 -> 校验帖子存在 -> 写入 forum_reports（status=0 待处理）
     */
    public function report(Request $request): Response
    {
        try {
            $userId = $request->userId;
            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录']);
            }
            $postId = (string)$request->param('post_id', '');
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
            // 不能举报自己的帖子
            if ((string)($post['user_id'] ?? '') === (string)$userId) {
                return json(['code' => 400, 'message' => '不能举报自己的帖子']);
            }

            Db::name('forum_reports')->insert([
                'id'          => $this->uuidV4(),
                'post_id'     => $postId,
                'reporter_id' => $userId,
                'reason'      => $reason,
                'desc'        => $desc,
                'status'      => 0,
                'create_time' => date('Y-m-d H:i:s')
            ]);

            return json(['code' => 200, 'message' => '举报已提交，感谢反馈']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 生成帖子分享小程序码（用于分享海报）
     * GET /post/poster-code?path=页面路径&id=帖子ID
     * 返回 base64 图片，前端写入本地文件后绘制到海报 canvas
     */
    public function posterCode(Request $request): Response
    {
        try {
            $path = ltrim((string)$request->param('path', 'subpkg/forum/detail'), '/');
            $id   = (string)$request->param('id', '');
            $query = '';
            if (!preg_match('/^[\w\/]+$/', $path)) {
                return json(['code' => 400, 'message' => '非法的页面路径']);
            }
            if ($id !== '') {
                if (!preg_match('/^[\w\-]+$/', $id)) {
                    return json(['code' => 400, 'message' => '非法的帖子ID']);
                }
                $query = '?id=' . $id;
            }
            $fullPath = $path . $query;

            $accessToken = VirtualPayService::getAccessToken();
            $url  = 'https://api.weixin.qq.com/wxa/getwxacode?access_token=' . $accessToken;
            $raw  = json_encode([
                'path'       => $fullPath,
                'width'      => 430,
                'auto_color' => false,
                'line_color' => ['r' => 37, 'g' => 99, 'b' => 235],
                'is_hyaline' => true,
            ]);

            $img = $this->httpPostRaw($url, $raw);
            // 微信成功返回图片二进制；失败返回 JSON {errcode,errmsg}
            if (substr(trim($img), 0, 1) === '{') {
                $err = json_decode($img, true);
                return json([
                    'code'    => 500,
                    'message' => '生成小程序码失败：' . ($err['errmsg'] ?? 'unknown')
                ]);
            }

            return json([
                'code' => 200,
                'data' => ['image' => 'data:image/png;base64,' . base64_encode($img)]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 发送原始 JSON 请求体（调用微信接口）
     */
    private function httpPostRaw(string $url, string $rawBody, int $timeout = 10): string
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $rawBody,
            CURLOPT_HTTPHEADER     => ['Content-Type: application/json'],
            CURLOPT_TIMEOUT        => $timeout,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);
        $res = curl_exec($ch);
        if ($res === false) {
            $err = curl_error($ch);
            curl_close($ch);
            throw new \Exception('HTTP POST 失败：' . $err);
        }
        curl_close($ch);
        return (string)$res;
    }

    /**
     * 发布帖子（需登录）
     */
    public function create(Request $request): Response
    {
        try {
            $userId  = $request->userId;
            $boardId = (string)$request->param('board_id', '');
            $key     = $request->param('key', '');
            $title   = trim($request->param('title', ''));
            $content = trim($request->param('content', ''));
            $tags    = $request->param('tags', '');
            $cover   = $request->param('cover_images', '');
            $isPaid  = (int)$request->param('is_paid', 0);
            $coinPrice = (int)$request->param('coin_price', 0);
            $status  = (int)$request->param('status', 1);

            if (empty($title)) {
                return json(['code' => 400, 'message' => '标题不能为空']);
            }
            if (empty($boardId) && !empty($key)) {
                $board = Db::name('forum_boards')->where('board_key', $key)->find();
                $boardId = $board ? $board['id'] : '';
            }
            if (empty($boardId)) {
                return json(['code' => 400, 'message' => '所属板块不能为空']);
            }

            if (is_array($tags)) {
                $tags = implode(',', $tags);
            }
            if (is_array($cover)) {
                $cover = json_encode($cover, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            }

            $category = Db::name('forum_boards')->where('id', $boardId)->value('board_key');

            $postId = $this->uuidV4();
            $plainSummary = trim(preg_replace('/\s+/', ' ', preg_replace('/^[#>+\-*`]+/m', '', $content)));
            Db::name('forum_posts')->insert([
                'id'           => $postId,
                'board_id'     => $boardId,
                'user_id'      => $userId,
                'title'        => $title,
                'summary'      => mb_substr($plainSummary, 0, 120),
                'content'      => $content,
                'category'     => $category ?: '',
                'tags'         => $tags ?: '',
                'cover_images' => $cover ?: '',
                'is_paid'      => $isPaid,
                'coin_price'   => $isPaid ? $coinPrice : 0,
                'status'       => $status,
                'create_time'  => date('Y-m-d H:i:s')
            ]);

            // 仅已发布帖子才计入板块帖子数
            if ($status === 1) {
                Db::name('forum_boards')->where('id', $boardId)->inc('post_count')->update();
            }

            return json([
                'code' => 200,
                'message' => '发布成功',
                'data' => ['id' => $postId]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 帖子图片上传（需登录）
     * 表单字段名：image；保存至 /static/images/forum/，返回可访问 url
     */
    public function uploadImage(Request $request): Response
    {
        try {
            $file = $request->file('image');
            if (!$file) {
                return json(['code' => 400, 'message' => '未上传文件']);
            }

            $validate = validate(['image' => [
                'fileSize' => 5 * 1024 * 1024, // 5MB
                'fileExt'  => 'jpg,jpeg,png,gif,webp',
                'fileMime' => 'image/jpeg,image/png,image/gif,image/webp'
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
            $info = $file->move($fullPath, $fileName);
            if ($info) {
                return json([
                    'code'    => 200,
                    'message' => '上传成功',
                    'data'    => [
                        'url' => $savePath . $fileName,
                        'name' => $fileName
                    ]
                ]);
            }
            return json(['code' => 500, 'message' => $file->getError()]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 点赞 / 取消点赞（需登录）
     */
    public function like(Request $request): Response
    {
        try {
            $userId = $request->userId;
            $postId = (string)$request->param('post_id', '');
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
                        'create_time' => date('Y-m-d H:i:s')
                    ]);
                    Db::name('forum_posts')->where('id', $postId)->inc('like_count')->update();
                    $liked = true;
                }
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                throw $e;
            }

            $likes = (int)Db::name('forum_posts')->where('id', $postId)->value('like_count');

            return json([
                'code' => 200,
                'message' => $liked ? '点赞成功' : '已取消点赞',
                'data' => ['liked' => $liked, 'likes' => $likes]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 发表评论（需登录）
     */
    public function comment(Request $request): Response
    {
        try {
            $userId  = $request->userId;
            $postId  = (string)$request->param('post_id', '');
            $content = trim($request->param('content', ''));
            $replyTo = (string)$request->param('reply_to', '');

            if (empty($postId)) {
                return json(['code' => 400, 'message' => '帖子参数不能为空']);
            }
            if (empty($content)) {
                return json(['code' => 400, 'message' => '评论内容不能为空']);
            }

            $commentId = Db::name('forum_post_comments')->insertGetId([
                'id'          => $this->uuidV4(),
                'post_id'     => $postId,
                'user_id'     => $userId,
                'parent_id'   => $replyTo ?: null,
                'content'     => $content,
                'status'      => 1,
                'create_time' => date('Y-m-d H:i:s')
            ]);

            Db::name('forum_posts')->where('id', $postId)->inc('comment_count')->update();

            return json([
                'code' => 200,
                'message' => '评论成功',
                'data' => ['id' => $commentId]
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
            $page  = (int)$request->param('page', 1);
            $limit = (int)$request->param('limit', 50);

            $where = [['post_id', '=', $id], ['status', '=', 1]];
            $paginate = Db::name('forum_post_comments')
                ->where($where)
                ->order('create_time', 'asc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            $list = array_map(function ($c) {
                $author = Db::name('users')
                    ->where('id', $c['user_id'])
                    ->field('nickname, avatar')
                    ->find();
                return [
                    'id'           => $c['id'],
                    'userId'       => $c['user_id'],
                    'content'      => $c['content'],
                    'author'       => $author['nickname'] ?? '匿名用户',
                    'authorAvatar' => $author['avatar'] ?? self::DEFAULT_AVATAR,
                    'replyTo'      => $c['parent_id'],
                    'likeCount'    => (int)$c['like_count'],
                    'createdAt'    => $c['create_time']
                ];
            }, $paginate->items());

            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list'  => $list,
                    'total' => $paginate->total(),
                    'page'  => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 将帖子行格式化为前端所需结构
     */
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

        // 封面字段为空时，从正文（markdown / HTML）中提取内嵌图片作为缩略图
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
            'coinPrice'    => (int)($post['coin_price'] ?? 0),
            'coverImages'  => array_slice($cover, 0, 9)
        ];
    }

    /**
     * 删除帖子（管理员；兼容路由 delete/:id 与 body.id 两种传参）
     */
    public function delete($id = 0): Response
    {
        try {
            if (empty($id)) {
                $id = input('id', '');
            }
            if (empty($id)) {
                return json(['code' => 400, 'message' => '缺少帖子ID']);
            }
            $post = Db::name('forum_posts')->where('id', $id)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }
            Db::name('forum_posts')->where('id', $id)->delete();
            if ((int)$post['status'] === 1) {
                Db::name('forum_boards')->where('id', $post['board_id'])->dec('post_count')->update();
            }
            return json(['code' => 200, 'message' => '删除成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新帖子（管理员；兼容路由 update/:id 与 body.id 两种传参）
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
            $post = Db::name('forum_posts')->where('id', $id)->find();
            if (!$post) {
                return json(['code' => 404, 'message' => '帖子不存在']);
            }
            $data = [];
            $title = trim($request->param('title', ''));
            $content = trim($request->param('content', ''));
            $key = $request->param('key', '');
            if ($title !== '') {
                $data['title'] = $title;
            }
            if ($content !== '') {
                $data['content'] = $content;
                $plain = trim(preg_replace('/\s+/', ' ', preg_replace('/^[#>+\-*`]+/m', '', $content)));
                $data['summary'] = mb_substr($plain, 0, 120);
            }
            if ($key !== '') {
                $board = Db::name('forum_boards')->where('board_key', $key)->find();
                if ($board) {
                    $data['board_id'] = $board['id'];
                    $data['category'] = $board['board_key'];
                }
            }
            if ($request->has('is_paid')) {
                $data['is_paid'] = (int)$request->param('is_paid', 0);
                $data['coin_price'] = $data['is_paid'] ? (int)$request->param('coin_price', 0) : 0;
            }
            if ($request->has('status')) {
                $data['status'] = (int)$request->param('status', 1);
            }
            if ($request->has('tags')) {
                $tags = $request->param('tags', '');
                $data['tags'] = is_array($tags) ? implode(',', $tags) : $tags;
            }
            $data['update_time'] = date('Y-m-d H:i:s');
            Db::name('forum_posts')->where('id', $id)->update($data);
            return json(['code' => 200, 'message' => '更新成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 从帖子正文中提取图片地址（兼容 Markdown ![](url) 与 HTML <img src>）
     * 仅取外链/相对路径，过滤 data: 内联 base64，并去重
     */
    private function extractImagesFromContent(string $content): array
    {
        $urls = [];

        // Markdown 图片：![alt](url)
        if (preg_match_all('/!\[[^\]]*\]\(([^)\s]+)\)/', $content, $m)) {
            $urls = array_merge($urls, $m[1]);
        }

        // HTML 图片：<img src="url" ...>
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

    /**
     * 获取帖子评论（供详情接口复用）
     */
    private function getComments($postId, $limit = 50): array
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
                'replyTo'      => (int)$c['parent_id'],
                'likeCount'    => (int)$c['like_count'],
                'createdAt'    => $c['create_time']
            ];
        }, $rows);
    }

    /**
     * 生成 UUID v4（不依赖第三方库）
     */
    private function uuidV4(): string
    {
        return sprintf(
            '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
        );
    }

    /**
     * 从请求中解析当前用户ID：
     * 优先取鉴权中间件注入的 userId；若未注入（公开读接口未挂 JwtAuth），
     * 则尝试从 Authorization 头解析 JWT。无法识别则返回空串（匿名）。
     */
    private function resolveUserId(Request $request): string
    {
        $userId = $request->userId ?? '';
        if (!empty($userId)) {
            return (string)$userId;
        }

        $token = $request->header('Authorization');
        if (!$token) {
            return '';
        }
        $token = str_replace('Bearer ', '', $token);
        try {
            $jwtService = new \app\service\JwtService();
            $payload = $jwtService->verifyToken($token);
            $uid = $payload->user_id ?? null;
            return $uid !== null ? (string)$uid : '';
        } catch (\Exception $e) {
            return '';
        }
    }

    /**
     * 确保用户存在钱包行（一对一），无则初始化 0 余额
     */
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
                'update_time'  => date('Y-m-d H:i:s')
            ]);
        }
    }
}
