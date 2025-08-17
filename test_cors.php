<?php
/**
 * CORS功能测试脚本
 * 使用方法：php test_cors.php
 */

require_once 'vendor/autoload.php';

use app\middleware\Cors;
use think\Request;
use think\Response;

echo "=== CORS中间件测试 ===\n\n";

// 模拟请求
$request = new Request();
$request->setMethod('GET');

// 模拟响应
$response = new Response();
$response->code(200);
$response->content('{"code": 200, "message": "success"}');

// 测试CORS中间件
echo "1. 测试CORS中间件\n";
$cors = new Cors();

// 模拟中间件调用
$result = $cors->handle($request, function($req) use ($response) {
    return $response;
});

echo "响应状态码: " . $result->getCode() . "\n";
echo "响应内容: " . $result->getContent() . "\n";

// 检查CORS头
$headers = $result->getHeader();
echo "\nCORS响应头:\n";
if (is_array($headers)) {
    foreach ($headers as $name => $value) {
        if (strpos($name, 'Access-Control-') === 0) {
            echo "  {$name}: {$value}\n";
        }
    }
} else {
    echo "  无法获取响应头信息\n";
}

// 测试OPTIONS预检请求
echo "\n2. 测试OPTIONS预检请求\n";
$optionsRequest = new Request();
$optionsRequest->setMethod('OPTIONS');

$optionsResult = $cors->handle($optionsRequest, function($req) use ($response) {
    return $response;
});

echo "OPTIONS响应状态码: " . $optionsResult->getCode() . "\n";
echo "OPTIONS响应内容: " . $optionsResult->getContent() . "\n";

// 检查OPTIONS响应头
$optionsHeaders = $optionsResult->getHeader();
echo "\nOPTIONS CORS响应头:\n";
if (is_array($optionsHeaders)) {
    foreach ($optionsHeaders as $name => $value) {
        if (strpos($name, 'Access-Control-') === 0) {
            echo "  {$name}: {$value}\n";
        }
    }
} else {
    echo "  无法获取OPTIONS响应头信息\n";
}

echo "\n=== 测试完成 ===\n";
echo "\n使用说明：\n";
echo "1. CORS中间件已配置到所有API路由\n";
echo "2. 支持所有常用HTTP方法\n";
echo "3. 允许携带Authorization等请求头\n";
echo "4. 预检请求缓存时间为86400秒\n";
echo "5. 可通过config/cors.php配置文件自定义设置\n";
echo "\n前端调用示例：\n";
echo "fetch('/auth/login', {\n";
echo "    method: 'POST',\n";
echo "    headers: {\n";
echo "        'Content-Type': 'application/json',\n";
echo "        'Authorization': 'Bearer token'\n";
echo "    },\n";
echo "    body: JSON.stringify({\n";
echo "        username: 'admin',\n";
echo "        password: '123456'\n";
echo "    })\n";
echo "});\n"; 