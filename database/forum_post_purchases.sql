-- 论坛付费帖子购买记录表（金币）。存量库若已随 sundongliang.sql 建好可跳过；
-- 若缺失，用 CREATE TABLE IF NOT EXISTS 安全创建。
CREATE TABLE IF NOT EXISTS `forum_post_purchases` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子ID -> forum_posts(id)',
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '购买用户 -> users(id)',
  `coins` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '本次支付的金币数(=帖子 coin_price)',
  `settle_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '结算状态:0未结算,1已结算,2已退款',
  `settle_amount` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '结算给作者的金币(扣除平台佣金后)',
  `settle_time` datetime DEFAULT NULL COMMENT '结算时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '购买时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛付费帖子购买记录(金币)';

ALTER TABLE `forum_post_purchases`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_post_user` (`post_id`,`user_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_settle` (`settle_status`);
