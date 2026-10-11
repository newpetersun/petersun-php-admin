<?php
/**
 * 统一路由入口
 * 约定：
 *   公开接口：未挂任何中间件
 *   登录接口：需 JwtAuth（用户 token）
 *   管理员接口：需 JwtAuth + AdminAuth
 *   200 成功 / 400 业务错误 / 401 未登录 / 403 无权限 / 404 不存在 / 500 服务器错误
 *
 * 内容模型说明：图文/视频/论坛帖子统一为 forum_posts 一行（type 仅 image_text|video），
 * 全部由 Post 控制器 + PostService 读写，原 Article 控制器已废弃。
 */

use think\facade\Route;

// ===================== 账号绑定 =====================
Route::group('account', function () {
    Route::get('list', 'Account/list');
    Route::post('bind', 'Account/bind');
    Route::post('unbind', 'Account/unbind');
})->middleware('JwtAuth');

// ===================== 违规申诉 =====================
Route::group('appeal', function () {
    Route::get('list', 'Appeal/list');
    Route::get('targets', 'Appeal/targets');
    Route::post('create', 'Appeal/create');
    Route::post('cancel/:id', 'Appeal/cancel');
})->middleware('JwtAuth')->pattern(['id' => '[\w-]+']);

// ===================== 用户令牌 =====================
Route::group('auth', function () {
    Route::get('profile', 'Auth/profile');
    Route::post('refresh', 'Auth/refresh');
    Route::post('logout', 'Auth/logout');
})->middleware('JwtAuth');

// ===================== 论坛板块 =====================
Route::group('board', function () {
    Route::get('list', 'Board/list');
    Route::get('detail', 'Board/detail');
});
Route::group('board', function () {
    Route::post('join', 'Board/join');
    Route::post('follow', 'Board/follow');
})->middleware('JwtAuth');
Route::group('board', function () {
    Route::get('admin-list', 'Board/adminList');
    Route::post('create', 'Board/create');
    Route::post('update/:id', 'Board/update');
    Route::delete('delete/:id', 'Board/delete');
    Route::post('status/:id', 'Board/status');
})->middleware(['JwtAuth', 'AdminAuth'])->pattern(['id' => '[\w-]+']);

// ===================== 实名认证 =====================
Route::group('certify', function () {
    Route::post('submit', 'Certification/submit');
    Route::get('mine', 'Certification/mine');
})->middleware('JwtAuth');
Route::group('certify', function () {
    Route::get('list', 'Certification/list');
    Route::post('review', 'Certification/review');
})->middleware(['JwtAuth', 'AdminAuth']);
Route::get('certify/status', 'Certification/status');

// ===================== 联系 / 留言 =====================
// 公开：联系信息读取、提交留言（无需登录）
Route::group('contact', function () {
    Route::get('info', 'Contact/info');
    Route::post('message', 'Contact/message');
});
// 登录：留言管理（仅登录后可读写，杜绝越权匿名访问）
Route::group('contact', function () {
    Route::post('update', 'Contact/update');
    Route::get('messages', 'Contact/messages');
    Route::post('read/:id', 'Contact/read');
    Route::post('deleteMessage', 'Contact/deleteMessage');
    Route::get('stats', 'Contact/stats');
    Route::post('batch-read', 'Contact/batchRead');
    Route::post('batch-delete', 'Contact/batchDelete');
})->middleware('JwtAuth')->pattern(['id' => '[\w-]+']);

// ===================== 创作者数据看板 =====================
Route::group('creator', function () {
    Route::get('overview', 'Creator/overview');
    Route::get('content-stats', 'Creator/contentStats');
    Route::get('fans', 'Creator/fans');
    Route::get('announcements', 'Creator/announcements');
})->middleware('JwtAuth');

// ===================== 收益 / 提现 / 付费订单 =====================
Route::group('earning', function () {
    Route::get('overview', 'Earning/overview');
    Route::get('trend', 'Earning/trend');
    Route::get('withdraw-list', 'Earning/withdrawList');
    Route::post('apply-withdraw', 'Earning/applyWithdraw');
    Route::get('orders', 'Earning/orders');
})->middleware('JwtAuth');

// ===================== 后台仪表盘 / 统计（AdminDashboard） =====================
Route::group('admin', function () {
    Route::get('dashboard', 'AdminDashboard/dashboard');
    Route::get('stats', 'AdminDashboard/stats');
    Route::get('visit-trend', 'AdminDashboard/visitTrend');
    Route::get('user-trend', 'AdminDashboard/userTrend');
    Route::get('popular-pages', 'AdminDashboard/popularPages');
    Route::get('system-info', 'AdminDashboard/systemInfo');
})->middleware(['JwtAuth', 'AdminAuth']);

// ===================== 后台角色与菜单 =====================
Route::group('admin', function () {
    Route::get('menu', 'Menu/index');
    Route::get('roles', 'Menu/roleList');
    Route::post('roles', 'Menu/roleSave');
    Route::delete('roles/:id', 'Menu/roleDelete');
    Route::get('menus', 'Menu/menuList');
    Route::post('menus', 'Menu/menuSave');
    Route::delete('menus/:id', 'Menu/menuDelete');
})->middleware(['JwtAuth', 'AdminAuth'])->pattern(['id' => '[\w-]+']);

// ===================== 后台审核：封面 / 资料（UserReviewAdmin） =====================
Route::group('admin', function () {
    Route::get('covers', 'UserReviewAdmin/coverList');
    Route::post('cover-review', 'UserReviewAdmin/coverReview');
    Route::get('profile-reviews', 'UserReviewAdmin/profileReviewList');
    Route::post('profile-review', 'UserReviewAdmin/profileReview');
})->middleware(['JwtAuth', 'AdminAuth']);

// ===================== 站内私信 =====================
Route::group('message', function () {
    Route::get('conversations', 'Message/conversations');
    Route::get('messages', 'Message/messages');
    Route::post('send', 'Message/send');
    Route::get('unread-count', 'Message/unreadCount');
})->middleware('JwtAuth');

// ===================== 虚拟支付（道具直购） =====================
Route::group('pay', function () {
    Route::get('goods', 'Pay/goods');
    Route::get('status', 'Pay/status');
    Route::post('order', 'Pay/order');
    Route::get('wallet', 'Pay/wallet');
})->middleware('JwtAuth');
Route::group('pay', function () {
    Route::get('query', 'Pay/query');
})->middleware(['JwtAuth', 'AdminAuth']);
Route::post('pay/notify', 'Pay/notify');

// ===================== 用户 =====================
// 公开只读：用户公开主页信息 / 启动页 / 地图数据
Route::group('user', function () {
    Route::get('info', 'User/info');
    Route::get('splash-data', 'User/getSplashData');
    Route::get('map-data', 'User/mapData');
});
// 小程序用户资料写入（身份取自 JWT；allowAnonymous 仅放行，未登录返回 401）
Route::group('user', function () {
    Route::post('save-info', 'User/saveUserInfo');
    Route::get('get-info', 'User/getUserInfo');
    Route::post('update-stats', 'User/updateUserStats');
    Route::post('upload-avatar', 'User/uploadAvatar');
})->middleware('JwtAuth', 'allowAnonymous');
// 用户上传封面（需登录）
Route::group('user', function () {
    Route::post('upload-cover', 'User/uploadCover');
})->middleware('JwtAuth');
// 后台用户管理（需管理员）
Route::group('user', function () {
    Route::get('list', 'User/list');
    Route::post('create', 'User/create');
    Route::post('update', 'User/update');
    Route::post('delete', 'User/delete');
})->middleware(['JwtAuth', 'AdminAuth']);

// ===================== 访问统计 =====================
Route::group('visit', function () {
    Route::post('log', 'Visit/log');
    Route::get('stats', 'Visit/stats');
    Route::get('trend', 'Visit/trend');
    Route::get('realtime', 'Visit/realtime');
    Route::get('geo', 'Visit/geo');
});

// ===================== 微信登录 / 后台扫码登录 =====================
// 小程序微信登录（公开）
Route::group('wechat', function () {
    Route::post('login', 'WechatAuth/login');
    Route::post('complete-info', 'WechatAuth/completeUserInfo');
    Route::get('verify-token', 'WechatAuth/verifyToken');
    Route::post('scan-confirm', 'WechatAuth/scanConfirm');
});
// 后台登录（与小程序登录拆分到 AdminAuth 控制器，公开）
Route::get('admin/captcha', 'AdminAuth/captcha');
Route::post('admin/password-login', 'AdminAuth/passwordLogin');
Route::post('admin/scan-ticket', 'AdminAuth/scanTicket');
Route::get('admin/scan-status', 'AdminAuth/scanStatus');

// ===================== 论坛首页聚合 =====================
Route::group('forum', function () {
    Route::get('hot-topics', 'Forum/hotTopics');
    Route::get('recommended', 'Forum/recommended');
    Route::get('active-authors', 'Forum/activeAuthors');
});

// ===================== 内容（帖子）统一接口 =====================
// 公开读
Route::group('post', function () {
    Route::get('list', 'Post/list');
    Route::get('detail/:id', 'Post/detail');
    Route::get('comments/:id', 'Post/comments');
    Route::get('poster-code', 'Post/posterCode');
})->pattern(['id' => '[\w-]+']);
// 登录写（发帖 / 点赞 / 评论 / 购买 / 举报 / 上传 / 更新 / 删除 + 创作者能力）
Route::group('post', function () {
    Route::post('create', 'Post/create');
    Route::post('upload-image', 'Post/uploadImage');
    Route::post('upload-video', 'Post/uploadVideo');
    Route::post('like', 'Post/like');
    Route::post('comment', 'Post/comment');
    Route::post('buy', 'Post/buy');
    Route::post('report', 'Post/report');
    Route::post('save', 'Post/save');
    Route::get('creator-list', 'Post/creatorList');
    Route::get('drafts', 'Post/drafts');
    Route::get('categories', 'Post/categories');
    Route::post('toggle-status/:id', 'Post/toggleStatus');
    Route::post('batch', 'Post/batch');
    Route::post('update/:id', 'Post/update');
    Route::post('delete/:id', 'Post/delete');
})->middleware('JwtAuth')->pattern(['id' => '[\w-]+']);
// 管理端（需管理员）
Route::group('post', function () {
    Route::get('admin-list', 'Post/adminList');
    Route::post('review/:id', 'Post/review');
})->middleware(['JwtAuth', 'AdminAuth'])->pattern(['id' => '[\w-]+']);

// ===================== 综合搜索 =====================
Route::get('search', 'Search/index');

// ===================== 系统设置 / 备份 =====================
Route::group('setting', function () {
    Route::get('list', 'Setting/list');
    Route::post('update', 'Setting/update');
    Route::get('system-info', 'Setting/systemInfo');
    Route::post('backup', 'Setting/backup');
    Route::post('restore', 'Setting/restore');
    Route::post('clear-cache', 'Setting/clearCache');
    Route::get('backup-list', 'Setting/backupList');
    Route::delete('backup/:filename', 'Setting/backup');
})->middleware(['JwtAuth', 'AdminAuth'])->pattern(['filename' => '.+']);
