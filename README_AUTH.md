# 用户认证系统使用说明

## 概述
本项目已集成完整的用户认证系统，使用JWT（JSON Web Token）进行身份验证，支持用户注册、登录、登出等功能。

## 功能特性

- ✅ 用户注册和登录
- ✅ JWT Token认证
- ✅ 密码加密存储（bcrypt）
- ✅ 用户信息管理
- ✅ Token刷新机制
- ✅ 中间件保护路由
- ✅ 完整的API文档

## 安装和配置

### 1. 安装依赖
```bash
composer install
```

### 2. 配置数据库
编辑 `.env` 文件（如果不存在，复制 `.example.env` 并重命名）：
```env
DB_TYPE = mysql
DB_HOST = 127.0.0.1
DB_NAME = your_database_name
DB_USER = your_username
DB_PASS = your_password
DB_PORT = 3306
DB_CHARSET = utf8mb4
```

### 3. 创建数据库表
执行SQL文件创建用户表：
```bash
mysql -u your_username -p your_database_name < database/users_table.sql
```

或者手动执行以下SQL：
```sql
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：1启用，0禁用',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) DEFAULT NULL COMMENT '最后登录IP',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
```

### 4. 测试系统
运行测试脚本验证功能：
```bash
php test_auth.php
```

## API接口

### 认证接口

| 方法 | 路径 | 说明 | 是否需要认证 |
|------|------|------|-------------|
| POST | `/auth/login` | 用户登录 | 否 |
| POST | `/auth/register` | 用户注册 | 否 |
| GET | `/auth/profile` | 获取用户信息 | 是 |
| POST | `/auth/refresh` | 刷新Token | 是 |
| POST | `/auth/logout` | 用户登出 | 是 |

### 使用示例

#### 1. 用户登录
```bash
curl -X POST http://your-domain.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "123456"
  }'
```

#### 2. 获取用户信息
```bash
curl -X GET http://your-domain.com/auth/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 3. 刷新Token
```bash
curl -X POST http://your-domain.com/auth/refresh \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 文件结构

```
petersun-php-admin/
├── app/
│   ├── controller/
│   │   └── Auth.php              # 认证控制器
│   ├── model/
│   │   └── User.php              # 用户模型
│   ├── service/
│   │   └── JwtService.php        # JWT服务
│   └── middleware/
│       └── JwtAuth.php           # JWT认证中间件
├── config/
│   └── jwt.php                   # JWT配置
├── database/
│   ├── migrations/
│   │   └── 20241201_create_users_table.php  # 用户表迁移
│   ├── seeds/
│   │   └── UserSeeder.php        # 用户数据种子
│   └── users_table.sql           # 用户表SQL
├── route/
│   └── app.php                   # 路由配置
├── API_AUTH.md                   # API文档
├── test_auth.php                 # 测试脚本
└── README_AUTH.md                # 本文件
```

## 默认用户

系统预置了两个测试用户：

| 用户名 | 密码 | 邮箱 | 说明 |
|--------|------|------|------|
| admin | 123456 | admin@example.com | 管理员用户 |
| test | 123456 | test@example.com | 测试用户 |

## 安全配置

### 1. 修改JWT密钥
在生产环境中，请修改 `app/service/JwtService.php` 中的密钥：
```php
$this->secret = 'your-production-secret-key';
```

### 2. 配置HTTPS
建议在生产环境中使用HTTPS协议。

### 3. 设置Token过期时间
可以在 `JwtService.php` 中修改Token过期时间：
```php
$this->expireTime = 3600; // 1小时
```

## 中间件使用

### 保护路由
在需要认证的路由上添加中间件：
```php
Route::group('protected', function () {
    Route::get('data', 'Controller/method');
})->middleware('JwtAuth');
```

### 获取当前用户
在控制器中获取当前用户信息：
```php
public function method(Request $request)
{
    $userId = $request->userId;
    $username = $request->username;
    // 处理业务逻辑
}
```

## 错误处理

系统会返回统一的错误格式：
```json
{
    "code": 401,
    "message": "Token无效或已过期"
}
```

常见错误码：
- 200: 成功
- 400: 请求参数错误
- 401: 未认证或token无效
- 403: 账户被禁用
- 404: 用户不存在
- 500: 服务器内部错误

## 扩展功能

### 1. 添加用户角色
可以在用户表中添加 `role` 字段，并在JWT payload中包含角色信息。

### 2. 实现Token黑名单
可以在登出时将Token加入黑名单，防止重复使用。

### 3. 添加登录日志
可以创建登录日志表，记录用户的登录历史。

### 4. 密码重置功能
可以实现邮箱验证的密码重置功能。

## 技术支持

如有问题，请查看：
1. `API_AUTH.md` - 详细的API文档
2. `test_auth.php` - 功能测试脚本
3. 项目日志文件

## 更新日志

- 2024-12-01: 初始版本，实现基础认证功能
- 支持用户注册、登录、JWT认证
- 集成ThinkPHP 8.0框架 