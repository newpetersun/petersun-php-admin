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
        // 处理预检请求 - 必须在调用next之前处理
        if ($request->method() === 'OPTIONS') {
            // 创建空响应
            $response = Response::create('', 'text', 200);
            
            // 设置CORS头 - 确保所有必要的头都被设置
            $response->header([
                'Access-Control-Allow-Origin' => 'http://localhost:5173',
                'Access-Control-Allow-Headers' => 'Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since, X-CSRF-TOKEN, X-Requested-With, Accept, Origin, Cache-Control, X-File-Name',
                'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
                'Access-Control-Allow-Credentials' => 'true',
                'Access-Control-Max-Age' => '86400',
                'Content-Type' => 'text/plain; charset=utf-8',
                'Content-Length' => '0'
            ]);
            
            return $response;
        }
        
        // 获取响应对象
        $response = $next($request);
        
        // 为所有响应设置CORS头
        $response->header([
            'Access-Control-Allow-Origin' => 'http://localhost:5173',
            'Access-Control-Allow-Headers' => 'Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since, X-CSRF-TOKEN, X-Requested-With, Accept, Origin, Cache-Control, X-File-Name',
            'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
            'Access-Control-Allow-Credentials' => 'true',
            'Access-Control-Max-Age' => '86400',
        ]);
        
        return $response;
    }
} 