<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 创作者收益控制器（收益概览 / 收益趋势 / 提现 / 付费订单）
 *
 * 数据来源：
 *   - earning_records     收益流水（收入/提现/调整）
 *   - user_wallet         钱包余额（balance 可用 / frozen 冻结 / total_earned 累计）
 *   - withdraw_records    提现申请
 *   - article_purchases   付费内容购买（付费订单 + 结算来源）
 */
class Earning extends BaseController
{
    private const SOURCE_TEXT = [
        'article' => '图文创作',
        'video'   => '视频创作',
        'reward'  => '粉丝赞赏',
        'withdraw' => '提现',
        'adjust'  => '平台调整',
    ];

    /** 收益概览：钱包 + 累计 + 本月预估 + 来源构成 + 最近流水 */
    public function overview(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $wallet = Db::name('user_wallet')->where('user_id', $uid)->find();
            $balance = (float) ($wallet['balance'] ?? 0);
            $frozen  = (float) ($wallet['frozen'] ?? 0);
            $totalEarned = (float) ($wallet['total_earned'] ?? 0);

            // 无钱包记录时以流水表兜底计算
            if (!$wallet) {
                $totalEarned = (float) Db::name('earning_records')->where('user_id', $uid)
                    ->where('amount', '>', 0)->sum('amount');
                $balance = $totalEarned - (float) Db::name('earning_records')->where('user_id', $uid)
                    ->where('amount', '<', 0)->sum('amount') - $frozen;
            }

            $monthEstimate = (float) Db::name('earning_records')->where('user_id', $uid)
                ->where('amount', '>', 0)->whereTime('create_time', 'month')->sum('amount');
            $pending = (float) Db::name('earning_records')->where('user_id', $uid)
                ->where('settle_status', 0)->where('amount', '>', 0)->sum('amount');

            // 来源构成
            $rows = Db::name('earning_records')->where('user_id', $uid)
                ->where('amount', '>', 0)
                ->field('source, COALESCE(SUM(amount),0) AS amount')
                ->group('source')
                ->order('amount', 'desc')
                ->select()
                ->toArray();
            $sum = 0.0;
            foreach ($rows as $r) {
                $sum += (float) $r['amount'];
            }
            $sources = [];
            foreach ($rows as $r) {
                $sources[] = [
                    'source' => $r['source'],
                    'name'   => self::SOURCE_TEXT[$r['source']] ?? $r['source'],
                    'amount' => round((float) $r['amount'], 2),
                    'pct'    => $sum > 0 ? round((float) $r['amount'] * 100 / $sum) : 0,
                ];
            }

            // 最近流水
            $recent = Db::name('earning_records')->where('user_id', $uid)
                ->field('id, source, amount, description, settle_status, create_time')
                ->order('create_time', 'desc')
                ->limit(10)
                ->select()
                ->toArray();
            $recentList = [];
            foreach ($recent as $r) {
                $amt = round((float) $r['amount'], 2);
                $recentList[] = [
                    'id'          => $r['id'],
                    'date'        => (string) $r['create_time'],
                    'source'      => self::SOURCE_TEXT[$r['source']] ?? $r['source'],
                    'description' => (string) ($r['description'] ?? ''),
                    'amount'      => $amt,
                    'direction'   => $amt >= 0 ? 'in' : 'out',
                    'settled'     => (int) $r['settle_status'] === 1,
                ];
            }

            return $this->ok([
                'metrics' => [
                    ['key' => 'balance', 'label' => '账户余额',   'value' => round($balance, 2), 'unit' => '元', 'frozen' => round($frozen, 2)],
                    ['key' => 'total',   'label' => '累计收益',   'value' => round($totalEarned, 2), 'unit' => '元'],
                    ['key' => 'month',   'label' => '本月预估',   'value' => round($monthEstimate, 2), 'unit' => '元', 'pending' => round($pending, 2)],
                ],
                'sources' => $sources,
                'recent'  => $recentList,
            ]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 收益趋势：range=7 | 30 | year */
    public function trend(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $range = (int) $request->param('range', 30);
            if (!in_array($range, [7, 30, 365], true)) {
                $range = 30;
            }

            // 7 天按日、30 天按日、年度按月
            $byMonth = ($range === 365);
            if ($byMonth) {
                $since = date('Y-m-01', strtotime('-11 months'));
                $rows = Db::name('earning_records')->where('user_id', $uid)
                    ->where('amount', '>', 0)
                    ->where('create_time', '>=', $since)
                    ->field("DATE_FORMAT(create_time, '%Y-%m') AS period, COALESCE(SUM(amount),0) AS amount")
                    ->group('period')->order('period', 'asc')->select()->toArray();
            } else {
                $since = date('Y-m-d', strtotime("-" . ($range - 1) . " days"));
                $rows = Db::name('earning_records')->where('user_id', $uid)
                    ->where('amount', '>', 0)
                    ->where('create_time', '>=', $since)
                    ->field("DATE_FORMAT(create_time, '%Y-%m-%d') AS period, COALESCE(SUM(amount),0) AS amount")
                    ->group('period')->order('period', 'asc')->select()->toArray();
            }

            $map = [];
            foreach ($rows as $r) {
                $map[(string) $r['period']] = round((float) $r['amount'], 2);
            }

            // 补齐缺失周期，保证前端折线连续
            $points = [];
            $cursor = $byMonth ? new \DateTime(date('Y-m-01', strtotime('-11 months'))) : new \DateTime($since);
            $end = new \DateTime();
            $fmt = $byMonth ? 'Y-m' : 'Y-m-d';
            while ($cursor <= $end) {
                $key = $cursor->format($fmt);
                $points[] = ['period' => $key, 'amount' => $map[$key] ?? 0.0];
                $cursor->modify($byMonth ? '+1 month' : '+1 day');
            }

            $total = 0.0;
            foreach ($points as $p) {
                $total += $p['amount'];
            }

            return $this->ok([
                'range'  => $range,
                'byMonth' => $byMonth,
                'points' => $points,
                'total'  => round($total, 2),
                'available' => $rows !== [],
            ]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 提现记录：status=processing|done|rejected，空为全部 */
    public function withdrawList(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $status = trim((string) $request->param('status', ''));
            if ($status !== '' && !in_array($status, ['processing', 'done', 'rejected'], true)) {
                return json(['code' => 400, 'message' => '状态值不正确']);
            }
            [$page, $limit] = $this->paging($request);

            $where = [['user_id', '=', $uid]];
            if ($status !== '') {
                $where[] = ['status', '=', $status];
            }

            $rows = Db::name('withdraw_records')->where($where)
                ->order('create_time', 'desc')
                ->paginate(['list_rows' => $limit, 'page' => $page]);

            $list = array_map([$this, 'formatWithdraw'], $rows->items());

            return $this->ok(['list' => $list, 'total' => $rows->total(), 'page' => $page, 'limit' => $limit]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /**
     * 申请提现
     * @param amount 金额（元）
     * @param method wechat|bank
     * @param account 收款账号（wechat 传手机号，bank 传卡号）
     */
    public function applyWithdraw(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $amount  = round((float) $request->param('amount', 0), 2);
            $method  = trim((string) $request->param('method', 'wechat'));
            $account = trim((string) $request->param('account', ''));

            if ($amount <= 0) {
                return json(['code' => 400, 'message' => '提现金额必须大于0']);
            }
            if ($amount < 10) {
                return json(['code' => 400, 'message' => '单次提现最低10元']);
            }
            if (!in_array($method, ['wechat', 'bank'], true)) {
                return json(['code' => 400, 'message' => '提现方式不正确']);
            }
            if ($account === '') {
                return json(['code' => 400, 'message' => '请填写收款账号']);
            }

            $wallet = Db::name('user_wallet')->where('user_id', $uid)->find();
            $balance = (float) ($wallet['balance'] ?? 0);
            if ($balance < $amount) {
                return json(['code' => 400, 'message' => '可提现余额不足']);
            }
            // 有处理中提现单时不允许再次申请
            $processing = Db::name('withdraw_records')->where('user_id', $uid)
                ->where('status', 'processing')->count();
            if ($processing > 0) {
                return json(['code' => 400, 'message' => '存在处理中的提现单，请等待到账后再试']);
            }

            $now = date('Y-m-d H:i:s');
            $no = 'W' . date('YmdHis') . str_pad((string) random_int(0, 999), 3, '0', STR_PAD_LEFT);

            Db::startTrans();
            try {
                Db::name('withdraw_records')->insert([
                    'id'            => uuid(),
                    'user_id'       => $uid,
                    'no'            => $no,
                    'amount'        => $amount,
                    'fee'           => 0.00,
                    'actual_amount' => $amount,
                    'method'        => $method,
                    'account'       => $this->maskAccount($account),
                    'status'        => 'processing',
                    'create_time'   => $now,
                ]);
                // 余额转入冻结
                Db::name('user_wallet')->where('user_id', $uid)->update([
                    'balance' => Db::raw('balance - ' . $amount),
                    'frozen'  => Db::raw('frozen + ' . $amount),
                ]);
                // 负向流水
                Db::name('earning_records')->insert([
                    'id'            => uuid(),
                    'user_id'       => $uid,
                    'source'        => 'withdraw',
                    'amount'        => -$amount,
                    'description'   => '提现申请',
                    'settle_status' => 1,
                    'settle_time'   => $now,
                    'create_time'   => $now,
                ]);
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                throw $e;
            }

            return $this->ok(['no' => $no, 'amount' => $amount], '提现申请已提交');
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /**
     * 付费订单（创作者视角：谁买了我的付费内容）
     * @param keyword 订单号或内容名
     * @param state   paid|refunded，空为全部
     */
    public function orders(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $keyword = trim((string) $request->param('keyword', ''));
            $state   = trim((string) $request->param('state', ''));
            if ($state !== '' && !in_array($state, ['paid', 'refunded'], true)) {
                return json(['code' => 400, 'message' => '状态值不正确']);
            }
            [$page, $limit] = $this->paging($request);

            $query = Db::name('forum_post_purchases')->alias('p')
                ->leftJoin('forum_posts a', 'a.id = p.post_id')
                ->leftJoin('users u', 'u.id = p.user_id')
                ->where('a.user_id', $uid)
                ->field('p.id, p.coins AS amount, p.settle_status, p.create_time, a.title, u.nickname, u.phone');
            if ($state === 'refunded') {
                $query->where('p.settle_status', 2);
            } elseif ($state === 'paid') {
                $query->where('p.settle_status', '<>', 2);
            }
            if ($keyword !== '') {
                $query->where(function ($q) use ($keyword) {
                    $q->where('p.id', 'like', "%{$keyword}%")
                      ->whereOr('a.title', 'like', "%{$keyword}%");
                });
            }

            $total = clone $query;
            $totalCount = $total->count();

            $rows = $query->order('p.create_time', 'desc')
                ->page($page, $limit)->select()->toArray();

            $list = [];
            foreach ($rows as $r) {
                $list[] = [
                    'id'       => $r['id'],
                    'no'       => $r['id'],
                    'content'  => (string) ($r['title'] ?? ''),
                    'buyer'    => $this->maskName((string) ($r['nickname'] ?? ''), (string) ($r['phone'] ?? '')),
                    'amount'   => round((float) $r['amount'], 2),
                    'paidAt'   => (string) $r['create_time'],
                    'state'    => (int) $r['settle_status'] === 2 ? 'refunded' : 'paid',
                ];
            }

            return $this->ok(['list' => $list, 'total' => $totalCount, 'page' => $page, 'limit' => $limit]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    // ========================================================
    // 内部方法
    // ========================================================

    /** 提现单输出格式 */
    private function formatWithdraw(array $r): array
    {
        return [
            'id'       => $r['id'],
            'no'       => (string) $r['no'],
            'amount'   => round((float) $r['amount'], 2),
            'fee'      => round((float) $r['fee'], 2),
            'actual'   => round((float) $r['actual_amount'], 2),
            'method'   => $r['method'],
            'methodText' => $r['method'] === 'bank' ? '银行卡' : '微信零钱',
            'account'  => (string) $r['account'],
            'status'   => (string) $r['status'],
            'statusText' => ['processing' => '处理中', 'done' => '已到账', 'rejected' => '已驳回'][(string) $r['status']] ?? '',
            'reason'   => (string) ($r['reject_reason'] ?? ''),
            'appliedAt' => (string) $r['create_time'],
        ];
    }

    /** 收款账号脱敏：保留首尾各 4 位 */
    private function maskAccount(string $account): string
    {
        $len = mb_strlen($account);
        if ($len <= 8) {
            return $account;
        }
        return mb_substr($account, 0, 4) . str_repeat('*', $len - 8) . mb_substr($account, -4);
    }

    /** 买家脱敏展示：优先昵称，其次手机号 */
    private function maskName(string $nickname, string $phone): string
    {
        if ($nickname !== '') {
            $len = mb_strlen($nickname);
            return $len <= 2 ? $nickname : mb_substr($nickname, 0, 1) . str_repeat('*', $len - 2) . mb_substr($nickname, -1);
        }
        return $this->maskAccount($phone);
    }

    /** 当前登录用户ID */
    private function uid(Request $request): string
    {
        return (string) ($request->userId ?? '');
    }

    /** 分页参数 [page, limit] */
    private function paging(Request $request): array
    {
        $page  = max(1, (int) $request->param('page', 1));
        $limit = min(50, max(1, (int) $request->param('limit', 10)));
        return [$page, $limit];
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
