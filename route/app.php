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
    
    // 微信登录相关接口（无需认证）
    Route::group('wechat', function () {
        Route::post('login', 'WechatAuth/login'); // 微信登录
        Route::post('complete-info', 'WechatAuth/completeUserInfo'); // 完善用户信息
        Route::get('verify-token', 'WechatAuth/verifyToken'); // 验证token
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
        Route::post('save-info', 'User/saveUserInfo'); // 保存微信用户信息
        Route::get('get-info', 'User/getUserInfo'); // 获取微信用户信息
        Route::post('update-stats', 'User/updateUserStats'); // 更新用户统计信息
        Route::post('upload-avatar', 'User/uploadAvatar'); // 上传用户头像
    });
    
    // 项目相关接口需鉴权
    Route::group('project', function () {
        Route::post('create', 'Project/create'); // 创建项目
        Route::post('update/:id', 'Project/update'); // 更新项目
        Route::delete('delete/:id', 'Project/delete'); // 删除项目
        Route::post('status/:id', 'Project/updateStatus'); // 更新项目状态
		Route::post('upload-image', 'Project/uploadImage'); // 上传项目图片
    })->middleware('JwtAuth');
    
	// 项目相关接口无需鉴权
	Route::group('project', function () {
	    Route::get('list', 'Project/list'); // 获取项目列表
	    Route::get('detail/:id', 'Project/detail'); // 获取项目详情
	    Route::get('categories', 'Project/categories'); // 获取项目分类
	    Route::get('featured', 'Project/featured'); // 获取首页推荐项目
	});
	
	// 联系相关接口需鉴权
	Route::group('contact', function () {
	    Route::post('update', 'Contact/update'); // 更新联系信息
	    Route::get('messages', 'Contact/messages'); // 获取留言列表
	    Route::post('read/:id', 'Contact/markAsRead'); // 标记留言为已读
	    Route::delete('message/:id', 'Contact/deleteMessage'); // 删除留言
	    Route::get('stats', 'Contact/stats'); // 获取留言统计
	    Route::post('batch-read', 'Contact/batchMarkAsRead'); // 批量标记为已读
	    Route::post('batch-delete', 'Contact/batchDelete'); // 批量删除留言
	})->middleware('JwtAuth');
	
    // 联系相关接口无需鉴权
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
        Route::get('dashboard', 'Admin/dashboard'); // 获取仪表盘数据
        Route::get('stats', 'Admin/stats'); // 获取系统统计
        Route::get('visit-trend', 'Admin/visitTrend'); // 获取访问趋势
        Route::get('popular-pages', 'Admin/popularPages'); // 获取热门页面
        Route::get('system-info', 'Admin/systemInfo'); // 获取系统信息
    })->middleware(['JwtAuth', 'AdminAuth']);
    
    // 系统设置接口
    Route::group('setting', function () {
        Route::get('list', 'Setting/getSettings'); // 获取系统设置
        Route::post('update', 'Setting/updateSettings'); // 更新系统设置
        Route::get('system-info', 'Setting/getSystemInfo'); // 获取系统信息
        Route::post('backup', 'Setting/backupData'); // 备份数据
        Route::post('restore', 'Setting/restoreData'); // 恢复数据
        Route::post('clear-cache', 'Setting/clearCache'); // 清除缓存
        Route::get('backup-list', 'Setting/getBackupList'); // 获取备份列表
        Route::delete('backup/:filename', 'Setting/deleteBackup'); // 删除备份文件
    })->middleware(['JwtAuth', 'AdminAuth']);
    
    // 访问统计接口
    Route::group('visit', function () {
        Route::post('log', 'Visit/log'); // 记录访问日志
        Route::get('stats', 'Visit/stats'); // 获取访问统计
        Route::get('trend', 'Visit/trend'); // 获取访问趋势
        Route::get('realtime', 'Visit/realtime'); // 获取实时访问数据
        Route::get('geo', 'Visit/geo'); // 获取地理位置统计
    });
    
    // 项目分类接口
    Route::group('category', function () {
        Route::get('list', 'Category/list'); // 获取分类列表
        Route::get('all', 'Category/all'); // 获取所有分类
        Route::get('detail/:id', 'Category/detail'); // 获取分类详情
        Route::post('create', 'Category/create'); // 创建分类
        Route::post('update/:id', 'Category/update'); // 更新分类
        Route::delete('delete/:id', 'Category/delete'); // 删除分类
        Route::post('status/:id', 'Category/status'); // 更新分类状态
    })->middleware(['JwtAuth', 'AdminAuth']);
    
    // 技术管理接口
    Route::group('technology', function () {
        Route::get('list', 'Technology/list'); // 获取技术列表
        Route::get('detail/:id', 'Technology/detail'); // 获取技术详情
        Route::post('create', 'Technology/create'); // 创建技术
        Route::post('update/:id', 'Technology/update'); // 更新技术
        Route::delete('delete/:id', 'Technology/delete'); // 删除技术
        Route::post('status/:id', 'Technology/status'); // 更新技术状态
        Route::post('upload-image', 'Technology/uploadImage'); // 上传技术图标
        Route::get('categories', 'Technology/categories'); // 获取技术分类列表
        Route::post('batch-delete', 'Technology/batchDelete'); // 批量删除技术
        Route::post('batch-status', 'Technology/batchStatus'); // 批量更新技术状态
    })->middleware(['JwtAuth', 'AdminAuth']);
    
    // 客户管理接口
    Route::group('client', function () {
        Route::get('list', 'Client/list'); // 获取客户列表
        Route::get('detail/:id', 'Client/detail'); // 获取客户详情
        Route::post('status/:id', 'Client/updateStatus'); // 更新客户状态
        Route::get('projects/:id', 'Client/projects'); // 获取客户的项目列表
    })->middleware(['JwtAuth', 'AdminAuth']);
    
    // 项目进度管理接口
    Route::group('progress', function () {
        Route::get('requirements/:project_id', 'Progress/getRequirements'); // 获取项目需求列表
        Route::get('requirement/:id', 'Progress/getRequirementDetail'); // 获取需求详情
        Route::post('requirement', 'Progress/createRequirement'); // 创建需求
        Route::put('requirement/:id', 'Progress/updateRequirement'); // 更新需求
        Route::delete('requirement/:id', 'Progress/deleteRequirement'); // 删除需求
        Route::get('stats/:project_id', 'Progress/getRequirementStats'); // 获取需求统计
        
        // 需求模板管理
        Route::get('templates', 'Progress/getTemplates'); // 获取需求模板列表
        Route::post('template', 'Progress/createTemplate'); // 创建需求模板
        
        // 工程师管理
        Route::get('engineers', 'Progress/getEngineers'); // 获取工程师列表
        
        // 工时管理
        Route::post('time-log', 'Progress/addTimeLog'); // 添加工时记录
        
        // 评论管理
        Route::post('comment', 'Progress/addComment'); // 添加评论
        
        // 附件管理
        Route::post('attachment/:requirement_id', 'Progress/uploadAttachment'); // 上传附件
        Route::delete('attachment/:id', 'Progress/deleteAttachment'); // 删除附件
    })->middleware('JwtAuth');
// 默认路由
Route::get('/', function () {
    return json([
        'code' => 200,
        'message' => 'PeterSun作品集API服务',
        'version' => '1.0.0',
        'timestamp' => date('Y-m-d H:i:s')
    ]);
});
