-- 更新users表结构，添加个人信息字段
ALTER TABLE `users` 
ADD COLUMN `name` varchar(100) DEFAULT NULL COMMENT '姓名' AFTER `nickname`,
ADD COLUMN `code_age` varchar(50) DEFAULT NULL COMMENT '编程年龄' AFTER `name`,
ADD COLUMN `description` text DEFAULT NULL COMMENT '个人描述' AFTER `code_age`,
ADD COLUMN `github` varchar(255) DEFAULT NULL COMMENT 'GitHub链接' AFTER `avatar`,
ADD COLUMN `wechat` varchar(100) DEFAULT NULL COMMENT '微信号' AFTER `github`;

-- 更新admin用户的信息
UPDATE `users` SET 
    `name` = 'PeterSun',
    `code_age` = '5年',
    `description` = '全栈开发工程师，专注于Web开发和移动应用开发',
    `avatar` = '/static/images/avatar.jpg',
    `github` = 'https://github.com/petersun',
    `wechat` = 'petersun_wechat'
WHERE `username` = 'admin';

-- 验证更新结果
SELECT `id`, `username`, `name`, `email`, `code_age`, `description`, `github`, `wechat` 
FROM `users` 
WHERE `username` = 'admin'; 