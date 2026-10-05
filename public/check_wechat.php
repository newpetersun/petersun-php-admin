<?php
// 临时诊断脚本：确认线上实际运行的 WechatAuth 控制器内容 & OPcache 状态。用后即删。
header('Content-Type: text/plain; charset=utf-8');

$file = __DIR__ . '/../app/controller/WechatAuth.php';
echo "file_exists = " . (file_exists($file) ? 'yes' : 'no') . "\n";

if (file_exists($file)) {
    $src = file_get_contents($file);
    // 检查插入数组里是否还含有 is_new_user / role
    $hasIsNewUser = (strpos($src, "'is_new_user'") !== false || strpos($src, '"is_new_user"') !== false);
    $hasRole      = (strpos($src, "'role'") !== false || strpos($src, '"role"') !== false);
    $hasVisitor   = (strpos($src, "'visitor'") !== false);
    echo "contains is_new_user in source = " . ($hasIsNewUser ? 'YES(旧版!)' : 'no(已修复)') . "\n";
    echo "contains role in source        = " . ($hasRole ? 'YES(旧版!)' : 'no(已修复)') . "\n";
    echo "uses user_type visitor         = " . ($hasVisitor ? 'yes' : 'no') . "\n";
}

// OPcache 状态
echo "\n--- OPcache ---\n";
if (function_exists('opcache_get_status')) {
    $status = opcache_get_status(false);
    if ($status === false) {
        echo "opcache enabled = no (未启用，文件改动应立即生效)\n";
    } else {
        $cfg = function_exists('opcache_get_configuration') ? opcache_get_configuration() : [];
        $validate = $cfg['directives']['opcache.validate_timestamps'] ?? 'unknown';
        echo "opcache enabled = yes\n";
        echo "validate_timestamps = " . var_export($validate, true) . " (0=不检查文件改动,需重启PHP才生效)\n";
        echo "opcache.restart_pending = " . ($status['restart_pending'] ?? 'n/a') . "\n";
    }
} else {
    echo "opcache 扩展未安装\n";
}

echo "\nPHP_VERSION = " . PHP_VERSION . "\n";
