-- 添加客户ID字段到项目表
ALTER TABLE `project` ADD COLUMN `client_id` int(11) NULL DEFAULT NULL COMMENT '关联的客户ID' AFTER `category_id`;
-- 添加索引
ALTER TABLE `project` ADD INDEX `idx_client`(`client_id`) USING BTREE;
