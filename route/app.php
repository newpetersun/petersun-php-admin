<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\facade\Route;

// API路由组
Route::group('api', function () {
    // 用户相关API
    Route::get('user/info', 'User/info');
    Route::post('user/update', 'User/update');
    
    // 项目相关API
    Route::get('project/list', 'Project/list');
    Route::get('project/detail/:id', 'Project/detail');
    Route::post('project/create', 'Project/create');
    Route::post('project/update/:id', 'Project/update');
    Route::delete('project/delete/:id', 'Project/delete');
    Route::post('project/status/:id', 'Project/updateStatus');
    
    // 联系信息相关API
    Route::get('contact/info', 'Contact/info');
    Route::post('contact/update', 'Contact/update');
    Route::get('contact/messages', 'Contact/messages');
    Route::post('contact/message', 'Contact/message');
    Route::post('contact/message/read/:id', 'Contact/markAsRead');
    Route::delete('contact/message/delete/:id', 'Contact/deleteMessage');
});

// 默认首页路由
Route::get('/', function () {
    return json([
        'code' => 200,
        'message' => '解忧青年作品集 API 服务',
        'version' => '1.0.0',
        'endpoints' => [
            'user' => '/api/user/*',
            'project' => '/api/project/*',
            'contact' => '/api/contact/*'
        ]
    ]);
});
