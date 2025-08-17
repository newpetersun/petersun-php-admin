-- 用户信息表
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '姓名',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `description` text COMMENT '个人描述',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `code_age` int(11) DEFAULT 0 COMMENT '码龄',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- 项目分类表
CREATE TABLE `project_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `key` varchar(50) NOT NULL COMMENT '分类标识',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0禁用，1启用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目分类表';

-- 项目表
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL COMMENT '项目标题',
  `description` text COMMENT '项目描述',
  `full_description` text COMMENT '完整描述',
  `image` varchar(255) DEFAULT NULL COMMENT '项目图片',
  `category` varchar(50) DEFAULT NULL COMMENT '项目分类',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0禁用，1启用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目表';

-- 项目标签表
CREATE TABLE `project_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `tag_name` varchar(50) NOT NULL COMMENT '标签名称',
  PRIMARY KEY (`id`),
  KEY `idx_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目标签表';

-- 项目技术栈表
CREATE TABLE `project_technology` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `tech_name` varchar(50) NOT NULL COMMENT '技术名称',
  PRIMARY KEY (`id`),
  KEY `idx_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目技术栈表';

-- 联系信息表
CREATE TABLE `contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `wechat` varchar(50) DEFAULT NULL COMMENT '微信',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ',
  `address` varchar(200) DEFAULT NULL COMMENT '地址',
  `github` varchar(200) DEFAULT NULL COMMENT 'GitHub',
  `working_hours` json DEFAULT NULL COMMENT '工作时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联系信息表';

-- 联系留言表
CREATE TABLE `contact_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '姓名',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `subject` varchar(200) DEFAULT NULL COMMENT '主题',
  `message` text NOT NULL COMMENT '留言内容',
  `status` tinyint(1) DEFAULT 0 COMMENT '状态：0未读，1已读',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联系留言表';

-- 插入初始数据
INSERT INTO `user` (`name`, `email`, `description`, `code_age`) VALUES 
('解忧青年', 'cto@cvun.net', '一位热衷于创建视觉元素、主题制作和嵌入式开发的全栈工程师。', 8);

INSERT INTO `project_category` (`name`, `key`, `sort_order`) VALUES 
('Web开发', 'web', 1),
('移动开发', 'mobile', 2),
('桌面应用', 'desktop', 3),
('数据分析', 'data', 4);

INSERT INTO `contact` (`email`, `wechat`, `qq`, `address`, `github`) VALUES 
('cto@cvun.net', 'cto-peter', '21312314', '河南省郑州市', 'github.com/Juveniles-Full-Stack-Developer'); 