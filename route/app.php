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
    // 用户信息相关
    Route::get('user/info', 'User/info');
    Route::post('user/update', 'User/update');
    
    // 项目相关
    Route::get('project/list', 'Project/list');
    Route::get('project/detail/:id', 'Project/detail');
    Route::post('project/create', 'Project/create');
    Route::post('project/update/:id', 'Project/update');
    Route::delete('project/delete/:id', 'Project/delete');
    Route::get('project/categories', 'Project/categories');
    
    // 联系信息相关
    Route::get('contact/info', 'Contact/info');
    Route::post('contact/update', 'Contact/update');
    Route::post('contact/message', 'Contact/message');
    Route::get('contact/messages', 'Contact/messages');
    Route::post('contact/read/:id', 'Contact/readMessage');
    Route::delete('contact/message/:id', 'Contact/deleteMessage');
});

// 后台管理路由组
Route::group('admin', function () {
    Route::get('/', 'Admin/index');
    Route::get('user', 'Admin/user');
    Route::get('project', 'Admin/project');
    Route::get('contact', 'Admin/contact');
    Route::get('message', 'Admin/message');
    Route::get('setting', 'Admin/setting');
});
