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
            ->field('id, status')
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

        // 不再按 user_type 限制；后台菜单/权限由用户 role_id 对应角色决定
        // 将用户信息添加到请求中
        $request->adminUser = $user;
        // 标记管理端上下文：供控制器区分「本人操作」与「管理端操作」
        // （如查看待审核/已驳回内容详情、跨用户读取数据等）
        $request->isAdmin = true;

        return $next($request);
    }
}
