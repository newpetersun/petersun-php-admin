<?php
// 应用公共文件

if (!function_exists('uuid')) {
    /**
     * 生成 UUID v4（不依赖第三方库）
     * 数据库主键/外键均为 CHAR(36) UUID，无自增，由应用层生成。
     */
    function uuid(): string
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
}
