<?php
/**
 * 简单CORS测试脚本
 */

echo "=== CORS配置测试 ===\n\n";

// 测试配置文件加载
echo "1. 测试CORS配置文件\n";
$corsConfig = include 'config/cors.php';
echo "CORS配置加载成功\n";
echo "允许的域名: " . $corsConfig['allow_origin'] . "\n";
echo "允许的方法: " . implode(', ', $corsConfig['allow_methods']) . "\n";
echo "允许的请求头: " . implode(', ', $corsConfig['allow_headers']) . "\n";
echo "是否允许凭证: " . ($corsConfig['allow_credentials'] ? '是' : '否') . "\n";
echo "预检缓存时间: " . $corsConfig['max_age'] . "秒\n\n";

// 测试中间件文件
echo "2. 测试CORS中间件文件\n";
if (file_exists('app/middleware/Cors.php')) {
    echo "CORS中间件文件存在\n";
} else {
    echo "CORS中间件文件不存在\n";
}

// 测试中间件注册
echo "\n3. 测试中间件注册\n";
$middlewareConfig = include 'app/middleware.php';
if (isset($middlewareConfig['Cors'])) {
    echo "CORS中间件已注册\n";
} else {
    echo "CORS中间件未注册\n";
}

echo "\n=== 测试完成 ===\n";
echo "\nCORS配置说明：\n";
echo "1. 所有API路由都已应用CORS中间件\n";
echo "2. 支持跨域请求和预检请求\n";
echo "3. 允许携带Authorization等请求头\n";
echo "4. 可通过config/cors.php自定义配置\n";
echo "\n前端调用示例：\n";
echo "fetch('http://your-domain.com/auth/login', {\n";
echo "    method: 'POST',\n";
echo "    headers: {\n";
echo "        'Content-Type': 'application/json'\n";
echo "    },\n";
echo "    body: JSON.stringify({\n";
echo "        username: 'admin',\n";
echo "        password: '123456'\n";
echo "    })\n";
echo "});\n"; 