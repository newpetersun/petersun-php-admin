-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2026-10-02 15:41:55
-- 服务器版本： 5.7.44-log
-- PHP 版本： 8.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `sundongliang`
--

-- --------------------------------------------------------

--
-- 表的结构 `admin_logs`
--

CREATE TABLE `admin_logs` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员日志表';

-- --------------------------------------------------------

--
-- 表的结构 `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '主题',
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '是否已读:1已读,0未读',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='留言表';

-- --------------------------------------------------------

--
-- 表的结构 `forum_boards`
--

CREATE TABLE `forum_boards` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `board_key` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '板块标识(原 key, 避免保留字)',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '板块名称',
  `icon_text` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图标文字',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '板块简介',
  `color_fg` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '主题色-前景',
  `color_bg` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '主题色-背景',
  `cover_image` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '封面图',
  `announcement` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '板块公告',
  `member_count` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '成员数',
  `post_count` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '帖子数',
  `sort_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1正常,0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛板块';

--
-- 转存表中的数据 `forum_boards`
--

INSERT INTO `forum_boards` (`id`, `board_key`, `name`, `icon_text`, `description`, `color_fg`, `color_bg`, `cover_image`, `announcement`, `member_count`, `post_count`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
('fde45e09-bc99-11f1-b410-525400fdb9eb', 'java', 'Java', 'Java', 'Java 语言与生态：并发、JVM、Spring Boot 实战', '#c2410c', '#ffedd5', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/java-banner.png', '欢迎来到 Java 板块，发帖请遵守社区规范，禁止广告与引战。', 12860, 13, 1, 1, '2026-09-28 23:08:40', '2026-10-01 21:16:55'),
('fde45ff4-bc99-11f1-b410-525400fdb9eb', 'python', 'Python', 'Py', 'Python 数据分析与工程：Pandas、异步、机器学习', '#1d4ed8', '#dbeafe', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/python-banner.png', 'Python 板块定期分享优质学习资源，欢迎投稿。', 9340, 5, 2, 1, '2026-09-28 23:08:40', '2026-09-30 14:41:40'),
('fde46064-bc99-11f1-b410-525400fdb9eb', 'frontend', '前端', '前', '前端工程与框架生态：React、Vue、性能优化、工程化', '#047857', '#d1fae5', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/frontend-banner.png', '前端板块聚焦工程化与性能，欢迎讨论新技术。', 15230, 5, 3, 1, '2026-09-28 23:08:40', '2026-09-30 14:41:40'),
('fde460b7-bc99-11f1-b410-525400fdb9eb', 'database', '数据库', '数', '数据库技术与存储：MySQL、Redis、索引优化与分库分表', '#7e22ce', '#f3e8ff', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/database-banner.png', '数据库板块分享性能优化与架构实战经验。', 7480, 5, 4, 1, '2026-09-28 23:08:40', '2026-09-30 14:41:40'),
('fde46100-bc99-11f1-b410-525400fdb9eb', 'ai', 'AI', 'AI', 'AI 与大模型应用：LLM 原理、RAG 检索增强、Agent 开发', '#be185d', '#fce7f3', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/ai-banner.png', 'AI 板块探讨大模型落地实践，禁止搬运未授权内容。', 18920, 5, 5, 1, '2026-09-28 23:08:40', '2026-09-30 14:41:40'),
('fde46144-bc99-11f1-b410-525400fdb9eb', 'cloud', '云计算', '云', '云原生与 DevOps：Kubernetes、Docker、微服务架构', '#0e7490', '#cffafe', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/cloud-banner.png', '云原生板块交流 K8s 与微服务落地经验。', 8350, 4, 6, 1, '2026-09-28 23:08:40', '2026-09-30 14:41:40');

-- --------------------------------------------------------

--
-- 表的结构 `forum_board_members`
--

CREATE TABLE `forum_board_members` (
  `board_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '板块ID -> forum_boards',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='板块成员';

-- --------------------------------------------------------

--
-- 表的结构 `forum_board_moderators`
--

CREATE TABLE `forum_board_moderators` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `board_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '板块ID -> forum_boards',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `role` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '版主' COMMENT '角色:版主/副版主',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='板块版主';

--
-- 转存表中的数据 `forum_board_moderators`
--

INSERT INTO `forum_board_moderators` (`id`, `board_id`, `user_id`, `role`, `create_time`) VALUES
('fde4d550-bc99-11f1-b410-525400fdb9eb', 'fde45e09-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40'),
('fde4d682-bc99-11f1-b410-525400fdb9eb', 'fde45ff4-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40'),
('fde4d6c9-bc99-11f1-b410-525400fdb9eb', 'fde46064-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40'),
('fde4d6fb-bc99-11f1-b410-525400fdb9eb', 'fde460b7-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40'),
('fde4d727-bc99-11f1-b410-525400fdb9eb', 'fde46100-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40'),
('fde4d752-bc99-11f1-b410-525400fdb9eb', 'fde46144-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40');

-- --------------------------------------------------------

--
-- 表的结构 `forum_posts`
--

CREATE TABLE `forum_posts` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID(UUID)',
  `board_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属板块 -> forum_boards',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者 -> users',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标题',
  `summary` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '摘要',
  `content` longtext COLLATE utf8mb4_unicode_ci COMMENT '正文',
  `category` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分类标识(同板块 board_key)',
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标签, 逗号分隔',
  `cover_images` text COLLATE utf8mb4_unicode_ci COMMENT '封面图 JSON 数组',
  `views` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '浏览量',
  `comment_count` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '评论数',
  `like_count` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '点赞数',
  `is_essence` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否精华',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否置顶',
  `is_paid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否付费资源:1是,0否',
  `coin_price` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '付费金币价格(0表示免费)',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1正常,0隐藏',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛帖子';

--
-- 转存表中的数据 `forum_posts`
--

INSERT INTO `forum_posts` (`id`, `board_id`, `user_id`, `title`, `summary`, `content`, `category`, `tags`, `cover_images`, `views`, `comment_count`, `like_count`, `is_essence`, `is_pinned`, `is_paid`, `coin_price`, `status`, `create_time`, `update_time`) VALUES
('16e3acee-4fc4-43f9-9d51-4538209526e5', 'fde45e09-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'Java入门简介', 'Java 入门简介 1. 什么是 Java Java 是一门**跨平台、面向对象、强类型**的高级编程语言，由 Sun 公司（现 Oracle）推出，核心口号：**一次编写，到处运行（Write Once, Run Anywhere）**。', '# Java 入门简介\n\n## 1. 什么是 Java\n\nJava 是一门**跨平台、面向对象、强类型**的高级编程语言，由 Sun 公司（现 Oracle）推出，核心口号：**一次编写，到处运行（Write Once, Run Anywhere）**。\n\n依靠 JVM（Java 虚拟机），同一套 Java 代码可以在 Windows、Linux、MacOS 等不同操作系统上运行。\n\nJava 三大版本：\n\n- **Java SE**：标准版，基础核心，桌面程序、控制台开发，学习入门必学。\n\n- **Java EE**：企业版，Web后端、服务端开发（SpringBoot 基于此）。\n\n- **Java ME**：微型版，嵌入式、移动端老旧设备，现在基本淘汰。\n\n## 2. Java 核心特点\n\n1. **跨平台**：源码编译成字节码 `.class`，由 JVM 解释执行，不直接和操作系统绑定。\n\n2. **面向对象**：封装、继承、多态，一切皆对象思想。\n\n3. **强类型语言**：变量必须声明数据类型，编译期做类型检查。\n\n4. **垃圾回收 GC**：自动管理内存，不用手动释放对象内存。\n\n5. **安全性高**：字节码校验机制，适合服务端后台开发。\n\n6. **生态庞大**：Spring 全家桶、Maven/Gradle 依赖库，企业市场占有率极高。\n\n## 3. 环境介绍 JDK / JRE / JVM\n\n- **JVM**：Java 虚拟机，执行字节码 `.class`，实现跨平台。\n\n- **JRE**：Java 运行环境，包含 JVM + 运行类库，**只运行程序用 JRE**。\n\n- **JDK**：Java 开发工具包，包含 JRE + 编译器(javac)、调试工具，**写代码必须装 JDK**。\n\n> 关系：`JDK ⊃ JRE ⊃ JVM`\n\n常用 LTS 长期支持版本：JDK8、JDK17（企业主流）\n\n## 4. 第一个 Java 程序 HelloWorld\n\n```\npublic class HelloWorld {\n    public static void main(String[] args) {\n        System.out.println(\"Hello Java\");\n    }\n}\n```', 'java', '', '', 37, 0, 1, 0, 0, 1, 1, 1, '2026-10-01 21:16:55', '2026-10-02 15:37:23');

-- --------------------------------------------------------

--
-- 表的结构 `forum_post_comments`
--

CREATE TABLE `forum_post_comments` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论者 -> users',
  `parent_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '回复的评论ID -> forum_post_comments (自引用)',
  `content` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '评论内容',
  `like_count` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '点赞数',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1正常,0删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子评论';

-- --------------------------------------------------------

--
-- 表的结构 `forum_post_likes`
--

CREATE TABLE `forum_post_likes` (
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子点赞';

--
-- 转存表中的数据 `forum_post_likes`
--

INSERT INTO `forum_post_likes` (`post_id`, `user_id`, `create_time`) VALUES
('16e3acee-4fc4-43f9-9d51-4538209526e5', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '2026-10-01 22:23:55');

-- --------------------------------------------------------

--
-- 表的结构 `user_wallet`
--

CREATE TABLE `user_wallet` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users(id)，一对一',
  `balance` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '金币余额',
  `frozen` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '冻结金币(待结算/冻结中)',
  `total_earned` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '累计获得金币',
  `total_spent` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '累计消费金币',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户钱包(金币)';

-- --------------------------------------------------------

--
-- 表的结构 `forum_post_purchases`
--

CREATE TABLE `forum_post_purchases` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts(id)',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '购买用户 -> users(id)',
  `coins` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '本次支付的金币数(=帖子 coin_price)',
  `settle_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '结算状态:0未结算,1已结算,2已退款',
  `settle_amount` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '结算给作者的金币(扣除平台佣金后)',
  `settle_time` datetime DEFAULT NULL COMMENT '结算时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '购买时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛付费帖子购买记录(金币)';

-- --------------------------------------------------------

--
-- 表的结构 `forum_reports`
--

CREATE TABLE `forum_reports` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '被举报帖子 -> forum_posts(id)',
  `reporter_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '举报人 -> users(id)',
  `reason` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '举报原因(垃圾广告/色情低俗/诈骗虚假/侵权抄袭/违法违规/其他)',
  `desc` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '补充说明',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '处理状态:0待处理,1已处理,2已驳回',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '举报时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛帖子举报记录';

-- --------------------------------------------------------

-- --------------------------------------------------------

--
-- 表的结构 `admin_scan_tickets`
--

CREATE TABLE `admin_scan_tickets` (
  `id`          int(11)    NOT NULL AUTO_INCREMENT,
  `ticket`      varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '随机票据',
  `user_id`     char(36)   COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '确认后绑定的 webmaster 用户',
  `status`      tinyint(1) NOT NULL DEFAULT '0' COMMENT '0待扫,1已确认,2已取消,3已使用',
  `expire_time` datetime  NOT NULL COMMENT '过期时间',
  `create_time` datetime  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ticket` (`ticket`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台扫码登录票据';

-- --------------------------------------------------------

--
-- 表的结构 `projects`
--

CREATE TABLE `projects` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目标题',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `full_description` text COLLATE utf8mb4_unicode_ci COMMENT '完整描述',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '项目图片',
  `category_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类ID -> project_categories',
  `client_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '客户ID -> users (可空)',
  `features` text COLLATE utf8mb4_unicode_ci COMMENT '功能特性, 逗号分隔',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `is_featured` tinyint(1) DEFAULT '0' COMMENT '是否推荐:1是,0否',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态:1发布,0草稿',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目表';

--
-- 转存表中的数据 `projects`
--

INSERT INTO `projects` (`id`, `title`, `description`, `full_description`, `image`, `category_id`, `client_id`, `features`, `sort_order`, `is_featured`, `status`, `create_time`, `update_time`) VALUES
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'LikeSee短视频管理系统', '现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越', '现代化UI设计，符合2025年审美，基于Vue 3 + Vite，性能卓越', '/static/images/projects/likesee-vue-admin/login.jpg', 'fde6476b-bc99-11f1-b410-525400fdb9eb', NULL, '', 1, 1, 1, '2025-08-17 17:48:10', '2026-09-30 14:41:40'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', '数据可视化大屏', '大数据驱动的短视频业务分析系统，提供实时数据监控和可视化', '基于大数据技术构建的业务分析系统，实时收集和处理短视频平台的海量数据，通过直观的图表和仪表盘展示关键业务指标，帮助运营团队快速了解业务状况并做出决策。', 'https://www.sundongliang.cn/static/images/projects/data-visualization/index.jpg', 'fde64989-bc99-11f1-b410-525400fdb9eb', NULL, '实时数据监控,多维度分析,自定义图表,数据导出功能,告警系统,历史数据查询', 2, 1, 1, '2025-08-17 17:48:10', '2026-09-30 14:41:40');

-- --------------------------------------------------------

--
-- 表的结构 `project_categories`
--

CREATE TABLE `project_categories` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `board_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类标识(原 key, 避免保留字)',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分类描述',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态:1启用,0禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目分类表';

--
-- 转存表中的数据 `project_categories`
--

INSERT INTO `project_categories` (`id`, `name`, `board_key`, `description`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
('fde6476b-bc99-11f1-b410-525400fdb9eb', 'Web开发', 'web', '', 1, 1, '2025-08-17 17:48:09', '2026-09-30 14:41:40'),
('fde648ed-bc99-11f1-b410-525400fdb9eb', '移动开发', 'mobile', '', 2, 1, '2025-08-17 17:48:09', '2026-09-30 14:41:40'),
('fde6494b-bc99-11f1-b410-525400fdb9eb', 'UI设计', 'design', '', 3, 1, '2025-08-17 17:48:09', '2026-09-30 14:41:40'),
('fde64989-bc99-11f1-b410-525400fdb9eb', '数据分析', 'data', '', 4, 1, '2025-08-17 17:48:09', '2026-09-30 14:41:40');

-- --------------------------------------------------------

--
-- 表的结构 `project_images`
--

CREATE TABLE `project_images` (
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `project_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目图片表' ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `project_images`
--

INSERT INTO `project_images` (`image_url`, `sort_order`, `create_time`, `id`, `project_id`) VALUES
('/static/images/projects/likesee-vue-admin/login.jpg', 0, '2025-09-01 21:32:45', 'fde6b177-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb'),
('/static/images/projects/project_68a9e7dde5031.jpg', 1, '2025-09-01 21:32:46', 'fde6b2c0-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb'),
('/static/images/projects/project_68a9e7ee77c10.jpg', 2, '2025-09-01 21:32:46', 'fde6b305-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb');

-- --------------------------------------------------------

--
-- 表的结构 `project_tags`
--

CREATE TABLE `project_tags` (
  `project_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目ID -> projects',
  `tag_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签ID -> tags'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目标签关联表';

--
-- 转存表中的数据 `project_tags`
--

INSERT INTO `project_tags` (`project_id`, `tag_id`) VALUES
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fde95e3d-bc99-11f1-b410-525400fdb9eb'),
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fde95f82-bc99-11f1-b410-525400fdb9eb'),
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fde95fc5-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fde95ff4-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fde96021-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fde9604a-bc99-11f1-b410-525400fdb9eb');

-- --------------------------------------------------------

--
-- 表的结构 `project_technologies`
--

CREATE TABLE `project_technologies` (
  `project_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目ID -> projects',
  `technology_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '技术栈ID -> technologies'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目技术栈关联表';

--
-- 转存表中的数据 `project_technologies`
--

INSERT INTO `project_technologies` (`project_id`, `technology_id`) VALUES
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fdea287f-bc99-11f1-b410-525400fdb9eb'),
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fdea2a46-bc99-11f1-b410-525400fdb9eb'),
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fdea2a9a-bc99-11f1-b410-525400fdb9eb'),
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fdea2ad2-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fdea2ad2-bc99-11f1-b410-525400fdb9eb'),
('fde5d7b6-bc99-11f1-b410-525400fdb9eb', 'fdea2b07-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fdea2b38-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fdea2b69-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fdea2b98-bc99-11f1-b410-525400fdb9eb'),
('fde5d9b7-bc99-11f1-b410-525400fdb9eb', 'fdea2bcc-bc99-11f1-b410-525400fdb9eb');

-- --------------------------------------------------------

--
-- 表的结构 `requirements`
--

CREATE TABLE `requirements` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `project_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目ID -> projects',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '需求标题',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '需求描述',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'pending' COMMENT '需求状态',
  `priority` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'medium' COMMENT '优先级',
  `estimated_hours` decimal(8,2) DEFAULT NULL COMMENT '预估工时',
  `actual_hours` decimal(8,2) DEFAULT NULL COMMENT '实际工时',
  `assignee_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '负责人ID -> users',
  `template_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '需求模板ID -> requirement_templates',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目需求表';

--
-- 转存表中的数据 `requirements`
--

INSERT INTO `requirements` (`id`, `project_id`, `title`, `description`, `status`, `priority`, `estimated_hours`, `actual_hours`, `assignee_id`, `template_id`, `create_time`, `update_time`) VALUES
('fde7187f-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'high', 16.00, 18.50, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde877d7-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71a94-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '响应式布局实现', '实现网站的响应式布局，确保在不同设备上都能正常显示', 'completed', 'high', 12.00, 10.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87ad6-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71b01-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '项目展示功能', '实现项目列表展示、详情查看、分类筛选等功能', 'progress', 'medium', 8.00, 5.50, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87ad6-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71b55-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '后台管理系统', '开发后台管理系统，支持内容管理、用户管理等功能', 'pending', 'medium', 20.00, 0.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87a90-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71b9d-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '数据统计功能', '实现访问统计、用户行为分析等数据统计功能', 'pending', 'low', 6.00, 0.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87a90-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71bdc-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '商品管理模块', '开发商品增删改查、分类管理、库存管理等功能', 'completed', 'high', 24.00, 26.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87a90-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71c18-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '订单处理系统', '实现订单创建、支付、发货、退款等完整流程', 'progress', 'high', 32.00, 15.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87a90-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71c5b-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '用户权限管理', '实现用户角色管理、权限控制等功能', 'pending', 'medium', 16.00, 0.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87a90-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71c9d-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '用户注册登录', '实现用户注册、登录、密码找回等功能', 'completed', 'high', 12.00, 14.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87a90-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71cdb-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '内容展示功能', '实现内容浏览、搜索、分类等功能', 'progress', 'medium', 16.00, 8.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87ad6-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71d18-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '消息推送系统', '集成消息推送服务，支持实时通知', 'pending', 'low', 8.00, 0.00, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'fde87a90-bc99-11f1-b410-525400fdb9eb', '2025-09-02 15:29:45', '2026-09-30 14:41:40'),
('fde71d5b-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', NULL, '2025-09-02 16:21:53', '2026-09-30 14:41:40'),
('fde71da0-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', NULL, '2025-09-02 16:31:33', '2026-09-30 14:41:40'),
('fde71de1-bc99-11f1-b410-525400fdb9eb', 'fde5d7b6-bc99-11f1-b410-525400fdb9eb', '用户界面设计', '设计个人作品集网站的用户界面，包括首页、项目展示页、联系页面等', 'completed', 'medium', NULL, NULL, 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', NULL, '2025-09-02 16:44:04', '2026-09-30 14:41:40');

-- --------------------------------------------------------

--
-- 表的结构 `requirement_attachments`
--

CREATE TABLE `requirement_attachments` (
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名',
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint(20) DEFAULT NULL COMMENT '文件大小',
  `file_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
  `uploader` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上传者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requirement_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `requirement_comments`
--

CREATE TABLE `requirement_comments` (
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容',
  `author` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论者',
  `author_avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '评论者头像',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统评论',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requirement_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `requirement_templates`
--

CREATE TABLE `requirement_templates` (
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `title_template` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题模板',
  `description_template` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '描述模板',
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '模板分类',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统模板',
  `usage_count` int(11) DEFAULT '0' COMMENT '使用次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `requirement_templates`
--

INSERT INTO `requirement_templates` (`name`, `title_template`, `description_template`, `category`, `is_system`, `usage_count`, `create_time`, `update_time`, `id`) VALUES
('用户界面设计', '设计{项目名称}的用户界面', '设计{项目名称}的用户界面，包括以下页面：\n1. 首页设计\n2. 主要功能页面\n3. 用户交互流程\n4. 响应式适配\n\n设计要求：\n- 符合现代设计趋势\n- 用户体验友好\n- 品牌风格统一', 'UI设计', 1, 0, '2025-09-02 15:12:50', '2026-09-30 14:41:40', 'fde877d7-bc99-11f1-b410-525400fdb9eb'),
('数据库设计', '设计{项目名称}的数据库结构', '设计{项目名称}的数据库结构，包括：\n1. 核心数据表设计\n2. 表关系设计\n3. 索引优化\n4. 数据安全考虑\n\n技术要求：\n- 符合第三范式\n- 性能优化\n- 数据完整性', '后端开发', 1, 0, '2025-09-02 15:12:50', '2026-09-30 14:41:40', 'fde879c7-bc99-11f1-b410-525400fdb9eb'),
('API接口开发', '开发{项目名称}的API接口', '开发{项目名称}的API接口，包括：\n1. RESTful API设计\n2. 接口文档编写\n3. 错误处理机制\n4. 接口测试\n\n技术要求：\n- 遵循REST规范\n- 统一响应格式\n- 完善的错误处理', '后端开发', 1, 0, '2025-09-02 15:12:50', '2026-09-30 14:41:40', 'fde87a90-bc99-11f1-b410-525400fdb9eb'),
('前端页面开发', '开发{项目名称}的前端页面', '开发{项目名称}的前端页面，包括：\n1. 页面结构搭建\n2. 样式设计实现\n3. 交互功能开发\n4. 浏览器兼容性\n\n技术要求：\n- 响应式设计\n- 性能优化\n- 代码规范', '前端开发', 1, 0, '2025-09-02 15:12:50', '2026-09-30 14:41:40', 'fde87ad6-bc99-11f1-b410-525400fdb9eb'),
('功能测试', '对{项目名称}进行功能测试', '对{项目名称}进行全面的功能测试，包括：\n1. 功能点测试\n2. 边界条件测试\n3. 异常情况测试\n4. 性能测试\n\n测试要求：\n- 测试用例完整\n- 覆盖率达标\n- 缺陷跟踪', '测试', 1, 0, '2025-09-02 15:12:50', '2026-09-30 14:41:40', 'fde87b1b-bc99-11f1-b410-525400fdb9eb');

-- --------------------------------------------------------

--
-- 表的结构 `requirement_time_logs`
--

CREATE TABLE `requirement_time_logs` (
  `user_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '记录者',
  `hours` decimal(8,2) NOT NULL COMMENT '工时',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '工时描述',
  `log_date` date NOT NULL COMMENT '工时日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requirement_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- 表的结构 `system_settings`
--

CREATE TABLE `system_settings` (
  `setting_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设置键名',
  `setting_value` text COLLATE utf8mb4_unicode_ci COMMENT '设置值',
  `setting_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'string' COMMENT '设置类型：string, int, bool, json',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设置描述',
  `group_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'basic' COMMENT '设置分组：basic, display, security, backup, system',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否系统设置：1是，0否',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统设置表' ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `system_settings`
--

INSERT INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`, `group_name`, `is_system`, `create_time`, `update_time`, `id`) VALUES
('site_name', '解忧青年作品集', 'string', '网站名称', 'basic', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8ecac-bc99-11f1-b410-525400fdb9eb'),
('site_description', '一位热衷于创建视觉元素、主题制作和嵌入式开发的全栈工程师。', 'string', '网站描述', 'basic', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8ee3d-bc99-11f1-b410-525400fdb9eb'),
('site_keywords', '作品集,前端开发,Vue,React,项目展示', 'string', '网站关键词', 'basic', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8eea2-bc99-11f1-b410-525400fdb9eb'),
('subdescription', '乔布斯于科技世界种下创新种子，罗永浩在行业浪潮里坚守情怀高地，都让我着迷。我仿佛看到老罗和乔布斯在科技和人文的十字路口探讨人生，所以我带着这份情怀，期待在这里与你相遇。', 'string', '网站副描述', 'basic', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8eeed-bc99-11f1-b410-525400fdb9eb'),
('projects_per_page', '9', 'int', '每页显示项目数', 'display', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8ef37-bc99-11f1-b410-525400fdb9eb'),
('enable_comments', '1', 'bool', '启用评论功能', 'display', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8ef7b-bc99-11f1-b410-525400fdb9eb'),
('enable_sharing', '1', 'bool', '启用分享功能', 'display', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8efb6-bc99-11f1-b410-525400fdb9eb'),
('login_lock', '1', 'bool', '登录失败锁定', 'security', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8efee-bc99-11f1-b410-525400fdb9eb'),
('session_timeout', '3600', 'int', '会话超时时间（秒）', 'security', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f035-bc99-11f1-b410-525400fdb9eb'),
('max_login_attempts', '5', 'int', '最大登录尝试次数', 'security', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f073-bc99-11f1-b410-525400fdb9eb'),
('lockout_duration', '1800', 'int', '锁定持续时间（秒）', 'security', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f0ac-bc99-11f1-b410-525400fdb9eb'),
('auto_backup', '1', 'bool', '自动备份', 'backup', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f0e9-bc99-11f1-b410-525400fdb9eb'),
('backup_frequency', 'weekly', 'string', '备份频率', 'backup', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f128-bc99-11f1-b410-525400fdb9eb'),
('backup_retention', '30', 'int', '备份保留天数', 'backup', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f164-bc99-11f1-b410-525400fdb9eb'),
('backup_path', '/backups/', 'string', '备份路径', 'backup', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f1a0-bc99-11f1-b410-525400fdb9eb'),
('system_version', '1.0.0', 'string', '系统版本', 'system', 1, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f1da-bc99-11f1-b410-525400fdb9eb'),
('maintenance_mode', '0', 'bool', '维护模式', 'system', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f213-bc99-11f1-b410-525400fdb9eb'),
('debug_mode', '0', 'bool', '调试模式', 'system', 0, '2025-09-01 14:10:30', '2026-09-30 14:41:40', 'fde8f24e-bc99-11f1-b410-525400fdb9eb');

-- --------------------------------------------------------

--
-- 表的结构 `tags`
--

CREATE TABLE `tags` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

--
-- 转存表中的数据 `tags`
--

INSERT INTO `tags` (`id`, `name`, `create_time`) VALUES
('fde95e3d-bc99-11f1-b410-525400fdb9eb', 'Vue3', '2025-08-17 17:48:10'),
('fde95f82-bc99-11f1-b410-525400fdb9eb', 'Web开发', '2025-08-17 17:48:10'),
('fde95fc5-bc99-11f1-b410-525400fdb9eb', '响应式', '2025-08-17 17:48:10'),
('fde95ff4-bc99-11f1-b410-525400fdb9eb', '数据分析', '2025-08-17 17:48:10'),
('fde96021-bc99-11f1-b410-525400fdb9eb', '大数据', '2025-08-17 17:48:10'),
('fde9604a-bc99-11f1-b410-525400fdb9eb', '可视化', '2025-08-17 17:48:10'),
('fde96075-bc99-11f1-b410-525400fdb9eb', 'React', '2025-08-17 17:48:10'),
('fde9609e-bc99-11f1-b410-525400fdb9eb', 'Node.js', '2025-08-17 17:48:10'),
('fde960c6-bc99-11f1-b410-525400fdb9eb', 'Python', '2025-08-17 17:48:10'),
('fde960f3-bc99-11f1-b410-525400fdb9eb', 'PHP', '2025-08-17 17:48:10');

-- --------------------------------------------------------

--
-- 表的结构 `technologies`
--

CREATE TABLE `technologies` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '技术名称',
  `img` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图标',
  `sort_order` int(11) DEFAULT NULL COMMENT '排序',
  `status` int(11) DEFAULT NULL COMMENT '状态',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='技术栈表';

--
-- 转存表中的数据 `technologies`
--

INSERT INTO `technologies` (`id`, `name`, `img`, `sort_order`, `status`, `create_time`, `update_time`) VALUES
('fdea287f-bc99-11f1-b410-525400fdb9eb', 'HTML', '/static/images/exp/html.png', 1, 1, '2025-09-01 19:07:53', NULL),
('fdea2a46-bc99-11f1-b410-525400fdb9eb', 'PHP', '/static/images/exp/php.png', 1, 1, '2025-09-01 19:08:13', NULL),
('fdea2a9a-bc99-11f1-b410-525400fdb9eb', 'VUE', '/static/images/exp/vue.png', 1, 1, '2025-09-01 19:08:26', NULL),
('fdea2ad2-bc99-11f1-b410-525400fdb9eb', 'Java', '/static/images/exp/java.png', 1, 1, '2025-09-01 19:08:41', NULL),
('fdea2b07-bc99-11f1-b410-525400fdb9eb', 'Python', '/static/images/exp/python.png', 1, 1, '2025-09-01 19:08:57', NULL),
('fdea2b38-bc99-11f1-b410-525400fdb9eb', 'ThinkPHP', '/static/images/exp/thinkphp.png', 1, 1, '2025-09-01 19:09:15', NULL),
('fdea2b69-bc99-11f1-b410-525400fdb9eb', 'Laravel', '/static/images/exp/laravel.png', 1, 1, '2025-09-01 19:09:26', NULL),
('fdea2b98-bc99-11f1-b410-525400fdb9eb', 'BootStrap', '/static/images/exp/bootstrap.png', 1, 1, '2025-09-01 19:09:38', NULL),
('fdea2bcc-bc99-11f1-b410-525400fdb9eb', 'Webpack', '/static/images/exp/webpack.png', 1, 1, '2025-09-01 19:09:51', NULL),
('fdea2bfd-bc99-11f1-b410-525400fdb9eb', 'Vite', '/static/images/exp/vite.png', 1, 1, '2025-09-01 19:10:03', NULL),
('fdea2c2b-bc99-11f1-b410-525400fdb9eb', 'FastAdmin', '/static/images/exp/fastadmin.png', 1, 1, '2025-09-01 19:10:16', NULL),
('fdea2c58-bc99-11f1-b410-525400fdb9eb', 'Uniapp', '/static/images/exp/uniapp.png', 1, 1, '2025-09-01 19:10:30', NULL),
('fdea2c87-bc99-11f1-b410-525400fdb9eb', 'Flutter', '/static/images/exp/flutter.png', 1, 1, '2025-09-01 19:10:41', NULL),
('fdea2cb4-bc99-11f1-b410-525400fdb9eb', 'PyCharm', '/static/images/exp/pycharm.png', 1, 1, '2025-09-01 19:10:52', NULL),
('fdea2ce6-bc99-11f1-b410-525400fdb9eb', 'PS', '/static/images/exp/ps.png', 1, 1, '2025-09-01 19:11:05', NULL),
('fdea2d13-bc99-11f1-b410-525400fdb9eb', 'PR', '/static/images/exp/pr.png', 1, 1, '2025-09-01 19:11:18', NULL),
('fdea2d45-bc99-11f1-b410-525400fdb9eb', 'AI', '/static/images/exp/ai.png', 1, 1, '2025-09-01 19:11:28', NULL),
('fdea2d72-bc99-11f1-b410-525400fdb9eb', 'C4D', '/static/images/exp/c4d.png', 1, 1, '2025-09-01 19:11:42', NULL),
('fdea2da0-bc99-11f1-b410-525400fdb9eb', 'Figma', '/static/images/exp/figma.png', 1, 1, '2025-09-01 19:11:55', NULL),
('fdea2dcf-bc99-11f1-b410-525400fdb9eb', 'Sketch', '/static/images/exp/sketch.png', 1, 1, '2025-09-01 19:12:06', NULL),
('fdea2dfd-bc99-11f1-b410-525400fdb9eb', 'FastAPI', '/static/images/exp/fastapi.png', 1, 1, '2025-09-01 19:12:17', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

CREATE TABLE `users` (
  `openid` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信openid',
  `user_key` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户唯一标识',
  `nickname` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `code_age` int(11) NOT NULL COMMENT '码龄',
  `avatar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `cover` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图URL',
  `gender` tinyint(1) DEFAULT '0' COMMENT '性别：0未知，1男，2女',
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地址',
  `language` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'zh_CN' COMMENT '语言',
  `visit_count` int(11) DEFAULT '0' COMMENT '访问次数',
  `like_count` int(11) DEFAULT '0' COMMENT '点赞次数',
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JWT token',
  `token_expire_time` datetime DEFAULT NULL COMMENT 'token过期时间',
  `is_engineer` tinyint(1) DEFAULT '0' COMMENT '是否工程师',
  `user_type` enum('visitor','customer','webmaster') COLLATE utf8mb4_unicode_ci DEFAULT 'visitor' COMMENT '用户类型：visitor访客,customer客户,webmaster站长',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1启用，0禁用',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `qq` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'QQ号',
  `wechat` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信号',
  `github` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'GitHub地址',
  `weibo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微博地址',
  `douyin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '抖音号',
  `web_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '个人网站',
  `working_hours` json DEFAULT NULL COMMENT '工作时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '国家',
  `province` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '省份',
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '城市'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统一用户表' ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `users`
--

INSERT INTO `users` (`openid`, `user_key`, `nickname`, `code_age`, `avatar`, `cover`, `gender`, `address`, `language`, `visit_count`, `like_count`, `token`, `token_expire_time`, `is_engineer`, `user_type`, `status`, `email`, `phone`, `qq`, `wechat`, `github`, `weibo`, `douyin`, `web_url`, `working_hours`, `last_login_time`, `last_login_ip`, `create_time`, `update_time`, `id`, `country`, `province`, `city`) VALUES
('ocAWa4obXLQHYrrxIKUg2nOEB8lU', 'f9dd0672c45163f7d04057a0a68a7222', '小伊', 0, 'https://api.sundongliang.cn/static/images/avatar/avatar_6abe56415cb7f.jpeg', NULL, 0, NULL, 'zh_CN', 0, 0, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3OTA4NjA2NTEsImV4cCI6MTc5MTQ2NTQ1MSwibmJmIjoxNzkwODYwNjUxLCJ1c2VyX2lkIjoiNjRjMmUyMzctNGVhOC00Y2FlLTlmZDQtYTc0OGUwNWI1NzE2IiwidHlwZSI6InVzZXIifQ.2zxE1o_MdAHnnpO-x4LBW_n7c2Xx2OU2315VU1dlQiQ', '2026-10-08 21:17:31', 0, 'visitor', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-01 21:17:31', NULL, '2026-10-01 20:47:02', '2026-10-01 21:17:31', '64c2e237-4ea8-4cae-9fd4-a748e05b5716', '', '', ''),
('ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'e2d2eb129b794b0a45b39881aa8161e3', 'Sam', 9, '/static/images/avatar/avatar_6a0c19fb10da5.jpg', '/static/images/cover/cover_6a0c1a18a9001.jpg', 0, '河南省郑州市', 'zh_CN', 0, 0, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3OTA4NTY0MDQsImV4cCI6MTc5MTQ2MTIwNCwibmJmIjoxNzkwODU2NDA0LCJ1c2VyX2lkIjoiZmRlYWY0NmEtYmM5OS0xMWYxLWI0MTAtNTI1NDAwZmRiOWViIiwidHlwZSI6InVzZXIifQ.vD45zFVRryr60IQd7G3aMhsaj4fYhguMZDhM5itjsLA', '2026-10-08 20:06:44', 0, 'webmaster', 1, 'cto@cvun.net', '15993113751', '21312314', 'cto-sam', 'https://github.com/Juveniles-Full-Stack-Developer', NULL, '47305446676', '', '[{\"day\": \"工作日\", \"time\": \"09:00 - 18:00\"}, {\"day\": \"周六\", \"time\": \"10:00 - 16:00\"}, {\"day\": \"周日\", \"time\": \"休息\"}]', '2026-10-01 20:06:44', '127.0.0.1', '2025-09-02 03:34:25', '2026-10-01 20:06:44', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '', '', '');

-- --------------------------------------------------------

--
-- 表的结构 `user_certifications`
--

CREATE TABLE `user_certifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users.id',
  `type` enum('personal','enterprise','official') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'personal' COMMENT '认证类型：personal个人认证,enterprise企业认证,official官方账号',
  `cert_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '认证名称(展示昵称/企业名/账号名)',
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '审核状态：pending待审核,approved已通过,rejected已驳回',
  `real_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '真实姓名(个人认证)',
  `id_card` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证号(个人认证)',
  `company_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '企业名称(企业认证)',
  `license_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '统一社会信用代码/营业执照号(企业认证)',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系手机号',
  `materials` text COLLATE utf8mb4_unicode_ci COMMENT '认证材料图片URL(JSON数组)',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '认证说明',
  `reject_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '驳回原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户认证表';

--
-- 转存表中的数据 `user_certifications`
--

INSERT INTO `user_certifications` (`id`, `user_id`, `type`, `cert_name`, `status`, `real_name`, `id_card`, `company_name`, `license_no`, `contact_phone`, `materials`, `description`, `reject_reason`, `audit_time`, `create_time`, `update_time`) VALUES
('85c59e32-7943-4353-9db4-8e8471324a72', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'personal', '全栈工程师', 'approved', NULL, NULL, NULL, NULL, '', '[]', '没有理由', NULL, NULL, '2026-09-30 19:10:16', '2026-09-30 20:32:29');

-- --------------------------------------------------------

--
-- 表的结构 `user_covers`
--

CREATE TABLE `user_covers` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users.id',
  `image` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '封面图URL(相对 /static 路径)',
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '审核状态：pending待审核,approved已通过,rejected已驳回',
  `reject_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '驳回原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户封面表(需审核)';

--
-- 转存表中的数据 `user_covers`
--

INSERT INTO `user_covers` (`id`, `user_id`, `image`, `status`, `reject_reason`, `audit_time`, `create_time`, `update_time`) VALUES
('4228d5e1-927b-4728-a8ee-75ba32f99b9c', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '/static/images/cover/cover_6abce3e71f742.png', 'approved', NULL, NULL, '2026-09-30 18:26:47', '2026-09-30 18:32:44');

-- --------------------------------------------------------

--
-- 表的结构 `user_entitlements`
--

CREATE TABLE `user_entitlements` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `openid` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户 openid -> users(openid)',
  `product_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '道具 ID',
  `quantity` int(11) NOT NULL DEFAULT '0' COMMENT '累计发放数量(可为负)',
  `wx_order_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '来源平台单号(唯一, 防重复发放)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户虚拟权益';

--
-- 转存表中的数据 `user_entitlements`
--

INSERT INTO `user_entitlements` (`id`, `openid`, `product_id`, `quantity`, `wx_order_id`, `create_time`, `update_time`) VALUES
('27b35ee7-4aa3-4cd8-bf37-a0b8e736f9e7', 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'coin_1', 2, 'VPO261001200229022697939', '2026-10-01 20:02:44', '2026-10-01 20:07:05');

-- --------------------------------------------------------

--
-- 表的结构 `user_follows`
--

CREATE TABLE `user_follows` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `follower_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关注者用户ID -> users.id',
  `following_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '被关注者用户ID -> users.id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户关注关系表';

--
-- 转存表中的数据 `user_follows`
--

INSERT INTO `user_follows` (`id`, `follower_id`, `following_id`, `create_time`) VALUES
('7e77c8a1-5392-4a4f-b809-081de8fb0476', '64c2e237-4ea8-4cae-9fd4-a748e05b5716', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '2026-10-01 21:17:48');

-- --------------------------------------------------------

--
-- 表的结构 `virtualpay_config`
--

CREATE TABLE `virtualpay_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(64) NOT NULL COMMENT '配置项名，与 .env 的键名一致（如 VP_APPID）',
  `value` text NOT NULL COMMENT '配置值',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='虚拟支付配置';

--
-- 转存表中的数据 `virtualpay_config`
--

INSERT INTO `virtualpay_config` (`id`, `name`, `value`, `remark`, `create_time`, `update_time`) VALUES
(1, 'VP_APPID', 'wx63617f985d8c028c', '小程序 AppID', '2026-10-01 20:19:34', '2026-10-01 20:19:34'),
(2, 'VP_APP_SECRET', 'a0a3d18cc49c5f70174245bf5e79d558', '小程序 AppSecret', '2026-10-01 20:19:34', '2026-10-01 20:19:34'),
(3, 'VP_OFFER_ID', '1450646881', '虚拟支付 OfferID', '2026-10-01 20:19:34', '2026-10-01 20:19:34'),
(4, 'VP_APP_KEY', 'pHOD10IVOI00wfDbq9SiEM1V70NicrhW', '现网 AppKey（env=0）', '2026-10-01 20:19:34', '2026-10-01 20:19:34'),
(5, 'VP_NOTIFY_TOKEN', 'JM9SNc6tHRsG4KcE8strWJdE7ttffdEG', '消息推送 Token', '2026-10-01 20:19:34', '2026-10-01 20:19:34'),
(6, 'VP_SANDBOX_APP_KEY', '6U8CiazJlkzic80a1uAYJ4MXaxHHi9oZ', '沙箱 AppKey（env=1）', '2026-10-01 20:19:34', '2026-10-01 20:19:34'),
(7, 'VP_ENV', '0', '0=现网，1=沙箱', '2026-10-01 20:19:34', '2026-10-01 20:19:34');

-- --------------------------------------------------------

--
-- 表的结构 `virtual_pay_orders`
--

CREATE TABLE `virtual_pay_orders` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `out_trade_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务单号(全局唯一)',
  `wx_order_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平台单号(幂等/对账)',
  `openid` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户 openid -> users(openid)',
  `product_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '道具 ID',
  `product_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '道具名称快照',
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT '1' COMMENT '购买数量',
  `goods_price` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '道具单价(分)',
  `pay_fee` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '订单总金额(分)',
  `attach` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '透传数据',
  `env` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0现网,1沙箱',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'pending/paid/closed',
  `deliver_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0未发货,1已发货',
  `paid_time` datetime DEFAULT NULL COMMENT '支付时间',
  `deliver_time` datetime DEFAULT NULL COMMENT '发货时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='虚拟支付订单';

--
-- 转存表中的数据 `virtual_pay_orders`
--

INSERT INTO `virtual_pay_orders` (`id`, `out_trade_no`, `wx_order_id`, `openid`, `product_id`, `product_name`, `quantity`, `goods_price`, `pay_fee`, `attach`, `env`, `status`, `deliver_status`, `paid_time`, `deliver_time`, `create_time`, `update_time`) VALUES
('1fd2c400-12a1-4da3-be30-9aacd196fe85', 'T20261001230528771702', NULL, 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'coin_1', '1', 1, 100, 100, '{\"user_id\":\"fdeaf46a-bc99-11f1-b410-525400fdb9eb\"}', 0, 'pending', 0, NULL, NULL, '2026-10-01 23:05:28', '2026-10-01 23:05:28'),
('371c797f-b7d8-4352-bc32-a75258655ada', 'T20261001200653199891', 'VPO261001200653053966839', 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'coin_1', '1', 1, 100, 100, '{\"user_id\":\"fdeaf46a-bc99-11f1-b410-525400fdb9eb\"}', 0, 'paid', 1, '2026-10-01 20:07:05', '2026-10-01 20:07:05', '2026-10-01 20:06:53', '2026-10-01 20:07:05'),
('383f1ae9-39a3-40d5-8197-affaaf22bd73', 'T20261001200229447728', 'VPO261001200229022697939', 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'coin_1', '1', 1, 100, 100, '{\"user_id\":\"fdeaf46a-bc99-11f1-b410-525400fdb9eb\"}', 0, 'paid', 1, '2026-10-01 20:02:44', '2026-10-01 20:02:44', '2026-10-01 20:02:29', '2026-10-01 20:02:44');

-- --------------------------------------------------------

--
-- 表的结构 `visit_logs`
--

CREATE TABLE `visit_logs` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `page` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问页面',
  `referer` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '来源页面',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `device_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'desktop' COMMENT '设备类型',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问日志表';

--
-- 转存表中的数据 `visit_logs`
--

INSERT INTO `visit_logs` (`id`, `ip`, `page`, `referer`, `user_agent`, `device_type`, `create_time`) VALUES
('00156632-efc8-433d-a5ed-85177b53a30f', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 17:13:00'),
('0252cbeb-d52a-465e-891a-e3e1e7a7ce8a', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:00:37'),
('06a87f64-f389-4564-935a-10c25962c48a', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 17:16:32'),
('07f43be7-bcb0-4eb6-8486-d26ca3a339a4', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 19:20:22'),
('0814dcd0-4430-4be9-b026-d4614f7fa68a', '124.220.124.159', '/pages/message/message', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:04:34'),
('15439a1c-7b2b-4f49-ad0e-b13f5813dfe2', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 18:38:33'),
('170a87e1-31e8-40d7-99d3-02071e16a825', '39.163.100.208', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 17:41:37'),
('17ff4227-08fe-42b0-bea9-badf8666bdaf', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:56:56'),
('2472b579-02aa-4e11-baba-c5ff92c2a81d', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 18:32:28'),
('29583710-2c6e-4bc9-9657-7f99f151fc80', '39.144.22.117', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/4G Language/zh_CN', 'mobile', '2026-10-01 23:06:01'),
('2b62dc62-9f78-4ff0-b031-65874ebc7eae', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 20:43:20'),
('2db39558-08fe-40d2-aefa-ae583cd97687', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:34:05'),
('2dfee1c3-3891-42e2-901a-0292f71ca3ba', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:01:25'),
('2e3658d6-5e3d-4626-8021-c0668cbd436a', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:35:53'),
('2eee8077-ccd1-4652-b747-9d1c71c817bf', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 16:13:56'),
('3024f90d-2275-441b-a51b-fa8d8959a483', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 17:12:58'),
('35d85acc-5a39-4a0a-bbd5-43795b47d2ad', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:40:54'),
('36033c31-52bd-4840-a7db-773b884c0960', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 22:01:18'),
('3717e716-adb2-4958-b658-b4b0df858747', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:06:41'),
('38d1aafc-6d29-4f25-92f3-a1358cd4960c', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 19:00:49'),
('395a1b29-0ada-49e0-bbe5-2bc505ace3d3', '124.220.124.244', '/pages/user/user', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:05:03'),
('437113d8-1a64-49b2-b055-3e20f6715a78', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:15:33'),
('43d15f7d-1af5-4b77-ad13-b4613e0bb87b', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:26:23'),
('4415e95e-a8b2-4629-9afa-e0a01d9c5f58', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:54:21'),
('486de2ab-c10b-4716-ade7-18d3a3abcaf3', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 18:07:21'),
('4dc7590f-7e01-42bf-b4a1-858e484b07d9', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 18:40:21'),
('50cb7f7d-aeae-4ab5-b32c-51c09cbbdf24', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:28:06'),
('5337620f-56ef-46ef-98d1-efc13b24d4fc', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 23:20:18'),
('534f40ff-a6dc-4b53-92d4-d0d4d23f97a4', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 17:21:55'),
('60c59470-c2ad-48d1-9cfe-6101cbd79819', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 16:10:09'),
('618e3170-0c0b-4673-afbd-8ddbff86b36f', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:39:31'),
('61e3c086-3a43-4c0c-8357-6981baa5d3d0', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:25:23'),
('644737fc-9ae6-461a-90d1-0aac6a709f5c', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/720630fd6a8bd95cd4562138cde1f3c7', 'mobile', '2026-09-30 23:50:14'),
('68b8dc55-e2a8-4eb7-8e83-b9d636b35b32', '39.144.22.117', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/4G Language/zh_CN', 'mobile', '2026-10-01 23:05:01'),
('69728f16-c5af-4944-9453-afa371d38b8e', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'desktop', '2026-09-30 22:35:35'),
('6ae00532-ba40-4323-9d7c-1d72dd264812', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:36:28'),
('6bceba17-c79d-44bf-987d-f974c5aff6e4', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:20:56'),
('6c32e2ee-0ea9-422a-997c-c5a1899e6f8e', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 17:33:35'),
('6dd137e4-e947-4b73-a367-0c25c71e8fc1', '124.220.124.244', '/pages/message/message', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:04:48'),
('6fa86b9e-e1ce-401c-82b0-da4e7620e18d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 17:27:31'),
('72066bc2-a9b6-4f41-9b17-3a378facd83d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:32:12'),
('760b47e7-3388-49a6-a3a0-cdaef302f64e', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:27:09'),
('76255845-beef-4d68-9cb2-28db41791c2d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 00:15:10'),
('7817d75f-8d0e-4225-8a7d-3ed1f27b9c32', '43.139.209.119', '/pages/message/message', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6abe77497f2cedcdf907b5443ba7) f6a6', 'desktop', '2026-10-01 23:10:36'),
('81c41016-dbe8-4aa0-a4ba-48b3b4f56973', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:01:27'),
('83e4d68e-6ca5-4b8b-b33f-7e9a26d0666d', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:11:48'),
('895c5926-b50f-4734-acf8-204a2666149b', '124.220.124.159', '/subpkg/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:07:23'),
('89d004b1-1115-47fb-a89f-e6167235f765', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 15:42:53'),
('8a4247b3-3d46-4f95-8714-28e4296190ab', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:08:14'),
('8db9599a-3bac-45ea-90bf-2cab5db77acb', '124.220.124.159', '/pages/user/user', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:04:47'),
('9065a87d-d67c-476b-bf65-bda1a3f0e044', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 21:52:10'),
('9618e610-db48-44e2-9d9b-f8c124744480', '39.163.100.249', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 11:38:01'),
('963e21d0-56b9-4a70-a041-04cf9a51ba08', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 19:56:07'),
('9982e8bb-6b1d-4c4b-8909-73ed9b017348', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 18:18:49'),
('9d1ca872-b244-4dc0-a2ea-06090a693122', '39.144.22.117', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/4G Language/zh_CN', 'mobile', '2026-10-01 22:57:38'),
('a138e32a-d178-4c8e-8b98-11f23552f7b7', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:30:33'),
('a1bddf55-cf96-4f93-84af-4b3c4cb44c40', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 11:37:55'),
('a46f3b9e-952c-4598-ad45-6c3afc4b3d0f', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 23:27:09'),
('a6945492-7920-4297-afd4-bc437aa6c2cd', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 20:43:17'),
('a88e8df2-e53e-4da7-861d-9b95d50c447e', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 15:54:21'),
('ac34653c-abc6-4522-b890-78bdbd67f21e', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 19:42:25'),
('acf4e7d9-9afd-43c6-8e76-8815afebd9fd', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:14:42'),
('aecc67b8-5a2a-4ef5-9ff3-d79d0ed4022c', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:28:27'),
('b3723fcc-5593-43e2-b708-32dc4cad0d31', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 21:29:17'),
('b83dcd8f-0808-4308-b38d-2fdffdd29fa1', '39.163.100.208', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 23:27:42'),
('bac57795-9740-418b-9e8d-7a3c9e8cc6be', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 16:57:42'),
('bd66b4b6-987f-4d08-8610-8ca12238f94e', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 16:13:58'),
('bde339ad-3c33-420d-9cac-3f4e68f5bada', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:48:22'),
('c31180c0-101b-4157-abec-a074830af284', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:08:47'),
('c700c490-873e-4065-8bff-fc011d0d6807', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 16:38:24'),
('cadaea63-4923-4a9b-b29d-61e26732ebaa', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:15:19'),
('cde04f9a-8d75-4417-8ff0-00844080cc14', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:13:27'),
('cf2f797a-6176-40ca-9479-f935b8de7da9', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 17:44:45'),
('d5f7ffcb-1ec9-47f9-bdd1-4f4c87cc0eef', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 18:50:16'),
('d7124144-a1fe-4718-a68d-f7f0fb2202bc', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:00:09'),
('db7e9311-436d-426d-a516-3068625f745c', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 18:50:39'),
('dbf44018-17d4-4d9f-ba99-0cac6bbc170d', '39.163.100.241', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-01 22:57:03'),
('dc6ddf0c-d5f0-47a7-afd9-d058a25db240', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 17:39:45'),
('df03f551-2a36-4e93-b600-d0ef70a23fdd', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:23:24'),
('df0d79db-165c-450c-88bf-84260c6ea465', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 19:14:16'),
('dfbb2ba2-0186-4517-9634-2b5268a921cb', '39.163.100.241', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-01 22:06:41'),
('e3161916-1683-47c7-9c50-36276f9acc1d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:30:45'),
('e431faf7-ccb3-446d-ad6d-a91ca2ce7399', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 15:48:18'),
('e4951d2b-7ca8-40e4-ab27-47390359ed78', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:42:08'),
('e603d801-d680-469b-a945-5207f09efda3', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 18:45:16'),
('ed6a7e7f-e79f-4a81-9c98-767649b29584', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-02 15:10:09'),
('ef110302-1349-47e8-84ca-d21ccd66acf7', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:24:56'),
('efbe9be4-080c-412c-aa10-3e1771e9d135', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:23:25'),
('f0c44b40-3985-4bd5-8ac4-4705ef95c4e9', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 20:31:23'),
('f45e6aa4-7403-4482-87e2-35031ce166f9', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:41:10'),
('f658b8a7-2c8d-4464-95ef-82f27d14415b', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:02:58'),
('f7a11a09-78d2-4f62-a8a0-1e84861c83d3', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 19:50:26'),
('f9777323-ab61-4784-9dd9-e9280732d0ae', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 21:51:59'),
('fb135cd9-dd2f-478e-9b37-54869cbcd298', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/52df024bbb6710ecbf4a1ad576c95418', 'mobile', '2026-10-01 22:59:39'),
('fbef4f4f-0d54-4ddd-857f-cd2662a234f1', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 21:17:28'),
('fdeb7633-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/13', 'mobile', '2026-01-05 15:27:39'),
('fdeb77bd-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/14', 'mobile', '2026-01-05 15:32:57'),
('fdeb7813-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.67(0x1800432b) NetType/WIFI Language/zh_CN', 'mobile', '2026-01-05 15:46:52'),
('fdeb7851-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/27', 'mobile', '2026-01-05 15:52:16'),
('fdeb7922-bc99-11f1-b410-525400fdb9eb', '101.34.86.201', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-01-05 15:56:42'),
('fdeb7955-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/37', 'mobile', '2026-05-19 15:18:51'),
('fdeb7981-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/37', 'mobile', '2026-05-19 15:23:05'),
('fdeb79ac-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/38', 'mobile', '2026-05-19 15:24:14'),
('fdeb7a2c-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/41', 'mobile', '2026-05-19 15:30:41'),
('fdeb7a5a-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/48', 'mobile', '2026-05-19 16:00:38'),
('fdeb7a84-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/49', 'mobile', '2026-05-19 16:05:57'),
('fdeb7b35-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/53', 'mobile', '2026-05-19 16:12:26'),
('fdeb7b60-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/55', 'mobile', '2026-05-19 16:14:28'),
('fdeb7b8c-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56', 'mobile', '2026-05-19 16:21:31'),
('fdeb7c19-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56', 'mobile', '2026-05-19 16:21:34'),
('fdeb7c49-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/61', 'mobile', '2026-05-19 16:28:04'),
('fdeb7cc2-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/61', 'mobile', '2026-05-19 16:28:17'),
('fdeb7cef-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:36:13'),
('fdeb7d1d-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:36:19'),
('fdeb7d96-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:42:51'),
('fdeb7dc0-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:55:01'),
('fdeb7e33-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 17:00:56'),
('fdeb7e60-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 17:02:36'),
('fdeb7ed3-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 17:13:13'),
('fdeb7efd-bc99-11f1-b410-525400fdb9eb', '39.144.24.239', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x1800492a) NetType/4G Language/zh_CN', 'mobile', '2026-05-20 18:52:51'),
('fdeb7f74-bc99-11f1-b410-525400fdb9eb', '39.144.24.239', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x1800492a) NetType/4G Language/zh_CN', 'mobile', '2026-05-20 21:29:18'),
('fdeb80bc-bc99-11f1-b410-525400fdb9eb', '125.45.110.184', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 16; PKM110 Build/BP2A.250605.015; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.177 Mobile Safari/537.36 XWEB/1460075 MMWEBSDK/20260202 MMWEBID/4073 MicroMessenger/8.0.71.3080(0x28004750) WeChat/arm64 Weixin NetType/4G Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-05-20 21:33:56'),
('fdeb8143-bc99-11f1-b410-525400fdb9eb', '39.144.22.46', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-01 20:25:33'),
('fdeb81f4-bc99-11f1-b410-525400fdb9eb', '39.144.22.46', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-01 22:18:36'),
('fdeb8296-bc99-11f1-b410-525400fdb9eb', '39.144.22.46', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-02 10:30:22'),
('fdeb8344-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-03 13:01:26'),
('fdeb83e4-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-03 13:02:22'),
('fdeb8577-bc99-11f1-b410-525400fdb9eb', '101.34.86.201', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:03:30'),
('fdeb85f4-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:03:39'),
('fdeb8655-bc99-11f1-b410-525400fdb9eb', '101.34.86.201', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:04:18'),
('fdeb86b1-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:04:30'),
('fdeb870e-bc99-11f1-b410-525400fdb9eb', '106.55.202.118', '/pages/index/index', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6a1fb62e815955e3e2cb62e598e2) f6a6', 'desktop', '2026-06-03 13:06:54'),
('fdeb8770-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/index/index', 'https://weixin110.qq.com/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-03 13:07:55'),
('fdeb87d1-bc99-11f1-b410-525400fdb9eb', '43.139.209.119', '/pages/index/index', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6a1fb62e815955e3e2cb62e598e2) 19ab', 'desktop', '2026-06-03 13:13:14'),
('fdeb87fe-bc99-11f1-b410-525400fdb9eb', '124.221.213.176', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:23:41'),
('fdeb882a-bc99-11f1-b410-525400fdb9eb', '124.221.213.176', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:24:32'),
('fdeb8854-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/index/index', 'http://1.13.163.77:12138/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-03 14:25:06'),
('fdeb8880-bc99-11f1-b410-525400fdb9eb', '114.132.52.44', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Mobile Safari/537.36 MicroMessenger/7.0.1', 'mobile', '2026-06-03 18:33:58'),
('fdeb88a9-bc99-11f1-b410-525400fdb9eb', '119.84.150.102', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 12; AOSP on Pixel Build/SQ1D.220205.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20251202 MMWEBID/3954 MicroMessenger/8.0.72.3020(0x28004835) WeChat/arm64 Weixin NetType/02:42:ac:11:00:13 Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-04 14:33:28'),
('fdeb88e8-bc99-11f1-b410-525400fdb9eb', '39.163.111.15', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-04 15:31:36'),
('fdeb8915-bc99-11f1-b410-525400fdb9eb', '119.2.154.223', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 16; SM-S9380 Build/BP4A.251205.006; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20260202 MMWEBID/5048 MicroMessenger/8.0.71.3080(0x28004750) WeChat/arm64 Weixin NetType/WIFI Language/en ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-04 15:37:00'),
('fdeb894a-bc99-11f1-b410-525400fdb9eb', '59.37.125.37', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 16; MEIZU 20 Pro Build/BQ2A.251110.001-BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20260502 MMWEBID/1396 MicroMessenger/8.0.74.3100(0x28004A31) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-04 16:12:36'),
('fdeb897b-bc99-11f1-b410-525400fdb9eb', '39.144.22.106', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-05 12:11:40'),
('fdeb89a8-bc99-11f1-b410-525400fdb9eb', '111.55.20.149', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-05 22:08:05'),
('fdeb89d3-bc99-11f1-b410-525400fdb9eb', '223.104.105.10', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-07 18:45:29'),
('fdeb8a02-bc99-11f1-b410-525400fdb9eb', '223.104.105.23', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-08 16:47:50'),
('fdeb8a2c-bc99-11f1-b410-525400fdb9eb', '39.163.100.235', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-09 11:15:12'),
('fdeb8a5a-bc99-11f1-b410-525400fdb9eb', '39.163.100.235', '/pages/index/index', 'http://1.13.163.77:12138/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-09 12:08:29'),
('fdeb8a89-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:11:46'),
('fdeb8ab7-bc99-11f1-b410-525400fdb9eb', '124.220.124.159', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:11:55'),
('fdeb8ae8-bc99-11f1-b410-525400fdb9eb', '124.220.126.5', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:11:56'),
('fdeb8b19-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:12:34'),
('fdeb8b52-bc99-11f1-b410-525400fdb9eb', '124.220.124.159', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:12:46');
INSERT INTO `visit_logs` (`id`, `ip`, `page`, `referer`, `user_agent`, `device_type`, `create_time`) VALUES
('fdeb8b80-bc99-11f1-b410-525400fdb9eb', '124.220.126.5', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:12:47'),
('fdeb8c05-bc99-11f1-b410-525400fdb9eb', '119.84.150.102', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 12; AOSP on Pixel Build/SQ1D.220205.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460205 MMWEBSDK/20260101 MMWEBID/3126 MicroMessenger/8.0.72.3020(0x28004835) WeChat/arm64 Weixin NetType/02:42:ac:11:00:07 Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-09 16:12:07'),
('fdeb8c36-bc99-11f1-b410-525400fdb9eb', '39.163.100.25', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-10 21:48:01'),
('fdeb8c65-bc99-11f1-b410-525400fdb9eb', '39.163.100.154', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-11 14:53:38'),
('fdeb8c95-bc99-11f1-b410-525400fdb9eb', '120.244.186.216', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 15; REA-AN00 Build/HONORREA-AN00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460205 MMWEBSDK/20260502 MMWEBID/5675 MicroMessenger/8.0.72.3100(0x28004853) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-12 21:43:11'),
('fdeb8d15-bc99-11f1-b410-525400fdb9eb', '39.163.100.8', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-13 12:03:57'),
('fdeb8d42-bc99-11f1-b410-525400fdb9eb', '110.179.140.14', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'desktop', '2026-06-13 13:04:06'),
('fdeb8d6d-bc99-11f1-b410-525400fdb9eb', '219.155.182.237', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-14 21:23:06'),
('fdeb8d98-bc99-11f1-b410-525400fdb9eb', '39.163.100.88', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b27) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-20 21:41:30'),
('fdeb8e12-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://1.13.163.77:12138/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-22 22:20:06'),
('fdeb8e3d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 22:51:02'),
('fdeb8e67-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 22:56:04'),
('fdeb8e92-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:02:06'),
('fdeb8f0d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:12:24'),
('fdeb91bf-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:19:12'),
('fdeb9208-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/contact/contact', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:21:44'),
('fdeb9295-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:25:44'),
('fdeb92c1-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:47:41'),
('fdeb933e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:00:55'),
('fdeb9369-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:08:11'),
('fdeb93e2-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:14:08'),
('fdeb940c-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:19:29'),
('fdeb948b-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:22:57'),
('fdeb94b5-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:23:38'),
('fdebc89c-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:31:10'),
('fdebca1e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:35:29'),
('fdebcadf-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:35:33'),
('fdebcb8d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:41:58'),
('fdebcc35-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:42:38'),
('fdebccdd-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:47:06'),
('fdebcdf7-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:50:51'),
('fdebcfac-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:53:46'),
('fdebd024-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:57:26'),
('fdebd08f-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:57:36'),
('fdebd102-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-06-23 01:03:01'),
('fdebd16e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:04:08'),
('fdebd1d4-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:09:33'),
('fdebd232-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:09:36'),
('fdebd28e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:09:39'),
('fdebd2ec-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:15:30'),
('fdebd34f-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:17:45'),
('fdebd3ab-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:17:48'),
('fdebd406-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:24:35'),
('fdebd48d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:27:32'),
('fdebd4bc-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:27:42'),
('fdebd4f3-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:34:42'),
('fdebd51f-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 11:57:16'),
('fdebd55c-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 11:57:28'),
('fdebd589-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 11:57:41'),
('fdebd5b9-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 12:03:44'),
('fdebd5e6-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 12:04:40'),
('fdebd616-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-23 14:44:17'),
('fdebd648-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 22:55:24'),
('fdebd678-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 22:55:57'),
('fdebd6a4-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 22:56:00'),
('fdebd6ce-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 23:00:28'),
('fdebd6fd-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-06-23 23:02:38'),
('fdebd72a-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 23:05:49'),
('fdebd757-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 23:06:14'),
('fdebd78a-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:09:37'),
('fdebd7c0-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:16:45'),
('fdebd7ef-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:27:22'),
('fdebd81a-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:31:51'),
('fdebd896-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:32:50'),
('fdebd8ce-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:32:57'),
('fdebd9c2-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:39:15'),
('fdebd9f3-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:40:27'),
('fdebda31-bc99-11f1-b410-525400fdb9eb', '222.140.168.137', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf2541b16) XWEB/20005', 'desktop', '2026-06-27 11:09:31'),
('fdebda64-bc99-11f1-b410-525400fdb9eb', '219.155.181.217', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2d) NetType/4G Language/zh_TW', 'mobile', '2026-06-27 11:09:47'),
('fdebdafe-bc99-11f1-b410-525400fdb9eb', '223.104.105.96', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/4G Language/zh_TW', 'mobile', '2026-06-30 18:56:54'),
('fdebdb29-bc99-11f1-b410-525400fdb9eb', '120.212.165.226', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-30 18:57:52'),
('fdebdb68-bc99-11f1-b410-525400fdb9eb', '1.196.155.72', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-30 22:51:10'),
('fdebdb98-bc99-11f1-b410-525400fdb9eb', '1.196.155.72', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-30 22:52:54'),
('fdebdc30-bc99-11f1-b410-525400fdb9eb', '39.163.100.150', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-30 22:57:27'),
('fdebdc5d-bc99-11f1-b410-525400fdb9eb', '39.163.100.150', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-30 22:57:32'),
('fdebdc98-bc99-11f1-b410-525400fdb9eb', '39.163.100.150', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-30 22:57:35'),
('fdebdd2f-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-07-07 15:43:01'),
('fdebdd5c-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-07-07 15:43:17'),
('fdebdec5-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 15:53:05'),
('fdebdf2e-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:05:12'),
('fdebe183-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:26:47'),
('fdebe23a-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:45:15'),
('fdebe269-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:45:19'),
('fdebe2f9-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:49:46'),
('fdebe329-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/5', 'mobile', '2026-07-07 16:54:54'),
('fdebe3c3-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b35) NetType/WIFI Language/zh_TW', 'mobile', '2026-07-07 16:59:57'),
('fdebe441-bc99-11f1-b410-525400fdb9eb', '39.163.100.198', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b42) NetType/WIFI Language/zh_TW', 'mobile', '2026-07-21 10:52:24'),
('fdec0eb1-bc99-11f1-b410-525400fdb9eb', '39.163.100.86', '/pages/index/index', 'http://43.137.17.63:12138/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-08-17 20:52:24'),
('fdec0fe9-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-09 23:44:31'),
('fdec10dc-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-09 23:46:31'),
('fdec118b-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-09 23:46:33'),
('fdec1264-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-10 00:08:27'),
('fdec130e-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-18 23:38:50'),
('fdec149f-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-18 23:47:09'),
('fdec1518-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-18 23:54:49'),
('fdec1578-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:07:50'),
('fdec15da-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:08:01'),
('fdec1656-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:08:03'),
('fdec16ba-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:08:05'),
('fdec16ee-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:27'),
('fdec1722-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:37'),
('fdec1750-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:40'),
('fdec177e-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:43'),
('fdec17ad-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-19 11:28:15'),
('fdec17da-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-19 11:29:47'),
('fdec1807-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:41:25'),
('fdec1834-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:41:33'),
('fdec1862-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:41:34'),
('fdec1890-bc99-11f1-b410-525400fdb9eb', '192.168.10.8', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-26 20:43:04'),
('fdec18be-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:44:59'),
('fdec18ea-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:45:14'),
('fdec1920-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:58:18'),
('fdec194d-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'desktop', '2026-09-27 15:59:44'),
('fdec1980-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:15:06'),
('fdec19ae-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:19:08'),
('fdec19de-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:19:09'),
('fdec1a0a-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:21:13'),
('fdec1a35-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:27:42'),
('fdec1a62-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:52:10'),
('fdec1a8d-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:04:15'),
('fdec1ac0-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:04:33'),
('fdec1af4-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:10:01'),
('fdec1b28-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:11:06'),
('fdec1bc7-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:13:53'),
('fdec1bf3-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:18:10'),
('fdec1c69-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:19:51'),
('fdec1d0d-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:29:48'),
('fdec1d3a-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/1b87cb8ef5e59905acd8a683d5746cd9', 'mobile', '2026-09-27 18:32:26'),
('fdec1d75-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-27 19:18:33'),
('fdec1db2-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 13:14:25'),
('fdec1e45-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 13:52:47'),
('fdec1e71-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:01:09'),
('fdec1e9d-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 14:01:22'),
('fdec1f24-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:07:35'),
('fdec1f52-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:08:34'),
('fdec1fe7-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:14:40'),
('fdec2013-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:22:44'),
('fdec204f-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:28:31'),
('fdec20e2-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:28:34'),
('fdec210c-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:33:49'),
('fdec2186-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:41:17'),
('fdec21c9-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:50:06'),
('fdec2260-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:55:11'),
('fdec228c-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:01:38'),
('fdec2305-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:07:00'),
('fdec238b-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:12:30'),
('fdec241f-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:13:39'),
('fdec2498-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:18:07'),
('fdec2511-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 15:25:52'),
('fdec51c8-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 15:31:12'),
('fdec53f4-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:37:51'),
('fdec5513-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:42:52'),
('fdec55c3-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 16:11:31'),
('fdec575a-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 16:22:57'),
('fdec5a3c-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 16:27:06'),
('fdec5a7e-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 17:11:32'),
('fdec5ab9-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 17:25:18'),
('fdec5ae7-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 17:34:33'),
('fdec5b1a-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 17:42:25'),
('fdec5b49-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 17:55:18'),
('fdec5b7a-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 22:42:13'),
('fdec5ba5-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 00:30:32'),
('fdec5bda-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 12:45:59'),
('fdec5c0d-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 12:51:59'),
('fdec5c3a-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:04:54'),
('fdec5c69-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:11:32'),
('fdec5c95-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:11:36'),
('fdec5cc4-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:35:42');
INSERT INTO `visit_logs` (`id`, `ip`, `page`, `referer`, `user_agent`, `device_type`, `create_time`) VALUES
('fdec5cef-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 14:41:11'),
('fdec5d1e-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:47:51'),
('fdec5d4a-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:47:57'),
('fdec5dfb-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:48:48'),
('fdec5e28-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 15:22:32'),
('fdec5e59-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 15:22:36'),
('fdec5e86-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 15:36:08'),
('fdec5eb5-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 15:38:02'),
('fdec5ee2-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (Phone; OpenHarmony 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 ArkWeb/4.1.6.1 Mobile HuaweiBrowser/5.0.4.303 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/96789cf62a111e467db4f25b04508176', 'mobile', '2026-09-29 15:56:35'),
('fdec5f14-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 15:58:07'),
('fdec5f46-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:02:11'),
('fdec5f73-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:03:16'),
('fdec5fa1-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:07:26'),
('fdec5fce-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:07:52'),
('fdec5ffa-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:13:12'),
('fdec6027-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:13:55'),
('fdec6053-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:16:00'),
('fdec60ea-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:24:54'),
('fdec6115-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:29:57'),
('fdec614a-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:44:55'),
('fdec6177-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:45:00'),
('fdec61a5-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:51:02'),
('fdec61d3-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 22:47:29'),
('fdec6202-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 22:52:28'),
('fdec622d-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 11:58:48'),
('fdec625b-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 12:38:00'),
('fdec6287-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 12:38:02'),
('fdec62b7-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 12:48:38'),
('fdec62e3-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 12:58:07'),
('ff634ee5-32cb-421b-a242-6b25cdcbaff0', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 14:57:41');

--
-- 转储表的索引
--

--
-- 表的索引 `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_action` (`action`);

--
-- 表的索引 `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_read` (`is_read`);

--
-- 表的索引 `forum_boards`
--
ALTER TABLE `forum_boards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_board_key` (`board_key`);

--
-- 表的索引 `forum_board_members`
--
ALTER TABLE `forum_board_members`
  ADD PRIMARY KEY (`board_id`,`user_id`),
  ADD KEY `fk_board_members_user` (`user_id`);

--
-- 表的索引 `forum_board_moderators`
--
ALTER TABLE `forum_board_moderators`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_board_user` (`board_id`,`user_id`),
  ADD KEY `idx_board` (`board_id`),
  ADD KEY `fk_board_mods_user` (`user_id`);

--
-- 表的索引 `forum_posts`
--
ALTER TABLE `forum_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_board` (`board_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_pinned` (`is_pinned`),
  ADD KEY `idx_create` (`create_time`);

--
-- 表的索引 `forum_post_comments`
--
ALTER TABLE `forum_post_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_post` (`post_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_parent` (`parent_id`);

--
-- 表的索引 `forum_post_likes`
--
ALTER TABLE `forum_post_likes`
  ADD PRIMARY KEY (`post_id`,`user_id`),
  ADD KEY `fk_post_likes_user` (`user_id`);

--
-- 表的索引 `forum_post_purchases`
--
ALTER TABLE `forum_post_purchases`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_post_user` (`post_id`,`user_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_settle` (`settle_status`);

--
-- 表的索引 `forum_reports`
--
ALTER TABLE `forum_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_post` (`post_id`),
  ADD KEY `idx_reporter` (`reporter_id`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_username` (`username`),
  ADD KEY `idx_user` (`user_id`);

--
-- 表的索引 `admin_scan_tickets`
--
ALTER TABLE `admin_scan_tickets`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category_id`),
  ADD KEY `idx_client` (`client_id`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `project_categories`
--
ALTER TABLE `project_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_board_key` (`board_key`);

--
-- 表的索引 `project_images`
--
ALTER TABLE `project_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_project_sort` (`sort_order`) USING BTREE,
  ADD KEY `fk_project_images_project` (`project_id`);

--
-- 表的索引 `project_tags`
--
ALTER TABLE `project_tags`
  ADD PRIMARY KEY (`project_id`,`tag_id`),
  ADD KEY `fk_project_tags_tag` (`tag_id`);

--
-- 表的索引 `project_technologies`
--
ALTER TABLE `project_technologies`
  ADD PRIMARY KEY (`project_id`,`technology_id`),
  ADD KEY `fk_project_tech_technology` (`technology_id`);

--
-- 表的索引 `requirements`
--
ALTER TABLE `requirements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_project_id` (`project_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_priority` (`priority`),
  ADD KEY `idx_assignee` (`assignee_id`),
  ADD KEY `fk_requirements_template` (`template_id`);

--
-- 表的索引 `requirement_attachments`
--
ALTER TABLE `requirement_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_uploader` (`uploader`) USING BTREE,
  ADD KEY `fk_req_attachments_req` (`requirement_id`);

--
-- 表的索引 `requirement_comments`
--
ALTER TABLE `requirement_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_author` (`author`) USING BTREE,
  ADD KEY `fk_req_comments_req` (`requirement_id`),
  ADD KEY `fk_req_comments_parent` (`parent_id`);

--
-- 表的索引 `requirement_templates`
--
ALTER TABLE `requirement_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`) USING BTREE,
  ADD KEY `idx_is_system` (`is_system`) USING BTREE;

--
-- 表的索引 `requirement_time_logs`
--
ALTER TABLE `requirement_time_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_name` (`user_name`) USING BTREE,
  ADD KEY `idx_log_date` (`log_date`) USING BTREE,
  ADD KEY `fk_req_timelogs_req` (`requirement_id`);

--
-- 表的索引 `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`) USING BTREE,
  ADD KEY `idx_group_name` (`group_name`) USING BTREE;

--
-- 表的索引 `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_name` (`name`);

--
-- 表的索引 `technologies`
--
ALTER TABLE `technologies`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_key` (`user_key`) USING BTREE,
  ADD UNIQUE KEY `uk_openid` (`openid`) USING BTREE,
  ADD KEY `idx_nickname` (`nickname`) USING BTREE,
  ADD KEY `idx_user_type` (`user_type`) USING BTREE,
  ADD KEY `idx_status` (`status`) USING BTREE,
  ADD KEY `idx_create_time` (`create_time`) USING BTREE;

--
-- 表的索引 `user_certifications`
--
ALTER TABLE `user_certifications`
  ADD KEY `idx_user_id` (`user_id`);

--
-- 表的索引 `user_covers`
--
ALTER TABLE `user_covers`
  ADD KEY `idx_user_id` (`user_id`);

--
-- 表的索引 `user_entitlements`
--
ALTER TABLE `user_entitlements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_wx_order_id` (`wx_order_id`),
  ADD KEY `idx_openid_product` (`openid`,`product_id`);

--
-- 表的索引 `user_follows`
--
ALTER TABLE `user_follows`
  ADD UNIQUE KEY `uk_follow` (`follower_id`,`following_id`),
  ADD KEY `idx_following_id` (`following_id`);

--
-- 表的索引 `virtualpay_config`
--
ALTER TABLE `virtualpay_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_name` (`name`);

--
-- 表的索引 `virtual_pay_orders`
--
ALTER TABLE `virtual_pay_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_out_trade_no` (`out_trade_no`),
  ADD UNIQUE KEY `uk_wx_order_id` (`wx_order_id`),
  ADD KEY `idx_openid` (`openid`),
  ADD KEY `idx_deliver` (`deliver_status`,`create_time`);

--
-- 表的索引 `visit_logs`
--
ALTER TABLE `visit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ip` (`ip`),
  ADD KEY `idx_page` (`page`),
  ADD KEY `idx_device` (`device_type`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `virtualpay_config`
--
ALTER TABLE `virtualpay_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 限制导出的表
--

--
-- 限制表 `forum_board_members`
--
ALTER TABLE `forum_board_members`
  ADD CONSTRAINT `fk_board_members_board` FOREIGN KEY (`board_id`) REFERENCES `forum_boards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_board_members_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `forum_board_moderators`
--
ALTER TABLE `forum_board_moderators`
  ADD CONSTRAINT `fk_board_mods_board` FOREIGN KEY (`board_id`) REFERENCES `forum_boards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_board_mods_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `forum_posts`
--
ALTER TABLE `forum_posts`
  ADD CONSTRAINT `fk_posts_board` FOREIGN KEY (`board_id`) REFERENCES `forum_boards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_posts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `forum_post_comments`
--
ALTER TABLE `forum_post_comments`
  ADD CONSTRAINT `fk_post_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `forum_post_comments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_post_comments_post` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_post_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `forum_post_likes`
--
ALTER TABLE `forum_post_likes`
  ADD CONSTRAINT `fk_post_likes_post` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_post_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `fk_projects_category` FOREIGN KEY (`category_id`) REFERENCES `project_categories` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_projects_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- 限制表 `project_images`
--
ALTER TABLE `project_images`
  ADD CONSTRAINT `fk_project_images_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `project_tags`
--
ALTER TABLE `project_tags`
  ADD CONSTRAINT `fk_project_tags_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_project_tags_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- 限制表 `project_technologies`
--
ALTER TABLE `project_technologies`
  ADD CONSTRAINT `fk_project_tech_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_project_tech_technology` FOREIGN KEY (`technology_id`) REFERENCES `technologies` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- 限制表 `requirements`
--
ALTER TABLE `requirements`
  ADD CONSTRAINT `fk_requirements_assignee` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_requirements_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_requirements_template` FOREIGN KEY (`template_id`) REFERENCES `requirement_templates` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- 限制表 `requirement_attachments`
--
ALTER TABLE `requirement_attachments`
  ADD CONSTRAINT `fk_req_attachments_req` FOREIGN KEY (`requirement_id`) REFERENCES `requirements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `requirement_comments`
--
ALTER TABLE `requirement_comments`
  ADD CONSTRAINT `fk_req_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `requirement_comments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_req_comments_req` FOREIGN KEY (`requirement_id`) REFERENCES `requirements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `requirement_time_logs`
--
ALTER TABLE `requirement_time_logs`
  ADD CONSTRAINT `fk_req_timelogs_req` FOREIGN KEY (`requirement_id`) REFERENCES `requirements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `user_entitlements`
--
ALTER TABLE `user_entitlements`
  ADD CONSTRAINT `fk_entitlements_user` FOREIGN KEY (`openid`) REFERENCES `users` (`openid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `virtual_pay_orders`
--
ALTER TABLE `virtual_pay_orders`
  ADD CONSTRAINT `fk_vpay_user` FOREIGN KEY (`openid`) REFERENCES `users` (`openid`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
