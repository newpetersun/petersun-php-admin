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
     * @param string $mode 传 'allowAnonymous' 时，无/无效 token 不返回 401，而是以匿名(userId='')继续
     * @return Response
     */
    public function handle(Request $request, \Closure $next, string $mode = ''): Response
    {
        $allowAnonymous = $mode === 'allowAnonymous';

        $token = $request->header('Authorization');

        // 无 token：匿名模式放行（userId 置空），否则 401
        if (!$token) {
            if ($allowAnonymous) {
                $request->userId = '';
                $request->userType = 'guest';
                return $next($request);
            }
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
            // 匿名模式：无效 token 视为匿名，不拦截
            if ($allowAnonymous) {
                $request->userId = '';
                $request->userType = 'guest';
                return $next($request);
            }
            return json(['code' => 401, 'message' => 'Token无效或已过期']);
        }
    }
} 