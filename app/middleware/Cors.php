<?php
declare(strict_types=1);

namespace app\middleware;

use think\Request;
use think\Response;

/**
 * CORS跨域中间件
 */
class Cors
{
    /**
     * 处理请求
     * @param Request $request
     * @param \Closure $next
     * @return Response
     */
    public function handle(Request $request, \Closure $next): Response
    {
        // 检查是否启用CORS
        if (!config('cors.enabled', true)) {
            return $next($request);
        }
        
        // 获取响应对象
        $response = $next($request);
        
        // 获取CORS配置
        $origin = config('cors.allow_origin', '*');
        $headers = implode(', ', config('cors.allow_headers', []));
        $methods = implode(', ', config('cors.allow_methods', []));
        $credentials = config('cors.allow_credentials', true) ? 'true' : 'false';
        $maxAge = config('cors.max_age', 86400);
        $exposeHeaders = implode(', ', config('cors.expose_headers', []));
        
        // 设置CORS头
        $corsHeaders = [
            'Access-Control-Allow-Origin' => $origin,
            'Access-Control-Allow-Headers' => $headers,
            'Access-Control-Allow-Methods' => $methods,
            'Access-Control-Allow-Credentials' => $credentials,
            'Access-Control-Max-Age' => $maxAge,
        ];
        
        // 添加暴露的响应头
        if (!empty($exposeHeaders)) {
            $corsHeaders['Access-Control-Expose-Headers'] = $exposeHeaders;
        }
        
        $response->header($corsHeaders);
        
        // 处理预检请求
        if ($request->method() === 'OPTIONS') {
            $response->code(200);
            $response->content('');
        }
        
        return $response;
    }
} 