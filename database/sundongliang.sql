SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


CREATE TABLE `admin_log` (
  `id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员日志表' ROW_FORMAT=DYNAMIC;

CREATE TABLE `contact` (
  `id` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `wechat` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信号',
  `qq` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'QQ号',
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地址',
  `github` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'GitHub地址',
  `working_hours` json DEFAULT NULL COMMENT '工作时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='联系信息表' ROW_FORMAT=DYNAMIC;

INSERT INTO `contact` (`id`, `email`, `wechat`, `qq`, `address`, `github`, `working_hours`, `create_time`, `update_time`) VALUES
(1, 'cto@cvun.net', 'cto-peters', '213123145', '河南省郑州市', 'https://github.com/petersun', '[{\"day\": \"工作日\", \"time\": \"09:00 - 18:00\"}, {\"day\": \"周六\", \"time\": \"10:00 - 16:00\"}, {\"day\": \"周日\", \"time\": \"休息\"}]', '2025-08-17 17:48:12', '2025-08-25 03:48:05');

CREATE TABLE `contact_message` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '主题',
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '是否已读：1已读，0未读',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='留言表' ROW_FORMAT=DYNAMIC;

INSERT INTO `contact_message` (`id`, `name`, `email`, `subject`, `message`, `ip`, `user_agent`, `is_read`, `read_time`, `create_time`) VALUES
(1, '张三', 'zhangsan@example.com', '项目合作', '您好，我对您的项目很感兴趣，想了解一下合作的可能性。', '127.0.0.1', NULL, 0, NULL, '2025-08-17 17:48:13'),
(2, '李四', 'lisi@example.com', '技术咨询', '请问您是否接受远程工作？我们公司正在寻找优秀的前端开发者。', '127.0.0.1', NULL, 1, NULL, '2025-08-17 17:48:13'),
(3, '王五', 'wangwu@example.com', '作品集咨询', '您的作品集设计很棒，想请教一下技术实现方案。', '127.0.0.1', NULL, 1, NULL, '2025-08-17 17:48:13');

CREATE TABLE `project` (
  `id` int(11) NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目标题',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `full_description` text COLLATE utf8mb4_unicode_ci COMMENT '完整描述',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '项目图片',
  `category_id` int(11) NOT NULL DEFAULT '1' COMMENT '分类ID',
  `client_id` int(11) DEFAULT NULL COMMENT '关联的客户ID',
  `features` text COLLATE utf8mb4_unicode_ci COMMENT '功能特性，逗号分隔',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `is_featured` tinyint(1) DEFAULT '0' COMMENT '是否推荐：1是，0否',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1发布，0草稿',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目表' ROW_FORMAT=DYNAMIC;

INSERT INTO `project` (`id`, `title`, `description`, `full_description`, `image`, `category_id`, `client_id`, `features`, `sort_order`, `is_featured`, `status`, `create_time`, `update_time`) VALUES
(1, 'LikeSee短视频管理系统', '现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越', '现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越', '/static/images/projects/likesee-vue-admin/login.jpg', 1, NULL, '', 1, 1, 1, '2025-08-17 17:48:10', '2025-09-01 21:32:45'),
(2, '数据可视化大屏', '大数据驱动的短视频业务分析系统，提供实时数据监控和可视化', '基于大数据技术构建的业务分析系统，实时收集和处理短视频平台的海量数据，通过直观的图表和仪表盘展示关键业务指标，帮助运营团队快速了解业务状况并做出决策。', 'https://www.sundongliang.cn/static/images/projects/data-visualization/index.jpg', 4, NULL, '实时数据监控,多维度分析,自定义图表,数据导出功能,告警系统,历史数据查询', 2, 1, 1, '2025-08-17 17:48:10', '2025-08-31 04:19:50');

CREATE TABLE `project_category` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类标识',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分类描述',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目分类表' ROW_FORMAT=DYNAMIC;

INSERT INTO `project_category` (`id`, `name`, `key`, `description`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
(1, 'Web开发', 'web', '', 1, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09'),
(2, '移动开发', 'mobile', '', 2, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09'),
(3, 'UI设计', 'design', '', 3, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09'),
(4, '数据分析', 'data', '', 4, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09');

CREATE TABLE `project_images` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目图片表' ROW_FORMAT=DYNAMIC;

INSERT INTO `project_images` (`id`, `project_id`, `image_url`, `sort_order`, `create_time`) VALUES
(10, 1, '/static/images/projects/likesee-vue-admin/login.jpg', 0, '2025-09-01 21:32:45'),
(11, 1, '/static/images/projects/project_68a9e7dde5031.jpg', 1, '2025-09-01 21:32:46'),
(12, 1, '/static/images/projects/project_68a9e7ee77c10.jpg', 2, '2025-09-01 21:32:46');

CREATE TABLE `project_requirements` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `title` varchar(200) NOT NULL COMMENT '需求标题',
  `description` text NOT NULL COMMENT '需求描述',
  `status` varchar(20) DEFAULT 'pending' COMMENT '需求状态',
  `priority` varchar(20) DEFAULT 'medium' COMMENT '优先级',
  `estimated_hours` decimal(8,2) DEFAULT NULL COMMENT '预估工时',
  `actual_hours` decimal(8,2) DEFAULT NULL COMMENT '实际工时',
  `assignee` int(11) DEFAULT NULL COMMENT '负责人',
  `assignee_id` int(11) DEFAULT NULL COMMENT '负责人id',
  `template_id` int(11) DEFAULT NULL COMMENT '需求模板ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

INSERT INTO `project_requirements` (`id`, `project_id`, `title`, `description`, `status`, `priority`, `estimated_hours`, `actual_hours`, `assignee`, `assignee_id`, `template_id`, `create_time`, `update_time`) VALUES
(1, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'high', 16.00, 18.50, NULL, 1, 1, '2025-09-02 15:29:45', '2025-09-02 16:53:31'),
(2, 1, '响应式布局实现', '实现网站的响应式布局，确保在不同设备上都能正常显示', 'completed', 'high', 12.00, 10.00, NULL, 1, 4, '2025-09-02 15:29:45', '2025-09-02 16:53:51'),
(3, 1, '项目展示功能', '实现项目列表展示、详情查看、分类筛选等功能', 'progress', 'medium', 8.00, 5.50, NULL, 1, 4, '2025-09-02 15:29:45', '2025-09-02 16:53:51'),
(4, 1, '后台管理系统', '开发后台管理系统，支持内容管理、用户管理等功能', 'pending', 'medium', 20.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:51'),
(5, 1, '数据统计功能', '实现访问统计、用户行为分析等数据统计功能', 'pending', 'low', 6.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:51'),
(6, 1, '商品管理模块', '开发商品增删改查、分类管理、库存管理等功能', 'completed', 'high', 24.00, 26.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52'),
(7, 1, '订单处理系统', '实现订单创建、支付、发货、退款等完整流程', 'progress', 'high', 32.00, 15.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52'),
(8, 1, '用户权限管理', '实现用户角色管理、权限控制等功能', 'pending', 'medium', 16.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52'),
(9, 1, '用户注册登录', '实现用户注册、登录、密码找回等功能', 'completed', 'high', 12.00, 14.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52'),
(10, 1, '内容展示功能', '实现内容浏览、搜索、分类等功能', 'progress', 'medium', 16.00, 8.00, NULL, 1, 4, '2025-09-02 15:29:45', '2025-09-02 16:53:52'),
(11, 1, '消息推送系统', '集成消息推送服务，支持实时通知', 'pending', 'low', 8.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52'),
(12, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, NULL, 1, NULL, '2025-09-02 16:21:53', '2025-09-02 16:53:52'),
(17, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, 0, 1, NULL, '2025-09-02 16:31:33', '2025-09-02 16:31:33'),
(18, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, 0, 1, NULL, '2025-09-02 16:44:04', '2025-09-02 16:51:42');

CREATE TABLE `project_tag` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `tag_id` int(11) NOT NULL COMMENT '标签ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目标签关联表' ROW_FORMAT=DYNAMIC;

INSERT INTO `project_tag` (`id`, `project_id`, `tag_id`) VALUES
(22, 1, 1),
(23, 1, 2),
(24, 1, 3),
(4, 2, 4),
(5, 2, 5),
(6, 2, 6);

CREATE TABLE `project_technology` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `technology_id` int(11) NOT NULL COMMENT '技术栈ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目技术栈关联表' ROW_FORMAT=DYNAMIC;

INSERT INTO `project_technology` (`id`, `project_id`, `technology_id`) VALUES
(37, 1, 1),
(38, 1, 2),
(39, 1, 3),
(40, 1, 4),
(41, 1, 5),
(8, 2, 4),
(6, 2, 6),
(7, 2, 7),
(9, 2, 8),
(10, 2, 9);

CREATE TABLE `requirement_attachments` (
  `id` int(11) NOT NULL,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `filename` varchar(255) NOT NULL COMMENT '文件名',
  `original_name` varchar(255) NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) NOT NULL COMMENT '文件路径',
  `file_size` bigint(20) DEFAULT NULL COMMENT '文件大小',
  `file_type` varchar(100) DEFAULT NULL COMMENT '文件类型',
  `uploader` varchar(100) DEFAULT NULL COMMENT '上传者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE `requirement_comments` (
  `id` int(11) NOT NULL,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `parent_id` int(11) DEFAULT NULL COMMENT '父评论ID',
  `content` text NOT NULL COMMENT '评论内容',
  `author` varchar(100) NOT NULL COMMENT '评论者',
  `author_avatar` varchar(255) DEFAULT NULL COMMENT '评论者头像',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统评论',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE `requirement_templates` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT '模板名称',
  `title_template` varchar(200) NOT NULL COMMENT '标题模板',
  `description_template` text NOT NULL COMMENT '描述模板',
  `category` varchar(50) DEFAULT NULL COMMENT '模板分类',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统模板',
  `usage_count` int(11) DEFAULT '0' COMMENT '使用次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

INSERT INTO `requirement_templates` (`id`, `name`, `title_template`, `description_template`, `category`, `is_system`, `usage_count`, `create_time`, `update_time`) VALUES
(1, '用户界面设计', '设计{项目名称}的用户界面', '设计{项目名称}的用户界面，包括以下页面：\n1. 首页设计\n2. 主要功能页面\n3. 用户交互流程\n4. 响应式适配\n\n设计要求：\n- 符合现代设计趋势\n- 用户体验友好\n- 品牌风格统一', 'UI设计', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50'),
(2, '数据库设计', '设计{项目名称}的数据库结构', '设计{项目名称}的数据库结构，包括：\n1. 核心数据表设计\n2. 表关系设计\n3. 索引优化\n4. 数据安全考虑\n\n技术要求：\n- 符合第三范式\n- 性能优化\n- 数据完整性', '后端开发', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50'),
(3, 'API接口开发', '开发{项目名称}的API接口', '开发{项目名称}的API接口，包括：\n1. RESTful API设计\n2. 接口文档编写\n3. 错误处理机制\n4. 接口测试\n\n技术要求：\n- 遵循REST规范\n- 统一响应格式\n- 完善的错误处理', '后端开发', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50'),
(4, '前端页面开发', '开发{项目名称}的前端页面', '开发{项目名称}的前端页面，包括：\n1. 页面结构搭建\n2. 样式设计实现\n3. 交互功能开发\n4. 浏览器兼容性\n\n技术要求：\n- 响应式设计\n- 性能优化\n- 代码规范', '前端开发', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50'),
(5, '功能测试', '对{项目名称}进行功能测试', '对{项目名称}进行全面的功能测试，包括：\n1. 功能点测试\n2. 边界条件测试\n3. 异常情况测试\n4. 性能测试\n\n测试要求：\n- 测试用例完整\n- 覆盖率达标\n- 缺陷跟踪', '测试', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50');

CREATE TABLE `requirement_time_logs` (
  `id` int(11) NOT NULL,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `user_name` varchar(100) NOT NULL COMMENT '记录者',
  `hours` decimal(8,2) NOT NULL COMMENT '工时',
  `description` text COMMENT '工时描述',
  `log_date` date NOT NULL COMMENT '工时日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `setting_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设置键名',
  `setting_value` text COLLATE utf8mb4_unicode_ci COMMENT '设置值',
  `setting_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'string' COMMENT '设置类型：string, int, bool, json',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设置描述',
  `group_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'basic' COMMENT '设置分组：basic, display, security, backup, system',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统设置：1是，0否',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统设置表' ROW_FORMAT=DYNAMIC;

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `setting_type`, `description`, `group_name`, `is_system`, `created_at`, `updated_at`) VALUES
(1, 'site_name', '解忧青年作品集', 'string', '网站名称', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(2, 'site_description', '一位热衷于创建视觉元素、主题制作和嵌入式开发的全栈工程师。', 'string', '网站描述', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(3, 'site_keywords', '作品集,前端开发,Vue,React,项目展示', 'string', '网站关键词', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(4, 'subdescription', '乔布斯于科技世界种下创新种子，罗永浩在行业浪潮里坚守情怀高地，都让我着迷。我仿佛看到老罗和乔布斯在科技和人文的十字路口探讨人生，所以我带着这份情怀，期待在这里与你相遇。', 'string', '网站副描述', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(5, 'projects_per_page', '9', 'int', '每页显示项目数', 'display', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(6, 'enable_comments', '1', 'bool', '启用评论功能', 'display', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(7, 'enable_sharing', '1', 'bool', '启用分享功能', 'display', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(8, 'login_lock', '1', 'bool', '登录失败锁定', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(9, 'session_timeout', '3600', 'int', '会话超时时间（秒）', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(10, 'max_login_attempts', '5', 'int', '最大登录尝试次数', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(11, 'lockout_duration', '1800', 'int', '锁定持续时间（秒）', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(12, 'auto_backup', '1', 'bool', '自动备份', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(13, 'backup_frequency', 'weekly', 'string', '备份频率', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(14, 'backup_retention', '30', 'int', '备份保留天数', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(15, 'backup_path', '/backups/', 'string', '备份路径', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(16, 'system_version', '1.0.0', 'string', '系统版本', 'system', 1, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(17, 'maintenance_mode', '0', 'bool', '维护模式', 'system', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30'),
(18, 'debug_mode', '0', 'bool', '调试模式', 'system', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');

CREATE TABLE `tag` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表' ROW_FORMAT=DYNAMIC;

INSERT INTO `tag` (`id`, `name`, `create_time`) VALUES
(1, 'Vue3', '2025-08-17 17:48:10'),
(2, 'Web开发', '2025-08-17 17:48:10'),
(3, '响应式', '2025-08-17 17:48:10'),
(4, '数据分析', '2025-08-17 17:48:10'),
(5, '大数据', '2025-08-17 17:48:10'),
(6, '可视化', '2025-08-17 17:48:10'),
(7, 'React', '2025-08-17 17:48:10'),
(8, 'Node.js', '2025-08-17 17:48:10'),
(9, 'Python', '2025-08-17 17:48:10'),
(10, 'PHP', '2025-08-17 17:48:10');

CREATE TABLE `technology` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '技术名称',
  `img` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='技术栈表' ROW_FORMAT=DYNAMIC;

INSERT INTO `technology` (`id`, `name`, `img`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
(1, 'HTML', '/static/images/exp/html.png', 1, 1, '2025-09-01 19:07:53', NULL),
(2, 'PHP', '/static/images/exp/php.png', 1, 1, '2025-09-01 19:08:13', NULL),
(3, 'VUE', '/static/images/exp/vue.png', 1, 1, '2025-09-01 19:08:26', NULL),
(4, 'Java', '/static/images/exp/java.png', 1, 1, '2025-09-01 19:08:41', NULL),
(5, 'Python', '/static/images/exp/python.png', 1, 1, '2025-09-01 19:08:57', NULL),
(6, 'ThinkPHP', '/static/images/exp/thinkphp.png', 1, 1, '2025-09-01 19:09:15', NULL),
(7, 'Laravel', '/static/images/exp/laravel.png', 1, 1, '2025-09-01 19:09:26', NULL),
(8, 'BootStrap', '/static/images/exp/bootstrap.png', 1, 1, '2025-09-01 19:09:38', NULL),
(9, 'Webpack', '/static/images/exp/webpack.png', 1, 1, '2025-09-01 19:09:51', NULL),
(10, 'Vite', '/static/images/exp/vite.png', 1, 1, '2025-09-01 19:10:03', NULL),
(11, 'FastAdmin', '/static/images/exp/fastadmin.png', 1, 1, '2025-09-01 19:10:16', NULL),
(12, 'Uniapp', '/static/images/exp/uniapp.png', 1, 1, '2025-09-01 19:10:30', NULL),
(13, 'Flutter', '/static/images/exp/flutter.png', 1, 1, '2025-09-01 19:10:41', NULL),
(14, 'PyCharm', '/static/images/exp/pycharm.png', 1, 1, '2025-09-01 19:10:52', NULL),
(15, 'PS', '/static/images/exp/ps.png', 1, 1, '2025-09-01 19:11:05', NULL),
(16, 'PR', '/static/images/exp/pr.png', 1, 1, '2025-09-01 19:11:18', NULL),
(17, 'AI', '/static/images/exp/ai.png', 1, 1, '2025-09-01 19:11:28', NULL),
(18, 'C4D', '/static/images/exp/c4d.png', 1, 1, '2025-09-01 19:11:42', NULL),
(19, 'Figma', '/static/images/exp/figma.png', 1, 1, '2025-09-01 19:11:55', NULL),
(20, 'Sketch', '/static/images/exp/sketch.png', 1, 1, '2025-09-01 19:12:06', NULL),
(21, 'FastAPI', '/static/images/exp/fastapi.png', 1, 1, '2025-09-01 19:12:17', NULL);

CREATE TABLE `users` (
  `id` int(11) NOT NULL COMMENT '用户ID',
  `openid` varchar(64) DEFAULT NULL COMMENT '微信openid',
  `user_key` varchar(64) DEFAULT NULL COMMENT '用户唯一标识',
  `nickname` varchar(100) NOT NULL COMMENT '用户昵称',
  `code_age` int(11) NOT NULL COMMENT '码龄',
  `avatar` varchar(500) DEFAULT NULL COMMENT '头像URL',
  `gender` tinyint(1) DEFAULT '0' COMMENT '性别：0未知，1男，2女',
  `country` varchar(50) DEFAULT '' COMMENT '国家',
  `province` varchar(50) DEFAULT '' COMMENT '省份',
  `city` varchar(50) DEFAULT '' COMMENT '城市',
  `language` varchar(20) DEFAULT 'zh_CN' COMMENT '语言',
  `visit_count` int(11) DEFAULT '0' COMMENT '访问次数',
  `like_count` int(11) DEFAULT '0' COMMENT '点赞次数',
  `token` varchar(255) DEFAULT NULL COMMENT 'JWT token',
  `token_expire_time` datetime DEFAULT NULL COMMENT 'token过期时间',
  `is_new_user` tinyint(1) DEFAULT '0' COMMENT '是否新用户',
  `is_engineer` tinyint(1) DEFAULT '0' COMMENT '是否工程师',
  `user_type` varchar(20) DEFAULT 'wechat' COMMENT '用户类型：wechat',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `role` varchar(20) DEFAULT '访客' COMMENT '角色',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  `wechat` varchar(50) DEFAULT NULL COMMENT '微信号',
  `github` varchar(255) DEFAULT NULL COMMENT 'GitHub地址',
  `web_url` varchar(255) DEFAULT NULL COMMENT '个人网站',
  `working_hours` json DEFAULT NULL COMMENT '工作时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='统一用户表' ROW_FORMAT=DYNAMIC;

INSERT INTO `users` (`id`, `openid`, `user_key`, `nickname`, `code_age`, `avatar`, `gender`, `country`, `province`, `city`, `language`, `visit_count`, `like_count`, `token`, `token_expire_time`, `is_new_user`, `is_engineer`, `user_type`, `status`, `role`, `email`, `phone`, `qq`, `wechat`, `github`, `web_url`, `working_hours`, `last_login_time`, `last_login_ip`, `create_time`, `update_time`) VALUES
(1, 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'e2d2eb129b794b0a45b39881aa8161e3', 'PeterSun', 9, '/static/images/avatar/avatar_695b5aec7ffd9.jpg', 0, '', '', '', 'zh_CN', 0, 0, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Njc1OTcyMjcsImV4cCI6MTc2ODIwMjAyNywibmJmIjoxNzY3NTk3MjI3LCJ1c2VyX2lkIjoxLCJ0eXBlIjoidXNlciJ9.JoOeR4H5Xw0XpGs6Cm1Sz7dtAdQditfuf0-bliPc8Ts', '2026-01-12 15:13:47', 0, 0, 'admin', 1, '访客', 'cto@cvun.net', '15993113751', '21312314', 'cto-peter', '', '', '[{\"day\": \"工作日\", \"time\": \"09:00 - 18:00\"}, {\"day\": \"周六\", \"time\": \"10:00 - 16:00\"}, {\"day\": \"周日\", \"time\": \"休息\"}]', '2026-01-05 15:13:47', '127.0.0.1', '2025-09-02 03:34:25', '2026-01-05 15:13:47');

CREATE TABLE `visit_log` (
  `id` int(11) NOT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `page` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问页面',
  `referer` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '来源页面',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `device_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'desktop' COMMENT '设备类型：desktop,mobile,tablet',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问日志表' ROW_FORMAT=DYNAMIC;


ALTER TABLE `admin_log`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_username` (`username`) USING BTREE,
  ADD KEY `idx_action` (`action`) USING BTREE,
  ADD KEY `idx_create_time` (`create_time`) USING BTREE;

ALTER TABLE `contact`
  ADD PRIMARY KEY (`id`) USING BTREE;

ALTER TABLE `contact_message`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_email` (`email`) USING BTREE,
  ADD KEY `idx_read` (`is_read`) USING BTREE,
  ADD KEY `idx_create_time` (`create_time`) USING BTREE;

ALTER TABLE `project`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_category` (`category_id`) USING BTREE,
  ADD KEY `idx_status` (`status`) USING BTREE,
  ADD KEY `idx_featured` (`is_featured`) USING BTREE,
  ADD KEY `idx_client` (`client_id`) USING BTREE;

ALTER TABLE `project_category`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `uk_key` (`key`) USING BTREE;

ALTER TABLE `project_images`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_project_id` (`project_id`) USING BTREE,
  ADD KEY `idx_project_sort` (`project_id`,`sort_order`) USING BTREE;

ALTER TABLE `project_requirements`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_project_id` (`project_id`) USING BTREE,
  ADD KEY `idx_status` (`status`) USING BTREE,
  ADD KEY `idx_priority` (`priority`) USING BTREE,
  ADD KEY `idx_assignee` (`assignee`) USING BTREE;

ALTER TABLE `project_tag`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `uk_project_tag` (`project_id`,`tag_id`) USING BTREE,
  ADD KEY `idx_project` (`project_id`) USING BTREE,
  ADD KEY `idx_tag` (`tag_id`) USING BTREE;

ALTER TABLE `project_technology`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `uk_project_tech` (`project_id`,`technology_id`) USING BTREE,
  ADD KEY `idx_project` (`project_id`) USING BTREE,
  ADD KEY `idx_technology` (`technology_id`) USING BTREE;

ALTER TABLE `requirement_attachments`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_requirement_id` (`requirement_id`) USING BTREE,
  ADD KEY `idx_uploader` (`uploader`) USING BTREE;

ALTER TABLE `requirement_comments`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_requirement_id` (`requirement_id`) USING BTREE,
  ADD KEY `idx_parent_id` (`parent_id`) USING BTREE,
  ADD KEY `idx_author` (`author`) USING BTREE;

ALTER TABLE `requirement_templates`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_category` (`category`) USING BTREE,
  ADD KEY `idx_is_system` (`is_system`) USING BTREE;

ALTER TABLE `requirement_time_logs`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_requirement_id` (`requirement_id`) USING BTREE,
  ADD KEY `idx_user_name` (`user_name`) USING BTREE,
  ADD KEY `idx_log_date` (`log_date`) USING BTREE;

ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `setting_key` (`setting_key`) USING BTREE,
  ADD KEY `idx_group_name` (`group_name`) USING BTREE;

ALTER TABLE `tag`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `uk_name` (`name`) USING BTREE;

ALTER TABLE `technology`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `uk_name` (`name`) USING BTREE;

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `uk_user_key` (`user_key`) USING BTREE,
  ADD UNIQUE KEY `uk_openid` (`openid`) USING BTREE,
  ADD KEY `idx_nickname` (`nickname`) USING BTREE,
  ADD KEY `idx_user_type` (`user_type`) USING BTREE,
  ADD KEY `idx_status` (`status`) USING BTREE,
  ADD KEY `idx_create_time` (`create_time`) USING BTREE;

ALTER TABLE `visit_log`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `idx_ip` (`ip`) USING BTREE,
  ADD KEY `idx_page` (`page`) USING BTREE,
  ADD KEY `idx_device` (`device_type`) USING BTREE,
  ADD KEY `idx_create_time` (`create_time`) USING BTREE;


ALTER TABLE `admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `contact_message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `project`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `project_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `project_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

ALTER TABLE `project_requirements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

ALTER TABLE `project_tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

ALTER TABLE `project_technology`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

ALTER TABLE `requirement_attachments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `requirement_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `requirement_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `requirement_time_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=19;

ALTER TABLE `tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

ALTER TABLE `technology`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID', AUTO_INCREMENT=3;

ALTER TABLE `visit_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=275;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
