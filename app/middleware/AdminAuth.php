<?php
declare(strict_types=1);

namespace app\middleware;

use think\Request;
use think\Response;
use think\facade\Db;

/**
 * 管理员权限验证中间件
 */
class AdminAuth
{
    /**
     * 处理请求
     *
     * @param Request $request
     * @param \Closure $next
     * @return Response
     */
    public function handle(Request $request, \Closure $next): Response
    {
        // 获取用户ID
        $userId = $request->userId ?? null;
        
        if (!$userId) {
            return json([
                'code' => 401,
                'message' => '未登录或登录已过期',
                'data' => null
            ]);
        }
        
        // 检查用户是否存在且为管理员
        $user = Db::name('users')
            ->where('id', $userId)
            ->field('id, user_type, status')
            ->find();
            
        if (!$user) {
            return json([
                'code' => 403,
                'message' => '用户不存在',
                'data' => null
            ]);
        }
        
        // 检查用户状态
        if ($user['status'] != 1) {
            return json([
                'code' => 403,
                'message' => '用户已被禁用',
                'data' => null
            ]);
        }
        
        // 检查用户类型是否为管理员
        if ($user['user_type'] !== 'admin') {
            return json([
                'code' => 403,
                'message' => '无管理员权限',
                'data' => null
            ]);
        }
        
        // 将用户信息添加到请求中
        $request->adminUser = $user;
        
        return $next($request);
    }
}
