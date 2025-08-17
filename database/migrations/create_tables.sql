-- 创建数据库表结构

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL COMMENT '姓名',
    `email` varchar(100) NOT NULL COMMENT '邮箱',
    `code_age` int(11) DEFAULT 8 COMMENT '码龄',
    `description` text COMMENT '个人描述',
    `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
    `github` varchar(255) DEFAULT NULL COMMENT 'GitHub地址',
    `wechat` varchar(50) DEFAULT NULL COMMENT '微信号',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- 项目分类表
CREATE TABLE IF NOT EXISTS `project_category` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL COMMENT '分类名称',
    `key` varchar(50) NOT NULL COMMENT '分类标识',
    `sort_order` int(11) DEFAULT 0 COMMENT '排序',
    `status` tinyint(1) DEFAULT 1 COMMENT '状态：1启用，0禁用',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目分类表';

-- 项目表
CREATE TABLE IF NOT EXISTS `project` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `title` varchar(200) NOT NULL COMMENT '项目标题',
    `description` text NOT NULL COMMENT '项目描述',
    `full_description` text COMMENT '完整描述',
    `image` varchar(255) DEFAULT NULL COMMENT '项目图片',
    `category_id` int(11) NOT NULL DEFAULT 1 COMMENT '分类ID',
    `features` text COMMENT '功能特性，逗号分隔',
    `sort_order` int(11) DEFAULT 0 COMMENT '排序',
    `is_featured` tinyint(1) DEFAULT 0 COMMENT '是否推荐：1是，0否',
    `status` tinyint(1) DEFAULT 1 COMMENT '状态：1发布，0草稿',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_category` (`category_id`),
    KEY `idx_status` (`status`),
    KEY `idx_featured` (`is_featured`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目表';

-- 标签表
CREATE TABLE IF NOT EXISTS `tag` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL COMMENT '标签名称',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- 技术栈表
CREATE TABLE IF NOT EXISTS `technology` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL COMMENT '技术名称',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技术栈表';

-- 项目标签关联表
CREATE TABLE IF NOT EXISTS `project_tag` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `project_id` int(11) NOT NULL COMMENT '项目ID',
    `tag_id` int(11) NOT NULL COMMENT '标签ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_project_tag` (`project_id`, `tag_id`),
    KEY `idx_project` (`project_id`),
    KEY `idx_tag` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目标签关联表';

-- 项目技术栈关联表
CREATE TABLE IF NOT EXISTS `project_technology` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `project_id` int(11) NOT NULL COMMENT '项目ID',
    `technology_id` int(11) NOT NULL COMMENT '技术栈ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_project_tech` (`project_id`, `technology_id`),
    KEY `idx_project` (`project_id`),
    KEY `idx_technology` (`technology_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目技术栈关联表';

-- 联系信息表
CREATE TABLE IF NOT EXISTS `contact` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `email` varchar(100) NOT NULL COMMENT '邮箱',
    `wechat` varchar(50) DEFAULT NULL COMMENT '微信号',
    `qq` varchar(20) DEFAULT NULL COMMENT 'QQ号',
    `address` varchar(200) DEFAULT NULL COMMENT '地址',
    `github` varchar(255) DEFAULT NULL COMMENT 'GitHub地址',
    `working_hours` json DEFAULT NULL COMMENT '工作时间',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联系信息表';

-- 留言表
CREATE TABLE IF NOT EXISTS `contact_message` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL COMMENT '姓名',
    `email` varchar(100) NOT NULL COMMENT '邮箱',
    `subject` varchar(200) DEFAULT NULL COMMENT '主题',
    `message` text NOT NULL COMMENT '留言内容',
    `ip` varchar(45) DEFAULT NULL COMMENT 'IP地址',
    `user_agent` text DEFAULT NULL COMMENT '用户代理',
    `is_read` tinyint(1) DEFAULT 0 COMMENT '是否已读：1已读，0未读',
    `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_email` (`email`),
    KEY `idx_read` (`is_read`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='留言表';

-- 访问日志表
CREATE TABLE IF NOT EXISTS `visit_log` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `ip` varchar(45) NOT NULL COMMENT 'IP地址',
    `page` varchar(255) NOT NULL COMMENT '访问页面',
    `referer` varchar(500) DEFAULT NULL COMMENT '来源页面',
    `user_agent` text DEFAULT NULL COMMENT '用户代理',
    `device_type` varchar(20) DEFAULT 'desktop' COMMENT '设备类型：desktop,mobile,tablet',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_ip` (`ip`),
    KEY `idx_page` (`page`),
    KEY `idx_device` (`device_type`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访问日志表';

-- 管理员日志表
CREATE TABLE IF NOT EXISTS `admin_log` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(50) NOT NULL COMMENT '用户名',
    `action` varchar(50) NOT NULL COMMENT '操作类型',
    `ip` varchar(45) DEFAULT NULL COMMENT 'IP地址',
    `user_agent` text DEFAULT NULL COMMENT '用户代理',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_username` (`username`),
    KEY `idx_action` (`action`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员日志表';

-- 插入初始数据

-- 用户信息
INSERT INTO `user` (`name`, `email`, `code_age`, `description`, `avatar`, `github`, `wechat`) VALUES
('PeterSun', 'cto@cvun.net', 8, '一位热衷于创建视觉元素、主题制作和嵌入式开发的全栈工程师。', '/static/images/peter.jpg', 'https://github.com/petersun', 'cto-peter');

-- 项目分类
INSERT INTO `project_category` (`name`, `key`, `sort_order`, `status`) VALUES
('Web开发', 'web', 1, 1),
('移动开发', 'mobile', 2, 1),
('UI设计', 'design', 3, 1),
('数据分析', 'data', 4, 1);

-- 项目数据
INSERT INTO `project` (`title`, `description`, `full_description`, `image`, `category_id`, `features`, `sort_order`, `is_featured`, `status`) VALUES
('LikeSee短视频管理系统', '现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越', '这是一个现代化的短视频管理系统，采用最新的前端技术栈，提供完整的短视频内容管理解决方案。系统具有响应式设计，支持多种设备访问，内置明暗主题切换功能，集成ECharts图表库进行数据可视化，具备完善的权限控制系统和丰富的组件库。', '/static/images/projects/likesee-vue-admin/login.jpg', 1, '用户权限管理,内容审核系统,数据统计分析,实时监控面板,多主题切换,响应式布局', 1, 1, 1),
('数据可视化大屏', '大数据驱动的短视频业务分析系统，提供实时数据监控和可视化', '基于大数据技术构建的业务分析系统，实时收集和处理短视频平台的海量数据，通过直观的图表和仪表盘展示关键业务指标，帮助运营团队快速了解业务状况并做出决策。', '/static/images/projects/data-visualization/index.jpg', 4, '实时数据监控,多维度分析,自定义图表,数据导出功能,告警系统,历史数据查询', 2, 1, 1);

-- 标签数据
INSERT INTO `tag` (`name`) VALUES
('Vue3'), ('Web开发'), ('响应式'), ('数据分析'), ('大数据'), ('可视化'), ('React'), ('Node.js'), ('Python'), ('PHP');

-- 技术栈数据
INSERT INTO `technology` (`name`) VALUES
('Vue 3'), ('Vite'), ('Element Plus'), ('ECharts'), ('Axios'), ('React'), ('D3.js'), ('WebSocket'), ('Node.js'), ('ThinkPHP'), ('Laravel'), ('MySQL');

-- 项目标签关联
INSERT INTO `project_tag` (`project_id`, `tag_id`) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5), (2, 6);

-- 项目技术栈关联
INSERT INTO `project_technology` (`project_id`, `technology_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 6), (2, 7), (2, 4), (2, 8), (2, 9);

-- 联系信息
INSERT INTO `contact` (`email`, `wechat`, `qq`, `address`, `github`, `working_hours`) VALUES
('cto@cvun.net', 'cto-peter', '21312314', '河南省郑州市', 'https://github.com/petersun', '[
    {"day": "工作日", "time": "09:00 - 18:00"},
    {"day": "周六", "time": "10:00 - 16:00"},
    {"day": "周日", "time": "休息"}
]');

-- 示例留言
INSERT INTO `contact_message` (`name`, `email`, `subject`, `message`, `ip`, `is_read`) VALUES
('张三', 'zhangsan@example.com', '项目合作', '您好，我对您的项目很感兴趣，想了解一下合作的可能性。', '127.0.0.1', 0),
('李四', 'lisi@example.com', '技术咨询', '请问您是否接受远程工作？我们公司正在寻找优秀的前端开发者。', '127.0.0.1', 1),
('王五', 'wangwu@example.com', '作品集咨询', '您的作品集设计很棒，想请教一下技术实现方案。', '127.0.0.1', 1); 