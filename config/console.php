<?php
// +----------------------------------------------------------------------
// | 控制台配置
// +----------------------------------------------------------------------
return [
    // 指令定义
    'commands' => [
        // 虚拟支付：兜底查单补发货（建议 crontab 每 5 分钟）
        'virtualpay:sync' => \app\command\VirtualPaySync::class,
        // 虚拟支付：签名函数与官方示例比对自检
        'virtualpay:signcheck' => \app\command\VirtualPaySignCheck::class,
    ],
];
