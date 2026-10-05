<?php
// +----------------------------------------------------------------------
// | 微信小程序「虚拟支付：个人」配置
// | 文档：https://developers.weixin.qq.com/miniprogram/dev/platform-capabilities/business-capabilities/virtual-payment/person
// +----------------------------------------------------------------------
// | 需要在项目根目录 .env 中填入以下变量（勿提交仓库）：
// |   VP_APPID=           小程序 AppID（MP 后台 → 设置）
// |   VP_APP_SECRET=      小程序 AppSecret
// |   VP_OFFER_ID=        OfferID（虚拟支付 → 基本配置）
// |   VP_APP_KEY=         现网 AppKey（env=0，虚拟支付 → 基本配置）
// |   VP_SANDBOX_APP_KEY= 沙箱 AppKey（env=1，仅联调用）
// |   VP_ENV=0            0=现网（正式），1=沙箱
// |   VP_NOTIFY_TOKEN=    消息推送 Token（开发管理 → 消息推送）
// +----------------------------------------------------------------------

return [
    // 小程序 AppID
    'appid'      => env('VP_APPID', ''),

    // 小程序 AppSecret（换取 access_token / session_key）
    'app_secret' => env('VP_APP_SECRET', ''),

    // 虚拟支付商户号 OfferID
    'offer_id'   => env('VP_OFFER_ID', ''),

    // 现网 AppKey（env = 0）
    'app_key'    => env('VP_APP_KEY', ''),

    // 沙箱 AppKey（env = 1）
    'sandbox_app_key' => env('VP_SANDBOX_APP_KEY', ''),

    // 支付环境：0=现网（正式环境，真实扣款），1=沙箱（联调用，不真实扣款）。
    // 沙箱需同时配置 VP_SANDBOX_APP_KEY 并在 MP 将道具发布到沙箱
    'env'        => (int) env('VP_ENV', 0),

    // 道具列表：需与 MP 后台【虚拟支付 → 道具管理】中已创建并发布的道具完全一致
    // product_id = 后台道具 ID；price = 单价（单位：分），必须与后台道具价格一致
    'goods'      => [
        'coin_1' => ['product_id' => 'coin_1', 'name' => '1', 'desc' => '充值 1 金币', 'price' => 100, 'grant' => 1],
        'coin_10' => ['product_id' => 'coin_10', 'name' => '10', 'desc' => '充值 10 金币', 'price' => 1000, 'grant' => 10],
        'coin_20' => ['product_id' => 'coin_20', 'name' => '20', 'desc' => '充值 20 金币', 'price' => 2000, 'grant' => 20],
        'coin_40' => ['product_id' => 'coin_40', 'name' => '40', 'desc' => '充值 40 金币', 'price' => 4000, 'grant' => 40],
        'coin_50' => ['product_id' => 'coin_50', 'name' => '50', 'desc' => '充值 50 金币', 'price' => 5000, 'grant' => 50],
    ],

    // 消息推送配置（开发管理 → 消息推送）
    'notify_token' => env('VP_NOTIFY_TOKEN', ''),

    // 个人主体月支付限额：10 万元 = 10,000,000 分（平台侧也会拦截，此处做本地软校验，避免用户支付时才失败）
    'monthly_limit_fen' => 10000000,

    // 兜底查单：扫描最近多久内未发货的订单（秒）
    'query_window' => 86400,

    // 兜底查单：单次最多处理条数
    'query_limit' => 100,
];
