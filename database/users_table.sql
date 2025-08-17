-- 创建用户表
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `name` varchar(100) DEFAULT NULL COMMENT '姓名',
  `code_age` varchar(50) DEFAULT NULL COMMENT '编程年龄',
  `description` text DEFAULT NULL COMMENT '个人描述',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `github` varchar(255) DEFAULT NULL COMMENT 'GitHub链接',
  `wechat` varchar(100) DEFAULT NULL COMMENT '微信号',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) DEFAULT NULL COMMENT '最后登录IP',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 插入默认管理员用户（密码：123456）
INSERT INTO `users` (`username`, `password`, `email`, `nickname`, `name`, `code_age`, `description`, `avatar`, `github`, `wechat`, `status`) VALUES
('admin', '$2y$10$9VtovDn5RSMuuX4nynFUhe6QsXBwK5V0akBwYi7mff3NeEM50dD1i', 'admin@example.com', '管理员', 'PeterSun', '5年', '全栈开发工程师，专注于Web开发和移动应用开发', '/static/images/avatar.jpg', 'https://github.com/petersun', 'petersun_wechat', 1); 