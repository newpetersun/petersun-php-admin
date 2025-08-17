<?php

return [
    // 允许的域名，* 表示允许所有域名
    'allow_origin' => '*',
    
    // 允许的请求头
    'allow_headers' => [
        'Authorization',
        'Content-Type',
        'If-Match',
        'If-Modified-Since',
        'If-None-Match',
        'If-Unmodified-Since',
        'X-CSRF-TOKEN',
        'X-Requested-With',
        'Accept',
        'Origin',
        'Cache-Control',
        'X-File-Name'
    ],
    
    // 允许的请求方法
    'allow_methods' => [
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
    ],
    
    // 是否允许携带凭证
    'allow_credentials' => true,
    
    // 预检请求缓存时间（秒）
    'max_age' => 86400,
    
    // 是否暴露响应头
    'expose_headers' => [
        'Content-Length',
        'Content-Range'
    ],
    
    // 是否启用CORS
    'enabled' => true,
]; 