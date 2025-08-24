-- 项目分类表
CREATE TABLE IF NOT EXISTS `project_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `key` varchar(50) NOT NULL COMMENT '分类标识',
  `description` varchar(255) DEFAULT NULL COMMENT '分类描述',
  `icon` varchar(255) DEFAULT NULL COMMENT '分类图标',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目分类表';

-- 初始数据
INSERT INTO `project_category` (`name`, `key`, `description`, `sort_order`, `status`) VALUES
('Web开发', 'web', 'Web相关开发项目', 1, 1),
('移动开发', 'mobile', '移动应用开发项目', 2, 1),
('UI设计', 'design', 'UI设计相关项目', 3, 1),
('数据分析', 'data', '数据分析相关项目', 4, 1);