<?php
declare(strict_types=1);

namespace app\middleware;

use app\service\JwtService;
use think\Request;
use think\Response;

/**
 * JWT认证中间件
 */
class JwtAuth
{
    /**
     * 处理请求
     * @param Request $request
     * @param \Closure $next
     * @return Response
     */
    public function handle(Request $request, \Closure $next): Response
    {
        $token = $request->header('Authorization');
        
        if (!$token) {
            return json(['code' => 401, 'message' => '未提供认证token']);
        }
        
        // 移除Bearer前缀
        $token = str_replace('Bearer ', '', $token);
        
        $jwtService = new JwtService();
        
        try {
            $payload = $jwtService->verifyToken($token);
            
            // 将用户信息添加到请求中
            $request->userId = $payload->user_id;
            $request->userType = $payload->type ?? 'wechat_user';
            
            return $next($request);
        } catch (\Exception $e) {
            return json(['code' => 401, 'message' => 'Token无效或已过期']);
        }
    }
} 