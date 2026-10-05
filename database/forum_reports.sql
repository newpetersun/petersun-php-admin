-- 论坛帖子举报表（存量库迁移用）
-- 在线上已有库执行以下语句即可，已存在则不会重复创建。

CREATE TABLE IF NOT EXISTS `forum_reports` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键UUID',
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '被举报帖子 -> forum_posts(id)',
  `reporter_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '举报人 -> users(id)',
  `reason` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '举报原因(垃圾广告/色情低俗/诈骗虚假/侵权抄袭/违法违规/其他)',
  `desc` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '补充说明',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '处理状态:0待处理,1已处理,2已驳回',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '举报时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛帖子举报记录';

ALTER TABLE `forum_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_post` (`post_id`),
  ADD KEY `idx_reporter` (`reporter_id`),
  ADD KEY `idx_status` (`status`);
