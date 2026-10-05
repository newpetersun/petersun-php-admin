-- 用户钱包表（金币余额从此表读写，不再放在 users 表）。存量库执行此脚本创建。
CREATE TABLE IF NOT EXISTS `user_wallet` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID -> users(id)，一对一',
  `balance` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '金币余额',
  `frozen` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '冻结金币(待结算/冻结中)',
  `total_earned` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '累计获得金币',
  `total_spent` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '累计消费金币',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户钱包(金币)';

ALTER TABLE `user_wallet`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user` (`user_id`);
