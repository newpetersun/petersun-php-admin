-- PeterSun作品集项目数据库初始化脚本
-- 创建时间: 2024-01-01
-- 说明: 此脚本包含项目所需的所有数据表结构和初始数据

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 用户表
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `name` varchar(100) DEFAULT NULL COMMENT '姓名',
  `code_age` varchar(50) DEFAULT NULL COMMENT '编程年龄',
  `description` text DEFAULT NULL COMMENT '个人描述',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `github` varchar(255) DEFAULT NULL COMMENT 'GitHub链接',
  `wechat` varchar(100) DEFAULT NULL COMMENT '微信号',
  `role` varchar(20) DEFAULT 'user' COMMENT '角色：admin管理员，user普通用户',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) DEFAULT NULL COMMENT '最后登录IP',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 项目表
CREATE TABLE IF NOT EXISTS `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL COMMENT '项目标题',
  `description` text DEFAULT NULL COMMENT '项目描述',
  `content` longtext DEFAULT NULL COMMENT '项目详细内容',
  `image` varchar(255) DEFAULT NULL COMMENT '项目封面图片',
  `category` varchar(50) DEFAULT NULL COMMENT '项目分类',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1发布，0草稿',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序',
  `is_featured` tinyint(1) DEFAULT 0 COMMENT '是否推荐：1是，0否',
  `view_count` int(11) DEFAULT 0 COMMENT '浏览次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_status` (`status`),
  KEY `idx_featured` (`is_featured`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目表';

-- 标签表
CREATE TABLE IF NOT EXISTS `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '标签名称',
  `color` varchar(20) DEFAULT '#007bff' COMMENT '标签颜色',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- 技术栈表
CREATE TABLE IF NOT EXISTS `technology` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '技术名称',
  `icon` varchar(255) DEFAULT NULL COMMENT '技术图标',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='技术栈表';

-- 项目标签关联表
CREATE TABLE IF NOT EXISTS `project_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `tag_id` int(11) NOT NULL COMMENT '标签ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_tag` (`project_id`, `tag_id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目标签关联表';

-- 项目技术栈关联表
CREATE TABLE IF NOT EXISTS `project_technology` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `technology_id` int(11) NOT NULL COMMENT '技术栈ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_technology` (`project_id`, `technology_id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_technology_id` (`technology_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目技术栈关联表';

-- 联系信息表
CREATE TABLE IF NOT EXISTS `contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '联系人姓名',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `wechat` varchar(100) DEFAULT NULL COMMENT '微信号',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  `address` varchar(255) DEFAULT NULL COMMENT '地址',
  `description` text DEFAULT NULL COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='联系信息表';

-- 留言表
CREATE TABLE IF NOT EXISTS `message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '留言者姓名',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `content` text NOT NULL COMMENT '留言内容',
  `ip` varchar(45) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `is_read` tinyint(1) DEFAULT 0 COMMENT '是否已读：1是，0否',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='留言表';

-- 访问日志表
CREATE TABLE IF NOT EXISTS `visit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(200) NOT NULL COMMENT '访问页面',
  `referer` varchar(500) DEFAULT NULL COMMENT '来源页面',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `ip` varchar(45) DEFAULT NULL COMMENT 'IP地址',
  `device_type` varchar(20) DEFAULT 'unknown' COMMENT '设备类型：desktop, mobile, tablet, unknown',
  `country` varchar(50) DEFAULT NULL COMMENT '国家',
  `province` varchar(50) DEFAULT NULL COMMENT '省份',
  `city` varchar(50) DEFAULT NULL COMMENT '城市',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_page` (`page`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_ip` (`ip`),
  KEY `idx_device_type` (`device_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问日志表';

-- 插入默认管理员用户（密码：123456）
INSERT INTO `users` (`username`, `password`, `email`, `nickname`, `name`, `code_age`, `description`, `avatar`, `github`, `wechat`, `role`, `status`) VALUES
('admin', '$2y$10$9VtovDn5RSMuuX4nynFUhe6QsXBwK5V0akBwYi7mff3NeEM50dD1i', 'admin@example.com', '管理员', 'PeterSun', '8年', '全栈开发工程师，专注于Web开发和移动应用开发', '/static/images/peter.jpg', 'https://github.com/petersun', 'cto-peter', 'admin', 1);

-- 插入默认联系信息
INSERT INTO `contact` (`name`, `email`, `phone`, `wechat`, `qq`, `address`, `description`) VALUES
('PeterSun', 'cto@cvun.net', '13800138000', 'cto-peter', '123456789', '北京市朝阳区', '全栈开发工程师，专注于Web开发和移动应用开发');

-- 插入默认标签
INSERT INTO `tag` (`name`, `color`) VALUES
('Web开发', '#007bff'),
('移动应用', '#28a745'),
('UI设计', '#ffc107'),
('后端开发', '#dc3545'),
('前端开发', '#17a2b8'),
('数据库', '#6f42c1'),
('人工智能', '#fd7e14'),
('区块链', '#20c997'),
('小程序', '#e83e8c'),
('APP开发', '#fd7e14');

-- 插入默认技术栈
INSERT INTO `technology` (`name`, `icon`) VALUES
('HTML', '/static/images/exp/html.png'),
('CSS', '/static/images/exp/css.png'),
('JavaScript', '/static/images/exp/js.png'),
('PHP', '/static/images/exp/php.png'),
('Vue', '/static/images/exp/vue.png'),
('React', '/static/images/exp/react.png'),
('Java', '/static/images/exp/java.png'),
('Python', '/static/images/exp/python.png'),
('ThinkPHP', '/static/images/exp/thinkphp.png'),
('Laravel', '/static/images/exp/laravel.png'),
('Bootstrap', '/static/images/exp/bootstrap.png'),
('Webpack', '/static/images/exp/webpack.png'),
('Vite', '/static/images/exp/vite.png'),
('FastAdmin', '/static/images/exp/fastadmin.png'),
('Uniapp', '/static/images/exp/uniapp.png'),
('Flutter', '/static/images/exp/flutter.png'),
('PyCharm', '/static/images/exp/pycharm.png'),
('PS', '/static/images/exp/ps.png'),
('PR', '/static/images/exp/pr.png'),
('AI', '/static/images/exp/ai.png'),
('C4D', '/static/images/exp/c4d.png'),
('Figma', '/static/images/exp/figma.png'),
('Sketch', '/static/images/exp/sketch.png'),
('FastAPI', '/static/images/exp/fastapi.png');

-- 插入示例项目
INSERT INTO `project` (`title`, `description`, `content`, `image`, `category`, `status`, `sort_order`, `is_featured`) VALUES
('个人作品集网站', '基于Vue3和ThinkPHP8开发的个人作品集展示网站，支持多端适配', '这是一个完整的个人作品集项目，包含前端展示和后台管理功能。前端使用Vue3 + UniApp实现跨平台开发，后端使用ThinkPHP8提供API服务。项目特点：\n\n1. 响应式设计，支持PC、平板、手机多端适配\n2. 后台管理系统，支持内容管理\n3. 访问统计功能\n4. 留言反馈系统\n5. 项目展示和技术栈展示', '/static/images/projects/portfolio.jpg', 'Web开发', 1, 1, 1),
('电商管理系统', '基于ThinkPHP和Vue.js开发的电商后台管理系统', '包含商品管理、订单管理、用户管理、数据统计等功能。系统采用前后端分离架构，后端提供RESTful API，前端使用Vue.js构建单页应用。\n\n主要功能：\n- 商品管理：商品增删改查、分类管理、库存管理\n- 订单管理：订单处理、发货管理、退款处理\n- 用户管理：用户信息、权限管理、会员等级\n- 数据统计：销售统计、用户分析、商品分析', '/static/images/projects/ecommerce.jpg', 'Web开发', 1, 2, 1),
('移动端APP', '基于UniApp开发的跨平台移动应用', '支持iOS和Android双平台，包含用户登录、内容展示、消息推送等功能。使用UniApp框架实现一套代码多端运行，大大提高了开发效率。\n\n功能特点：\n- 用户注册登录\n- 内容浏览和搜索\n- 消息推送通知\n- 离线缓存\n- 社交分享', '/static/images/projects/mobile-app.jpg', '移动应用', 1, 3, 1),
('数据可视化平台', '基于ECharts的数据可视化展示平台', '支持多种图表类型，实时数据更新，响应式设计。平台提供丰富的数据可视化组件，支持自定义配置和主题切换。\n\n图表类型：\n- 柱状图、折线图、饼图\n- 散点图、雷达图、热力图\n- 地图、3D图表\n- 仪表盘、进度条', '/static/images/projects/data-viz.jpg', 'Web开发', 1, 4, 0),
('小程序商城', '微信小程序电商平台', '基于微信小程序开发的电商平台，支持商品浏览、购物车、订单管理、支付等功能。\n\n主要功能：\n- 商品展示和搜索\n- 购物车管理\n- 订单处理\n- 微信支付集成\n- 用户中心', '/static/images/projects/miniprogram.jpg', '小程序', 1, 5, 0);

-- 为项目添加标签关联
INSERT INTO `project_tag` (`project_id`, `tag_id`) VALUES
(1, 1), (1, 5), -- 个人作品集网站：Web开发、前端开发
(2, 1), (2, 4), (2, 6), -- 电商管理系统：Web开发、后端开发、数据库
(3, 2), (3, 9), -- 移动端APP：移动应用、APP开发
(4, 1), (4, 5), -- 数据可视化平台：Web开发、前端开发
(5, 9); -- 小程序商城：小程序

-- 为项目添加技术栈关联
INSERT INTO `project_technology` (`project_id`, `technology_id`) VALUES
(1, 5), (1, 9), (1, 15), -- 个人作品集网站：Vue、ThinkPHP、Uniapp
(2, 5), (2, 9), (2, 11), -- 电商管理系统：Vue、ThinkPHP、Bootstrap
(3, 15), (3, 16), -- 移动端APP：Uniapp、Flutter
(4, 5), (4, 12), -- 数据可视化平台：Vue、Webpack
(5, 15); -- 小程序商城：Uniapp

SET FOREIGN_KEY_CHECKS = 1; 