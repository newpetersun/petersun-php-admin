<?php
/**
 * API接口测试脚本
 * 用于验证后端接口是否正常工作
 */

// 设置错误报告
error_reporting(E_ALL);
ini_set('display_errors', 1);

// 测试配置
$baseUrl = 'http://127.0.0.5'; // 修改为你的API地址
$testResults = [];

// 测试函数
function testApi($method, $url, $data = null, $description = '') {
    global $baseUrl, $testResults;
    
    $fullUrl = $baseUrl . $url;
    
    // 初始化cURL
    $ch = curl_init();
    
    // 设置cURL选项
    curl_setopt($ch, CURLOPT_URL, $fullUrl);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Accept: application/json'
    ]);
    
    if ($method === 'POST') {
        curl_setopt($ch, CURLOPT_POST, true);
        if ($data) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        }
    } elseif ($method === 'DELETE') {
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
    }
    
    // 执行请求
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    
    curl_close($ch);
    
    // 解析响应
    $result = [
        'url' => $fullUrl,
        'method' => $method,
        'http_code' => $httpCode,
        'description' => $description,
        'success' => false,
        'response' => null,
        'error' => null
    ];
    
    if ($error) {
        $result['error'] = $error;
    } else {
        $result['response'] = json_decode($response, true);
        $result['success'] = $httpCode >= 200 && $httpCode < 300;
    }
    
    $testResults[] = $result;
    
    // 输出结果
    $status = $result['success'] ? '✅' : '❌';
    echo "{$status} {$description}\n";
    echo "   URL: {$fullUrl}\n";
    echo "   HTTP Code: {$httpCode}\n";
    if ($result['error']) {
        echo "   Error: {$result['error']}\n";
    }
    if ($result['response']) {
        echo "   Response: " . json_encode($result['response'], JSON_UNESCAPED_UNICODE) . "\n";
    }
    echo "\n";
    
    return $result;
}

// 开始测试
echo "=== PeterSun作品集API接口测试 ===\n\n";

// 1. 测试首页接口
testApi('GET', '/', null, '首页接口测试');

// 2. 测试用户信息接口
testApi('GET', '/user/info', null, '获取用户信息');

// 3. 测试技术栈接口
testApi('GET', '/user/technologies', null, '获取技术栈列表');

// 4. 测试地图数据接口
testApi('GET', '/user/map-data', null, '获取地图数据');

// 5. 测试项目列表接口
testApi('GET', '/project/list', null, '获取项目列表');

// 6. 测试项目详情接口
testApi('GET', '/project/detail/1', null, '获取项目详情');

// 7. 测试项目分类接口
testApi('GET', '/project/categories', null, '获取项目分类');

// 8. 测试推荐项目接口
testApi('GET', '/project/featured', null, '获取推荐项目');

// 9. 测试联系信息接口
testApi('GET', '/contact/info', null, '获取联系信息');

// 10. 测试留言提交接口
testApi('POST', '/contact/message', [
    'name' => '测试用户',
    'email' => 'test@example.com',
    'content' => '这是一条测试留言'
], '提交留言');

// 11. 测试访问日志接口
testApi('POST', '/visit/log', [
    'page' => '/test',
    'referer' => 'http://example.com',
    'user_agent' => 'Mozilla/5.0 (Test)'
], '记录访问日志');

// 12. 测试访问统计接口
testApi('GET', '/visit/stats', null, '获取访问统计');

// 13. 测试管理员登录接口
testApi('POST', '/auth/login', [
    'username' => 'admin',
    'password' => '123456'
], '管理员登录');

// 输出测试总结
echo "=== 测试总结 ===\n";
$totalTests = count($testResults);
$successTests = count(array_filter($testResults, function($result) {
    return $result['success'];
}));
$failedTests = $totalTests - $successTests;

echo "总测试数: {$totalTests}\n";
echo "成功: {$successTests}\n";
echo "失败: {$failedTests}\n";
echo "成功率: " . round(($successTests / $totalTests) * 100, 2) . "%\n\n";

if ($failedTests > 0) {
    echo "=== 失败的测试 ===\n";
    foreach ($testResults as $result) {
        if (!$result['success']) {
            echo "❌ {$result['description']}\n";
            echo "   URL: {$result['url']}\n";
            echo "   HTTP Code: {$result['http_code']}\n";
            if ($result['error']) {
                echo "   Error: {$result['error']}\n";
            }
            echo "\n";
        }
    }
}

echo "测试完成！\n"; 