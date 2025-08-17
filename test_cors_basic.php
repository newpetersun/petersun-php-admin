<?php
echo "=== CORS基础测试 ===\n\n";

// 测试配置文件
echo "1. 测试CORS配置文件\n";
if (file_exists('config/cors.php')) {
    echo "✓ CORS配置文件存在\n";
    $config = include 'config/cors.php';
    echo "✓ 配置文件加载成功\n";
    echo "  允许域名: " . $config['allow_origin'] . "\n";
} else {
    echo "✗ CORS配置文件不存在\n";
}

// 测试中间件文件
echo "\n2. 测试CORS中间件文件\n";
if (file_exists('app/middleware/Cors.php')) {
    echo "✓ CORS中间件文件存在\n";
} else {
    echo "✗ CORS中间件文件不存在\n";
}

// 测试中间件注册
echo "\n3. 测试中间件注册\n";
if (file_exists('config/middleware.php')) {
    $middleware = include 'config/middleware.php';
    if (isset($middleware['alias']['Cors'])) {
        echo "✓ CORS中间件已注册\n";
    } else {
        echo "✗ CORS中间件未注册\n";
    }
} else {
    echo "✗ 中间件配置文件不存在\n";
}

echo "\n=== 测试完成 ===\n"; 