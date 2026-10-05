-- ============================================================
-- 后台登录体系（基于 users 表，废弃 admins 表）
--  - 后台密码登录：账号 = 站长昵称(nickname)，密码 = bcrypt 哈希，仅 user_type=webmaster 可登录
--  - 扫码登录：admin_scan_tickets 票据表（与密码登录无关，保留）
--  - 前置：sundongliang.sql 已建 users 表，且含 webmaster 管理员(Sam)
-- 执行顺序：先 sundongliang.sql（全量库），再本文件；本文件可重复执行（幂等）
-- ============================================================

-- 1) 安全给 users 表增加后台密码登录字段（列不存在才加，重复执行不报错）
SET @db  = DATABASE();
SET @col = (SELECT COUNT(*) FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'users' AND COLUMN_NAME = 'password');
SET @sql = IF(@col = 0,
  'ALTER TABLE `users` ADD COLUMN `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT ''后台密码登录(bcrypt 哈希)；仅 webmaster 设置，普通用户为空''',
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2) 后台扫码登录票据（扫码登录使用；IF NOT EXISTS 幂等）
CREATE TABLE IF NOT EXISTS `admin_scan_tickets` (
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

-- 3) 清理旧版 admins 体系遗留的多余 webmaster 种子用户（如存在，无害）
DELETE FROM `users` WHERE `id` = 'a0000000-0000-0000-0000-00000000000a';

-- 4) 给已有的 webmaster 管理员(Sam)设置初始密码
--    登录账号 = 昵称 "Sam"，初始密码 = admin123（bcrypt 哈希，请上线前修改）
UPDATE `users`
SET `password` = '$2y$10$sqN1OQ1uw5p3ZQywRYDwpuYSjxR7Jzj0UgA6GJpFQiRsdoJSshwAG'
WHERE `id` = 'fdeaf46a-bc99-11f1-b410-525400fdb9eb'
  AND `user_type` = 'webmaster';

-- 5) 昵称唯一约束（后台以昵称登录，需唯一避免歧义；索引不存在才加，幂等）
SET @idx = (SELECT COUNT(*) FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'users' AND INDEX_NAME = 'uk_nickname');
SET @sql2 = IF(@idx = 0, 'ALTER TABLE `users` ADD UNIQUE KEY `uk_nickname` (`nickname`)', 'SELECT 1');
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;
