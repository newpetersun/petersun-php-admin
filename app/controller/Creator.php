<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 创作者数据控制器（概览 / 待办 / 内容数据 / 粉丝画像）
 *
 * 数据来源：
 *   - 内容指标取 articles 累计字段，始终可用；
 *   - 粉丝指标由 user_follows 关联 users 聚合；
 *   - 分日趋势取 article_daily_stats，依赖内容浏览埋点写入，
 *     无数据时返回 available=false，前端展示空态而非 0。
 */
class Creator extends BaseController
{
    /** 概览：核心指标 + 待办数 + 认证状态 */
    public function overview(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $sum = Db::name('forum_posts')->where('user_id', $uid)
                ->field('COUNT(*) AS total, COALESCE(SUM(views),0) AS views, COALESCE(SUM(like_count),0) AS likes, COALESCE(SUM(comment_count),0) AS comments')
                ->find() ?: [];

            $fans = Db::name('user_follows')->where('following_id', $uid)->count();
            $monthIncome = Db::name('earning_records')
                ->where('user_id', $uid)
                ->where('settle_status', 1)
                ->where('amount', '>', 0)
                ->whereTime('create_time', 'month')
                ->sum('amount');

            return $this->ok([
                'metrics'  => [
                    ['key' => 'views',   'label' => '总阅读 / 播放', 'value' => (int) ($sum['views'] ?? 0), 'unit' => '次'],
                    ['key' => 'fans',    'label' => '粉丝总数',       'value' => (int) $fans, 'unit' => '人'],
                    ['key' => 'income',  'label' => '本月收益',       'value' => round((float) $monthIncome, 2), 'unit' => '元'],
                    ['key' => 'content', 'label' => '内容总数',       'value' => (int) ($sum['total'] ?? 0), 'unit' => '篇'],
                ],
                'todos'    => $this->todoCounts($uid),
                'verified' => $this->verifyStatus($uid),
            ]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /**
     * 内容数据：核心指标 + 热门内容 TopN + 分日趋势
     *
     * @param range 统计区间：7 | 30（天）
     * @param top   热门内容条数，默认 5
     */
    public function contentStats(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $range = (int) $request->param('range', 7);
            $range = in_array($range, [7, 30], true) ? $range : 7;
            $topN  = min(20, max(1, (int) $request->param('top', 5)));
            $since = date('Y-m-d', strtotime("-{$range} days"));

            $sum = Db::name('forum_posts')->where('user_id', $uid)
                ->field('COUNT(*) AS total, COALESCE(SUM(views),0) AS views, COALESCE(SUM(like_count),0) AS likes, COALESCE(SUM(comment_count),0) AS comments')
                ->find() ?: [];

            $byType = Db::name('forum_posts')->where('user_id', $uid)
                ->field('type, COUNT(*) AS cnt')
                ->group('type')
                ->select()
                ->toArray();
            $typeMap = [];
            foreach ($byType as $t) {
                $typeMap[$t['type'] === 'video' ? 'video' : 'image_text'] = (int) $t['cnt'];
            }

            // 热门内容（按阅读量）
            $top = Db::name('forum_posts')->where('user_id', $uid)
                ->where('status', 'approved')
                ->field('id, title, cover_images, views, like_count, comment_count, type')
                ->order('views', 'desc')
                ->limit($topN)
                ->select()
                ->toArray();
            $maxViews = 0;
            foreach ($top as $t) {
                $maxViews = max($maxViews, (int) $t['views']);
            }
            $topList = [];
            foreach ($top as $t) {
                $topCover = '';
                $decoded = json_decode((string) ($t['cover_images'] ?? ''), true);
                if (is_array($decoded) && isset($decoded[0])) {
                    $topCover = (string) $decoded[0];
                }
                $topList[] = [
                    'id'       => $t['id'],
                    'title'    => (string) $t['title'],
                    'cover'    => $topCover,
                    'type'     => $t['type'],
                    'views'    => (int) $t['views'],
                    'likes'    => (int) $t['like_count'],
                    'comments' => (int) $t['comment_count'],
                    'pct'      => $maxViews > 0 ? round((int) $t['views'] * 100 / $maxViews) : 0,
                ];
            }

            // 分日趋势：当前内容未启用分日埋点，返回空态
            $trend = [];

            $rangeFans = Db::name('user_follows')->where('following_id', $uid)
                ->whereTime('create_time', "-{$range} days")
                ->count();

            return $this->ok([
                'range'   => $range,
                'metrics' => [
                    ['key' => 'views',    'label' => '总阅读 / 播放', 'value' => (int) ($sum['views'] ?? 0)],
                    ['key' => 'engage',   'label' => '总互动',        'value' => (int) ($sum['likes'] ?? 0) + (int) ($sum['comments'] ?? 0)],
                    ['key' => 'fans',     'label' => '新增粉丝',      'value' => (int) $rangeFans],
                    ['key' => 'content',  'label' => '内容总数',      'value' => (int) ($sum['total'] ?? 0)],
                ],
                'content' => [
                    'imageText' => (int) ($typeMap['image_text'] ?? 0),
                    'video'     => (int) ($typeMap['video'] ?? 0),
                ],
                'top'       => $topList,
                'trend'     => $trend,
                'available' => $trend !== [],
            ]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /**
     * 粉丝画像：总数 / 活跃 / 铁粉 / 性别 / 年龄 / 城市 Top
     *
     * 说明：users 表无生日/年龄字段，年龄分布无法计算，返回 available=false；
     * 性别取粉丝自身资料 gender；城市取粉丝资料 city。
     */
    public function fans(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $total = Db::name('user_follows')->where('following_id', $uid)->count();
            $range = (int) $request->param('range', 30);
            $range = in_array($range, [7, 30, 90], true) ? $range : 30;
            $newFans = Db::name('user_follows')->where('following_id', $uid)
                ->whereTime('create_time', "-{$range} days")
                ->count();

            // 粉丝资料聚合（关联 users）
            $rows = Db::name('user_follows')->alias('f')
                ->join('users u', 'u.id = f.follower_id')
                ->where('f.following_id', $uid)
                ->field('u.gender, u.province, u.city, u.create_time')
                ->select()
                ->toArray();

            $male = $female = $unknown = 0;
            $cityMap = [];
            foreach ($rows as $r) {
                $g = (int) ($r['gender'] ?? 0);
                if ($g === 1) {
                    $male++;
                } elseif ($g === 2) {
                    $female++;
                } else {
                    $unknown++;
                }
                $city = trim((string) ($r['city'] ?? ''));
                if ($city === '') {
                    $city = trim((string) ($r['province'] ?? ''));
                }
                if ($city !== '') {
                    $cityMap[$city] = ($cityMap[$city] ?? 0) + 1;
                }
            }
            arsort($cityMap);
            $cities = [];
            foreach (array_slice($cityMap, 0, 5, true) as $name => $cnt) {
                $cities[] = ['name' => (string) $name, 'count' => (int) $cnt];
            }

            // 活跃粉丝：近 30 天有访问或互动记录（以登录时间近似）
            $activeFrom = date('Y-m-d H:i:s', strtotime('-30 days'));
            $activeIds = Db::name('users')->where('last_login_time', '>=', $activeFrom)->column('id');
            $active = 0;
            if ($activeIds !== []) {
                $active = Db::name('user_follows')->where('following_id', $uid)
                    ->whereIn('follower_id', $activeIds)->count();
            }

            // 铁粉：互动次数最高的头部粉丝（按评论数排序取前 10）
            // 注意：group() 后不能用 COUNT() 表达式排序，须用字段别名
            $loyalRows = Db::name('user_follows')->alias('f')
                ->leftJoin('forum_post_comments c', 'c.user_id = f.follower_id')
                ->where('f.following_id', $uid)
                ->group('f.follower_id')
                ->field('f.follower_id, COUNT(c.id) AS cnt')
                ->order('cnt', 'desc')
                ->limit(10)
                ->select()
                ->toArray();
            $fansTop = count($loyalRows);

            $genderTotal = max(1, $male + $female);

            return $this->ok([
                'metrics' => [
                    ['key' => 'total',   'label' => '粉丝总数', 'value' => (int) $total],
                    ['key' => 'active',  'label' => '活跃粉丝', 'value' => (int) $active],
                    ['key' => 'loyal',   'label' => '铁粉',     'value' => (int) $fansTop],
                ],
                'gender' => [
                    'male'    => $male,
                    'female'  => $female,
                    'unknown' => $unknown,
                    'femalePct' => (int) round($female * 100 / $genderTotal),
                ],
                'age' => [
                    'available' => false,
                    'reason'    => '用户资料未采集年龄字段，暂无法统计年龄分布',
                    'items'     => [],
                ],
                'cities'    => $cities,
                'newInRange' => (int) $newFans,
                'range'     => $range,
            ]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /**
     * 官方公告（创作者中心展示）
     *
     * @param limit 返回条数，默认 5，上限 20
     */
    public function announcements(Request $request): Response
    {
        try {
            $limit = min(20, max(1, (int) $request->param('limit', 5)));

            $rows = Db::name('announcements')
                ->where('status', 1)
                ->order('is_top', 'desc')
                ->order('publish_time', 'desc')
                ->order('id', 'desc')
                ->limit($limit)
                ->select()
                ->toArray();

            $typeText = [
                'notice'   => '通知',
                'activity' => '活动',
                'rule'     => '规则',
            ];

            $list = [];
            foreach ($rows as $r) {
                $list[] = [
                    'id'       => $r['id'],
                    'title'    => (string) $r['title'],
                    'content'  => (string) $r['content'],
                    'type'     => (string) $r['type'],
                    'typeText' => $typeText[(string) $r['type']] ?? '公告',
                    'link'     => (string) ($r['link'] ?? ''),
                    'isTop'    => (int) $r['is_top'] === 1,
                    'time'     => (string) ($r['publish_time'] ?? $r['create_time'] ?? ''),
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

    /**
     * 待办计数
     * 评论待审核 / 申诉处理中 / 未读私信 / 被驳回内容
     */
    private function todoCounts(string $uid): array
    {
        // 待回复评论：自己内容下的正常评论
        $pendingComments = Db::name('forum_post_comments')->alias('c')
            ->join('forum_posts p', 'p.id = c.post_id')
            ->where('p.user_id', $uid)
            ->where('c.status', 1)
            ->count();

        $appeals = Db::name('appeals')->where('user_id', $uid)
            ->where('status', 'processing')->count();

        $unread = Db::name('user_messages')->where('to_id', $uid)
            ->where('is_read', 0)->count();

        $rejected = Db::name('forum_posts')->where('user_id', $uid)
            ->where('status', 'rejected')->count();

        return [
            ['key' => 'comments', 'label' => '待回复评论', 'count' => (int) $pendingComments, 'path' => 'comments'],
            ['key' => 'appeals',  'label' => '待处理申诉', 'count' => (int) $appeals, 'path' => 'appeals'],
            ['key' => 'messages', 'label' => '待读私信',   'count' => (int) $unread, 'path' => 'messages'],
            ['key' => 'rejected', 'label' => '被驳回内容', 'count' => (int) $rejected, 'path' => 'publish'],
        ];
    }

    /**
     * 实名认证状态
     * @return array{status:string,text:string}
     */
    private function verifyStatus(string $uid): array
    {
        $row = Db::name('user_certifications')->where('user_id', $uid)
            ->order('create_time', 'desc')
            ->field('status')
            ->find();
        $status = (string) ($row['status'] ?? 'none');
        $text = [
            'none'      => '未认证',
            'pending'   => '审核中',
            'approved'  => '已认证',
            'rejected'  => '已驳回',
        ][$status] ?? '未认证';

        return ['status' => $status === '' ? 'none' : $status, 'text' => $text];
    }

    /** 当前登录用户ID */
    private function uid(Request $request): string
    {
        return (string) ($request->userId ?? '');
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
