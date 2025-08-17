<?php
/**
 * 认证功能测试脚本
 * 使用方法：php test_auth.php
 */

require_once 'vendor/autoload.php';

use app\model\User;
use app\service\JwtService;

echo "=== 用户认证功能测试 ===\n\n";

// 测试密码加密
echo "1. 测试密码加密功能\n";
$password = '123456';
$hashedPassword = User::hashPassword($password);
echo "原始密码: {$password}\n";
echo "加密后: {$hashedPassword}\n";
echo "验证结果: " . (User::verifyPassword($password, $hashedPassword) ? '成功' : '失败') . "\n\n";

// 测试JWT服务
echo "2. 测试JWT服务\n";
$jwtService = new JwtService();

$payload = [
    'user_id' => 1,
    'username' => 'admin'
];

$token = $jwtService->generateToken($payload);
echo "生成的Token: {$token}\n";

try {
    $decoded = $jwtService->verifyToken($token);
    echo "Token验证成功，用户ID: {$decoded->user_id}, 用户名: {$decoded->username}\n";
} catch (Exception $e) {
    echo "Token验证失败: " . $e->getMessage() . "\n";
}

echo "\n3. 测试用户模型方法\n";
// 注意：这里需要数据库连接，如果数据库未配置，会报错
try {
    $user = new User();
    echo "用户模型创建成功\n";
} catch (Exception $e) {
    echo "用户模型创建失败: " . $e->getMessage() . "\n";
}

echo "\n=== 测试完成 ===\n";
echo "\n使用说明：\n";
echo "1. 确保数据库已配置并创建了users表\n";
echo "2. 可以通过以下API接口测试：\n";
echo "   - POST /auth/login - 用户登录\n";
echo "   - POST /auth/register - 用户注册\n";
echo "   - GET /auth/profile - 获取用户信息\n";
echo "   - POST /auth/refresh - 刷新token\n";
echo "   - POST /auth/logout - 用户登出\n";
echo "\n默认测试账号：\n";
echo "用户名: admin, 密码: 123456\n";
echo "用户名: test, 密码: 123456\n"; 