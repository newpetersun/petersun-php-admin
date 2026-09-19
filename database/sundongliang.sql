-- MySQL dump 10.13  Distrib 5.7.44, for Linux (x86_64)
--
-- Host: localhost    Database: sundongliang
-- ------------------------------------------------------
-- Server version	5.7.44-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_log`
--

DROP TABLE IF EXISTS `admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_username` (`username`) USING BTREE,
  KEY `idx_action` (`action`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='管理员日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_log`
--

LOCK TABLES `admin_log` WRITE;
/*!40000 ALTER TABLE `admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_message`
--

DROP TABLE IF EXISTS `contact_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '主题',
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '是否已读：1已读，0未读',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_email` (`email`) USING BTREE,
  KEY `idx_read` (`is_read`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='留言表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_message`
--

LOCK TABLES `contact_message` WRITE;
/*!40000 ALTER TABLE `contact_message` DISABLE KEYS */;
INSERT INTO `contact_message` VALUES (1,'张三','zhangsan@example.com','项目合作','您好，我对您的项目很感兴趣，想了解一下合作的可能性。','127.0.0.1',NULL,0,NULL,'2025-08-17 17:48:13'),(2,'李四','lisi@example.com','技术咨询','请问您是否接受远程工作？我们公司正在寻找优秀的前端开发者。','127.0.0.1',NULL,1,NULL,'2025-08-17 17:48:13'),(3,'王五','wangwu@example.com','作品集咨询','您的作品集设计很棒，想请教一下技术实现方案。','127.0.0.1',NULL,1,NULL,'2025-08-17 17:48:13');
/*!40000 ALTER TABLE `contact_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_category` (`category_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_featured` (`is_featured`) USING BTREE,
  KEY `idx_client` (`client_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='项目表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES (1,'LikeSee短视频管理系统','现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越','现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越','/static/images/projects/likesee-vue-admin/login.jpg',1,NULL,'',1,1,1,'2025-08-17 17:48:10','2025-09-01 21:32:45'),(2,'数据可视化大屏','大数据驱动的短视频业务分析系统，提供实时数据监控和可视化','基于大数据技术构建的业务分析系统，实时收集和处理短视频平台的海量数据，通过直观的图表和仪表盘展示关键业务指标，帮助运营团队快速了解业务状况并做出决策。','https://www.sundongliang.cn/static/images/projects/data-visualization/index.jpg',4,NULL,'实时数据监控,多维度分析,自定义图表,数据导出功能,告警系统,历史数据查询',2,1,1,'2025-08-17 17:48:10','2025-08-31 04:19:50');
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_category`
--

DROP TABLE IF EXISTS `project_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类标识',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分类描述',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_key` (`key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='项目分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_category`
--

LOCK TABLES `project_category` WRITE;
/*!40000 ALTER TABLE `project_category` DISABLE KEYS */;
INSERT INTO `project_category` VALUES (1,'Web开发','web','',1,1,'2025-08-17 17:48:09','2025-08-17 17:48:09'),(2,'移动开发','mobile','',2,1,'2025-08-17 17:48:09','2025-08-17 17:48:09'),(3,'UI设计','design','',3,1,'2025-08-17 17:48:09','2025-08-17 17:48:09'),(4,'数据分析','data','',4,1,'2025-08-17 17:48:09','2025-08-17 17:48:09');
/*!40000 ALTER TABLE `project_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_images`
--

DROP TABLE IF EXISTS `project_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_project_id` (`project_id`) USING BTREE,
  KEY `idx_project_sort` (`project_id`,`sort_order`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='项目图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_images`
--

LOCK TABLES `project_images` WRITE;
/*!40000 ALTER TABLE `project_images` DISABLE KEYS */;
INSERT INTO `project_images` VALUES (10,1,'/static/images/projects/likesee-vue-admin/login.jpg',0,'2025-09-01 21:32:45'),(11,1,'/static/images/projects/project_68a9e7dde5031.jpg',1,'2025-09-01 21:32:46'),(12,1,'/static/images/projects/project_68a9e7ee77c10.jpg',2,'2025-09-01 21:32:46');
/*!40000 ALTER TABLE `project_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_requirements`
--

DROP TABLE IF EXISTS `project_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_requirements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_project_id` (`project_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_priority` (`priority`) USING BTREE,
  KEY `idx_assignee` (`assignee`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_requirements`
--

LOCK TABLES `project_requirements` WRITE;
/*!40000 ALTER TABLE `project_requirements` DISABLE KEYS */;
INSERT INTO `project_requirements` VALUES (1,1,'用户界面设计','设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等','completed','high',16.00,18.50,NULL,1,1,'2025-09-02 15:29:45','2025-09-02 16:53:31'),(2,1,'响应式布局实现','实现网站的响应式布局，确保在不同设备上都能正常显示','completed','high',12.00,10.00,NULL,1,4,'2025-09-02 15:29:45','2025-09-02 16:53:51'),(3,1,'项目展示功能','实现项目列表展示、详情查看、分类筛选等功能','progress','medium',8.00,5.50,NULL,1,4,'2025-09-02 15:29:45','2025-09-02 16:53:51'),(4,1,'后台管理系统','开发后台管理系统，支持内容管理、用户管理等功能','pending','medium',20.00,0.00,NULL,1,3,'2025-09-02 15:29:45','2025-09-02 16:53:51'),(5,1,'数据统计功能','实现访问统计、用户行为分析等数据统计功能','pending','low',6.00,0.00,NULL,1,3,'2025-09-02 15:29:45','2025-09-02 16:53:51'),(6,1,'商品管理模块','开发商品增删改查、分类管理、库存管理等功能','completed','high',24.00,26.00,NULL,1,3,'2025-09-02 15:29:45','2025-09-02 16:53:52'),(7,1,'订单处理系统','实现订单创建、支付、发货、退款等完整流程','progress','high',32.00,15.00,NULL,1,3,'2025-09-02 15:29:45','2025-09-02 16:53:52'),(8,1,'用户权限管理','实现用户角色管理、权限控制等功能','pending','medium',16.00,0.00,NULL,1,3,'2025-09-02 15:29:45','2025-09-02 16:53:52'),(9,1,'用户注册登录','实现用户注册、登录、密码找回等功能','completed','high',12.00,14.00,NULL,1,3,'2025-09-02 15:29:45','2025-09-02 16:53:52'),(10,1,'内容展示功能','实现内容浏览、搜索、分类等功能','progress','medium',16.00,8.00,NULL,1,4,'2025-09-02 15:29:45','2025-09-02 16:53:52'),(11,1,'消息推送系统','集成消息推送服务，支持实时通知','pending','low',8.00,0.00,NULL,1,3,'2025-09-02 15:29:45','2025-09-02 16:53:52'),(12,1,'用户界面设计','设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等','completed','medium',NULL,NULL,NULL,1,NULL,'2025-09-02 16:21:53','2025-09-02 16:53:52'),(17,1,'用户界面设计','设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等','completed','medium',NULL,NULL,0,1,NULL,'2025-09-02 16:31:33','2025-09-02 16:31:33'),(18,1,'用户界面设计','设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等','completed','medium',NULL,NULL,0,1,NULL,'2025-09-02 16:44:04','2025-09-02 16:51:42');
/*!40000 ALTER TABLE `project_requirements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_tag`
--

DROP TABLE IF EXISTS `project_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `tag_id` int(11) NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_project_tag` (`project_id`,`tag_id`) USING BTREE,
  KEY `idx_project` (`project_id`) USING BTREE,
  KEY `idx_tag` (`tag_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='项目标签关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_tag`
--

LOCK TABLES `project_tag` WRITE;
/*!40000 ALTER TABLE `project_tag` DISABLE KEYS */;
INSERT INTO `project_tag` VALUES (22,1,1),(23,1,2),(24,1,3),(4,2,4),(5,2,5),(6,2,6);
/*!40000 ALTER TABLE `project_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_technology`
--

DROP TABLE IF EXISTS `project_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_technology` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目ID',
  `technology_id` int(11) NOT NULL COMMENT '技术栈ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_project_tech` (`project_id`,`technology_id`) USING BTREE,
  KEY `idx_project` (`project_id`) USING BTREE,
  KEY `idx_technology` (`technology_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='项目技术栈关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_technology`
--

LOCK TABLES `project_technology` WRITE;
/*!40000 ALTER TABLE `project_technology` DISABLE KEYS */;
INSERT INTO `project_technology` VALUES (37,1,1),(38,1,2),(39,1,3),(40,1,4),(41,1,5),(8,2,4),(6,2,6),(7,2,7),(9,2,8),(10,2,9);
/*!40000 ALTER TABLE `project_technology` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirement_attachments`
--

DROP TABLE IF EXISTS `requirement_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requirement_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `filename` varchar(255) NOT NULL COMMENT '文件名',
  `original_name` varchar(255) NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) NOT NULL COMMENT '文件路径',
  `file_size` bigint(20) DEFAULT NULL COMMENT '文件大小',
  `file_type` varchar(100) DEFAULT NULL COMMENT '文件类型',
  `uploader` varchar(100) DEFAULT NULL COMMENT '上传者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_requirement_id` (`requirement_id`) USING BTREE,
  KEY `idx_uploader` (`uploader`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement_attachments`
--

LOCK TABLES `requirement_attachments` WRITE;
/*!40000 ALTER TABLE `requirement_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirement_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirement_comments`
--

DROP TABLE IF EXISTS `requirement_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requirement_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `parent_id` int(11) DEFAULT NULL COMMENT '父评论ID',
  `content` text NOT NULL COMMENT '评论内容',
  `author` varchar(100) NOT NULL COMMENT '评论者',
  `author_avatar` varchar(255) DEFAULT NULL COMMENT '评论者头像',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统评论',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_requirement_id` (`requirement_id`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE,
  KEY `idx_author` (`author`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement_comments`
--

LOCK TABLES `requirement_comments` WRITE;
/*!40000 ALTER TABLE `requirement_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirement_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirement_templates`
--

DROP TABLE IF EXISTS `requirement_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requirement_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '模板名称',
  `title_template` varchar(200) NOT NULL COMMENT '标题模板',
  `description_template` text NOT NULL COMMENT '描述模板',
  `category` varchar(50) DEFAULT NULL COMMENT '模板分类',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统模板',
  `usage_count` int(11) DEFAULT '0' COMMENT '使用次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_category` (`category`) USING BTREE,
  KEY `idx_is_system` (`is_system`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement_templates`
--

LOCK TABLES `requirement_templates` WRITE;
/*!40000 ALTER TABLE `requirement_templates` DISABLE KEYS */;
INSERT INTO `requirement_templates` VALUES (1,'用户界面设计','设计{项目名称}的用户界面','设计{项目名称}的用户界面，包括以下页面：\n1. 首页设计\n2. 主要功能页面\n3. 用户交互流程\n4. 响应式适配\n\n设计要求：\n- 符合现代设计趋势\n- 用户体验友好\n- 品牌风格统一','UI设计',1,0,'2025-09-02 15:12:50','2025-09-02 15:12:50'),(2,'数据库设计','设计{项目名称}的数据库结构','设计{项目名称}的数据库结构，包括：\n1. 核心数据表设计\n2. 表关系设计\n3. 索引优化\n4. 数据安全考虑\n\n技术要求：\n- 符合第三范式\n- 性能优化\n- 数据完整性','后端开发',1,0,'2025-09-02 15:12:50','2025-09-02 15:12:50'),(3,'API接口开发','开发{项目名称}的API接口','开发{项目名称}的API接口，包括：\n1. RESTful API设计\n2. 接口文档编写\n3. 错误处理机制\n4. 接口测试\n\n技术要求：\n- 遵循REST规范\n- 统一响应格式\n- 完善的错误处理','后端开发',1,0,'2025-09-02 15:12:50','2025-09-02 15:12:50'),(4,'前端页面开发','开发{项目名称}的前端页面','开发{项目名称}的前端页面，包括：\n1. 页面结构搭建\n2. 样式设计实现\n3. 交互功能开发\n4. 浏览器兼容性\n\n技术要求：\n- 响应式设计\n- 性能优化\n- 代码规范','前端开发',1,0,'2025-09-02 15:12:50','2025-09-02 15:12:50'),(5,'功能测试','对{项目名称}进行功能测试','对{项目名称}进行全面的功能测试，包括：\n1. 功能点测试\n2. 边界条件测试\n3. 异常情况测试\n4. 性能测试\n\n测试要求：\n- 测试用例完整\n- 覆盖率达标\n- 缺陷跟踪','测试',1,0,'2025-09-02 15:12:50','2025-09-02 15:12:50');
/*!40000 ALTER TABLE `requirement_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirement_time_logs`
--

DROP TABLE IF EXISTS `requirement_time_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requirement_time_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requirement_id` int(11) NOT NULL COMMENT '需求ID',
  `user_name` varchar(100) NOT NULL COMMENT '记录者',
  `hours` decimal(8,2) NOT NULL COMMENT '工时',
  `description` text COMMENT '工时描述',
  `log_date` date NOT NULL COMMENT '工时日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_requirement_id` (`requirement_id`) USING BTREE,
  KEY `idx_user_name` (`user_name`) USING BTREE,
  KEY `idx_log_date` (`log_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement_time_logs`
--

LOCK TABLES `requirement_time_logs` WRITE;
/*!40000 ALTER TABLE `requirement_time_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirement_time_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `setting_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设置键名',
  `setting_value` text COLLATE utf8mb4_unicode_ci COMMENT '设置值',
  `setting_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'string' COMMENT '设置类型：string, int, bool, json',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设置描述',
  `group_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'basic' COMMENT '设置分组：basic, display, security, backup, system',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统设置：1是，0否',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `setting_key` (`setting_key`) USING BTREE,
  KEY `idx_group_name` (`group_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='系统设置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'site_name','解忧青年作品集','string','网站名称','basic',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(2,'site_description','一位热衷于创建视觉元素、主题制作和嵌入式开发的全栈工程师。','string','网站描述','basic',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(3,'site_keywords','作品集,前端开发,Vue,React,项目展示','string','网站关键词','basic',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(4,'subdescription','乔布斯于科技世界种下创新种子，罗永浩在行业浪潮里坚守情怀高地，都让我着迷。我仿佛看到老罗和乔布斯在科技和人文的十字路口探讨人生，所以我带着这份情怀，期待在这里与你相遇。','string','网站副描述','basic',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(5,'projects_per_page','9','int','每页显示项目数','display',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(6,'enable_comments','1','bool','启用评论功能','display',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(7,'enable_sharing','1','bool','启用分享功能','display',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(8,'login_lock','1','bool','登录失败锁定','security',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(9,'session_timeout','3600','int','会话超时时间（秒）','security',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(10,'max_login_attempts','5','int','最大登录尝试次数','security',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(11,'lockout_duration','1800','int','锁定持续时间（秒）','security',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(12,'auto_backup','1','bool','自动备份','backup',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(13,'backup_frequency','weekly','string','备份频率','backup',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(14,'backup_retention','30','int','备份保留天数','backup',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(15,'backup_path','/backups/','string','备份路径','backup',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(16,'system_version','1.0.0','string','系统版本','system',1,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(17,'maintenance_mode','0','bool','维护模式','system',0,'2025-09-01 14:10:30','2025-09-01 14:10:30'),(18,'debug_mode','0','bool','调试模式','system',0,'2025-09-01 14:10:30','2025-09-01 14:10:30');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='标签表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'Vue3','2025-08-17 17:48:10'),(2,'Web开发','2025-08-17 17:48:10'),(3,'响应式','2025-08-17 17:48:10'),(4,'数据分析','2025-08-17 17:48:10'),(5,'大数据','2025-08-17 17:48:10'),(6,'可视化','2025-08-17 17:48:10'),(7,'React','2025-08-17 17:48:10'),(8,'Node.js','2025-08-17 17:48:10'),(9,'Python','2025-08-17 17:48:10'),(10,'PHP','2025-08-17 17:48:10');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technology`
--

DROP TABLE IF EXISTS `technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `technology` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '技术名称',
  `img` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='技术栈表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technology`
--

LOCK TABLES `technology` WRITE;
/*!40000 ALTER TABLE `technology` DISABLE KEYS */;
INSERT INTO `technology` VALUES (1,'HTML','/static/images/exp/html.png',1,1,'2025-09-01 19:07:53',NULL),(2,'PHP','/static/images/exp/php.png',1,1,'2025-09-01 19:08:13',NULL),(3,'VUE','/static/images/exp/vue.png',1,1,'2025-09-01 19:08:26',NULL),(4,'Java','/static/images/exp/java.png',1,1,'2025-09-01 19:08:41',NULL),(5,'Python','/static/images/exp/python.png',1,1,'2025-09-01 19:08:57',NULL),(6,'ThinkPHP','/static/images/exp/thinkphp.png',1,1,'2025-09-01 19:09:15',NULL),(7,'Laravel','/static/images/exp/laravel.png',1,1,'2025-09-01 19:09:26',NULL),(8,'BootStrap','/static/images/exp/bootstrap.png',1,1,'2025-09-01 19:09:38',NULL),(9,'Webpack','/static/images/exp/webpack.png',1,1,'2025-09-01 19:09:51',NULL),(10,'Vite','/static/images/exp/vite.png',1,1,'2025-09-01 19:10:03',NULL),(11,'FastAdmin','/static/images/exp/fastadmin.png',1,1,'2025-09-01 19:10:16',NULL),(12,'Uniapp','/static/images/exp/uniapp.png',1,1,'2025-09-01 19:10:30',NULL),(13,'Flutter','/static/images/exp/flutter.png',1,1,'2025-09-01 19:10:41',NULL),(14,'PyCharm','/static/images/exp/pycharm.png',1,1,'2025-09-01 19:10:52',NULL),(15,'PS','/static/images/exp/ps.png',1,1,'2025-09-01 19:11:05',NULL),(16,'PR','/static/images/exp/pr.png',1,1,'2025-09-01 19:11:18',NULL),(17,'AI','/static/images/exp/ai.png',1,1,'2025-09-01 19:11:28',NULL),(18,'C4D','/static/images/exp/c4d.png',1,1,'2025-09-01 19:11:42',NULL),(19,'Figma','/static/images/exp/figma.png',1,1,'2025-09-01 19:11:55',NULL),(20,'Sketch','/static/images/exp/sketch.png',1,1,'2025-09-01 19:12:06',NULL),(21,'FastAPI','/static/images/exp/fastapi.png',1,1,'2025-09-01 19:12:17',NULL);
/*!40000 ALTER TABLE `technology` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `openid` varchar(64) DEFAULT NULL COMMENT '微信openid',
  `user_key` varchar(64) DEFAULT NULL COMMENT '用户唯一标识',
  `nickname` varchar(100) NOT NULL COMMENT '用户昵称',
  `code_age` int(11) NOT NULL COMMENT '码龄',
  `avatar` varchar(500) DEFAULT NULL COMMENT '头像URL',
  `cover` varchar(500) DEFAULT NULL COMMENT '封面图URL',
  `gender` tinyint(1) DEFAULT '0' COMMENT '性别：0未知，1男，2女',
  `address` varchar(200) DEFAULT NULL COMMENT '地址',
  `language` varchar(20) DEFAULT 'zh_CN' COMMENT '语言',
  `visit_count` int(11) DEFAULT '0' COMMENT '访问次数',
  `like_count` int(11) DEFAULT '0' COMMENT '点赞次数',
  `token` varchar(255) DEFAULT NULL COMMENT 'JWT token',
  `token_expire_time` datetime DEFAULT NULL COMMENT 'token过期时间',
  `is_engineer` tinyint(1) DEFAULT '0' COMMENT '是否工程师',
  `user_type` enum('visitor','customer','webmaster') DEFAULT 'visitor' COMMENT '用户类型：visitor访客,customer客户,webmaster站长',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  `wechat` varchar(50) DEFAULT NULL COMMENT '微信号',
  `github` varchar(255) DEFAULT NULL COMMENT 'GitHub地址',
  `weibo` varchar(255) DEFAULT NULL COMMENT '微博地址',
  `douyin` varchar(255) DEFAULT NULL COMMENT '抖音号',
  `web_url` varchar(255) DEFAULT NULL COMMENT '个人网站',
  `working_hours` json DEFAULT NULL COMMENT '工作时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_key` (`user_key`) USING BTREE,
  UNIQUE KEY `uk_openid` (`openid`) USING BTREE,
  KEY `idx_nickname` (`nickname`) USING BTREE,
  KEY `idx_user_type` (`user_type`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='统一用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'ocAWa4jVUL8Lp9eiqkRbMjYkjq28','e2d2eb129b794b0a45b39881aa8161e3','Sam',9,'/static/images/avatar/avatar_6a0c19fb10da5.jpg','/static/images/cover/cover_6a0c1a18a9001.jpg',0,'河南省郑州市','zh_CN',0,0,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3ODM0MTQ1MDgsImV4cCI6MTc4NDAxOTMwOCwibmJmIjoxNzgzNDE0NTA4LCJ1c2VyX2lkIjoxLCJ0eXBlIjoidXNlciJ9.otluB5Y66TFxFcgiNlWGdR_6UMcRSBEPIDA8Y_j58vo','2026-07-14 16:55:08',0,'webmaster',1,'cto@cvun.net','15993113751','21312314','cto-sam','https://github.com/Juveniles-Full-Stack-Developer',NULL,'47305446676','','[{\"day\": \"工作日\", \"time\": \"09:00 - 18:00\"}, {\"day\": \"周六\", \"time\": \"10:00 - 16:00\"}, {\"day\": \"周日\", \"time\": \"休息\"}]','2026-07-07 16:55:08','127.0.0.1','2025-09-02 03:34:25','2026-07-07 16:55:08');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit_log`
--

DROP TABLE IF EXISTS `visit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `visit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `page` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问页面',
  `referer` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '来源页面',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `device_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'desktop' COMMENT '设备类型：desktop,mobile,tablet',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ip` (`ip`) USING BTREE,
  KEY `idx_page` (`page`) USING BTREE,
  KEY `idx_device` (`device_type`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=425 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='访问日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_log`
--

LOCK TABLES `visit_log` WRITE;
/*!40000 ALTER TABLE `visit_log` DISABLE KEYS */;
INSERT INTO `visit_log` VALUES (275,'39.163.100.107','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/13','mobile','2026-01-05 15:27:39'),(276,'39.163.100.107','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/14','mobile','2026-01-05 15:32:57'),(277,'39.163.100.107','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.67(0x1800432b) NetType/WIFI Language/zh_CN','mobile','2026-01-05 15:46:52'),(278,'39.163.100.107','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/27','mobile','2026-01-05 15:52:16'),(279,'101.34.86.201','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-01-05 15:56:42'),(280,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/37','mobile','2026-05-19 15:18:51'),(281,'39.163.100.17','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/37','mobile','2026-05-19 15:23:05'),(282,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/38','mobile','2026-05-19 15:24:14'),(283,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/41','mobile','2026-05-19 15:30:41'),(284,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/48','mobile','2026-05-19 16:00:38'),(285,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/49','mobile','2026-05-19 16:05:57'),(286,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/53','mobile','2026-05-19 16:12:26'),(287,'39.163.100.17','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/55','mobile','2026-05-19 16:14:28'),(288,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56','mobile','2026-05-19 16:21:31'),(289,'39.163.100.17','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56','mobile','2026-05-19 16:21:34'),(290,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/61','mobile','2026-05-19 16:28:04'),(291,'39.163.100.17','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/61','mobile','2026-05-19 16:28:17'),(292,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1','mobile','2026-05-19 16:36:13'),(293,'39.163.100.17','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1','mobile','2026-05-19 16:36:19'),(294,'39.163.100.17','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-05-19 16:42:51'),(295,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-05-19 16:55:01'),(296,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-05-19 17:00:56'),(297,'39.163.100.17','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1','mobile','2026-05-19 17:02:36'),(298,'39.163.100.17','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-05-19 17:13:13'),(299,'39.144.24.239','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x1800492a) NetType/4G Language/zh_CN','mobile','2026-05-20 18:52:51'),(300,'39.144.24.239','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x1800492a) NetType/4G Language/zh_CN','mobile','2026-05-20 21:29:18'),(301,'125.45.110.184','/pages/index/index','','Mozilla/5.0 (Linux; Android 16; PKM110 Build/BP2A.250605.015; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.177 Mobile Safari/537.36 XWEB/1460075 MMWEBSDK/20260202 MMWEBID/4073 MicroMessenger/8.0.71.3080(0x28004750) WeChat/arm64 Weixin NetType/4G Language/zh_CN ABI/arm64 MiniProgramEnv/android','mobile','2026-05-20 21:33:56'),(302,'39.144.22.46','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN','mobile','2026-06-01 20:25:33'),(303,'39.144.22.46','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN','mobile','2026-06-01 22:18:36'),(304,'39.144.22.46','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN','mobile','2026-06-02 10:30:22'),(305,'39.163.100.209','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN','mobile','2026-06-03 13:01:26'),(306,'39.163.100.209','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN','mobile','2026-06-03 13:02:22'),(307,'101.34.86.201','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-03 13:03:30'),(308,'124.220.124.244','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-03 13:03:39'),(309,'101.34.86.201','/pages/contact/contact','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-03 13:04:18'),(310,'124.220.124.244','/pages/contact/contact','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-03 13:04:30'),(311,'106.55.202.118','/pages/index/index','','Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6a1fb62e815955e3e2cb62e598e2) f6a6','desktop','2026-06-03 13:06:54'),(312,'39.163.100.209','/pages/index/index','https://weixin110.qq.com/','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN','mobile','2026-06-03 13:07:55'),(313,'43.139.209.119','/pages/index/index','','Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6a1fb62e815955e3e2cb62e598e2) 19ab','desktop','2026-06-03 13:13:14'),(314,'124.221.213.176','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-03 13:23:41'),(315,'124.221.213.176','/pages/contact/contact','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-03 13:24:32'),(316,'39.163.100.209','/pages/index/index','http://1.13.163.77:12138/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-03 14:25:06'),(317,'114.132.52.44','/pages/index/index','','Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Mobile Safari/537.36 MicroMessenger/7.0.1','mobile','2026-06-03 18:33:58'),(318,'119.84.150.102','/pages/index/index','','Mozilla/5.0 (Linux; Android 12; AOSP on Pixel Build/SQ1D.220205.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20251202 MMWEBID/3954 MicroMessenger/8.0.72.3020(0x28004835) WeChat/arm64 Weixin NetType/02:42:ac:11:00:13 Language/zh_CN ABI/arm64 MiniProgramEnv/android','mobile','2026-06-04 14:33:28'),(319,'39.163.111.15','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN','mobile','2026-06-04 15:31:36'),(320,'119.2.154.223','/pages/index/index','','Mozilla/5.0 (Linux; Android 16; SM-S9380 Build/BP4A.251205.006; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20260202 MMWEBID/5048 MicroMessenger/8.0.71.3080(0x28004750) WeChat/arm64 Weixin NetType/WIFI Language/en ABI/arm64 MiniProgramEnv/android','mobile','2026-06-04 15:37:00'),(321,'59.37.125.37','/pages/index/index','','Mozilla/5.0 (Linux; Android 16; MEIZU 20 Pro Build/BQ2A.251110.001-BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20260502 MMWEBID/1396 MicroMessenger/8.0.74.3100(0x28004A31) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android','mobile','2026-06-04 16:12:36'),(322,'39.144.22.106','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN','mobile','2026-06-05 12:11:40'),(323,'111.55.20.149','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN','mobile','2026-06-05 22:08:05'),(324,'223.104.105.10','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN','mobile','2026-06-07 18:45:29'),(325,'223.104.105.23','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN','mobile','2026-06-08 16:47:50'),(326,'39.163.100.235','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN','mobile','2026-06-09 11:15:12'),(327,'39.163.100.235','/pages/index/index','http://1.13.163.77:12138/','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','desktop','2026-06-09 12:08:29'),(328,'124.220.124.244','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-09 12:11:46'),(329,'124.220.124.159','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-09 12:11:55'),(330,'124.220.126.5','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-09 12:11:56'),(331,'124.220.124.244','/pages/contact/contact','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-09 12:12:34'),(332,'124.220.124.159','/pages/contact/contact','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-09 12:12:46'),(333,'124.220.126.5','/pages/contact/contact','','Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team','desktop','2026-06-09 12:12:47'),(334,'119.84.150.102','/pages/index/index','','Mozilla/5.0 (Linux; Android 12; AOSP on Pixel Build/SQ1D.220205.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460205 MMWEBSDK/20260101 MMWEBID/3126 MicroMessenger/8.0.72.3020(0x28004835) WeChat/arm64 Weixin NetType/02:42:ac:11:00:07 Language/zh_CN ABI/arm64 MiniProgramEnv/android','mobile','2026-06-09 16:12:07'),(335,'39.163.100.25','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN','mobile','2026-06-10 21:48:01'),(336,'39.163.100.154','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','desktop','2026-06-11 14:53:38'),(337,'120.244.186.216','/pages/index/index','','Mozilla/5.0 (Linux; Android 15; REA-AN00 Build/HONORREA-AN00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460205 MMWEBSDK/20260502 MMWEBID/5675 MicroMessenger/8.0.72.3100(0x28004853) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android','mobile','2026-06-12 21:43:11'),(338,'39.163.100.8','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','desktop','2026-06-13 12:03:57'),(339,'110.179.140.14','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','desktop','2026-06-13 13:04:06'),(340,'219.155.182.237','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN','mobile','2026-06-14 21:23:06'),(341,'39.163.100.88','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b27) NetType/WIFI Language/zh_TW','mobile','2026-06-20 21:41:30'),(342,'39.163.100.251','/pages/index/index','http://1.13.163.77:12138/','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','desktop','2026-06-22 22:20:06'),(343,'39.163.100.251','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 22:51:02'),(344,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 22:56:04'),(345,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 23:02:06'),(346,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 23:12:24'),(347,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 23:19:12'),(348,'39.163.100.251','/pages/contact/contact','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 23:21:44'),(349,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 23:25:44'),(350,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-22 23:47:41'),(351,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:00:55'),(352,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:08:11'),(353,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:14:08'),(354,'39.163.100.251','/pages/index/index','http://192.168.10.6:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:19:29'),(355,'39.163.100.251','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:22:57'),(356,'39.163.100.251','/pages/user/user','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:23:38'),(357,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:31:10'),(358,'39.163.100.251','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:35:29'),(359,'39.163.100.251','/pages/user/user','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:35:33'),(360,'39.163.100.251','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:41:58'),(361,'39.163.100.251','/pages/user/user','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:42:38'),(362,'39.163.100.251','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:47:06'),(363,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:50:51'),(364,'39.163.100.251','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:53:46'),(365,'39.163.100.251','/pages/user/user','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:57:26'),(366,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 00:57:36'),(367,'39.163.100.251','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1','mobile','2026-06-23 01:03:01'),(368,'39.163.100.251','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 01:04:08'),(369,'39.163.100.251','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 01:09:33'),(370,'39.163.100.251','/pages/user/user','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 01:09:36'),(371,'39.163.100.251','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 01:09:39'),(372,'39.163.100.251','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 01:15:30'),(373,'39.163.100.251','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 01:17:45'),(374,'39.163.100.251','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 01:17:48'),(375,'39.163.100.251','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 01:24:35'),(376,'39.163.100.251','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 01:27:32'),(377,'39.163.100.251','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 01:27:42'),(378,'39.163.100.251','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 01:34:42'),(379,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 11:57:16'),(380,'39.163.100.130','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 11:57:28'),(381,'39.163.100.130','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 11:57:41'),(382,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 12:03:44'),(383,'39.163.100.130','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 12:04:40'),(384,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','desktop','2026-06-23 14:44:17'),(385,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 22:55:24'),(386,'39.163.100.130','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 22:55:57'),(387,'39.163.100.130','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 22:56:00'),(388,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 23:00:28'),(389,'39.163.100.130','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1','mobile','2026-06-23 23:02:38'),(390,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 23:05:49'),(391,'39.163.100.130','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW','mobile','2026-06-23 23:06:14'),(392,'39.163.100.130','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:09:37'),(393,'39.163.100.130','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:16:45'),(394,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:27:22'),(395,'39.163.100.130','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:31:51'),(396,'39.163.100.130','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:32:50'),(397,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:32:57'),(398,'39.163.100.130','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:39:15'),(399,'39.163.100.130','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-06-23 23:40:27'),(400,'222.140.168.137','/pages/index/index','','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf2541b16) XWEB/20005','desktop','2026-06-27 11:09:31'),(401,'219.155.181.217','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2d) NetType/4G Language/zh_TW','mobile','2026-06-27 11:09:47'),(402,'223.104.105.96','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/4G Language/zh_TW','mobile','2026-06-30 18:56:54'),(403,'120.212.165.226','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN','mobile','2026-06-30 18:57:52'),(404,'1.196.155.72','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN','mobile','2026-06-30 22:51:10'),(405,'1.196.155.72','/pages/contact/contact','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN','mobile','2026-06-30 22:52:54'),(406,'39.163.100.150','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW','mobile','2026-06-30 22:57:27'),(407,'39.163.100.150','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW','mobile','2026-06-30 22:57:32'),(408,'39.163.100.150','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW','mobile','2026-06-30 22:57:35'),(409,'39.163.100.191','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1','mobile','2026-07-07 15:43:01'),(410,'39.163.100.191','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1','mobile','2026-07-07 15:43:17'),(411,'39.163.100.191','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-07-07 15:53:05'),(412,'39.163.100.191','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-07-07 16:05:12'),(413,'39.163.100.191','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-07-07 16:26:47'),(414,'39.163.100.191','/pages/message/message','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-07-07 16:45:15'),(415,'39.163.100.191','/pages/user/user','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-07-07 16:45:19'),(416,'39.163.100.191','/pages/index/index','http://localhost:5173/','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','mobile','2026-07-07 16:49:46'),(417,'39.163.100.191','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/5','mobile','2026-07-07 16:54:54'),(418,'39.163.100.191','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b35) NetType/WIFI Language/zh_TW','mobile','2026-07-07 16:59:57'),(419,'39.163.100.198','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b42) NetType/WIFI Language/zh_TW','mobile','2026-07-21 10:52:24'),(420,'39.163.100.86','/pages/index/index','http://43.137.17.63:12138/','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','desktop','2026-08-17 20:52:24'),(421,'39.163.100.156','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN','mobile','2026-09-09 23:44:31'),(422,'39.163.100.156','/pages/message/message','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN','mobile','2026-09-09 23:46:31'),(423,'39.163.100.156','/pages/user/user','','Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN','mobile','2026-09-09 23:46:33'),(424,'39.163.100.156','/pages/index/index','','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1','mobile','2026-09-10 00:08:27');
/*!40000 ALTER TABLE `visit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'sundongliang'
--

--
-- Dumping routines for database 'sundongliang'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-18 23:36:27
