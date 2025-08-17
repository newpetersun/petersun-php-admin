<?php
// 测试文件 - 用于验证配置
echo "ThinkPHP 路由测试<br>";
echo "当前时间: " . date('Y-m-d H:i:s') . "<br>";
echo "PHP版本: " . PHP_VERSION . "<br>";
echo "请求URI: " . $_SERVER['REQUEST_URI'] . "<br>";
echo "查询字符串: " . $_SERVER['QUERY_STRING'] . "<br>";

// 测试路由解析
if (isset($_GET['s'])) {
    echo "路由参数 s: " . $_GET['s'] . "<br>";
} else {
    echo "没有路由参数 s<br>";
}

// 测试ThinkPHP是否正常加载
try {
    require __DIR__ . '/../vendor/autoload.php';
    echo "ThinkPHP 自动加载器正常<br>";
    
    // 测试路由
    echo "路由类加载正常<br>";
    
} catch (Exception $e) {
    echo "错误: " . $e->getMessage() . "<br>";
}
?> 