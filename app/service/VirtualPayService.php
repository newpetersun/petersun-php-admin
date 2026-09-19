<?php
declare(strict_types=1);

namespace app\service;

use think\facade\Cache;
use think\facade\Db;

/**
 * 微信小程序「虚拟支付：个人」服务
 *
 * 文档：
 * https://developers.weixin.qq.com/miniprogram/dev/platform-capabilities/business-capabilities/virtual-payment/person
 *
 * 两套签名（5.5 节）：
 *   paySig    = HMAC-SHA256(appKey,     uri + '&' + postBody)
 *   signature = HMAC-SHA256(sessionKey, postBody)
 * postBody 必须与真正发出去的请求体逐字节一致（不格式化、不改键顺序）。
 */
class VirtualPayService
{
    /** 前端拉起支付时的 uri，文档规定固定值 */
    const URI_REQUEST_VIRTUAL_PAYMENT = 'requestVirtualPayment';

    /** 道具直购的 mode，文档规定固定值 */
    const MODE_SHORT_SERIES_GOODS = 'short_series_goods';

    /** 微信 B 端接口域名 */
    const API_HOST = 'https://api.weixin.qq.com';

    // ------------------------------------------------------------------
    // 签名
    // ------------------------------------------------------------------

    /**
     * 支付签名 paySig
     *
     * @param string      $uri      前端固定 'requestVirtualPayment'；B 端为实际路径如 '/xpay/query_order'
     * @param string      $postBody 真正发出的请求体原始字符串
     * @param string|null $appKey   不传则按 env 自动取现网/沙箱 AppKey
     */
    public static function calcPaySig(string $uri, string $postBody, ?string $appKey = null): string
    {
        $appKey = $appKey ?? self::getAppKey();
        return hash_hmac('sha256', $uri . '&' . $postBody, $appKey);
    }

    /**
     * 用户态签名 signature
     *
     * @param string $postBody   前端为 signData 字符串；B 端为请求体
     * @param string $sessionKey 通过 auth.code2Session 获取
     */
    public static function calcSignature(string $postBody, string $sessionKey): string
    {
        return hash_hmac('sha256', $postBody, $sessionKey);
    }

    /** 按 env 取 AppKey：env=0 现网，env=1 沙箱 */
    public static function getAppKey(): string
    {
        $env = (int) config('virtualpay.env', 0);
        return $env === 1
            ? (string) config('virtualpay.sandbox_app_key', '')
            : (string) config('virtualpay.app_key', '');
    }

    /** 环境标识：文档要求正式环境固定 0 */
    public static function getEnv(): int
    {
        return (int) config('virtualpay.env', 0);
    }

    // ------------------------------------------------------------------
    // 微信基础接口
    // ------------------------------------------------------------------

    /** 获取小程序全局 access_token（B 端接口需要），缓存 7000 秒 */
    public static function getAccessToken(): string
    {
        $appid = (string) config('virtualpay.appid', '');
        $cacheKey = 'vp_access_token_' . $appid;

        $cached = Cache::get($cacheKey);
        if ($cached) {
            return (string) $cached;
        }

        $url = self::API_HOST . '/cgi-bin/token?' . http_build_query([
            'grant_type' => 'client_credential',
            'appid'      => $appid,
            'secret'     => (string) config('virtualpay.app_secret', ''),
        ]);

        $result = json_decode((string) self::httpGet($url), true);
        if (empty($result['access_token'])) {
            throw new \Exception('获取 access_token 失败：' . json_encode($result, JSON_UNESCAPED_UNICODE));
        }

        Cache::set($cacheKey, $result['access_token'], 7000);
        return (string) $result['access_token'];
    }

    /**
     * code2Session：同时拿到 openid 与 session_key（signature 依赖 session_key）
     *
     * @return array{openid:string, session_key:string}
     */
    public static function code2Session(string $code): array
    {
        $url = self::API_HOST . '/sns/jscode2session?' . http_build_query([
            'appid'      => (string) config('virtualpay.appid', ''),
            'secret'     => (string) config('virtualpay.app_secret', ''),
            'js_code'    => $code,
            'grant_type' => 'authorization_code',
        ]);

        $result = json_decode((string) self::httpGet($url), true);
        if (empty($result['openid'])) {
            throw new \Exception('code2Session 失败：' . json_encode($result, JSON_UNESCAPED_UNICODE));
        }
        if (empty($result['session_key'])) {
            throw new \Exception('code2Session 未返回 session_key：' . json_encode($result, JSON_UNESCAPED_UNICODE));
        }

        return [
            'openid'      => (string) $result['openid'],
            'session_key' => (string) $result['session_key'],
        ];
    }

    // ------------------------------------------------------------------
    // 下单
    // ------------------------------------------------------------------

    /**
     * 生成下单参数（payData），供前端 wx.requestVirtualPayment 直接使用
     *
     * @param string $openid     用户 openid
     * @param string $sessionKey 用户当前有效 session_key
     * @param string $productId  道具 ID（须在配置中存在）
     * @param int    $quantity   购买数量
     * @param string $attach     透传数据（必填，发货时原样回传）
     *
     * @return array{mode:string, signData:string, paySig:string, signature:string, outTradeNo:string, goodsPrice:int}
     */
    public static function createOrder(string $openid, string $sessionKey, string $productId, int $quantity = 1, string $attach = ''): array
    {
        $goods = self::getGoods($productId);
        $quantity = max(1, $quantity);

        // 个人主体月支付限额软校验
        self::assertMonthlyLimit($goods['price'] * $quantity);

        $outTradeNo = self::generateOutTradeNo();

        // signData 的键顺序与内容必须与实际请求一致，不做任何二次格式化
        $signData = json_encode([
            'offerId'      => (string) config('virtualpay.offer_id', ''),
            'buyQuantity'  => $quantity,
            'env'          => self::getEnv(),
            'currencyType' => 'CNY',
            'productId'    => $goods['product_id'],
            'goodsPrice'   => (int) $goods['price'],
            'outTradeNo'   => $outTradeNo,
            'attach'       => $attach,
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

        $payData = [
            'mode'       => self::MODE_SHORT_SERIES_GOODS,
            'signData'   => $signData,
            'paySig'     => self::calcPaySig(self::URI_REQUEST_VIRTUAL_PAYMENT, $signData),
            'signature'  => self::calcSignature($signData, $sessionKey),
            'outTradeNo' => $outTradeNo,
            'goodsPrice' => (int) $goods['price'],
        ];

        // 订单落库（待支付）
        Db::name('virtual_pay_order')->insert([
            'out_trade_no'   => $outTradeNo,
            'openid'         => $openid,
            'product_id'     => $goods['product_id'],
            'product_name'   => $goods['name'],
            'quantity'       => $quantity,
            'goods_price'    => (int) $goods['price'],
            'pay_fee'        => (int) $goods['price'] * $quantity,
            'attach'         => $attach,
            'env'            => self::getEnv(),
            'status'         => 'pending',
            'deliver_status' => 0,
            'create_time'    => date('Y-m-d H:i:s'),
            'update_time'    => date('Y-m-d H:i:s'),
        ]);

        return $payData;
    }

    /**
     * 业务单号：8-32 位，不能以下划线开头，每次下单重新生成且不复用
     * 形如 T20260918153012 + 6 位随机 = 21 位
     */
    public static function generateOutTradeNo(): string
    {
        return 'T' . date('YmdHis') . str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
    }

    /** 取道具配置，不存在则抛错（防止与 MP 后台价格不一致） */
    public static function getGoods(string $productId): array
    {
        $goods = config('virtualpay.goods', []);
        if (!isset($goods[$productId])) {
            throw new \Exception('道具不存在或未配置：' . $productId);
        }
        return $goods[$productId];
    }

    /** 可售道具列表（供前端展示） */
    public static function listGoods(): array
    {
        $list = [];
        foreach ((array) config('virtualpay.goods', []) as $item) {
            $list[] = [
                'product_id' => $item['product_id'],
                'name'       => $item['name'],
                'desc'       => $item['desc'] ?? '',
                'price'      => (int) $item['price'],
                'price_yuan' => number_format($item['price'] / 100, 2, '.', ''),
            ];
        }
        return $list;
    }

    /** 本月已产生（含待支付）的金额是否超过个人主体 10 万元限额 */
    public static function assertMonthlyLimit(int $amountFen): void
    {
        $start = date('Y-m-01 00:00:00');
        $used  = (int) Db::name('virtual_pay_order')
            ->where('create_time', '>=', $start)
            ->whereIn('status', ['pending', 'paid'])
            ->sum('pay_fee');

        if ($used + $amountFen > (int) config('virtualpay.monthly_limit_fen', 10000000)) {
            throw new \Exception('本月虚拟支付已达个人主体 10 万元限额，暂无法继续下单');
        }
    }

    // ------------------------------------------------------------------
    // 查单（兜底发货）
    // ------------------------------------------------------------------

    /**
     * 调用 B 端 /xpay/query_order
     *
     * pay_sig 放在 query 上：POST /xpay/query_order?access_token=xxx&pay_sig=xxx
     * 参与签名的 uri = '/xpay/query_order'，postBody = 实际请求体
     */
    public static function queryOrder(string $openid, string $outTradeNo): array
    {
        $uri  = '/xpay/query_order';
        $body = json_encode([
            'openid'   => $openid,
            'env'      => self::getEnv(),
            'order_id' => $outTradeNo,
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

        $url = self::API_HOST . $uri . '?' . http_build_query([
            'access_token' => self::getAccessToken(),
            'pay_sig'      => self::calcPaySig($uri, $body),
        ]);

        $result = json_decode((string) self::httpPostRaw($url, $body), true) ?: [];
        if (isset($result['errcode']) && (int) $result['errcode'] !== 0) {
            throw new \Exception('query_order 失败：' . json_encode($result, JSON_UNESCAPED_UNICODE));
        }
        return $result;
    }

    // ------------------------------------------------------------------
    // 发货（幂等）
    // ------------------------------------------------------------------

    /**
     * 发货：以 wx_order_id 做幂等去重
     *
     * @param array $data wx_order_id / out_trade_no / openid / product_id / quantity
     * @return array{0:bool, 1:string} [是否成功, 'delivered' | 'duplicate_skipped']
     */
    public static function deliver(array $data): array
    {
        $wxOrderId  = (string) ($data['wx_order_id'] ?? '');
        $outTradeNo = (string) ($data['out_trade_no'] ?? '');
        $openid     = (string) ($data['openid'] ?? '');
        $productId  = (string) ($data['product_id'] ?? '');
        $quantity   = (int) ($data['quantity'] ?? 1);

        if ($wxOrderId === '' || $openid === '' || $productId === '') {
            return [false, 'missing_params'];
        }

        // 已按平台单号发过货 → 直接返回成功
        $done = Db::name('virtual_pay_order')->where('wx_order_id', $wxOrderId)->find();
        if ($done && (int) $done['deliver_status'] === 1) {
            return [true, 'duplicate_skipped'];
        }

        $granted = false;
        Db::transaction(function () use ($wxOrderId, $outTradeNo, $openid, $productId, $quantity, &$granted) {
            $now = date('Y-m-d H:i:s');

            $order = $outTradeNo !== ''
                ? Db::name('virtual_pay_order')->where('out_trade_no', $outTradeNo)->find()
                : null;

            if ($order) {
                // CAS：只有仍是「未发货」才允许占位，重复推送时影响行数为 0
                $affected = Db::name('virtual_pay_order')
                    ->where('id', $order['id'])
                    ->where('deliver_status', 0)
                    ->update([
                        'wx_order_id'    => $wxOrderId,
                        'status'         => 'paid',
                        'deliver_status' => 1,
                        'paid_time'      => $now,
                        'deliver_time'   => $now,
                        'update_time'    => $now,
                    ]);
                if (!$affected) {
                    $granted = false;
                    return;
                }
            } else {
                // 本地无订单（兜底查单场景）：补建一条，wx_order_id 唯一索引冲突即视为已处理
                $exists = Db::name('virtual_pay_order')->where('wx_order_id', $wxOrderId)->find();
                if ($exists) {
                    $granted = false;
                    return;
                }
                Db::name('virtual_pay_order')->insert([
                    'out_trade_no'   => $outTradeNo !== '' ? $outTradeNo : $wxOrderId,
                    'wx_order_id'    => $wxOrderId,
                    'openid'         => $openid,
                    'product_id'     => $productId,
                    'product_name'   => $productId,
                    'quantity'       => $quantity,
                    'goods_price'    => 0,
                    'pay_fee'        => 0,
                    'attach'         => '',
                    'env'            => self::getEnv(),
                    'status'         => 'paid',
                    'deliver_status' => 1,
                    'paid_time'      => $now,
                    'deliver_time'   => $now,
                    'create_time'    => $now,
                    'update_time'    => $now,
                ]);
            }

            self::grantEntitlement($openid, $productId, $quantity, $wxOrderId);
            $granted = true;
        });

        return [$granted ?: self::isDelivered($wxOrderId), $granted ? 'delivered' : 'duplicate_skipped'];
    }

    /** 发放权益：user_entitlement 以 wx_order_id 唯一索引兜底防重复 */
    private static function grantEntitlement(string $openid, string $productId, int $quantity, string $wxOrderId): void
    {
        $goods  = (array) config('virtualpay.goods', []);
        $grant  = isset($goods[$productId]) ? (int) $goods[$productId]['grant'] : 0;
        $amount = $grant > 0 ? $grant * $quantity : $quantity;

        if (Db::name('user_entitlement')->where('wx_order_id', $wxOrderId)->find()) {
            return;
        }

        $row = Db::name('user_entitlement')
            ->where('openid', $openid)
            ->where('product_id', $productId)
            ->find();

        if ($row) {
            Db::name('user_entitlement')
                ->where('id', $row['id'])
                ->inc('quantity', $amount)
                ->update(['update_time' => date('Y-m-d H:i:s')]);
        } else {
            Db::name('user_entitlement')->insert([
                'openid'      => $openid,
                'product_id'  => $productId,
                'quantity'    => $amount,
                'wx_order_id' => $wxOrderId,
                'create_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s'),
            ]);
        }
    }

    /** 该平台单号是否已发货 */
    public static function isDelivered(string $wxOrderId): bool
    {
        if ($wxOrderId === '') {
            return false;
        }
        $row = Db::name('virtual_pay_order')->where('wx_order_id', $wxOrderId)->find();
        return $row && (int) $row['deliver_status'] === 1;
    }

    /**
     * 兜底查单并补发货（推送丢失时使用）
     *
     * 平台订单状态：0初始化 1已创建 2已支付待发货 3发货中 4已发货 5已退款 6已关闭
     * 只有 2/3/4/8 需要（或已经）发货
     *
     * @return array{out_trade_no:string, result:string, status:int}
     */
    public static function syncOrder(array $order): array
    {
        try {
            $result = self::queryOrder($order['openid'], $order['out_trade_no']);
        } catch (\Exception $e) {
            return [
                'out_trade_no' => $order['out_trade_no'],
                'result'       => 'query_failed',
                'status'       => 0,
                'message'      => $e->getMessage(),
            ];
        }

        $orderInfo = $result['order'] ?? [];
        $status    = (int) ($orderInfo['status'] ?? 0);

        if (!in_array($status, [2, 3, 4, 8], true)) {
            return ['out_trade_no' => $order['out_trade_no'], 'result' => 'unpaid', 'status' => $status];
        }

        [$ok, $reason] = self::deliver([
            'wx_order_id'  => (string) ($orderInfo['wx_order_id'] ?? ''),
            'out_trade_no' => $order['out_trade_no'],
            'openid'       => $order['openid'],
            'product_id'   => $order['product_id'],
            'quantity'     => (int) $order['quantity'],
        ]);

        return [
            'out_trade_no' => $order['out_trade_no'],
            'result'       => $ok ? ($reason === 'delivered' ? 'delivered' : 'already_delivered') : 'deliver_failed',
            'status'       => $status,
        ];
    }

    /** 待发货订单列表（兜底扫描用） */
    public static function pendingOrders(int $limit = 100): array
    {
        return Db::name('virtual_pay_order')
            ->where('deliver_status', 0)
            ->where('create_time', '>=', date('Y-m-d H:i:s', time() - (int) config('virtualpay.query_window', 86400)))
            ->limit($limit)
            ->select()
            ->toArray();
    }

    // ------------------------------------------------------------------
    // 发货推送解析 / 校验
    // ------------------------------------------------------------------

    /** 解析 xpay_goods_deliver_notify 推送 XML */
    public static function parseNotify(string $xml): array
    {
        $prev = libxml_use_internal_errors(true);
        $obj  = simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA);
        libxml_use_internal_errors(false);
        libxml_clear_errors();

        if ($obj === false) {
            throw new \Exception('推送 XML 解析失败');
        }

        $arr = json_decode(json_encode($obj), true) ?: [];

        return [
            'event'        => (string) ($arr['Event'] ?? ''),
            'openid'       => (string) ($arr['OpenId'] ?? ''),
            'out_trade_no' => (string) ($arr['OutTradeNo'] ?? ''),
            'env'          => (int) ($arr['Env'] ?? 0),
            'wx_order_id'  => (string) ($arr['WeChatPayInfo']['MchOrderNo'] ?? ''),
            'product_id'   => (string) ($arr['GoodsInfo']['ProductId'] ?? ''),
            'quantity'     => (int) ($arr['GoodsInfo']['Quantity'] ?? 1),
            'attach'       => (string) ($arr['GoodsInfo']['Attach'] ?? ''),
        ];
    }

    /** 明文模式下的消息推送来源校验（配置 Token 后才校验） */
    public static function verifyNotifySignature(string $signature, string $timestamp, string $nonce): bool
    {
        $token = (string) config('virtualpay.notify_token', '');
        if ($token === '') {
            return true; // 未配置 Token 时跳过，交由平台 URL 保密性保障
        }
        $arr = [$token, $timestamp, $nonce];
        sort($arr, SORT_STRING);
        return hash_equals(sha1(implode('', $arr)), $signature);
    }

    // ------------------------------------------------------------------
    // HTTP
    // ------------------------------------------------------------------

    private static function httpGet(string $url, int $timeout = 10)
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => $timeout,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);
        $res = curl_exec($ch);
        if ($res === false) {
            $err = curl_error($ch);
            curl_close($ch);
            throw new \Exception('HTTP GET 失败：' . $err);
        }
        curl_close($ch);
        return $res;
    }

    /** 发送原始字符串请求体，保证与参与签名的 postBody 完全一致 */
    private static function httpPostRaw(string $url, string $rawBody, int $timeout = 10)
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
        return $res;
    }

    // ------------------------------------------------------------------
    // 自检：与官方文档签名示例核对（2.6 节）
    // ------------------------------------------------------------------

    /**
     * 官方示例（企业版文档 2.6）：
     *   uri         = '/xpay/query_user_balance'
     *   appkey      = '12345'
     *   post_body   = '{"openid": "xxx", "user_ip": "127.0.0.1", "env": 0}'
     *   pay_sig     = 'c37809f27c6d7fd1837ad2500a04512b66b34fd793a39a385fade56dca89a4b5'
     *   session_key = '9hAb/NEYUlkaMBEsmFgzig=='
     *   signature   = '089d9e8dc5d308977360c4b79ec600a93d736802802a807d634192328032f6c7'
     *
     * @return array{ok:bool, detail:array}
     */
    public static function selfCheckSignature(): array
    {
        $uri        = '/xpay/query_user_balance';
        $appKey     = '12345';
        $postBody   = '{"openid": "xxx", "user_ip": "127.0.0.1", "env": 0}';
        $sessionKey = '9hAb/NEYUlkaMBEsmFgzig==';

        $expectedPaySig = 'c37809f27c6d7fd1837ad2500a04512b66b34fd793a39a385fade56dca89a4b5';
        $expectedSign   = '089d9e8dc5d308977360c4b79ec600a93d736802802a807d634192328032f6c7';

        $actualPaySig = self::calcPaySig($uri, $postBody, $appKey);
        $actualSign   = self::calcSignature($postBody, $sessionKey);

        return [
            'ok'     => $actualPaySig === $expectedPaySig && $actualSign === $expectedSign,
            'detail' => [
                'pay_sig'   => ['expected' => $expectedPaySig, 'actual' => $actualPaySig, 'match' => $actualPaySig === $expectedPaySig],
                'signature' => ['expected' => $expectedSign, 'actual' => $actualSign, 'match' => $actualSign === $expectedSign],
            ],
        ];
    }
}
