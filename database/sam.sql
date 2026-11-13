/*
 Navicat Premium Dump SQL

 Source Server         : sam
 Source Server Type    : MySQL
 Source Server Version : 50738 (5.7.38-log)
 Source Host           : localhost:3306
 Source Schema         : sam

 Target Server Type    : MySQL
 Target Server Version : 50738 (5.7.38-log)
 File Encoding         : 65001

 Date: 13/10/2026 16:51:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_logs
-- ----------------------------
DROP TABLE IF EXISTS `admin_logs`;
CREATE TABLE `admin_logs`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_action`(`action`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin_logs
-- ----------------------------

-- ----------------------------
-- Table structure for admin_scan_tickets
-- ----------------------------
DROP TABLE IF EXISTS `admin_scan_tickets`;
CREATE TABLE `admin_scan_tickets`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '随机票据',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '确认后绑定的 webmaster 用户',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0待扫,1已确认,2已取消,3已使用',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ticket`(`ticket`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '后台扫码登录票据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin_scan_tickets
-- ----------------------------
INSERT INTO `admin_scan_tickets` VALUES (83, 'aee9bd289e5348792f3342f8c9ced9ef', NULL, 0, '2026-10-12 00:13:31', '2026-10-12 00:11:31');
INSERT INTO `admin_scan_tickets` VALUES (84, '13a16a6ca4f37a4e63f9c74cb5ba3629', NULL, 0, '2026-10-12 01:04:46', '2026-10-12 01:02:46');
INSERT INTO `admin_scan_tickets` VALUES (85, '43442035cbcc7d0b8f497f091261b8ca', NULL, 0, '2026-10-12 01:07:35', '2026-10-12 01:05:35');
INSERT INTO `admin_scan_tickets` VALUES (86, '7e9e0f18faa4fb453aa443a5e65906e5', NULL, 0, '2026-10-12 01:10:35', '2026-10-12 01:08:35');
INSERT INTO `admin_scan_tickets` VALUES (87, '1a685916e563134b0d15d353cd1ee245', NULL, 0, '2026-10-12 01:13:35', '2026-10-12 01:11:35');
INSERT INTO `admin_scan_tickets` VALUES (88, '4254968c31127d53d34177e81c6a2ffa', NULL, 0, '2026-10-12 01:16:35', '2026-10-12 01:14:35');
INSERT INTO `admin_scan_tickets` VALUES (89, 'e6d65162fce115901b91e99e510b08f3', NULL, 0, '2026-10-12 01:19:35', '2026-10-12 01:17:35');
INSERT INTO `admin_scan_tickets` VALUES (90, '1700f5409533e083669d71363b153ff3', NULL, 0, '2026-10-12 01:22:35', '2026-10-12 01:20:35');
INSERT INTO `admin_scan_tickets` VALUES (91, '441ff1d44f07404ccd742ed6005dcee6', NULL, 0, '2026-10-12 01:25:35', '2026-10-12 01:23:35');
INSERT INTO `admin_scan_tickets` VALUES (92, '98308c82660a0d781dffd5ce73856109', NULL, 0, '2026-10-12 12:40:54', '2026-10-12 12:38:54');
INSERT INTO `admin_scan_tickets` VALUES (93, '53b01dc0a00f595c2b732cd536e398c4', NULL, 0, '2026-10-12 12:49:11', '2026-10-12 12:47:11');
INSERT INTO `admin_scan_tickets` VALUES (94, 'f895400457051b5ba909d6c7889c221d', NULL, 0, '2026-10-12 12:49:15', '2026-10-12 12:47:15');
INSERT INTO `admin_scan_tickets` VALUES (95, 'a148227c8c4d4c31c536a59c3a053cac', NULL, 0, '2026-10-12 15:34:07', '2026-10-12 15:32:07');
INSERT INTO `admin_scan_tickets` VALUES (96, '36e0abf0a5ea9da5746a597c44a13051', NULL, 0, '2026-10-12 16:09:39', '2026-10-12 16:07:39');
INSERT INTO `admin_scan_tickets` VALUES (97, '1f65c88041af60690431ca6a3dddb153', NULL, 0, '2026-10-12 20:01:37', '2026-10-12 19:59:37');
INSERT INTO `admin_scan_tickets` VALUES (98, '8b835bb8c485dfbee8bf7d19a69f73df', NULL, 0, '2026-10-12 20:01:40', '2026-10-12 19:59:40');
INSERT INTO `admin_scan_tickets` VALUES (99, 'b32741bad16a0e16b1927a6daefd033c', NULL, 0, '2026-10-12 20:26:43', '2026-10-12 20:24:43');

-- ----------------------------
-- Table structure for announcements
-- ----------------------------
DROP TABLE IF EXISTS `announcements`;
CREATE TABLE `announcements`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '公告标题',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '公告内容',
  `type` enum('notice','activity','rule') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'notice' COMMENT '类型：notice通知,activity活动,rule规则',
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跳转链接（可空）',
  `is_top` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否置顶：0否,1是',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1显示,0隐藏',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_top_time`(`status`, `is_top`, `publish_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '官方公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of announcements
-- ----------------------------
INSERT INTO `announcements` VALUES ('a522911b-c0b3-11f1-8252-d853bc33c228', '创作者中心上线', '图文、视频、收益与粉丝数据看板已全部开放，欢迎反馈使用体验。', 'notice', NULL, 1, 1, '2026-10-05 19:55:22', '2026-10-05 19:55:22', '2026-10-05 19:55:22');
INSERT INTO `announcements` VALUES ('a52294f4-c0b3-11f1-8252-d853bc33c228', '内容审核标准说明', '涉及医疗、金融等表述需补充资质证明，否则将被驳回。请在发布前自查。', 'rule', NULL, 0, 1, '2026-10-05 19:55:22', '2026-10-05 19:55:22', '2026-10-05 19:55:22');
INSERT INTO `announcements` VALUES ('a52295cb-c0b3-11f1-8252-d853bc33c228', '本月创作激励活动', '本月发布 10 篇以上原创内容，可参与平台流量扶持与现金奖励。', 'activity', NULL, 0, 1, '2026-10-05 19:55:22', '2026-10-05 19:55:22', '2026-10-05 19:55:22');
INSERT INTO `announcements` VALUES ('b8be2f97-c0b3-11f1-8252-d853bc33c228', '创作者中心上线', '图文、视频、收益与粉丝数据看板已全部开放，欢迎反馈使用体验。', 'notice', NULL, 1, 1, '2026-10-05 19:55:55', '2026-10-05 19:55:55', '2026-10-05 19:55:55');
INSERT INTO `announcements` VALUES ('b8be32e9-c0b3-11f1-8252-d853bc33c228', '内容审核标准说明', '涉及医疗、金融等表述需补充资质证明，否则将被驳回。请在发布前自查。', 'rule', NULL, 0, 1, '2026-10-05 19:55:55', '2026-10-05 19:55:55', '2026-10-05 19:55:55');
INSERT INTO `announcements` VALUES ('b8be3378-c0b3-11f1-8252-d853bc33c228', '本月创作激励活动', '本月发布 10 篇以上原创内容，可参与平台流量扶持与现金奖励。', 'activity', NULL, 0, 1, '2026-10-05 19:55:55', '2026-10-05 19:55:55', '2026-10-05 19:55:55');

-- ----------------------------
-- Table structure for appeals
-- ----------------------------
DROP TABLE IF EXISTS `appeals`;
CREATE TABLE `appeals`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申诉人ID -> users.id',
  `target_type` enum('post','comment','video') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'post' COMMENT '申诉对象类型',
  `target_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申诉对象ID -> forum_posts.id',
  `target_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对象标题（冗余，便于列表展示）',
  `punish` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '处罚措施',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '违规类型/申诉理由',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '补充说明',
  `status` enum('processing','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'processing' COMMENT '状态：processing处理中,approved申诉通过,rejected申诉驳回',
  `result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '处理结果说明',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id`, `create_time`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '违规申诉表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of appeals
-- ----------------------------

-- ----------------------------
-- Table structure for contact_messages
-- ----------------------------
DROP TABLE IF EXISTS `contact_messages`;
CREATE TABLE `contact_messages`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `subject` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '主题',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `is_read` tinyint(1) NULL DEFAULT 0 COMMENT '是否已读:1已读,0未读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE,
  INDEX `idx_read`(`is_read`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '留言表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contact_messages
-- ----------------------------

-- ----------------------------
-- Table structure for earning_records
-- ----------------------------
DROP TABLE IF EXISTS `earning_records`;
CREATE TABLE `earning_records`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创作者ID -> users.id',
  `source` enum('article','video','reward','withdraw','adjust') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'article' COMMENT '来源：article图文创作,video视频创作,reward粉丝赞赏,withdraw提现,adjust平台调整',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '金额（正=收入,负=提现/调整）',
  `ref_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联ID（文章ID/提现单ID等）',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源说明',
  `settle_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '结算状态：0待结算,1已结算',
  `settle_time` datetime NULL DEFAULT NULL COMMENT '结算时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id`, `create_time`) USING BTREE,
  INDEX `idx_user_source`(`user_id`, `source`) USING BTREE,
  INDEX `idx_settle`(`settle_status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '创作者收益流水表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of earning_records
-- ----------------------------

-- ----------------------------
-- Table structure for forum_board_members
-- ----------------------------
DROP TABLE IF EXISTS `forum_board_members`;
CREATE TABLE `forum_board_members`  (
  `board_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '板块ID -> forum_boards',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`board_id`, `user_id`) USING BTREE,
  INDEX `fk_board_members_user`(`user_id`) USING BTREE,
  CONSTRAINT `fk_board_members_board` FOREIGN KEY (`board_id`) REFERENCES `forum_boards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_board_members_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '板块成员' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_board_members
-- ----------------------------

-- ----------------------------
-- Table structure for forum_board_moderators
-- ----------------------------
DROP TABLE IF EXISTS `forum_board_moderators`;
CREATE TABLE `forum_board_moderators`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `board_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '板块ID -> forum_boards',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '版主' COMMENT '角色:版主/副版主',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_board_user`(`board_id`, `user_id`) USING BTREE,
  INDEX `idx_board`(`board_id`) USING BTREE,
  INDEX `fk_board_mods_user`(`user_id`) USING BTREE,
  CONSTRAINT `fk_board_mods_board` FOREIGN KEY (`board_id`) REFERENCES `forum_boards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_board_mods_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '板块版主' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_board_moderators
-- ----------------------------
INSERT INTO `forum_board_moderators` VALUES ('fde4d550-bc99-11f1-b410-525400fdb9eb', 'fde45e09-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40');
INSERT INTO `forum_board_moderators` VALUES ('fde4d551-bc99-11f1-b410-525400fdb9eb', 'fde45e09-bc99-11f1-b410-525400fdb9eb', '4c02cc70-ac92-4289-a096-b7b610cc696d', '版主', '2026-09-28 23:08:40');
INSERT INTO `forum_board_moderators` VALUES ('fde4d727-bc99-11f1-b410-525400fdb9eb', 'fde46100-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '版主', '2026-09-28 23:08:40');

-- ----------------------------
-- Table structure for forum_boards
-- ----------------------------
DROP TABLE IF EXISTS `forum_boards`;
CREATE TABLE `forum_boards`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `board_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '板块标识(原 key, 避免保留字)',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '板块名称',
  `icon_text` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图标文字',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '板块简介',
  `color_bg` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '主题色-背景',
  `cover_image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '封面图',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '板块头像',
  `announcement` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '板块公告',
  `member_count` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '成员数',
  `post_count` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '帖子数',
  `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:1正常,0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_board_key`(`board_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '论坛板块' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_boards
-- ----------------------------
INSERT INTO `forum_boards` VALUES ('fde45e09-bc99-11f1-b410-525400fdb9eb', 'java', 'Java', 'Java', 'Java 语言与生态：并发、JVM、Spring Boot 实战', '#ff4c4c', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/java-banner.png', '', '欢迎来到 Java 板块，发帖请遵守社区规范，禁止广告与引战。', 0, 0, 1, 1, '2026-09-28 23:08:40', '2026-10-12 20:39:01');
INSERT INTO `forum_boards` VALUES ('fde46100-bc99-11f1-b410-525400fdb9eb', 'AICG', 'AICG', 'AICG', 'AICG（AI Generated Content）即人工智能生成内容，是当下数字创作的核心赛道。本板块聚焦AI视觉、AI绘画、AI漫剧、AI视频、AI创意素材全品类内容，汇集零基础创作教程、优质AI作品、实用生成技巧、Prompt模板与前沿玩法，为所有AI创作者提供一站式学习、创作与交流阵地。\n在这里，无需专业绘画、剪辑、建模基础，依靠AI工具即可快速产出高质量图文、动态短片、原创角色与创意视觉内容。我们覆盖多模态AI创作全场景：从文案脚本、人设绘制、分镜构图，到动态漫剧、视频生成、后期精修，打通从灵感构思到成品输出的完整创作链路。\n板块主打低门槛、高效率、可量产的创作理念，适配新手入门、创作者进阶、自媒体量产、个人兴趣创作等多元需求。无论是二次元插画、写实视觉、创意海报，还是AI漫剧、短视频剧情内容，均可在这里找到可落地的创作方法与优质参考案例。\n欢迎加入 AICG 创作社区，用AI释放创意，以技术赋能创作，人人皆可实现「所想即所得」的数字创作自由。', '#6366F1', '/spark/app/app_17ew17qamgs/runtime/api/v1/storage/object/obj_xptdhtg5f1ig/default/Posts/ai-banner.png', '/static/images/forum/forum_6accd0cb473a9.png', 'AI 板块探讨大模型落地实践，禁止搬运未授权内容。', 0, 1, 5, 1, '2026-09-28 23:08:40', '2026-10-12 20:21:33');

-- ----------------------------
-- Table structure for forum_post_comments
-- ----------------------------
DROP TABLE IF EXISTS `forum_post_comments`;
CREATE TABLE `forum_post_comments`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `post_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论者 -> users',
  `parent_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回复的评论ID -> forum_post_comments (自引用)',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '评论内容',
  `like_count` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:1正常,0删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post`(`post_id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE,
  CONSTRAINT `fk_post_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `forum_post_comments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_post_comments_post` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子评论' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_post_comments
-- ----------------------------
INSERT INTO `forum_post_comments` VALUES ('1aa72072-0247-46aa-818a-dad70cd0f1f3', 'bc5790bf-baf6-43ec-a676-bb3e51fa8883', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '99e7ed3b-28d1-4742-b7a9-b6b9e93a1130', '感谢支持', 0, 1, '2026-10-13 15:19:43');
INSERT INTO `forum_post_comments` VALUES ('99e7ed3b-28d1-4742-b7a9-b6b9e93a1130', 'bc5790bf-baf6-43ec-a676-bb3e51fa8883', '4c02cc70-ac92-4289-a096-b7b610cc696d', NULL, '写的真好', 0, 1, '2026-10-12 16:35:19');
INSERT INTO `forum_post_comments` VALUES ('b9222b9a-4ebb-4653-a8e2-8a36062ed764', 'bc5790bf-baf6-43ec-a676-bb3e51fa8883', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', NULL, '占楼', 0, 1, '2026-10-13 15:20:17');
INSERT INTO `forum_post_comments` VALUES ('be43730d-9c38-4187-aa62-2e40917c46b0', 'bc5790bf-baf6-43ec-a676-bb3e51fa8883', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '99e7ed3b-28d1-4742-b7a9-b6b9e93a1130', '感谢支持', 0, 1, '2026-10-13 15:20:10');

-- ----------------------------
-- Table structure for forum_post_likes
-- ----------------------------
DROP TABLE IF EXISTS `forum_post_likes`;
CREATE TABLE `forum_post_likes`  (
  `post_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`post_id`, `user_id`) USING BTREE,
  INDEX `fk_post_likes_user`(`user_id`) USING BTREE,
  CONSTRAINT `fk_post_likes_post` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子点赞' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_post_likes
-- ----------------------------
INSERT INTO `forum_post_likes` VALUES ('16e3acee-4fc4-43f9-9d51-4538209526e5', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '2026-10-01 22:23:55');
INSERT INTO `forum_post_likes` VALUES ('bc5790bf-baf6-43ec-a676-bb3e51fa8883', '4c02cc70-ac92-4289-a096-b7b610cc696d', '2026-10-12 15:59:14');

-- ----------------------------
-- Table structure for forum_post_purchases
-- ----------------------------
DROP TABLE IF EXISTS `forum_post_purchases`;
CREATE TABLE `forum_post_purchases`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `post_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts(id)',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '购买用户 -> users(id)',
  `coins` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '本次支付的金币数(=帖子 coin_price)',
  `settle_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '结算状态:0未结算,1已结算,2已退款',
  `settle_amount` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结算给作者的金币(扣除平台佣金后)',
  `settle_time` datetime NULL DEFAULT NULL COMMENT '结算时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '购买时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_post_user`(`post_id`, `user_id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_settle`(`settle_status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '论坛付费帖子购买记录(金币)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_post_purchases
-- ----------------------------

-- ----------------------------
-- Table structure for forum_posts
-- ----------------------------
DROP TABLE IF EXISTS `forum_posts`;
CREATE TABLE `forum_posts`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容ID(UUID)',
  `board_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属板块 -> forum_boards',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者 -> users',
  `type` enum('image_text','video') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image_text' COMMENT '类型:image_text图文,video视频',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标题',
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '摘要',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '正文(Markdown)',
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分类标识',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标签, 逗号分隔',
  `cover_images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '封面图 JSON 数组',
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频地址(type=video)',
  `duration` int(11) NOT NULL DEFAULT 0 COMMENT '视频时长(秒)',
  `views` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `comment_count` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论数',
  `like_count` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `is_essence` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否精华',
  `is_pinned` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否置顶',
  `is_paid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否付费资源:1是,0否',
  `coin_price` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '付费金币价格',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'approved' COMMENT '状态:draft/pending/approved/rejected/offline',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_board`(`board_id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_pinned`(`is_pinned`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_create`(`create_time`) USING BTREE,
  CONSTRAINT `fk_posts_board` FOREIGN KEY (`board_id`) REFERENCES `forum_boards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_posts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '内容表(图文/视频/论坛帖子统一为一物)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_posts
-- ----------------------------
INSERT INTO `forum_posts` VALUES ('bc5790bf-baf6-43ec-a676-bb3e51fa8883', 'fde46100-bc99-11f1-b410-525400fdb9eb', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'image_text', 'AI漫剧零基础入门指南', '一、什么是AI漫剧？ 漫剧：结合「漫画画面+剧情配音+字幕+镜头动画+背景音乐」的短视频形式，介于静态漫画和真人短剧之间，节奏快、故事性强、观赏性高。 AI漫剧：全程借助AI工具，自动/半自动', '## 一、什么是AI漫剧？\n\n**漫剧**：结合「漫画画面+剧情配音+字幕+镜头动画+背景音乐」的短视频形式，介于静态漫画和真人短剧之间，节奏快、故事性强、观赏性高。\n\n**AI漫剧**：全程借助AI工具，自动/半自动完成**脚本撰写、画面生成、人物建模、配音、字幕、剪辑动效**，无需手绘、无需真人出镜，零基础、低门槛、高效率制作漫剧。\n\n### AI漫剧核心特点\n\n- **成本极低**：不用画师、不用演员、不用搭建场景，大幅降低创作和制作成本\n\n- **出片极快**：单集1\\-3分钟的漫剧，熟练后30分钟\\-2小时即可完成制作\n\n- **风格统一**：AI固定人物人设、画风，全程画面不崩坏、风格不跑偏\n\n- **受众广泛**：适配抖音、快手、小红书、B站、视频号等全平台流量\n\n- **题材自由**：言情、玄幻、悬疑、校园、古风、都市爽文等均可制作\n\n## 二、新手必懂的基础术语\n\n- **人设**：角色的外貌、发型、穿搭、性格、固定画风，是漫剧统一画面的核心\n\n- **分镜**：单集剧情的镜头拆分，包含画面内容、人物动作、场景、台词、镜头角度\n\n- **口播配音**：AI智能配音，支持多角色音色切换，替代真人配音\n\n- **微动效**：AI画面动态效果，比如人物眨眼、点头、发丝飘动、镜头推拉，避免画面僵硬\n\n- **卡点**：字幕、配音、背景音乐、镜头切换节奏同步，提升观看质感\n\n## 三、新手必备AI工具清单（免费\\+低成本）\n\n无需全套掌握，新手优先搭配「1套基础组合」即可起步\n\n### 1. 脚本写作工具（写剧情、分镜）\n\n- **通用工具**：ChatGPT、豆包、文心一言\n\n- **用途**：生成原创剧情、改写爽文剧本、拆分镜头分镜、优化台词\n\n- **新手技巧**：直接输入提示词，指定「漫剧风格、单集时长、剧情反转、人物设定」，一键出脚本\n\n### 2. AI漫剧画面生成工具（核心）\n\n- **专项工具**：即梦AI、无界AI、漫剧AI、皮皮AI漫剧\n\n- **通用绘图工具**：Midjourney、Stable Diffusion（进阶精细化画风）\n\n- **核心功能**：生成统一人设、场景画面、漫画分镜图，支持风格锁定\n\n### 3. AI配音工具\n\n- **常用工具**：剪映AI配音、讯飞配音、滴答配音\n\n- **优势**：多音色、男女老少角色全覆盖、情绪配音（甜妹、冷峻、霸气、温柔），支持批量生成\n\n### 4. 剪辑合成工具（新手首选）\n\n- **必备工具**：剪映（电脑端/手机端，完全免费）\n\n- **用途**：拼接画面、添加微动效、自动字幕、搭配BGM、转场调色、导出成片\n\n## 四、AI漫剧完整制作流程（新手照着做）\n\n整套流程分为**脚本→人设→画面→配音→剪辑→导出**6步，零基础可直接复刻\n\n### 第一步：确定题材，撰写单集脚本\n\n先定题材和核心人设，再生成短视频适配的短平快剧本，拒绝冗长铺垫。\n\n**新手万能提示词**：\n\n> 请帮我写一集1分钟AI漫剧脚本，题材为【都市爽文】，风格轻松解压，单集有铺垫\\+反转，人物2个，台词简洁，拆分8个镜头，标注每个镜头的画面内容、人物动作、台词，适配短视频节奏。\n> \n> \n\n### 第二步：固定全局人设（最关键）\n\n漫剧最大的痛点是**人物画风混乱**，新手第一步必须锁定人设：\n\n1. 用AI生成主角、配角的固定形象（脸型、发型、穿搭、身高、画风）\n\n2. 保存人设原图，后续所有镜头均「参考人设生成」，保证全程统一\n\n3. 确定画风：日系漫画、国漫写实、Q版、甜宠扁平风等，全程不更换\n\n### 第三步：AI生成分镜画面\n\n根据脚本的8-12个镜头，逐一生成对应场景、动作、表情的漫画画面。\n\n**画面生成核心要点**：\n\n- 画面比例统一：短视频优先 **9:16 竖屏**\n\n- 单镜头单画面，避免一镜到底，镜头切换越频繁，观感越流畅\n\n- 搭配表情变化：开心、愤怒、委屈、冷漠，贴合台词情绪\n\n### 第四步：AI批量配音\n\n1. 将脚本台词复制到配音工具，按角色分配音色\n\n2. 调整语速：短视频语速稍快（1.1-1.2倍），避免拖沓\n\n3. 导出高清音频，保存备用\n\n### 第五步：剪映合成成片（新手核心步骤）\n\n1. **导入素材**：全部漫画画面、配音音频\n\n2. **自动字幕**：剪映自动识别音频生成字幕，微调错别字\n\n3. **添加动效**：给画面加轻微缩放、平移、眨眼微动效，告别静态图片\n\n4. **搭配音效BGM**：根据剧情加氛围感背景音乐、转场音效、情绪音效\n\n5. **转场调色**：统一滤镜，添加轻微转场，画面质感更统一\n\n### 第六步：导出发布\n\n导出参数：1080P分辨率、60帧、高清码率，适配全平台发布。\n\n## 五、新手常见踩坑避坑指南\n\n- **坑1：人物每集画风不一样** → 解决：首次生成人设后保存原图，所有镜头复用人设参考\n\n- **坑2：剧情拖沓没人看** → 解决：单集必须有冲突、反转、悬念，开头3秒抓眼球\n\n- **坑3：画面僵硬像PPT** → 解决：多加微动效、镜头推拉，缩短单镜头时长（1\\-3秒最佳）\n\n- **坑4：字幕杂乱** → 解决：统一字幕字体、大小、颜色，台词分行简洁不拥挤\n\n- **坑5：BGM盖过人声** → 解决：背景音乐音量调低30%\\-40%，保证人声清晰\n\n## 六、新手快速进阶练习路线\n\n1. **第一周：熟悉流程**：跟着教程复刻1集简单短篇漫剧，熟练工具操作\n\n2. **第二周：固定画风人设**：打造专属固定角色，练习多镜头画面统一\n\n3. **第三周：优化剧情节奏**：学习写爽点、反转、悬念脚本，提升完播率\n\n4. **第四周：精细化剪辑**：精进动效、音效、调色，做出精品质感漫剧\n\n## 七、适合新手的热门题材\n\n流量稳定、制作难度低、受众广，新手优先选择：\n\n- 都市爽文、逆袭打脸、职场逆袭\n\n- 甜宠恋爱、校园暗恋、古风言情\n\n- 短篇悬疑、细思极恐、灵异小故事\n\n- 治愈日常、搞笑沙雕、脑洞短篇\n\n## 八、入门总结\n\nAI漫剧的核心优势是**低门槛、高效率、可量产**，零基础新手不用纠结技术，先完成再完美。掌握「脚本→人设→画面→配音→剪辑」的标准化流程，就能稳定产出可发布的漫剧视频，后续只需优化画风、剧情节奏和剪辑细节，即可快速提升作品质量和流量。\n\n', 'AICG', '', '', '', 0, 57, 4, 1, 0, 0, 1, 2, 'approved', NULL, NULL, '2026-10-12 00:48:40', '2026-10-13 16:49:06');

-- ----------------------------
-- Table structure for menus
-- ----------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT 0 COMMENT '父级ID，0表示分组',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图标(kebab名)',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由路径，分组可为空',
  `role` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '可见角色code，逗号分隔，空=全部',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1显示0隐藏',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE,
  INDEX `idx_role`(`role`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of menus
-- ----------------------------
INSERT INTO `menus` VALUES (1, 0, '常用功能', '', '', 'admin', 0, 1, '2026-10-05 13:27:57', '2026-10-10 15:54:18');
INSERT INTO `menus` VALUES (2, 0, '用户管理', '', '', 'admin', 3, 1, '2026-10-05 13:27:57', '2026-10-10 15:54:46');
INSERT INTO `menus` VALUES (3, 1, '概览', 'dashboard-fill', '/admin', 'admin', 1, 1, '2026-10-05 13:27:57', '2026-10-10 15:49:50');
INSERT INTO `menus` VALUES (4, 62, '帖子列表', 'news-fill', '/admin/content', 'admin', 2, 1, '2026-10-05 13:27:57', '2026-10-10 15:53:56');
INSERT INTO `menus` VALUES (5, 2, '创作者管理', 'user-community-fill', '/admin/creators', 'admin', 1, 1, '2026-10-05 13:27:57', '2026-10-10 15:50:36');
INSERT INTO `menus` VALUES (6, 2, '用户管理', 'user-settings-fill', '/admin/users', 'admin', 2, 1, '2026-10-05 13:27:57', '2026-10-10 15:50:56');
INSERT INTO `menus` VALUES (7, 15, '系统设置', 'settings2-fill', '/admin/settings', 'admin', 3, 1, '2026-10-05 13:27:57', '2026-10-10 15:52:03');
INSERT INTO `menus` VALUES (10, 18, '板块列表', 'ai-generate3d-fill', '/admin/boards', 'admin', 1, 1, '2026-10-10 13:21:02', '2026-10-10 15:57:17');
INSERT INTO `menus` VALUES (11, 18, '板块审核', 'check-double-fill', '/admin/board-review', 'admin', 2, 1, '2026-10-10 13:32:43', '2026-10-10 15:56:30');
INSERT INTO `menus` VALUES (15, 0, '系统管理', '', '', 'admin', 5, 1, '2026-10-05 13:49:44', '2026-10-10 15:54:59');
INSERT INTO `menus` VALUES (16, 15, '角色管理', 'shield-user-fill', '/admin/roles', 'admin', 1, 1, '2026-10-05 13:49:44', '2026-10-10 15:58:57');
INSERT INTO `menus` VALUES (17, 15, '菜单管理', 'layout-left-fill', '/admin/menus', 'admin', 2, 1, '2026-10-05 13:49:44', '2026-10-10 15:59:22');
INSERT INTO `menus` VALUES (18, 0, '版块', '', '', 'admin', 2, 1, '2026-10-10 13:32:43', '2026-10-10 15:54:31');
INSERT INTO `menus` VALUES (20, 0, '工作台', '', '', 'creator', 1, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (21, 20, '概览', 'dashboard-fill', '/creator', 'creator', 1, 1, '2026-10-05 14:17:02', '2026-10-11 16:23:34');
INSERT INTO `menus` VALUES (22, 0, '内容创作', '', '', 'creator', 2, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (23, 22, '我的帖子', 'news-fill', '/creator/articles', 'creator', 1, 1, '2026-10-05 14:17:02', '2026-10-11 23:27:00');
INSERT INTO `menus` VALUES (24, 22, '我的视频', 'video-fill', '/creator/videos', 'creator', 2, 1, '2026-10-05 14:17:02', '2026-10-11 16:24:05');
INSERT INTO `menus` VALUES (25, 22, '草稿箱', 'draft-fill', '/creator/drafts', 'creator', 3, 1, '2026-10-05 14:17:02', '2026-10-11 16:25:17');
INSERT INTO `menus` VALUES (27, 0, '数据分析', '', '', 'creator', 3, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (28, 27, '内容数据', 'bar-chart', '/creator/content-stats', 'creator', 1, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (29, 27, '粉丝画像', 'user-heart', '/creator/fans', 'creator', 2, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (31, 0, '互动管理', '', '', 'creator', 4, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (32, 31, '评论管理', 'chat-3', '/creator/comments', 'creator', 1, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (33, 31, '私信留言', 'mail-send', '/creator/messages', 'creator', 2, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (34, 31, '违规申诉', 'shield-check', '/creator/appeals', 'creator', 3, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (35, 0, '变现中心', '', '', 'creator', 5, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (36, 35, '收益概览', 'money-cny-circle', '/creator/earnings', 'creator', 1, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (37, 35, '提现记录', 'bank-card', '/creator/withdraw', 'creator', 2, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (38, 35, '付费订单', 'shopping-bag', '/creator/orders', 'creator', 3, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (39, 0, '账号设置', '', '', 'creator', 6, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (40, 39, '个人资料', 'user', '/creator/profile', 'creator', 1, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (41, 39, '实名认证', 'shield-user', '/creator/verify', 'creator', 2, 1, '2026-10-05 14:17:02', '2026-10-05 14:17:02');
INSERT INTO `menus` VALUES (42, 39, '绑定账号', 'accessibility-line', '/creator/bind', 'creator', 3, 1, '2026-10-05 14:17:02', '2026-10-05 19:03:08');
INSERT INTO `menus` VALUES (51, 2, '认证审核', 'user-follow-fill', '/admin/certifications', 'admin', 3, 1, '2026-10-10 13:48:00', '2026-10-10 15:58:12');
INSERT INTO `menus` VALUES (60, 2, '封面审核', 'image-ai-fill', '/admin/cover-review', 'admin', 4, 1, '2026-10-10 15:47:59', '2026-10-10 15:55:37');
INSERT INTO `menus` VALUES (61, 2, '资料审核', 'id-card-fill', '/admin/profile-review', 'admin', 5, 1, '2026-10-10 15:47:59', '2026-10-10 15:55:49');
INSERT INTO `menus` VALUES (62, 0, '帖子', '', '', 'admin', 1, 1, '2026-10-10 15:53:48', '2026-10-10 15:54:25');

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接收通知的用户 -> users.id',
  `sender_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '触发者 -> users.id；系统通知为 NULL',
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system' COMMENT '通知类型:comment评论,like点赞,at@提及,follow关注,system系统',
  `action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '动作文案，如「评论了你的帖子」',
  `snippet` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '摘要/引用内容（帖子标题、评论片段等）',
  `target_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跳转目标类型:post帖子,comment评论,user用户',
  `target_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跳转目标ID（帖子/评论/用户ID）',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读:0未读,1已读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '读取时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`, `is_read`, `create_time`) USING BTREE,
  INDEX `idx_sender`(`sender_id`) USING BTREE,
  CONSTRAINT `fk_notifications_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户通知（互动提醒）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notifications
-- ----------------------------
INSERT INTO `notifications` VALUES ('01e584ab-d2fe-46f1-ab38-a85c86a8f570', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '4c02cc70-ac92-4289-a096-b7b610cc696d', 'like', '赞了你的帖子', 'AI漫剧零基础入门指南', 'post', 'bc5790bf-baf6-43ec-a676-bb3e51fa8883', 1, '2026-10-12 16:31:00', '2026-10-12 15:59:14');
INSERT INTO `notifications` VALUES ('031ac2a8-dfae-487d-b703-e73dd37a315d', '4c02cc70-ac92-4289-a096-b7b610cc696d', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'comment', '回复了你的评论', '感谢支持', 'comment', 'be43730d-9c38-4187-aa62-2e40917c46b0', 0, NULL, '2026-10-13 15:20:10');
INSERT INTO `notifications` VALUES ('4818b9ce-1fbf-440e-bfb8-4fe1c0da4a13', '4c02cc70-ac92-4289-a096-b7b610cc696d', NULL, 'system', '资料审核已通过', '新的个人资料已生效', NULL, NULL, 1, '2026-10-12 15:54:24', '2026-10-12 15:51:49');
INSERT INTO `notifications` VALUES ('96e15eb9-400a-4d28-b65c-f164ecc51e4b', '4c02cc70-ac92-4289-a096-b7b610cc696d', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'comment', '回复了你的评论', '感谢支持', 'comment', '1aa72072-0247-46aa-818a-dad70cd0f1f3', 0, NULL, '2026-10-13 15:19:43');
INSERT INTO `notifications` VALUES ('9e96e9b5-e506-4cd0-a08e-705c658f6a8b', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '4c02cc70-ac92-4289-a096-b7b610cc696d', 'comment', '评论了你的帖子', '写的真好', 'post', 'bc5790bf-baf6-43ec-a676-bb3e51fa8883', 1, '2026-10-12 16:36:48', '2026-10-12 16:35:19');

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色标识：admin/creator',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1启用0禁用',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '默认注册角色：1=小程序新注册用户自动分配，全局仅一个',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, '管理员', 'admin', '', 1, 0, 0, '2026-10-05 13:27:57', '2026-10-05 13:27:57');
INSERT INTO `roles` VALUES (2, '创作者', 'creator', '', 1, 0, 0, '2026-10-05 13:27:57', '2026-10-10 16:20:57');
INSERT INTO `roles` VALUES (3, '用户', 'user', '默认注册用户', 1, 0, 1, '2026-10-10 16:11:18', '2026-10-10 16:20:57');

-- ----------------------------
-- Table structure for user_certifications
-- ----------------------------
DROP TABLE IF EXISTS `user_certifications`;
CREATE TABLE `user_certifications`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users.id',
  `type` enum('personal','enterprise','official') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'personal' COMMENT '认证类型：personal个人认证,enterprise企业认证,official官方账号',
  `cert_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '认证名称(展示昵称/企业名/账号名)',
  `status` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '审核状态：pending待审核,approved已通过,rejected已驳回',
  `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '真实姓名(个人认证)',
  `id_card` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号(个人认证)',
  `company_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '企业名称(企业认证)',
  `license_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '统一社会信用代码/营业执照号(企业认证)',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系手机号',
  `materials` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '认证材料图片URL(JSON数组)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '认证说明',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户认证表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_certifications
-- ----------------------------

-- ----------------------------
-- Table structure for user_covers
-- ----------------------------
DROP TABLE IF EXISTS `user_covers`;
CREATE TABLE `user_covers`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users.id',
  `image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '封面图URL(相对 /static 路径)',
  `status` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '审核状态：pending待审核,approved已通过,rejected已驳回',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户封面表(需审核)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_covers
-- ----------------------------
INSERT INTO `user_covers` VALUES ('4228d5e1-927b-4728-a8ee-75ba32f99b9c', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', '/static/images/cover/cover_6abce3e71f742.png', 'approved', NULL, NULL, '2026-09-30 18:26:47', '2026-09-30 18:32:44');

-- ----------------------------
-- Table structure for user_favorites
-- ----------------------------
DROP TABLE IF EXISTS `user_favorites`;
CREATE TABLE `user_favorites`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `post_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_post`(`user_id`, `post_id`) USING BTREE,
  INDEX `idx_post`(`post_id`) USING BTREE,
  CONSTRAINT `fk_fav_post` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fav_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户收藏夹' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_favorites
-- ----------------------------

-- ----------------------------
-- Table structure for user_messages
-- ----------------------------
DROP TABLE IF EXISTS `user_messages`;
CREATE TABLE `user_messages`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `conversation_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '会话ID（双方ID字典序md5）',
  `from_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送者 -> users.id',
  `to_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接收者 -> users.id',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '消息内容',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读:0未读,1已读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '读取时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_conversation`(`conversation_id`) USING BTREE,
  INDEX `idx_to_read`(`to_id`, `is_read`) USING BTREE,
  INDEX `fk_user_messages_from`(`from_id`) USING BTREE,
  CONSTRAINT `fk_user_messages_from` FOREIGN KEY (`from_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_messages_to` FOREIGN KEY (`to_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '站内私信' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_messages
-- ----------------------------

-- ----------------------------
-- Table structure for user_profile_pending
-- ----------------------------
DROP TABLE IF EXISTS `user_profile_pending`;
CREATE TABLE `user_profile_pending`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联 users.id',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `gender` tinyint(1) NULL DEFAULT 0 COMMENT '性别：0未知，1男，2女',
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '国家',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市',
  `code_age` int(11) NULL DEFAULT NULL COMMENT '码龄',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `github` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'GitHub',
  `web_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '个人网站',
  `status` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '快照审核状态',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '驳回原因',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户资料待审快照' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_profile_pending
-- ----------------------------
INSERT INTO `user_profile_pending` VALUES ('1eb97147-d58e-411e-b9d9-c933c1ccd35e', '4c02cc70-ac92-4289-a096-b7b610cc696d', '小伊伊', '/static/images/avatar/avatar_6acc918403d28.jpeg', 0, '', '', '', NULL, NULL, NULL, NULL, 'approved', '', '2026-10-12 15:51:38', '2026-10-12 15:51:49');

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联 users.id',
  `role_id` int(11) NOT NULL COMMENT '关联 roles.id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id`, `role_id`) USING BTREE,
  INDEX `idx_role`(`role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户-角色关联（支持多角色）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES ('2ab86442-6d04-4f56-ad23-781691783aff', '2d17e117-90cd-42d5-948b-eebdbff844b5', 3, '2026-10-12 15:22:56');
INSERT INTO `user_roles` VALUES ('3545901a-b1c2-464e-bab5-61394033cae3', 'ee66761c-a802-401d-ae42-bd350e9bd9e3', 3, '2026-10-12 15:23:22');
INSERT INTO `user_roles` VALUES ('53ce66ee-8d15-43d1-94c0-e457f73c21c4', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 2, '2026-10-10 16:23:23');
INSERT INTO `user_roles` VALUES ('53fd405e-dd46-4fab-8b5b-39b3fce2d1ca', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 1, '2026-10-10 16:23:23');
INSERT INTO `user_roles` VALUES ('5acf1b84-f09d-4287-b12f-e5926072da2f', '4c02cc70-ac92-4289-a096-b7b610cc696d', 3, '2026-10-12 15:51:38');
INSERT INTO `user_roles` VALUES ('60dc9024-db59-4cdf-ab69-58360848db01', 'e1bc61bf-0d6c-4e6e-bb89-42fdfb72cb47', 3, '2026-10-12 15:42:32');
INSERT INTO `user_roles` VALUES ('617ace2b-87b2-412c-9a71-d2bea7551018', '52e726a4-1742-4e2a-8bcc-e9f0a4d8188d', 3, '2026-10-12 15:26:17');
INSERT INTO `user_roles` VALUES ('67e56dca-abea-4b12-9800-b008d35b3143', '11488101-68c7-4037-b997-16537ee9c160', 3, '2026-10-12 15:37:19');
INSERT INTO `user_roles` VALUES ('9b875849-c482-11f1-9bad-d853bc33c228', 'd1f076cf-f2e3-4541-b323-01bf62c33273', 2, '2026-10-10 16:14:27');

-- ----------------------------
-- Table structure for user_view_history
-- ----------------------------
DROP TABLE IF EXISTS `user_view_history`;
CREATE TABLE `user_view_history`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users',
  `post_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最近浏览时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_post`(`user_id`, `post_id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `fk_hist_post`(`post_id`) USING BTREE,
  CONSTRAINT `fk_hist_post` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_hist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户浏览历史(每帖仅保留最近一条)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_view_history
-- ----------------------------
INSERT INTO `user_view_history` VALUES ('cdd59b15-0691-45bc-aab4-4e788dbf4df5', 'fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'bc5790bf-baf6-43ec-a676-bb3e51fa8883', '2026-10-13 16:49:06');

-- ----------------------------
-- Table structure for user_wallet
-- ----------------------------
DROP TABLE IF EXISTS `user_wallet`;
CREATE TABLE `user_wallet`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users(id)，一对一',
  `balance` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '金币余额',
  `frozen` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '冻结金币(待结算/冻结中)',
  `total_earned` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '累计获得金币',
  `total_spent` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '累计消费金币',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户钱包(金币)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_wallet
-- ----------------------------
INSERT INTO `user_wallet` VALUES ('0216779d-94a5-4096-974c-a8d2a6746127', '2d17e117-90cd-42d5-948b-eebdbff844b5', 0, 0, 0, 0, '2026-10-12 15:22:56', '2026-10-12 15:22:56');
INSERT INTO `user_wallet` VALUES ('1dcb960c-cd2d-4bbb-a353-49c4b148f9da', '11488101-68c7-4037-b997-16537ee9c160', 0, 0, 0, 0, '2026-10-12 15:37:19', '2026-10-12 15:37:19');
INSERT INTO `user_wallet` VALUES ('54d6957c-311b-40c2-882b-5ff50bea2942', '4c02cc70-ac92-4289-a096-b7b610cc696d', 0, 0, 0, 0, '2026-10-12 15:51:38', '2026-10-12 15:51:38');
INSERT INTO `user_wallet` VALUES ('9a27e7a6-9b0b-48ed-8e8c-f836ac0829c9', '52e726a4-1742-4e2a-8bcc-e9f0a4d8188d', 0, 0, 0, 0, '2026-10-12 15:26:17', '2026-10-12 15:26:17');
INSERT INTO `user_wallet` VALUES ('a8354b41-a1c3-4f41-902b-8384a9f3907b', 'd1f076cf-f2e3-4541-b323-01bf62c33273', 99, 0, 0, 1, '2026-10-02 16:39:54', '2026-10-02 16:40:25');
INSERT INTO `user_wallet` VALUES ('c4c0b2b4-0a2f-47e5-a2b8-1e44206bf2e3', 'e1bc61bf-0d6c-4e6e-bb89-42fdfb72cb47', 0, 0, 0, 0, '2026-10-12 15:42:32', '2026-10-12 15:42:32');
INSERT INTO `user_wallet` VALUES ('c8f30b84-2b3c-4cb6-892b-7c055adc826b', 'ee66761c-a802-401d-ae42-bd350e9bd9e3', 0, 0, 0, 0, '2026-10-12 15:23:22', '2026-10-12 15:23:22');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '微信openid',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '后台密码登录(bcrypt 哈希)；仅 webmaster 设置，普通用户为空',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图URL',
  `gender` tinyint(1) NULL DEFAULT 0 COMMENT '性别：0未知，1男，2女',
  `code_age` int(11) NOT NULL COMMENT '码龄',
  `language` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'zh_CN' COMMENT '语言',
  `role_id` int(11) NOT NULL DEFAULT 0 COMMENT '角色ID，关联 roles.id',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `qq` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'QQ号',
  `wechat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '微信号',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'JWT token',
  `github` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'GitHub地址',
  `weibo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '微博地址',
  `douyin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '抖音号',
  `web_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '个人网站',
  `token_expire_time` datetime NULL DEFAULT NULL COMMENT 'token过期时间',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '国家',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '城市',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `profile_status` enum('approved','pending','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'approved' COMMENT '资料审核状态：approved通过/pending待审/rejected驳回',
  `profile_reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '资料驳回原因',
  `profile_audit_time` datetime NULL DEFAULT NULL COMMENT '资料审核时间',
  `user_type` enum('visitor','customer','webmaster') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'visitor' COMMENT '用户类型',
  `visit_count` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '访问次数',
  `like_count` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '被点赞数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_nickname`(`nickname`) USING BTREE,
  UNIQUE INDEX `uk_openid`(`openid`) USING BTREE,
  INDEX `idx_nickname`(`nickname`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '统一用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('4c02cc70-ac92-4289-a096-b7b610cc696d', 'ocAWa4obXLQHYrrxIKUg2nOEB8lU', '小伊伊', NULL, '/static/images/avatar/avatar_6acc918403d28.jpeg', NULL, 0, 0, 'zh_CN', 3, NULL, NULL, NULL, NULL, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3OTE4MTE0MDAsImV4cCI6MTc5MjQxNjIwMCwibmJmIjoxNzkxODExNDAwLCJ1c2VyX2lkIjoiNGMwMmNjNzAtYWM5Mi00Mjg5LWEwOTYtYjdiNjEwY2M2OTZkIiwidHlwZSI6InVzZXIifQ.3bJc9xVOA2GlvmlhM07iYmHjcks2j1A_jxK65vg1C6w', NULL, NULL, NULL, NULL, '2026-10-19 21:23:20', 1, '2026-10-12 21:23:20', NULL, '2026-10-12 15:51:38', '2026-10-12 21:23:20', '', '', '', NULL, 'approved', '', '2026-10-12 15:51:49', 'visitor', 0, 0);
INSERT INTO `users` VALUES ('fdeaf46a-bc99-11f1-b410-525400fdb9eb', 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'Sam', '$2y$10$8uAeGf.x8wkDN51dgB/2SubZC611I05YJLKvTjvE/pk28A.qQdzmC', '/static/images/avatar/avatar_6a0c19fb10da5.jpg', '/static/images/cover/cover_6a0c1a18a9001.jpg', 0, 9, 'zh_CN', 1, 'cto@cvun.net', '15993113751', '21312314', 'cto-sam', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3OTE4Nzk1ODMsImV4cCI6MTc5MjQ4NDM4MywibmJmIjoxNzkxODc5NTgzLCJ1c2VyX2lkIjoiZmRlYWY0NmEtYmM5OS0xMWYxLWI0MTAtNTI1NDAwZmRiOWViIiwidHlwZSI6InVzZXIifQ.vfS9QtUMow9Schi2pSxUCEGKsxClrTPgSyVHZUSo_nc', 'https://github.com/Juveniles-Full-Stack-Developer', NULL, '47305446676', '', '2026-10-20 16:19:43', 1, '2026-10-13 16:19:43', '127.0.0.1', '2025-09-02 03:34:25', '2026-10-13 16:19:43', '', '', '', '河南省郑州市', 'approved', '', NULL, 'visitor', 0, 0);

-- ----------------------------
-- Table structure for virtual_pay_orders
-- ----------------------------
DROP TABLE IF EXISTS `virtual_pay_orders`;
CREATE TABLE `virtual_pay_orders`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务单号(全局唯一)',
  `wx_order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '平台单号(幂等/对账)',
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户 openid -> users(openid)',
  `product_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '道具 ID',
  `product_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '道具名称快照',
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '购买数量',
  `goods_price` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '道具单价(分)',
  `pay_fee` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单总金额(分)',
  `attach` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '透传数据',
  `env` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0现网,1沙箱',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'pending/paid/closed',
  `deliver_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0未发货,1已发货',
  `paid_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `deliver_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_out_trade_no`(`out_trade_no`) USING BTREE,
  UNIQUE INDEX `uk_wx_order_id`(`wx_order_id`) USING BTREE,
  INDEX `idx_openid`(`openid`) USING BTREE,
  INDEX `idx_deliver`(`deliver_status`, `create_time`) USING BTREE,
  CONSTRAINT `fk_vpay_user` FOREIGN KEY (`openid`) REFERENCES `users` (`openid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '虚拟支付订单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of virtual_pay_orders
-- ----------------------------
INSERT INTO `virtual_pay_orders` VALUES ('027c72c7-4109-4d51-8ec6-ac6b94400f3b', 'A20261002164025034028', NULL, 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'article_income', '文章收益 《Java入门简介》', 1, 0, 0, '{\"post_id\":\"16e3acee-4fc4-43f9-9d51-4538209526e5\",\"buyer_id\":\"d1f076cf-f2e3-4541-b323-01bf62c33273\",\"type\":\"article_income\"}', 0, 'paid', 1, '2026-10-02 16:40:25', '2026-10-02 16:40:25', '2026-10-02 16:40:25', '2026-10-02 16:40:25');
INSERT INTO `virtual_pay_orders` VALUES ('383f1ae9-39a3-40d5-8197-affaaf22bd73', 'T20261001200229447728', 'VPO261001200229022697939', 'ocAWa4jVUL8Lp9eiqkRbMjYkjq28', 'coin_1', '1', 1, 100, 100, '{\"user_id\":\"fdeaf46a-bc99-11f1-b410-525400fdb9eb\"}', 0, 'paid', 1, '2026-10-01 20:02:44', '2026-10-01 20:02:44', '2026-10-01 20:02:29', '2026-10-01 20:02:44');

-- ----------------------------
-- Table structure for virtualpay_config
-- ----------------------------
DROP TABLE IF EXISTS `virtualpay_config`;
CREATE TABLE `virtualpay_config`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置项名，与 .env 的键名一致（如 VP_APPID）',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置值',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '说明',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '虚拟支付配置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of virtualpay_config
-- ----------------------------
INSERT INTO `virtualpay_config` VALUES (1, 'VP_APPID', 'wx63617f985d8c028c', '小程序 AppID', '2026-10-01 20:19:34', '2026-10-01 20:19:34');
INSERT INTO `virtualpay_config` VALUES (2, 'VP_APP_SECRET', 'a0a3d18cc49c5f70174245bf5e79d558', '小程序 AppSecret', '2026-10-01 20:19:34', '2026-10-01 20:19:34');
INSERT INTO `virtualpay_config` VALUES (3, 'VP_OFFER_ID', '1450646881', '虚拟支付 OfferID', '2026-10-01 20:19:34', '2026-10-01 20:19:34');
INSERT INTO `virtualpay_config` VALUES (4, 'VP_APP_KEY', 'pHOD10IVOI00wfDbq9SiEM1V70NicrhW', '现网 AppKey（env=0）', '2026-10-01 20:19:34', '2026-10-01 20:19:34');
INSERT INTO `virtualpay_config` VALUES (5, 'VP_NOTIFY_TOKEN', 'JM9SNc6tHRsG4KcE8strWJdE7ttffdEG', '消息推送 Token', '2026-10-01 20:19:34', '2026-10-01 20:19:34');
INSERT INTO `virtualpay_config` VALUES (6, 'VP_SANDBOX_APP_KEY', '6U8CiazJlkzic80a1uAYJ4MXaxHHi9oZ', '沙箱 AppKey（env=1）', '2026-10-01 20:19:34', '2026-10-01 20:19:34');
INSERT INTO `virtualpay_config` VALUES (7, 'VP_ENV', '0', '0=现网，1=沙箱', '2026-10-01 20:19:34', '2026-10-01 20:19:34');

-- ----------------------------
-- Table structure for visit_logs
-- ----------------------------
DROP TABLE IF EXISTS `visit_logs`;
CREATE TABLE `visit_logs`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问页面',
  `referer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源页面',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `device_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'desktop' COMMENT '设备类型',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ip`(`ip`) USING BTREE,
  INDEX `idx_page`(`page`) USING BTREE,
  INDEX `idx_device`(`device_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '访问日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of visit_logs
-- ----------------------------
INSERT INTO `visit_logs` VALUES ('00156632-efc8-433d-a5ed-85177b53a30f', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 17:13:00');
INSERT INTO `visit_logs` VALUES ('0028bfed-8953-494b-8ed9-927cf8cd0c03', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s1 winId/s1 token/393dc4bed4cc1da9d100ad4d8841376d', 'mobile', '2026-10-02 16:09:14');
INSERT INTO `visit_logs` VALUES ('0252cbeb-d52a-465e-891a-e3e1e7a7ce8a', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:00:37');
INSERT INTO `visit_logs` VALUES ('059e1d4f-d9a9-4b5a-a7b0-290f0210470b', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:27:12');
INSERT INTO `visit_logs` VALUES ('06a87f64-f389-4564-935a-10c25962c48a', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 17:16:32');
INSERT INTO `visit_logs` VALUES ('07f43be7-bcb0-4eb6-8486-d26ca3a339a4', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 19:20:22');
INSERT INTO `visit_logs` VALUES ('0814dcd0-4430-4be9-b026-d4614f7fa68a', '124.220.124.159', '/pages/message/message', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:04:34');
INSERT INTO `visit_logs` VALUES ('0c18f07c-2245-4e3e-a8b8-e82a0586f986', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:54:06');
INSERT INTO `visit_logs` VALUES ('0c869724-34ee-46ca-91d9-cac2cd32a11c', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:40:33');
INSERT INTO `visit_logs` VALUES ('1356ff99-c3bd-4372-ada3-b9ec62d80dc3', '192.168.10.6', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/74fa3ae8dbb10e5248dc555f9063f2ff', 'mobile', '2026-10-12 00:03:00');
INSERT INTO `visit_logs` VALUES ('1524d0d4-f7ee-4c9a-b4af-78c2f93ab549', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:21:52');
INSERT INTO `visit_logs` VALUES ('15439a1c-7b2b-4f49-ad0e-b13f5813dfe2', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 18:38:33');
INSERT INTO `visit_logs` VALUES ('170a87e1-31e8-40d7-99d3-02071e16a825', '39.163.100.208', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 17:41:37');
INSERT INTO `visit_logs` VALUES ('17ff4227-08fe-42b0-bea9-badf8666bdaf', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:56:56');
INSERT INTO `visit_logs` VALUES ('18251ecb-e0d1-44b4-80c0-7d9e4bd80d09', '192.168.10.3', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:07:26');
INSERT INTO `visit_logs` VALUES ('18998c8e-9bf8-4b54-ab69-46a7e82e3b50', '192.168.10.6', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/d9dec1c217a393c4a44fe5a9b3d74f99', 'mobile', '2026-10-12 15:59:37');
INSERT INTO `visit_logs` VALUES ('1a019332-e270-4b7d-9002-b3b43ac70b20', '192.168.10.9', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 17:40:00');
INSERT INTO `visit_logs` VALUES ('1ab20759-91fa-43f8-8224-937f828cb0ff', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 17:46:49');
INSERT INTO `visit_logs` VALUES ('1ca619a0-30ca-4052-9abc-6c1d31d6abe5', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-13 16:00:15');
INSERT INTO `visit_logs` VALUES ('1d0f43d8-6309-421c-b0fd-693f385193a0', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:16:52');
INSERT INTO `visit_logs` VALUES ('1dec2c04-233b-4bec-9f8f-b99c1421bd3a', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 13:59:41');
INSERT INTO `visit_logs` VALUES ('20d18831-c5c3-4514-a44c-39d44a9641b9', '192.168.10.7', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:36:21');
INSERT INTO `visit_logs` VALUES ('2472b579-02aa-4e11-baba-c5ff92c2a81d', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 18:32:28');
INSERT INTO `visit_logs` VALUES ('29583710-2c6e-4bc9-9657-7f99f151fc80', '39.144.22.117', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/4G Language/zh_CN', 'mobile', '2026-10-01 23:06:01');
INSERT INTO `visit_logs` VALUES ('2b62dc62-9f78-4ff0-b031-65874ebc7eae', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 20:43:20');
INSERT INTO `visit_logs` VALUES ('2db39558-08fe-40d2-aefa-ae583cd97687', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:34:05');
INSERT INTO `visit_logs` VALUES ('2dbc6cf4-9c1c-412c-ab47-f4d341982728', '39.144.22.66', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/4G Language/zh_CN', 'mobile', '2026-10-02 18:21:42');
INSERT INTO `visit_logs` VALUES ('2dfee1c3-3891-42e2-901a-0292f71ca3ba', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:01:25');
INSERT INTO `visit_logs` VALUES ('2e3658d6-5e3d-4626-8021-c0668cbd436a', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:35:53');
INSERT INTO `visit_logs` VALUES ('2eee8077-ccd1-4652-b747-9d1c71c817bf', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 16:13:56');
INSERT INTO `visit_logs` VALUES ('3024f90d-2275-441b-a51b-fa8d8959a483', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 17:12:58');
INSERT INTO `visit_logs` VALUES ('336996d8-4e50-4216-85a9-d3949394014c', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-13 15:53:46');
INSERT INTO `visit_logs` VALUES ('337b6d9c-606d-4120-b205-54de75d095cd', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s1 winId/s1 token/393dc4bed4cc1da9d100ad4d8841376d', 'mobile', '2026-10-02 16:29:19');
INSERT INTO `visit_logs` VALUES ('35d85acc-5a39-4a0a-bbd5-43795b47d2ad', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:40:54');
INSERT INTO `visit_logs` VALUES ('36033c31-52bd-4840-a7db-773b884c0960', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 22:01:18');
INSERT INTO `visit_logs` VALUES ('3701b244-6e2f-4a77-a3bc-f311ecd6044b', '192.168.10.3', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 22:09:31');
INSERT INTO `visit_logs` VALUES ('3717e716-adb2-4958-b658-b4b0df858747', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:06:41');
INSERT INTO `visit_logs` VALUES ('38d1aafc-6d29-4f25-92f3-a1358cd4960c', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 19:00:49');
INSERT INTO `visit_logs` VALUES ('395a1b29-0ada-49e0-bbe5-2bc505ace3d3', '124.220.124.244', '/pages/user/user', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:05:03');
INSERT INTO `visit_logs` VALUES ('3aaaf505-7185-47dc-b282-5e47f548cf61', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 20:59:08');
INSERT INTO `visit_logs` VALUES ('410b0f56-296b-44b1-bb8d-b7b110c9107d', '39.163.100.20', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e33) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-03 19:08:44');
INSERT INTO `visit_logs` VALUES ('437113d8-1a64-49b2-b055-3e20f6715a78', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:15:33');
INSERT INTO `visit_logs` VALUES ('43d15f7d-1af5-4b77-ad13-b4613e0bb87b', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:26:23');
INSERT INTO `visit_logs` VALUES ('4415e95e-a8b2-4629-9afa-e0a01d9c5f58', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:54:21');
INSERT INTO `visit_logs` VALUES ('486de2ab-c10b-4716-ade7-18d3a3abcaf3', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 18:07:21');
INSERT INTO `visit_logs` VALUES ('4ae7e5b9-0826-4c8c-89f1-fe95522b50c0', '192.168.10.9', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 17:39:26');
INSERT INTO `visit_logs` VALUES ('4dc7590f-7e01-42bf-b4a1-858e484b07d9', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 18:40:21');
INSERT INTO `visit_logs` VALUES ('4f63f592-446b-4624-a263-0f32ebcaf684', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s1 winId/s1 token/393dc4bed4cc1da9d100ad4d8841376d', 'mobile', '2026-10-02 16:02:08');
INSERT INTO `visit_logs` VALUES ('50cb7f7d-aeae-4ab5-b32c-51c09cbbdf24', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:28:06');
INSERT INTO `visit_logs` VALUES ('50dd232b-1318-489c-8e53-3b4612060c48', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:30:51');
INSERT INTO `visit_logs` VALUES ('521475f1-32e8-49d3-87b0-2903176bd261', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 15:29:39');
INSERT INTO `visit_logs` VALUES ('5337620f-56ef-46ef-98d1-efc13b24d4fc', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 23:20:18');
INSERT INTO `visit_logs` VALUES ('534f40ff-a6dc-4b53-92d4-d0d4d23f97a4', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 17:21:55');
INSERT INTO `visit_logs` VALUES ('5403ca1f-ee38-4752-88e0-e364907fad13', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'desktop', '2026-10-12 16:26:21');
INSERT INTO `visit_logs` VALUES ('58de592c-a8a5-4fbd-b241-2c4cd9a636c0', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 18:15:38');
INSERT INTO `visit_logs` VALUES ('5a2056ef-16c4-4be6-80dd-cb2a1d8bcdce', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:36:52');
INSERT INTO `visit_logs` VALUES ('5aab955f-6ad2-4f9f-9bc4-b3fe1a6aca34', '192.168.10.7', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:40:47');
INSERT INTO `visit_logs` VALUES ('5f832cdd-8de3-495b-a043-f04f06d0f83b', '192.168.10.3', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 18:19:38');
INSERT INTO `visit_logs` VALUES ('60c59470-c2ad-48d1-9cfe-6101cbd79819', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 16:10:09');
INSERT INTO `visit_logs` VALUES ('618e3170-0c0b-4673-afbd-8ddbff86b36f', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:39:31');
INSERT INTO `visit_logs` VALUES ('61e3c086-3a43-4c0c-8357-6981baa5d3d0', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:25:23');
INSERT INTO `visit_logs` VALUES ('644737fc-9ae6-461a-90d1-0aac6a709f5c', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/720630fd6a8bd95cd4562138cde1f3c7', 'mobile', '2026-09-30 23:50:14');
INSERT INTO `visit_logs` VALUES ('66ba3939-a0d4-4b3c-9ca4-d0293c3a0bbf', '39.163.100.20', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e33) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-03 11:31:33');
INSERT INTO `visit_logs` VALUES ('68b8dc55-e2a8-4eb7-8e83-b9d636b35b32', '39.144.22.117', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/4G Language/zh_CN', 'mobile', '2026-10-01 23:05:01');
INSERT INTO `visit_logs` VALUES ('68da4610-1327-4167-899a-c24649481176', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s1 winId/s1 token/393dc4bed4cc1da9d100ad4d8841376d', 'mobile', '2026-10-02 16:20:10');
INSERT INTO `visit_logs` VALUES ('69728f16-c5af-4944-9453-afa371d38b8e', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'desktop', '2026-09-30 22:35:35');
INSERT INTO `visit_logs` VALUES ('6adc2e90-043f-4bdc-ad32-647ec44975a8', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:47:15');
INSERT INTO `visit_logs` VALUES ('6ae00532-ba40-4323-9d7c-1d72dd264812', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:36:28');
INSERT INTO `visit_logs` VALUES ('6bceba17-c79d-44bf-987d-f974c5aff6e4', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:20:56');
INSERT INTO `visit_logs` VALUES ('6c32e2ee-0ea9-422a-997c-c5a1899e6f8e', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 17:33:35');
INSERT INTO `visit_logs` VALUES ('6ca852b6-2b30-48a6-848c-4173da586e40', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 18:07:23');
INSERT INTO `visit_logs` VALUES ('6dd137e4-e947-4b73-a367-0c25c71e8fc1', '124.220.124.244', '/pages/message/message', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:04:48');
INSERT INTO `visit_logs` VALUES ('6fa86b9e-e1ce-401c-82b0-da4e7620e18d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 17:27:31');
INSERT INTO `visit_logs` VALUES ('72066bc2-a9b6-4f41-9b17-3a378facd83d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:32:12');
INSERT INTO `visit_logs` VALUES ('760b47e7-3388-49a6-a3a0-cdaef302f64e', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:27:09');
INSERT INTO `visit_logs` VALUES ('76255845-beef-4d68-9cb2-28db41791c2d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 00:15:10');
INSERT INTO `visit_logs` VALUES ('766ed573-f721-4676-961d-6f68c3a98d44', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:48:36');
INSERT INTO `visit_logs` VALUES ('7817d75f-8d0e-4225-8a7d-3ed1f27b9c32', '43.139.209.119', '/pages/message/message', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6abe77497f2cedcdf907b5443ba7) f6a6', 'desktop', '2026-10-01 23:10:36');
INSERT INTO `visit_logs` VALUES ('7a59bbba-6516-4270-93a6-2be9db611227', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 18:15:04');
INSERT INTO `visit_logs` VALUES ('7d20d2bc-8a74-404f-8ec6-38ad8ac8dd22', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 17:28:19');
INSERT INTO `visit_logs` VALUES ('7dfec56c-aa1f-47d7-9031-db9be08fe325', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 17:46:57');
INSERT INTO `visit_logs` VALUES ('819a80e0-ed93-4a75-8239-836f55def17b', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:49:38');
INSERT INTO `visit_logs` VALUES ('81c41016-dbe8-4aa0-a4ba-48b3b4f56973', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:01:27');
INSERT INTO `visit_logs` VALUES ('820afac0-d23c-4340-b31f-4a589d2dd463', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s1 winId/s1 token/393dc4bed4cc1da9d100ad4d8841376d', 'mobile', '2026-10-02 16:37:14');
INSERT INTO `visit_logs` VALUES ('83b39ea6-3948-49a4-96d2-859b0803cb2f', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:59:28');
INSERT INTO `visit_logs` VALUES ('83e4d68e-6ca5-4b8b-b33f-7e9a26d0666d', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:11:48');
INSERT INTO `visit_logs` VALUES ('84de5eff-b289-497e-bab5-aaf612604d67', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:16:27');
INSERT INTO `visit_logs` VALUES ('889feead-a57b-4a56-8c2e-a790fee68d9d', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s1 winId/s1 token/393dc4bed4cc1da9d100ad4d8841376d', 'mobile', '2026-10-02 15:50:30');
INSERT INTO `visit_logs` VALUES ('895c5926-b50f-4734-acf8-204a2666149b', '124.220.124.159', '/subpkg/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:07:23');
INSERT INTO `visit_logs` VALUES ('89d004b1-1115-47fb-a89f-e6167235f765', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 15:42:53');
INSERT INTO `visit_logs` VALUES ('8a4247b3-3d46-4f95-8714-28e4296190ab', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:08:14');
INSERT INTO `visit_logs` VALUES ('8a88b797-1456-492b-a277-ca40f10df9e9', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/d9dec1c217a393c4a44fe5a9b3d74f99', 'mobile', '2026-10-12 15:22:37');
INSERT INTO `visit_logs` VALUES ('8db9599a-3bac-45ea-90bf-2cab5db77acb', '124.220.124.159', '/pages/user/user', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-10-01 23:04:47');
INSERT INTO `visit_logs` VALUES ('8fd6c2bd-bbb8-455a-945f-da99c33477f7', '192.168.10.7', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:46:13');
INSERT INTO `visit_logs` VALUES ('9065a87d-d67c-476b-bf65-bda1a3f0e044', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 21:52:10');
INSERT INTO `visit_logs` VALUES ('93ed4fe7-e535-4e88-b2e4-74fd7af59b9a', '39.144.22.66', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 17:35:08');
INSERT INTO `visit_logs` VALUES ('94b1116b-83f3-4a5d-8925-54b52fa16021', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/d9dec1c217a393c4a44fe5a9b3d74f99', 'mobile', '2026-10-12 15:50:48');
INSERT INTO `visit_logs` VALUES ('9618e610-db48-44e2-9d9b-f8c124744480', '39.163.100.249', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 11:38:01');
INSERT INTO `visit_logs` VALUES ('963e21d0-56b9-4a70-a041-04cf9a51ba08', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 19:56:07');
INSERT INTO `visit_logs` VALUES ('979b2054-12c3-4881-b3fb-06a15dd411da', '192.168.10.3', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 18:22:52');
INSERT INTO `visit_logs` VALUES ('980223b0-0cc6-4dc1-a204-db3a36e7c2ae', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 15:14:32');
INSERT INTO `visit_logs` VALUES ('9982e8bb-6b1d-4c4b-8909-73ed9b017348', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 18:18:49');
INSERT INTO `visit_logs` VALUES ('9998f17a-fad4-4e6d-8260-2102b5dd8fb9', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/74fa3ae8dbb10e5248dc555f9063f2ff', 'mobile', '2026-10-12 00:01:57');
INSERT INTO `visit_logs` VALUES ('9a83ad66-365e-4e67-88f1-ffc573a8195b', '192.168.10.8', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e33) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-13 16:03:27');
INSERT INTO `visit_logs` VALUES ('9a89da95-f5cc-45ba-b2eb-a5b38421e22c', '39.163.100.36', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 19:49:11');
INSERT INTO `visit_logs` VALUES ('9d1ca872-b244-4dc0-a2ea-06090a693122', '39.144.22.117', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/4G Language/zh_CN', 'mobile', '2026-10-01 22:57:38');
INSERT INTO `visit_logs` VALUES ('9f81e343-c95c-458d-a488-5648d039b1bb', '192.168.10.7', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:36:20');
INSERT INTO `visit_logs` VALUES ('a138e32a-d178-4c8e-8b98-11f23552f7b7', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:30:33');
INSERT INTO `visit_logs` VALUES ('a1bddf55-cf96-4f93-84af-4b3c4cb44c40', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 11:37:55');
INSERT INTO `visit_logs` VALUES ('a223c819-7bca-48fd-8e14-c36c821cf2ee', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/d9dec1c217a393c4a44fe5a9b3d74f99', 'mobile', '2026-10-12 15:41:05');
INSERT INTO `visit_logs` VALUES ('a3456078-d08a-4373-ae02-a224eceef525', '192.168.10.6', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/d9dec1c217a393c4a44fe5a9b3d74f99', 'mobile', '2026-10-12 16:07:16');
INSERT INTO `visit_logs` VALUES ('a46f3b9e-952c-4598-ad45-6c3afc4b3d0f', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 23:27:09');
INSERT INTO `visit_logs` VALUES ('a6945492-7920-4297-afd4-bc437aa6c2cd', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 20:43:17');
INSERT INTO `visit_logs` VALUES ('a74b49e8-a5f4-4b80-9b64-d286e49431af', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 22:05:13');
INSERT INTO `visit_logs` VALUES ('a88e8df2-e53e-4da7-861d-9b95d50c447e', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 15:54:21');
INSERT INTO `visit_logs` VALUES ('ab60507b-4097-4887-8aab-91261dfd5cf1', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 18:22:24');
INSERT INTO `visit_logs` VALUES ('ac34653c-abc6-4522-b890-78bdbd67f21e', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 19:42:25');
INSERT INTO `visit_logs` VALUES ('acf4e7d9-9afd-43c6-8e76-8815afebd9fd', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 18:14:42');
INSERT INTO `visit_logs` VALUES ('aecc67b8-5a2a-4ef5-9ff3-d79d0ed4022c', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:28:27');
INSERT INTO `visit_logs` VALUES ('af479de1-2c7b-4239-a322-7a3ca8f1cfb5', '192.168.10.3', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 20:45:46');
INSERT INTO `visit_logs` VALUES ('b3723fcc-5593-43e2-b708-32dc4cad0d31', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 21:29:17');
INSERT INTO `visit_logs` VALUES ('b4252052-9834-421e-97e7-dd9fa4f37b65', '192.168.10.9', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 17:55:08');
INSERT INTO `visit_logs` VALUES ('b83dcd8f-0808-4308-b38d-2fdffdd29fa1', '39.163.100.208', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 23:27:42');
INSERT INTO `visit_logs` VALUES ('b85093ae-6d7d-403d-9133-b458d133eb4a', '39.163.100.20', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e33) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-03 17:14:45');
INSERT INTO `visit_logs` VALUES ('bac57795-9740-418b-9e8d-7a3c9e8cc6be', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 16:57:42');
INSERT INTO `visit_logs` VALUES ('bbac9eff-f6a0-43d7-bff7-9c5bf8ddd1b4', '192.168.10.7', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:55:37');
INSERT INTO `visit_logs` VALUES ('bbbc86dc-bc1d-4b33-b388-e60d9eb1ab2d', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/d9dec1c217a393c4a44fe5a9b3d74f99', 'mobile', '2026-10-12 15:27:38');
INSERT INTO `visit_logs` VALUES ('bd66b4b6-987f-4d08-8610-8ca12238f94e', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 16:13:58');
INSERT INTO `visit_logs` VALUES ('bde339ad-3c33-420d-9cac-3f4e68f5bada', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:48:22');
INSERT INTO `visit_logs` VALUES ('be224751-3033-4c51-bb64-01dd2d7b786b', '192.168.10.8', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-13 15:20:45');
INSERT INTO `visit_logs` VALUES ('c31180c0-101b-4157-abec-a074830af284', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:08:47');
INSERT INTO `visit_logs` VALUES ('c37b927d-f66e-45b1-9906-501039e7280e', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:48:57');
INSERT INTO `visit_logs` VALUES ('c700c490-873e-4065-8bff-fc011d0d6807', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 16:38:24');
INSERT INTO `visit_logs` VALUES ('c8563c49-b337-45b1-9366-0e29d8d149ab', '192.168.10.6', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/d9dec1c217a393c4a44fe5a9b3d74f99', 'mobile', '2026-10-12 15:52:00');
INSERT INTO `visit_logs` VALUES ('c8f2bbcc-bb02-403d-b576-7f8c56874934', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:59:56');
INSERT INTO `visit_logs` VALUES ('cadaea63-4923-4a9b-b29d-61e26732ebaa', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:15:19');
INSERT INTO `visit_logs` VALUES ('cbcaa85c-aa75-4195-b2b1-2cf7ffba1fff', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-13 15:33:48');
INSERT INTO `visit_logs` VALUES ('cbf3350d-4050-4131-a3ed-7ed571b27679', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s1 winId/s1 token/393dc4bed4cc1da9d100ad4d8841376d', 'mobile', '2026-10-02 16:53:08');
INSERT INTO `visit_logs` VALUES ('cde04f9a-8d75-4417-8ff0-00844080cc14', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:13:27');
INSERT INTO `visit_logs` VALUES ('cf2f797a-6176-40ca-9479-f935b8de7da9', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 17:44:45');
INSERT INTO `visit_logs` VALUES ('cf9684c9-de74-498d-9454-03a0d449f571', '192.168.10.7', '/pages/message/message', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:49:25');
INSERT INTO `visit_logs` VALUES ('cfebd031-8fb7-4873-b2e6-85a654f86641', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/74fa3ae8dbb10e5248dc555f9063f2ff', 'mobile', '2026-10-12 01:07:59');
INSERT INTO `visit_logs` VALUES ('d1f78e6a-1978-4b07-a8ef-72239db21890', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:09:51');
INSERT INTO `visit_logs` VALUES ('d2a2d8ce-295f-4c64-8b9c-c698ab90da94', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:32:48');
INSERT INTO `visit_logs` VALUES ('d4e9e046-b854-4ded-9049-8d300a486eec', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 22:11:58');
INSERT INTO `visit_logs` VALUES ('d5f7ffcb-1ec9-47f9-bdd1-4f4c87cc0eef', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 18:50:16');
INSERT INTO `visit_logs` VALUES ('d7124144-a1fe-4718-a68d-f7f0fb2202bc', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:00:09');
INSERT INTO `visit_logs` VALUES ('d9f11a6d-d33d-42e7-8e3f-5adf1ca73fea', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'desktop', '2026-10-13 14:42:44');
INSERT INTO `visit_logs` VALUES ('db7e9311-436d-426d-a516-3068625f745c', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 18:50:39');
INSERT INTO `visit_logs` VALUES ('dbf44018-17d4-4d9f-ba99-0cac6bbc170d', '39.163.100.241', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-01 22:57:03');
INSERT INTO `visit_logs` VALUES ('dc6ddf0c-d5f0-47a7-afd9-d058a25db240', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 17:39:45');
INSERT INTO `visit_logs` VALUES ('df03f551-2a36-4e93-b600-d0ef70a23fdd', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:23:24');
INSERT INTO `visit_logs` VALUES ('df0d79db-165c-450c-88bf-84260c6ea465', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 19:14:16');
INSERT INTO `visit_logs` VALUES ('dfbb2ba2-0186-4517-9634-2b5268a921cb', '39.163.100.241', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-01 22:06:41');
INSERT INTO `visit_logs` VALUES ('e1848283-451a-4c42-87a2-39032973f41a', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 21:39:04');
INSERT INTO `visit_logs` VALUES ('e3161916-1683-47c7-9c50-36276f9acc1d', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 20:30:45');
INSERT INTO `visit_logs` VALUES ('e336e348-b3b1-431b-8d00-7f7738f02288', '192.168.10.7', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:34:12');
INSERT INTO `visit_logs` VALUES ('e431faf7-ccb3-446d-ad6d-a91ca2ce7399', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 15:48:18');
INSERT INTO `visit_logs` VALUES ('e4951d2b-7ca8-40e4-ab27-47390359ed78', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:42:08');
INSERT INTO `visit_logs` VALUES ('e603d801-d680-469b-a945-5207f09efda3', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 18:45:16');
INSERT INTO `visit_logs` VALUES ('e604c6a3-a7ba-4464-b760-daf41c91832e', '192.168.10.3', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 20:47:11');
INSERT INTO `visit_logs` VALUES ('e759e6c3-0898-4cb3-ac0f-1bd5e17a56f4', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:47:36');
INSERT INTO `visit_logs` VALUES ('e8597191-2769-47f6-b20c-eeb752ab65df', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-13 16:19:25');
INSERT INTO `visit_logs` VALUES ('e94dac41-c782-46d7-99bd-282e54761eb5', '192.168.10.6', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 16:07:49');
INSERT INTO `visit_logs` VALUES ('ec076d4d-f676-469b-8b97-0d0d53d9c8ce', '39.144.22.65', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e33) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-03 19:14:49');
INSERT INTO `visit_logs` VALUES ('ed6a7e7f-e79f-4a81-9c98-767649b29584', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-02 15:10:09');
INSERT INTO `visit_logs` VALUES ('ef110302-1349-47e8-84ca-d21ccd66acf7', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 20:24:56');
INSERT INTO `visit_logs` VALUES ('efbe9be4-080c-412c-aa10-3e1771e9d135', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 22:23:25');
INSERT INTO `visit_logs` VALUES ('f0100322-086a-42b0-9f6a-572a15670f09', '39.144.22.65', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e33) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-03 11:32:59');
INSERT INTO `visit_logs` VALUES ('f09053f5-327a-4465-87ac-cba2ff60f370', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-10-12 14:26:03');
INSERT INTO `visit_logs` VALUES ('f0c44b40-3985-4bd5-8ac4-4705ef95c4e9', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 20:31:23');
INSERT INTO `visit_logs` VALUES ('f45e6aa4-7403-4482-87e2-35031ce166f9', '39.163.100.241', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-01 21:41:10');
INSERT INTO `visit_logs` VALUES ('f658b8a7-2c8d-4464-95ef-82f27d14415b', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/deb1b3108beda80dc6c6349294254cd8', 'mobile', '2026-09-30 19:02:58');
INSERT INTO `visit_logs` VALUES ('f7a11a09-78d2-4f62-a8a0-1e84861c83d3', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 19:50:26');
INSERT INTO `visit_logs` VALUES ('f9777323-ab61-4784-9dd9-e9280732d0ae', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 21:51:59');
INSERT INTO `visit_logs` VALUES ('fa78221b-2f35-43e4-a65d-fa2bfeb72ea7', '192.168.10.8', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e33) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-13 15:36:51');
INSERT INTO `visit_logs` VALUES ('fb135cd9-dd2f-478e-9b37-54869cbcd298', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/52df024bbb6710ecbf4a1ad576c95418', 'mobile', '2026-10-01 22:59:39');
INSERT INTO `visit_logs` VALUES ('fbde131c-b2f4-42f0-b9d3-645df82c169c', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/74fa3ae8dbb10e5248dc555f9063f2ff', 'mobile', '2026-10-12 01:01:15');
INSERT INTO `visit_logs` VALUES ('fbef4f4f-0d54-4ddd-857f-cd2662a234f1', '39.163.100.241', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/87cc854b8b2fcfb0920fe0a2edf85733', 'mobile', '2026-10-01 21:17:28');
INSERT INTO `visit_logs` VALUES ('fdeb7633-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/13', 'mobile', '2026-01-05 15:27:39');
INSERT INTO `visit_logs` VALUES ('fdeb77bd-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/14', 'mobile', '2026-01-05 15:32:57');
INSERT INTO `visit_logs` VALUES ('fdeb7813-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.67(0x1800432b) NetType/WIFI Language/zh_CN', 'mobile', '2026-01-05 15:46:52');
INSERT INTO `visit_logs` VALUES ('fdeb7851-bc99-11f1-b410-525400fdb9eb', '39.163.100.107', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/27', 'mobile', '2026-01-05 15:52:16');
INSERT INTO `visit_logs` VALUES ('fdeb7922-bc99-11f1-b410-525400fdb9eb', '101.34.86.201', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-01-05 15:56:42');
INSERT INTO `visit_logs` VALUES ('fdeb7955-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/37', 'mobile', '2026-05-19 15:18:51');
INSERT INTO `visit_logs` VALUES ('fdeb7981-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/37', 'mobile', '2026-05-19 15:23:05');
INSERT INTO `visit_logs` VALUES ('fdeb79ac-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/38', 'mobile', '2026-05-19 15:24:14');
INSERT INTO `visit_logs` VALUES ('fdeb7a2c-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/41', 'mobile', '2026-05-19 15:30:41');
INSERT INTO `visit_logs` VALUES ('fdeb7a5a-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/48', 'mobile', '2026-05-19 16:00:38');
INSERT INTO `visit_logs` VALUES ('fdeb7a84-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/49', 'mobile', '2026-05-19 16:05:57');
INSERT INTO `visit_logs` VALUES ('fdeb7b35-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/53', 'mobile', '2026-05-19 16:12:26');
INSERT INTO `visit_logs` VALUES ('fdeb7b60-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/55', 'mobile', '2026-05-19 16:14:28');
INSERT INTO `visit_logs` VALUES ('fdeb7b8c-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56', 'mobile', '2026-05-19 16:21:31');
INSERT INTO `visit_logs` VALUES ('fdeb7c19-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/56', 'mobile', '2026-05-19 16:21:34');
INSERT INTO `visit_logs` VALUES ('fdeb7c49-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/61', 'mobile', '2026-05-19 16:28:04');
INSERT INTO `visit_logs` VALUES ('fdeb7cc2-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/61', 'mobile', '2026-05-19 16:28:17');
INSERT INTO `visit_logs` VALUES ('fdeb7cef-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:36:13');
INSERT INTO `visit_logs` VALUES ('fdeb7d1d-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:36:19');
INSERT INTO `visit_logs` VALUES ('fdeb7d96-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:42:51');
INSERT INTO `visit_logs` VALUES ('fdeb7dc0-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 16:55:01');
INSERT INTO `visit_logs` VALUES ('fdeb7e33-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 17:00:56');
INSERT INTO `visit_logs` VALUES ('fdeb7e60-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 17:02:36');
INSERT INTO `visit_logs` VALUES ('fdeb7ed3-bc99-11f1-b410-525400fdb9eb', '39.163.100.17', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-05-19 17:13:13');
INSERT INTO `visit_logs` VALUES ('fdeb7efd-bc99-11f1-b410-525400fdb9eb', '39.144.24.239', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x1800492a) NetType/4G Language/zh_CN', 'mobile', '2026-05-20 18:52:51');
INSERT INTO `visit_logs` VALUES ('fdeb7f74-bc99-11f1-b410-525400fdb9eb', '39.144.24.239', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x1800492a) NetType/4G Language/zh_CN', 'mobile', '2026-05-20 21:29:18');
INSERT INTO `visit_logs` VALUES ('fdeb80bc-bc99-11f1-b410-525400fdb9eb', '125.45.110.184', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 16; PKM110 Build/BP2A.250605.015; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.177 Mobile Safari/537.36 XWEB/1460075 MMWEBSDK/20260202 MMWEBID/4073 MicroMessenger/8.0.71.3080(0x28004750) WeChat/arm64 Weixin NetType/4G Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-05-20 21:33:56');
INSERT INTO `visit_logs` VALUES ('fdeb8143-bc99-11f1-b410-525400fdb9eb', '39.144.22.46', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-01 20:25:33');
INSERT INTO `visit_logs` VALUES ('fdeb81f4-bc99-11f1-b410-525400fdb9eb', '39.144.22.46', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-01 22:18:36');
INSERT INTO `visit_logs` VALUES ('fdeb8296-bc99-11f1-b410-525400fdb9eb', '39.144.22.46', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-02 10:30:22');
INSERT INTO `visit_logs` VALUES ('fdeb8344-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-03 13:01:26');
INSERT INTO `visit_logs` VALUES ('fdeb83e4-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-03 13:02:22');
INSERT INTO `visit_logs` VALUES ('fdeb8577-bc99-11f1-b410-525400fdb9eb', '101.34.86.201', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:03:30');
INSERT INTO `visit_logs` VALUES ('fdeb85f4-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:03:39');
INSERT INTO `visit_logs` VALUES ('fdeb8655-bc99-11f1-b410-525400fdb9eb', '101.34.86.201', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:04:18');
INSERT INTO `visit_logs` VALUES ('fdeb86b1-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:04:30');
INSERT INTO `visit_logs` VALUES ('fdeb870e-bc99-11f1-b410-525400fdb9eb', '106.55.202.118', '/pages/index/index', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6a1fb62e815955e3e2cb62e598e2) f6a6', 'desktop', '2026-06-03 13:06:54');
INSERT INTO `visit_logs` VALUES ('fdeb8770-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/index/index', 'https://weixin110.qq.com/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-03 13:07:55');
INSERT INTO `visit_logs` VALUES ('fdeb87d1-bc99-11f1-b410-525400fdb9eb', '43.139.209.119', '/pages/index/index', '', 'Tencent Security Team, more information: https://developers.weixin.qq.com/community/minihome/doc/0008ea401c89c02cff2d1345051001 (6a1fb62e815955e3e2cb62e598e2) 19ab', 'desktop', '2026-06-03 13:13:14');
INSERT INTO `visit_logs` VALUES ('fdeb87fe-bc99-11f1-b410-525400fdb9eb', '124.221.213.176', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:23:41');
INSERT INTO `visit_logs` VALUES ('fdeb882a-bc99-11f1-b410-525400fdb9eb', '124.221.213.176', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-03 13:24:32');
INSERT INTO `visit_logs` VALUES ('fdeb8854-bc99-11f1-b410-525400fdb9eb', '39.163.100.209', '/pages/index/index', 'http://1.13.163.77:12138/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-03 14:25:06');
INSERT INTO `visit_logs` VALUES ('fdeb8880-bc99-11f1-b410-525400fdb9eb', '114.132.52.44', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Mobile Safari/537.36 MicroMessenger/7.0.1', 'mobile', '2026-06-03 18:33:58');
INSERT INTO `visit_logs` VALUES ('fdeb88a9-bc99-11f1-b410-525400fdb9eb', '119.84.150.102', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 12; AOSP on Pixel Build/SQ1D.220205.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20251202 MMWEBID/3954 MicroMessenger/8.0.72.3020(0x28004835) WeChat/arm64 Weixin NetType/02:42:ac:11:00:13 Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-04 14:33:28');
INSERT INTO `visit_logs` VALUES ('fdeb88e8-bc99-11f1-b410-525400fdb9eb', '39.163.111.15', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-04 15:31:36');
INSERT INTO `visit_logs` VALUES ('fdeb8915-bc99-11f1-b410-525400fdb9eb', '119.2.154.223', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 16; SM-S9380 Build/BP4A.251205.006; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20260202 MMWEBID/5048 MicroMessenger/8.0.71.3080(0x28004750) WeChat/arm64 Weixin NetType/WIFI Language/en ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-04 15:37:00');
INSERT INTO `visit_logs` VALUES ('fdeb894a-bc99-11f1-b410-525400fdb9eb', '59.37.125.37', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 16; MEIZU 20 Pro Build/BQ2A.251110.001-BP2A.250605.031.A3; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460149 MMWEBSDK/20260502 MMWEBID/1396 MicroMessenger/8.0.74.3100(0x28004A31) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-04 16:12:36');
INSERT INTO `visit_logs` VALUES ('fdeb897b-bc99-11f1-b410-525400fdb9eb', '39.144.22.106', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-05 12:11:40');
INSERT INTO `visit_logs` VALUES ('fdeb89a8-bc99-11f1-b410-525400fdb9eb', '111.55.20.149', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-05 22:08:05');
INSERT INTO `visit_logs` VALUES ('fdeb89d3-bc99-11f1-b410-525400fdb9eb', '223.104.105.10', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-07 18:45:29');
INSERT INTO `visit_logs` VALUES ('fdeb8a02-bc99-11f1-b410-525400fdb9eb', '223.104.105.23', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.73(0x18004939) NetType/4G Language/zh_CN', 'mobile', '2026-06-08 16:47:50');
INSERT INTO `visit_logs` VALUES ('fdeb8a2c-bc99-11f1-b410-525400fdb9eb', '39.163.100.235', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-09 11:15:12');
INSERT INTO `visit_logs` VALUES ('fdeb8a5a-bc99-11f1-b410-525400fdb9eb', '39.163.100.235', '/pages/index/index', 'http://1.13.163.77:12138/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-09 12:08:29');
INSERT INTO `visit_logs` VALUES ('fdeb8a89-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:11:46');
INSERT INTO `visit_logs` VALUES ('fdeb8ab7-bc99-11f1-b410-525400fdb9eb', '124.220.124.159', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:11:55');
INSERT INTO `visit_logs` VALUES ('fdeb8ae8-bc99-11f1-b410-525400fdb9eb', '124.220.126.5', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:11:56');
INSERT INTO `visit_logs` VALUES ('fdeb8b19-bc99-11f1-b410-525400fdb9eb', '124.220.124.244', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:12:34');
INSERT INTO `visit_logs` VALUES ('fdeb8b52-bc99-11f1-b410-525400fdb9eb', '124.220.124.159', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:12:46');
INSERT INTO `visit_logs` VALUES ('fdeb8b80-bc99-11f1-b410-525400fdb9eb', '124.220.126.5', '/pages/contact/contact', '', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF XWEB/1000/Tencent Security Team', 'desktop', '2026-06-09 12:12:47');
INSERT INTO `visit_logs` VALUES ('fdeb8c05-bc99-11f1-b410-525400fdb9eb', '119.84.150.102', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 12; AOSP on Pixel Build/SQ1D.220205.004; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460205 MMWEBSDK/20260101 MMWEBID/3126 MicroMessenger/8.0.72.3020(0x28004835) WeChat/arm64 Weixin NetType/02:42:ac:11:00:07 Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-09 16:12:07');
INSERT INTO `visit_logs` VALUES ('fdeb8c36-bc99-11f1-b410-525400fdb9eb', '39.163.100.25', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-10 21:48:01');
INSERT INTO `visit_logs` VALUES ('fdeb8c65-bc99-11f1-b410-525400fdb9eb', '39.163.100.154', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-11 14:53:38');
INSERT INTO `visit_logs` VALUES ('fdeb8c95-bc99-11f1-b410-525400fdb9eb', '120.244.186.216', '/pages/index/index', '', 'Mozilla/5.0 (Linux; Android 15; REA-AN00 Build/HONORREA-AN00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460205 MMWEBSDK/20260502 MMWEBID/5675 MicroMessenger/8.0.72.3100(0x28004853) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android', 'mobile', '2026-06-12 21:43:11');
INSERT INTO `visit_logs` VALUES ('fdeb8d15-bc99-11f1-b410-525400fdb9eb', '39.163.100.8', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-13 12:03:57');
INSERT INTO `visit_logs` VALUES ('fdeb8d42-bc99-11f1-b410-525400fdb9eb', '110.179.140.14', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'desktop', '2026-06-13 13:04:06');
INSERT INTO `visit_logs` VALUES ('fdeb8d6d-bc99-11f1-b410-525400fdb9eb', '219.155.182.237', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.74(0x18004a22) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-14 21:23:06');
INSERT INTO `visit_logs` VALUES ('fdeb8d98-bc99-11f1-b410-525400fdb9eb', '39.163.100.88', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b27) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-20 21:41:30');
INSERT INTO `visit_logs` VALUES ('fdeb8e12-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://1.13.163.77:12138/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-22 22:20:06');
INSERT INTO `visit_logs` VALUES ('fdeb8e3d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 22:51:02');
INSERT INTO `visit_logs` VALUES ('fdeb8e67-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 22:56:04');
INSERT INTO `visit_logs` VALUES ('fdeb8e92-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:02:06');
INSERT INTO `visit_logs` VALUES ('fdeb8f0d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:12:24');
INSERT INTO `visit_logs` VALUES ('fdeb91bf-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:19:12');
INSERT INTO `visit_logs` VALUES ('fdeb9208-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/contact/contact', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:21:44');
INSERT INTO `visit_logs` VALUES ('fdeb9295-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:25:44');
INSERT INTO `visit_logs` VALUES ('fdeb92c1-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-22 23:47:41');
INSERT INTO `visit_logs` VALUES ('fdeb933e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:00:55');
INSERT INTO `visit_logs` VALUES ('fdeb9369-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:08:11');
INSERT INTO `visit_logs` VALUES ('fdeb93e2-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:14:08');
INSERT INTO `visit_logs` VALUES ('fdeb940c-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:19:29');
INSERT INTO `visit_logs` VALUES ('fdeb948b-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:22:57');
INSERT INTO `visit_logs` VALUES ('fdeb94b5-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:23:38');
INSERT INTO `visit_logs` VALUES ('fdebc89c-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:31:10');
INSERT INTO `visit_logs` VALUES ('fdebca1e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:35:29');
INSERT INTO `visit_logs` VALUES ('fdebcadf-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:35:33');
INSERT INTO `visit_logs` VALUES ('fdebcb8d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:41:58');
INSERT INTO `visit_logs` VALUES ('fdebcc35-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:42:38');
INSERT INTO `visit_logs` VALUES ('fdebccdd-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:47:06');
INSERT INTO `visit_logs` VALUES ('fdebcdf7-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:50:51');
INSERT INTO `visit_logs` VALUES ('fdebcfac-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:53:46');
INSERT INTO `visit_logs` VALUES ('fdebd024-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:57:26');
INSERT INTO `visit_logs` VALUES ('fdebd08f-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 00:57:36');
INSERT INTO `visit_logs` VALUES ('fdebd102-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-06-23 01:03:01');
INSERT INTO `visit_logs` VALUES ('fdebd16e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:04:08');
INSERT INTO `visit_logs` VALUES ('fdebd1d4-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:09:33');
INSERT INTO `visit_logs` VALUES ('fdebd232-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:09:36');
INSERT INTO `visit_logs` VALUES ('fdebd28e-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:09:39');
INSERT INTO `visit_logs` VALUES ('fdebd2ec-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:15:30');
INSERT INTO `visit_logs` VALUES ('fdebd34f-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:17:45');
INSERT INTO `visit_logs` VALUES ('fdebd3ab-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:17:48');
INSERT INTO `visit_logs` VALUES ('fdebd406-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 01:24:35');
INSERT INTO `visit_logs` VALUES ('fdebd48d-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:27:32');
INSERT INTO `visit_logs` VALUES ('fdebd4bc-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:27:42');
INSERT INTO `visit_logs` VALUES ('fdebd4f3-bc99-11f1-b410-525400fdb9eb', '39.163.100.251', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 01:34:42');
INSERT INTO `visit_logs` VALUES ('fdebd51f-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 11:57:16');
INSERT INTO `visit_logs` VALUES ('fdebd55c-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 11:57:28');
INSERT INTO `visit_logs` VALUES ('fdebd589-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 11:57:41');
INSERT INTO `visit_logs` VALUES ('fdebd5b9-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 12:03:44');
INSERT INTO `visit_logs` VALUES ('fdebd5e6-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 12:04:40');
INSERT INTO `visit_logs` VALUES ('fdebd616-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-06-23 14:44:17');
INSERT INTO `visit_logs` VALUES ('fdebd648-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 22:55:24');
INSERT INTO `visit_logs` VALUES ('fdebd678-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 22:55:57');
INSERT INTO `visit_logs` VALUES ('fdebd6a4-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 22:56:00');
INSERT INTO `visit_logs` VALUES ('fdebd6ce-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 23:00:28');
INSERT INTO `visit_logs` VALUES ('fdebd6fd-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-06-23 23:02:38');
INSERT INTO `visit_logs` VALUES ('fdebd72a-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 23:05:49');
INSERT INTO `visit_logs` VALUES ('fdebd757-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b29) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-23 23:06:14');
INSERT INTO `visit_logs` VALUES ('fdebd78a-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:09:37');
INSERT INTO `visit_logs` VALUES ('fdebd7c0-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:16:45');
INSERT INTO `visit_logs` VALUES ('fdebd7ef-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:27:22');
INSERT INTO `visit_logs` VALUES ('fdebd81a-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:31:51');
INSERT INTO `visit_logs` VALUES ('fdebd896-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:32:50');
INSERT INTO `visit_logs` VALUES ('fdebd8ce-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:32:57');
INSERT INTO `visit_logs` VALUES ('fdebd9c2-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:39:15');
INSERT INTO `visit_logs` VALUES ('fdebd9f3-bc99-11f1-b410-525400fdb9eb', '39.163.100.130', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-06-23 23:40:27');
INSERT INTO `visit_logs` VALUES ('fdebda31-bc99-11f1-b410-525400fdb9eb', '222.140.168.137', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 MicroMessenger/7.0.20.1781(0x6700143B) NetType/WIFI MiniProgramEnv/Windows WindowsWechat/WMPF WindowsWechat(0x63090a13) UnifiedPCWindowsWechat(0xf2541b16) XWEB/20005', 'desktop', '2026-06-27 11:09:31');
INSERT INTO `visit_logs` VALUES ('fdebda64-bc99-11f1-b410-525400fdb9eb', '219.155.181.217', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2d) NetType/4G Language/zh_TW', 'mobile', '2026-06-27 11:09:47');
INSERT INTO `visit_logs` VALUES ('fdebdafe-bc99-11f1-b410-525400fdb9eb', '223.104.105.96', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/4G Language/zh_TW', 'mobile', '2026-06-30 18:56:54');
INSERT INTO `visit_logs` VALUES ('fdebdb29-bc99-11f1-b410-525400fdb9eb', '120.212.165.226', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-30 18:57:52');
INSERT INTO `visit_logs` VALUES ('fdebdb68-bc99-11f1-b410-525400fdb9eb', '1.196.155.72', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-30 22:51:10');
INSERT INTO `visit_logs` VALUES ('fdebdb98-bc99-11f1-b410-525400fdb9eb', '1.196.155.72', '/pages/contact/contact', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_CN', 'mobile', '2026-06-30 22:52:54');
INSERT INTO `visit_logs` VALUES ('fdebdc30-bc99-11f1-b410-525400fdb9eb', '39.163.100.150', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-30 22:57:27');
INSERT INTO `visit_logs` VALUES ('fdebdc5d-bc99-11f1-b410-525400fdb9eb', '39.163.100.150', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-30 22:57:32');
INSERT INTO `visit_logs` VALUES ('fdebdc98-bc99-11f1-b410-525400fdb9eb', '39.163.100.150', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b2f) NetType/WIFI Language/zh_TW', 'mobile', '2026-06-30 22:57:35');
INSERT INTO `visit_logs` VALUES ('fdebdd2f-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-07-07 15:43:01');
INSERT INTO `visit_logs` VALUES ('fdebdd5c-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1', 'mobile', '2026-07-07 15:43:17');
INSERT INTO `visit_logs` VALUES ('fdebdec5-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 15:53:05');
INSERT INTO `visit_logs` VALUES ('fdebdf2e-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:05:12');
INSERT INTO `visit_logs` VALUES ('fdebe183-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:26:47');
INSERT INTO `visit_logs` VALUES ('fdebe23a-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:45:15');
INSERT INTO `visit_logs` VALUES ('fdebe269-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:45:19');
INSERT INTO `visit_logs` VALUES ('fdebe2f9-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-07-07 16:49:46');
INSERT INTO `visit_logs` VALUES ('fdebe329-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2504030 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/5', 'mobile', '2026-07-07 16:54:54');
INSERT INTO `visit_logs` VALUES ('fdebe3c3-bc99-11f1-b410-525400fdb9eb', '39.163.100.191', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b35) NetType/WIFI Language/zh_TW', 'mobile', '2026-07-07 16:59:57');
INSERT INTO `visit_logs` VALUES ('fdebe441-bc99-11f1-b410-525400fdb9eb', '39.163.100.198', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.75(0x18004b42) NetType/WIFI Language/zh_TW', 'mobile', '2026-07-21 10:52:24');
INSERT INTO `visit_logs` VALUES ('fdec0eb1-bc99-11f1-b410-525400fdb9eb', '39.163.100.86', '/pages/index/index', 'http://43.137.17.63:12138/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'desktop', '2026-08-17 20:52:24');
INSERT INTO `visit_logs` VALUES ('fdec0fe9-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-09 23:44:31');
INSERT INTO `visit_logs` VALUES ('fdec10dc-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-09 23:46:31');
INSERT INTO `visit_logs` VALUES ('fdec118b-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.76(0x18004c38) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-09 23:46:33');
INSERT INTO `visit_logs` VALUES ('fdec1264-bc99-11f1-b410-525400fdb9eb', '39.163.100.156', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.0 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-10 00:08:27');
INSERT INTO `visit_logs` VALUES ('fdec130e-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-18 23:38:50');
INSERT INTO `visit_logs` VALUES ('fdec149f-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-18 23:47:09');
INSERT INTO `visit_logs` VALUES ('fdec1518-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-18 23:54:49');
INSERT INTO `visit_logs` VALUES ('fdec1578-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:07:50');
INSERT INTO `visit_logs` VALUES ('fdec15da-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:08:01');
INSERT INTO `visit_logs` VALUES ('fdec1656-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:08:03');
INSERT INTO `visit_logs` VALUES ('fdec16ba-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-19 00:08:05');
INSERT INTO `visit_logs` VALUES ('fdec16ee-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:27');
INSERT INTO `visit_logs` VALUES ('fdec1722-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:37');
INSERT INTO `visit_logs` VALUES ('fdec1750-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:40');
INSERT INTO `visit_logs` VALUES ('fdec177e-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:21:43');
INSERT INTO `visit_logs` VALUES ('fdec17ad-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-19 11:28:15');
INSERT INTO `visit_logs` VALUES ('fdec17da-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-19 11:29:47');
INSERT INTO `visit_logs` VALUES ('fdec1807-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:41:25');
INSERT INTO `visit_logs` VALUES ('fdec1834-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/045895154d359921d15d3948eeb824d9', 'mobile', '2026-09-19 11:41:33');
INSERT INTO `visit_logs` VALUES ('fdec1862-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:41:34');
INSERT INTO `visit_logs` VALUES ('fdec1890-bc99-11f1-b410-525400fdb9eb', '192.168.10.8', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-26 20:43:04');
INSERT INTO `visit_logs` VALUES ('fdec18be-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:44:59');
INSERT INTO `visit_logs` VALUES ('fdec18ea-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:45:14');
INSERT INTO `visit_logs` VALUES ('fdec1920-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/forum/forum', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-26 20:58:18');
INSERT INTO `visit_logs` VALUES ('fdec194d-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', '', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'desktop', '2026-09-27 15:59:44');
INSERT INTO `visit_logs` VALUES ('fdec1980-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:15:06');
INSERT INTO `visit_logs` VALUES ('fdec19ae-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:19:08');
INSERT INTO `visit_logs` VALUES ('fdec19de-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:19:09');
INSERT INTO `visit_logs` VALUES ('fdec1a0a-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:21:13');
INSERT INTO `visit_logs` VALUES ('fdec1a35-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:27:42');
INSERT INTO `visit_logs` VALUES ('fdec1a62-bc99-11f1-b410-525400fdb9eb', '127.0.0.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 16:52:10');
INSERT INTO `visit_logs` VALUES ('fdec1a8d-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/user/user', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:04:15');
INSERT INTO `visit_logs` VALUES ('fdec1ac0-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:04:33');
INSERT INTO `visit_logs` VALUES ('fdec1af4-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:10:01');
INSERT INTO `visit_logs` VALUES ('fdec1b28-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:11:06');
INSERT INTO `visit_logs` VALUES ('fdec1bc7-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:13:53');
INSERT INTO `visit_logs` VALUES ('fdec1bf3-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:18:10');
INSERT INTO `visit_logs` VALUES ('fdec1c69-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:19:51');
INSERT INTO `visit_logs` VALUES ('fdec1d0d-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/index/index', 'http://192.168.10.6:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/27.2 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-27 18:29:48');
INSERT INTO `visit_logs` VALUES ('fdec1d3a-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/1b87cb8ef5e59905acd8a683d5746cd9', 'mobile', '2026-09-27 18:32:26');
INSERT INTO `visit_logs` VALUES ('fdec1d75-bc99-11f1-b410-525400fdb9eb', '192.168.10.2', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-27 19:18:33');
INSERT INTO `visit_logs` VALUES ('fdec1db2-bc99-11f1-b410-525400fdb9eb', '192.168.10.6', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 13:14:25');
INSERT INTO `visit_logs` VALUES ('fdec1e45-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 13:52:47');
INSERT INTO `visit_logs` VALUES ('fdec1e71-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:01:09');
INSERT INTO `visit_logs` VALUES ('fdec1e9d-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 14:01:22');
INSERT INTO `visit_logs` VALUES ('fdec1f24-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:07:35');
INSERT INTO `visit_logs` VALUES ('fdec1f52-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:08:34');
INSERT INTO `visit_logs` VALUES ('fdec1fe7-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:14:40');
INSERT INTO `visit_logs` VALUES ('fdec2013-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:22:44');
INSERT INTO `visit_logs` VALUES ('fdec204f-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:28:31');
INSERT INTO `visit_logs` VALUES ('fdec20e2-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:28:34');
INSERT INTO `visit_logs` VALUES ('fdec210c-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:33:49');
INSERT INTO `visit_logs` VALUES ('fdec2186-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 14:41:17');
INSERT INTO `visit_logs` VALUES ('fdec21c9-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:50:06');
INSERT INTO `visit_logs` VALUES ('fdec2260-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 14:55:11');
INSERT INTO `visit_logs` VALUES ('fdec228c-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:01:38');
INSERT INTO `visit_logs` VALUES ('fdec2305-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:07:00');
INSERT INTO `visit_logs` VALUES ('fdec238b-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:12:30');
INSERT INTO `visit_logs` VALUES ('fdec241f-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:13:39');
INSERT INTO `visit_logs` VALUES ('fdec2498-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:18:07');
INSERT INTO `visit_logs` VALUES ('fdec2511-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 15:25:52');
INSERT INTO `visit_logs` VALUES ('fdec51c8-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 15:31:12');
INSERT INTO `visit_logs` VALUES ('fdec53f4-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:37:51');
INSERT INTO `visit_logs` VALUES ('fdec5513-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/265d18960fa4a596a1eec69a2d37b8b0', 'mobile', '2026-09-28 15:42:52');
INSERT INTO `visit_logs` VALUES ('fdec55c3-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 16:11:31');
INSERT INTO `visit_logs` VALUES ('fdec575a-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 16:22:57');
INSERT INTO `visit_logs` VALUES ('fdec5a3c-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 16:27:06');
INSERT INTO `visit_logs` VALUES ('fdec5a7e-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 17:11:32');
INSERT INTO `visit_logs` VALUES ('fdec5ab9-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 17:25:18');
INSERT INTO `visit_logs` VALUES ('fdec5ae7-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 17:34:33');
INSERT INTO `visit_logs` VALUES ('fdec5b1a-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 17:42:25');
INSERT INTO `visit_logs` VALUES ('fdec5b49-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-28 17:55:18');
INSERT INTO `visit_logs` VALUES ('fdec5b7a-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-28 22:42:13');
INSERT INTO `visit_logs` VALUES ('fdec5ba5-bc99-11f1-b410-525400fdb9eb', '39.163.100.1', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 00:30:32');
INSERT INTO `visit_logs` VALUES ('fdec5bda-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 12:45:59');
INSERT INTO `visit_logs` VALUES ('fdec5c0d-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 12:51:59');
INSERT INTO `visit_logs` VALUES ('fdec5c3a-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:04:54');
INSERT INTO `visit_logs` VALUES ('fdec5c69-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:11:32');
INSERT INTO `visit_logs` VALUES ('fdec5c95-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:11:36');
INSERT INTO `visit_logs` VALUES ('fdec5cc4-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:35:42');
INSERT INTO `visit_logs` VALUES ('fdec5cef-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 14:41:11');
INSERT INTO `visit_logs` VALUES ('fdec5d1e-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:47:51');
INSERT INTO `visit_logs` VALUES ('fdec5d4a-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:47:57');
INSERT INTO `visit_logs` VALUES ('fdec5dfb-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 14:48:48');
INSERT INTO `visit_logs` VALUES ('fdec5e28-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 15:22:32');
INSERT INTO `visit_logs` VALUES ('fdec5e59-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 15:22:36');
INSERT INTO `visit_logs` VALUES ('fdec5e86-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 15:36:08');
INSERT INTO `visit_logs` VALUES ('fdec5eb5-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 15:38:02');
INSERT INTO `visit_logs` VALUES ('fdec5ee2-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (Phone; OpenHarmony 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 ArkWeb/4.1.6.1 Mobile HuaweiBrowser/5.0.4.303 wechatdevtools/2.02.2608070 MicroMessenger/8.0.5 Language/zh_CN webview/ hash/33709919 sid/s0 winId/s0 token/96789cf62a111e467db4f25b04508176', 'mobile', '2026-09-29 15:56:35');
INSERT INTO `visit_logs` VALUES ('fdec5f14-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 15:58:07');
INSERT INTO `visit_logs` VALUES ('fdec5f46-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:02:11');
INSERT INTO `visit_logs` VALUES ('fdec5f73-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:03:16');
INSERT INTO `visit_logs` VALUES ('fdec5fa1-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:07:26');
INSERT INTO `visit_logs` VALUES ('fdec5fce-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:07:52');
INSERT INTO `visit_logs` VALUES ('fdec5ffa-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:13:12');
INSERT INTO `visit_logs` VALUES ('fdec6027-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:13:55');
INSERT INTO `visit_logs` VALUES ('fdec6053-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:16:00');
INSERT INTO `visit_logs` VALUES ('fdec60ea-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:24:54');
INSERT INTO `visit_logs` VALUES ('fdec6115-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-29 16:29:57');
INSERT INTO `visit_logs` VALUES ('fdec614a-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:44:55');
INSERT INTO `visit_logs` VALUES ('fdec6177-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:45:00');
INSERT INTO `visit_logs` VALUES ('fdec61a5-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 16:51:02');
INSERT INTO `visit_logs` VALUES ('fdec61d3-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 22:47:29');
INSERT INTO `visit_logs` VALUES ('fdec6202-bc99-11f1-b410-525400fdb9eb', '39.163.100.118', '/pages/index/index', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-29 22:52:28');
INSERT INTO `visit_logs` VALUES ('fdec622d-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 11:58:48');
INSERT INTO `visit_logs` VALUES ('fdec625b-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/message/message', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 12:38:00');
INSERT INTO `visit_logs` VALUES ('fdec6287-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-09-30 12:38:02');
INSERT INTO `visit_logs` VALUES ('fdec62b7-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 12:48:38');
INSERT INTO `visit_logs` VALUES ('fdec62e3-bc99-11f1-b410-525400fdb9eb', '39.163.100.208', '/pages/user/user', 'http://localhost:5173/', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'mobile', '2026-09-30 12:58:07');
INSERT INTO `visit_logs` VALUES ('ff634ee5-32cb-421b-a242-6b25cdcbaff0', '39.163.100.249', '/pages/user/user', '', 'Mozilla/5.0 (iPhone; CPU iPhone OS 27_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.78(0x18004e22) NetType/WIFI Language/zh_CN', 'mobile', '2026-10-02 14:57:41');

-- ----------------------------
-- Table structure for withdraw_records
-- ----------------------------
DROP TABLE IF EXISTS `withdraw_records`;
CREATE TABLE `withdraw_records`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创作者ID -> users.id',
  `no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '提现单号',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '提现金额（元）',
  `fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '手续费',
  `actual_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际到账金额',
  `method` enum('wechat','bank') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'wechat' COMMENT '方式：wechat微信零钱,bank银行卡',
  `account` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '收款账号（脱敏展示）',
  `status` enum('processing','done','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'processing' COMMENT '状态：processing处理中,done已到账,rejected已驳回',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_no`(`no`) USING BTREE,
  INDEX `idx_user_time`(`user_id`, `create_time`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '提现申请记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of withdraw_records
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- Table structure for poster_designs（海报设计模板）
-- ----------------------------
DROP TABLE IF EXISTS `poster_designs`;
CREATE TABLE `poster_designs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('cover','text') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cover' COMMENT '类型:cover单封面海报,text纯文字海报',
  `post_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '绑定的帖子类型:image_text图文,video视频,空=通用',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '设计配置JSON(width/height/bg_color/bg_image/title*/content*/footer_text/code_size/cover等)',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认模板(帖子分享套用)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1启用0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_default`(`is_default`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '海报设计模板' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of menus：新增「海报设计」菜单（挂在「常用功能」分组下）
-- ----------------------------
INSERT INTO `menus` (`parent_id`, `title`, `icon`, `path`, `role`, `sort`, `status`) VALUES
(1, '海报设计', 'image-edit-fill', '/admin/poster-design', 'admin', 3, 1);

-- ----------------------------
-- Records of poster_designs：预置三套分享海报模板（通用/图文/视频）
-- ----------------------------
INSERT INTO `poster_designs` (`id`, `type`, `post_type`, `title`, `config`, `is_default`, `status`, `create_time`, `update_time`) VALUES
(1, 'cover', '', '通用分享海报', '{"type":"cover","width":600,"height":840,"bg_color":"#ffffff","bg_image":"","title":"","title_color":"#1f2937","title_size":32,"content":"","content_color":"#4b5563","content_size":18,"footer_text":"长按识别小程序码","footer_color":"#9ca3af","code_size":160,"cover":""}', 1, 1, '2026-10-16 00:00:00', '2026-10-16 00:00:00'),
(2, 'cover', 'image_text', '图文专属海报', '{"type":"cover","width":600,"height":840,"bg_color":"#ffffff","bg_image":"","title":"","title_color":"#0f766e","title_size":32,"content":"","content_color":"#475569","content_size":18,"footer_text":"长按识别小程序码 查看图文","footer_color":"#94a3b8","code_size":160,"cover":""}', 0, 1, '2026-10-16 00:00:00', '2026-10-16 00:00:00'),
(3, 'text', 'video', '视频专属海报', '{"type":"text","width":600,"height":840,"bg_color":"#0f172a","bg_image":"","title":"","title_color":"#ffffff","title_size":34,"content":"","content_color":"#cbd5e1","content_size":18,"footer_text":"长按识别小程序码 观看视频","footer_color":"#94a3b8","code_size":150,"cover":""}', 0, 1, '2026-10-16 00:00:00', '2026-10-16 00:00:00');
