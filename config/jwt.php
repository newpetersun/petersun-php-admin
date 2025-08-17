<?php

return [
    // JWT密钥，请在生产环境中修改为强密钥
    'secret' => env('JWT_SECRET', 'your-super-secret-jwt-key-change-in-production'),
    
    // 算法
    'algorithm' => 'HS256',
    
    // Token过期时间（秒）
    'expire_time' => env('JWT_EXPIRE_TIME', 7200), // 2小时
    
    // 刷新Token过期时间（秒）
    'refresh_expire_time' => env('JWT_REFRESH_EXPIRE_TIME', 604800), // 7天
    
    // 是否启用黑名单
    'enable_blacklist' => env('JWT_ENABLE_BLACKLIST', false),
    
    // 黑名单缓存前缀
    'blacklist_prefix' => 'jwt_blacklist:',
]; 