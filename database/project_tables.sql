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
  `country` varchar(50) DEFAULT NULL COMMENT '国家',
  `province` varchar(50) DEFAULT NULL COMMENT '省份',
  `city` varchar(50) DEFAULT NULL COMMENT '城市',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_page` (`page`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问日志表';

-- 插入默认数据
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
('区块链', '#20c997');

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
('个人作品集网站', '基于Vue3和ThinkPHP8开发的个人作品集展示网站，支持多端适配', '这是一个完整的个人作品集项目，包含前端展示和后台管理功能...', '/static/images/projects/portfolio.jpg', 'Web开发', 1, 1, 1),
('电商管理系统', '基于ThinkPHP和Vue.js开发的电商后台管理系统', '包含商品管理、订单管理、用户管理、数据统计等功能...', '/static/images/projects/ecommerce.jpg', 'Web开发', 1, 2, 1),
('移动端APP', '基于UniApp开发的跨平台移动应用', '支持iOS和Android双平台，包含用户登录、内容展示、消息推送等功能...', '/static/images/projects/mobile-app.jpg', '移动应用', 1, 3, 1),
('数据可视化平台', '基于ECharts的数据可视化展示平台', '支持多种图表类型，实时数据更新，响应式设计...', '/static/images/projects/data-viz.jpg', 'Web开发', 1, 4, 0); 