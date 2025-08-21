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

// 全局CORS中间件
    // 认证相关接口（无需认证）
    Route::group('auth', function () {
        Route::post('login', 'Auth/login'); // 用户登录
        Route::post('register', 'Auth/register'); // 用户注册
    });
    
    // 需要认证的接口
    Route::group('auth', function () {
        Route::get('profile', 'Auth/profile'); // 获取用户信息
        Route::post('refresh', 'Auth/refresh'); // 刷新token
        Route::post('logout', 'Auth/logout'); // 用户登出
    })->middleware('JwtAuth');
    
    // 用户相关接口
    Route::group('user', function () {
        Route::get('info', 'User/info'); // 获取用户信息
        Route::post('update', 'User/update'); // 更新用户信息
        Route::get('technologies', 'User/technologies'); // 获取技术栈列表
        Route::get('map-data', 'User/mapData'); // 获取地图数据
    });
    
    // 项目相关接口
    Route::group('project', function () {
        Route::get('list', 'Project/list'); // 获取项目列表
        Route::get('detail/:id', 'Project/detail'); // 获取项目详情
        Route::get('categories', 'Project/categories'); // 获取项目分类
        Route::get('featured', 'Project/featured'); // 获取首页推荐项目
        Route::post('create', 'Project/create'); // 创建项目
        Route::post('update/:id', 'Project/update'); // 更新项目
        Route::delete('delete/:id', 'Project/delete'); // 删除项目
        Route::post('status/:id', 'Project/updateStatus'); // 更新项目状态
    });
    
    // 联系相关接口
    Route::group('contact', function () {
        Route::get('info', 'Contact/info'); // 获取联系信息
        Route::post('update', 'Contact/update'); // 更新联系信息
        Route::get('messages', 'Contact/messages'); // 获取留言列表
        Route::post('message', 'Contact/message'); // 提交留言
        Route::post('read/:id', 'Contact/markAsRead'); // 标记留言为已读
        Route::delete('message/:id', 'Contact/deleteMessage'); // 删除留言
        Route::get('stats', 'Contact/stats'); // 获取留言统计
        Route::post('batch-read', 'Contact/batchMarkAsRead'); // 批量标记为已读
        Route::post('batch-delete', 'Contact/batchDelete'); // 批量删除留言
    });
    
    // 后台管理接口
    Route::group('admin', function () {
        Route::post('login', 'Admin/login'); // 管理员登录
        Route::get('dashboard', 'Admin/dashboard'); // 获取仪表盘数据
        Route::get('stats', 'Admin/stats'); // 获取系统统计
        Route::get('visit-trend', 'Admin/visitTrend'); // 获取访问趋势
        Route::get('popular-pages', 'Admin/popularPages'); // 获取热门页面
        Route::get('system-info', 'Admin/systemInfo'); // 获取系统信息
    });
    
    // 访问统计接口
    Route::group('visit', function () {
        Route::post('log', 'Visit/log'); // 记录访问日志
        Route::get('stats', 'Visit/stats'); // 获取访问统计
        Route::get('trend', 'Visit/trend'); // 获取访问趋势
        Route::get('realtime', 'Visit/realtime'); // 获取实时访问数据
        Route::get('geo', 'Visit/geo'); // 获取地理位置统计
    });
// 默认路由
Route::get('/', function () {
    return json([
        'code' => 200,
        'message' => 'PeterSun作品集API服务',
        'version' => '1.0.0',
        'timestamp' => date('Y-m-d H:i:s'),
        'endpoints' => [
            'auth' => [
                'POST /auth/login' => '用户登录',
                'POST /auth/register' => '用户注册',
                'GET /auth/profile' => '获取用户信息',
                'POST /auth/refresh' => '刷新Token',
                'POST /auth/logout' => '用户登出'
            ],
            'user' => [
                'GET /user/info' => '获取用户信息',
                'POST /user/update' => '更新用户信息',
                'GET /user/technologies' => '获取技术栈列表',
                'GET /user/map-data' => '获取地图数据'
            ],
            'project' => [
                'GET /project/list' => '获取项目列表',
                'GET /project/detail/:id' => '获取项目详情',
                'GET /project/categories' => '获取项目分类',
                'GET /project/featured' => '获取首页推荐项目',
                'POST /project/create' => '创建项目',
                'POST /project/update/:id' => '更新项目',
                'DELETE /project/delete/:id' => '删除项目',
                'POST /project/status/:id' => '更新项目状态'
            ],
            'contact' => [
                'GET /contact/info' => '获取联系信息',
                'POST /contact/update' => '更新联系信息',
                'GET /contact/messages' => '获取留言列表',
                'POST /contact/message' => '提交留言',
                'POST /contact/read/:id' => '标记留言为已读',
                'DELETE /contact/message/:id' => '删除留言',
                'GET /contact/stats' => '获取留言统计',
                'POST /contact/batch-read' => '批量标记为已读',
                'POST /contact/batch-delete' => '批量删除留言'
            ],
            'admin' => [
                'POST /admin/login' => '管理员登录',
                'GET /admin/dashboard' => '获取仪表盘数据',
                'GET /admin/stats' => '获取系统统计',
                'GET /admin/visit-trend' => '获取访问趋势',
                'GET /admin/popular-pages' => '获取热门页面',
                'GET /admin/system-info' => '获取系统信息'
            ],
            'visit' => [
                'POST /visit/log' => '记录访问日志',
                'GET /visit/stats' => '获取访问统计',
                'GET /visit/trend' => '获取访问趋势',
                'GET /visit/realtime' => '获取实时访问数据',
                'GET /visit/geo' => '获取地理位置统计'
            ]
        ]
    ]);
});
