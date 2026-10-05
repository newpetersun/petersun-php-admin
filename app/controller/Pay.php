<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use app\service\VirtualPayService;
use app\service\VpConfig;
use think\facade\Db;
use think\Request;
use think\Response;

/**
 * 虚拟支付：个人（道具直购）
 *
 * 接口清单（文档 5.4.3）：
 *   POST /pay/goods   道具列表
 *   POST /pay/order   下单，生成 outTradeNo + signData + paySig，返回给前端去支付
 *   POST /pay/notify  接收发货推送，验签后幂等发货，返回 XML
 *   POST /pay/query   手动触发兜底查单（定时请用 php think virtualpay:sync）
 *   GET  /pay/status  前端轮询订单状态
 */
class Pay extends BaseController
{
    /** 道具列表 */
    public function goods(): Response
    {
        return json([
            'code'    => 200,
            'message' => '获取成功',
            'data'    => [
                'list'             => VirtualPayService::listGoods(),
                'monthly_limit_yuan' => (int) config('virtualpay.monthly_limit_fen', 10000000) / 100,
            ],
        ]);
    }

    /**
     * 下单：返回可直接用于 wx.requestVirtualPayment 的 payData
     *
     * 入参：code（wx.login 获取，用于换取最新 session_key）、product_id、quantity
     */
    public function order(Request $request): Response
    {
        $code      = (string) $request->param('code', '');
        $productId = (string) $request->param('product_id', '');
        $quantity  = (int) $request->param('quantity', 1);
        $userId    = (string) ($request->userId ?? '');

        if ($code === '') {
            return json(['code' => 400, 'message' => '缺少 code，请先调用 wx.login']);
        }
        if ($productId === '') {
            return json(['code' => 400, 'message' => '缺少 product_id']);
        }

        // 基础配置未就绪时给出明确提示，避免生成无效签名（配置优先取自数据库，回退 .env）
        $required = ['VP_APPID', 'VP_OFFER_ID', 'VP_APP_KEY'];
        // 沙箱环境必须使用沙箱 AppKey 签名，缺了会被微信判 PAYMENT_ILLEGAL
        if ((int) VpConfig::get('VP_ENV', 0) === 1) {
            $required[] = 'VP_SANDBOX_APP_KEY';
        }
        foreach ($required as $name) {
            if ((string) VpConfig::get($name, '') === '') {
                return json(['code' => 500, 'message' => "虚拟支付尚未配置 {$name}，请在后台/数据库补充后再下单"]);
            }
        }

        try {
            // 每次下单都用最新 code 换取 session_key，避免 session_key 过期导致 signature 失效
            $session = VirtualPayService::code2Session($code);

            $payData = VirtualPayService::createOrder(
                $session['openid'],
                $session['session_key'],
                $productId,
                $quantity,
                json_encode(['user_id' => $userId], JSON_UNESCAPED_UNICODE)
            );

            return json([
                'code'    => 200,
                'message' => '下单成功',
                'data'    => $payData,
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => $e->getMessage()]);
        }
    }

    /** 前端轮询订单状态：以服务端订单为准，不依赖前端 success 回调 */
    public function status(Request $request): Response
    {
        $outTradeNo = (string) $request->param('out_trade_no', '');
        if ($outTradeNo === '') {
            return json(['code' => 400, 'message' => '缺少 out_trade_no']);
        }

        $userId = (string) ($request->userId ?? '');
        $user   = $userId !== '' ? Db::name('users')->where('id', $userId)->find() : null;

        $order = Db::name('virtual_pay_orders')->where('out_trade_no', $outTradeNo)->find();
        if (!$order) {
            return json(['code' => 404, 'message' => '订单不存在']);
        }
        // 归属校验：只允许本人查询
        if ($user && $order['openid'] !== $user['openid']) {
            return json(['code' => 403, 'message' => '无权查询该订单']);
        }

        return json([
            'code'    => 200,
            'message' => '获取成功',
            'data'    => [
                'out_trade_no'   => $order['out_trade_no'],
                'status'         => $order['status'],
                'deliver_status' => (int) $order['deliver_status'],
                'product_id'     => $order['product_id'],
                'quantity'       => (int) $order['quantity'],
                'paid'           => (int) $order['deliver_status'] === 1,
            ],
        ]);
    }

    /**
     * 钱包概览：服务端账户余额 + 购买记录
     *
     * 余额 = user_entitlements 按 openid 累计的 quantity（金币数）
     * 记录 = virtual_pay_orders 中已发货（deliver_status=1）的订单
     * 以 JWT 中的 userId 关联 users.openid，避免前端伪造余额
     */
    public function wallet(Request $request): Response
    {
        $userId = (string) ($request->userId ?? '');
        $user   = $userId !== '' ? Db::name('users')->where('id', $userId)->find() : null;
        if (!$user || empty($user['openid'])) {
            return json(['code' => 401, 'message' => '用户未登录或缺少 openid']);
        }
        $openid = $user['openid'];

        // 余额以 user_wallet 为准（充值发货时已入账到此表，buy 消费也走此表）
        $wallet  = Db::name('user_wallet')->where('user_id', $userId)->find();
        $balance = $wallet ? (int) $wallet['balance'] : 0;

        $rows = Db::name('virtual_pay_orders')
            ->where('openid', $openid)
            ->where('deliver_status', 1)
            ->order('paid_time', 'desc')
            ->limit(50)
            ->select()
            ->toArray();

        $goods   = config('virtualpay.goods', []);
        $records = [];
        foreach ($rows as $o) {
            $grant = isset($goods[$o['product_id']]) ? (int) $goods[$o['product_id']]['grant'] : 0;
            // 文章收益（article_income）等亦为正向收入
            $records[] = [
                'name'   => $o['product_name'] ?: $o['product_id'],
                'amount' => $grant > 0 ? $grant * (int) $o['quantity'] : (int) $o['quantity'],
                'time'   => $o['paid_time'] ?: $o['create_time'],
            ];
        }

        // 金币支出：本人购买付费文章的记录（forum_post_purchases），以负向展示
        $purchases = Db::name('forum_post_purchases')
            ->alias('p')
            ->join('forum_posts f', 'f.id = p.post_id', 'left')
            ->where('p.user_id', $userId)
            ->field('p.coins, p.create_time, f.title')
            ->order('p.create_time', 'desc')
            ->limit(50)
            ->select()
            ->toArray();
        foreach ($purchases as $p) {
            $records[] = [
                'name'   => '购买文章《' . ($p['title'] ?: '未知') . '》',
                'amount' => -(int) $p['coins'],
                'time'   => $p['create_time'],
            ];
        }

        // 合并后按时间倒序
        usort($records, function ($a, $b) {
            return strtotime($b['time'] ?? '0') - strtotime($a['time'] ?? '0');
        });

        return json([
            'code'    => 200,
            'message' => '获取成功',
            'data'    => [
                'balance' => $balance,
                'records' => $records,
            ],
        ]);
    }

    /**
     * 发货推送：xpay_goods_deliver_notify
     *
     * 以「发货推送」为主路径；返回 ErrCode=0 表示成功，非 0 平台最多重试 15 次
     */
    public function notify(Request $request): Response
    {
        // 微信服务器配置时的 URL/Token 验证：GET 请求，验签通过后原样返回 echostr
        if (strtoupper($request->method()) === 'GET') {
            $ok = VirtualPayService::verifyNotifySignature(
                (string) $request->param('signature', ''),
                (string) $request->param('timestamp', ''),
                (string) $request->param('nonce', '')
            );
            // 用 text/plain 返回，避免 APP_DEBUG 下注入的调试工具条污染响应体（微信需逐字节比对 echostr）
            return response($ok ? (string) $request->param('echostr', '') : 'invalid signature', $ok ? 200 : 403)
                ->contentType('text/plain; charset=utf-8');
        }

        $raw = (string) $request->getContent();

        try {
            // 明文模式下，发货推送（POST）的来源由回调 URL 私密性保证，
            // 不做公众号消息推送那套 signature 验签（该签名仅用于上面的 GET URL 握手）。
            // 安全模式（AES 加密）需另行实现解密校验。

            $data = VirtualPayService::parseNotify($raw);

            if ($data['event'] !== 'xpay_goods_deliver_notify') {
                // 非发货事件直接确认，避免平台无意义重试
                return $this->notifyXml(0, 'ignored');
            }

            [$ok] = VirtualPayService::deliver($data);

            return $this->notifyXml($ok ? 0 : 1, $ok ? 'success' : 'deliver_failed');
        } catch (\Exception $e) {
            trace('虚拟支付发货推送处理失败：' . $e->getMessage() . ' raw=' . $raw, 'error');
            // 返回非 0 让平台重试；解析类错误重试也无意义，但仍按规范返回失败由平台决定是否重试
            return $this->notifyXml(1, $e->getMessage());
        }
    }

    /** 手动触发兜底查单（管理端）；定时任务请用 php think virtualpay:sync */
    public function query(Request $request): Response
    {
        $outTradeNo = (string) $request->param('out_trade_no', '');
        try {
            if ($outTradeNo !== '') {
                $order = Db::name('virtual_pay_orders')->where('out_trade_no', $outTradeNo)->find();
                if (!$order) {
                    return json(['code' => 404, 'message' => '订单不存在']);
                }
                $result = $this->syncOne($order);
                return json(['code' => 200, 'message' => '查单完成', 'data' => $result]);
            }

            $list = VirtualPayService::pendingOrders((int) config('virtualpay.query_limit', 100));

            $summary = [];
            foreach ($list as $order) {
                $summary[] = $this->syncOne($order);
            }

            return json(['code' => 200, 'message' => '查单完成', 'data' => $summary]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => $e->getMessage()]);
        }
    }

    /**
     * 对单笔订单查单并补发货
     * 平台订单状态：2=已支付待发货，3=发货中，4=已发货 → 均视为需要/已经发货
     */
    public function syncOne(array $order): array
    {
        return VirtualPayService::syncOrder($order);
    }

    /** 按平台要求返回 XML 响应 */
    private function notifyXml(int $errCode, string $errMsg = ''): Response
    {
        $xml = '<xml><ErrCode>' . $errCode . '</ErrCode>'
            . '<ErrMsg><![CDATA[' . $errMsg . ']]></ErrMsg></xml>';

        return response($xml, 200, ['Content-Type' => 'application/xml']);
    }
}
