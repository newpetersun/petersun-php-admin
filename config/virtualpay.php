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

    // 支付环境：0=现网（正式环境），1=沙箱。文档要求 env 固定填 0
    'env'        => (int) env('VP_ENV', 0),

    // 道具列表：需与 MP 后台【虚拟支付 → 道具管理】中已创建并发布的道具完全一致
    // product_id = 后台道具 ID；price = 单价（单位：分），必须与后台道具价格一致
    'goods'      => [
        // 示例：AI 对话次数包。上线前请在 MP 后台创建同名道具并发布，再核对 price
        'ai_chat_100' => [
            'product_id' => 'ai_chat_100',
            'name'       => 'AI 对话 100 次',
            'desc'       => '购买后可在 AI 对话中额外提问 100 次',
            'price'      => 100,   // 单位：分（1.00 元）
            'grant'      => 100,   // 发货时发放的权益数量
        ],
        'ai_chat_500' => [
            'product_id' => 'ai_chat_500',
            'name'       => 'AI 对话 500 次',
            'desc'       => '购买后可在 AI 对话中额外提问 500 次',
            'price'      => 400,   // 单位：分（4.00 元）
            'grant'      => 500,
        ],
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
