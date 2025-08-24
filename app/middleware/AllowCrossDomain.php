<?php
declare (strict_types = 1);

namespace app\middleware;

class AllowCrossDomain
{
    /**
     * 处理请求
     *
     * @param \think\Request $request
     * @param \Closure       $next
     * @return \think\Response
     */
    public function handle($request, \Closure $next)
    {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Headers: Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since, X-Requested-With');
        header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
        header('Access-Control-Max-Age: 1728000');
        
        // 预检请求直接返回成功
        if ($request->isOptions()) {
            return response('', 200);
        }
        
        return $next($request);
    }
} 