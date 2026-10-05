-- forum_posts 新增付费金币价格字段（已导入 sundongliang.sql 的存量库执行此脚本）
ALTER TABLE `forum_posts`
  ADD COLUMN `coin_price` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '付费金币价格(0表示免费)' AFTER `is_paid`;
