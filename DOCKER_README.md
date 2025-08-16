# PeterSun PHP Admin - Docker 部署指南

## 项目简介

这是一个基于 ThinkPHP 8 的 PHP 管理后台系统，使用 Docker 进行容器化部署。

## 系统要求

- Docker 20.10+
- Docker Compose 2.0+
- 至少 2GB 可用内存
- 至少 10GB 可用磁盘空间

## 快速开始

### 1. 克隆项目

```bash
git clone <项目地址>
cd petersun-php-admin
```

### 2. 环境配置

复制环境配置文件：

```bash
cp .example.env .env
```

编辑 `.env` 文件，配置数据库连接信息：

```env
APP_DEBUG = true

DB_TYPE = mysql
DB_HOST = mysql
DB_NAME = petersun_admin
DB_USER = root
DB_PASS = password
DB_PORT = 3306
DB_CHARSET = utf8mb4

DEFAULT_LANG = zh-cn
```

### 3. 启动服务

使用 Docker Compose 启动所有服务：

```bash
docker-compose up -d
```

### 4. 访问应用

- 主应用：http://localhost:8080
- phpMyAdmin：http://localhost:8081
- 数据库：localhost:3306

## 服务说明

### 应用服务 (app)
- **端口**: 8080
- **技术栈**: PHP 8.1 + Nginx + PHP-FPM
- **功能**: 提供 Web 应用服务

### 数据库服务 (mysql)
- **端口**: 3306
- **版本**: MySQL 8.0
- **数据库**: petersun_admin
- **用户名**: root
- **密码**: password

### 数据库管理 (phpMyAdmin)
- **端口**: 8081
- **功能**: 提供数据库管理界面

## 常用命令

### 启动服务
```bash
docker-compose up -d
```

### 停止服务
```bash
docker-compose down
```

### 查看日志
```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs app
docker-compose logs mysql
```

### 进入容器
```bash
# 进入应用容器
docker-compose exec app bash

# 进入数据库容器
docker-compose exec mysql mysql -u root -p
```

### 重新构建
```bash
docker-compose build --no-cache
docker-compose up -d
```

## 数据持久化

项目使用 Docker volumes 来持久化数据：

- `mysql_data`: MySQL 数据库数据
- `./runtime`: 应用运行时文件
- `./public`: 公共文件目录

## 性能优化

### PHP-FPM 配置
- 最大子进程数：50
- 启动进程数：5
- 最大请求数：1000

### Nginx 配置
- 静态文件缓存：1年
- 安全头设置
- URL 重写支持

## 安全配置

### 文件访问限制
- 禁止访问 `runtime`、`config`、`app` 等敏感目录
- 隐藏 PHP 版本信息
- 设置安全响应头

### 数据库安全
- 使用强密码
- 限制网络访问
- 定期备份

## 故障排除

### 常见问题

1. **端口冲突**
   ```bash
   # 修改 docker-compose.yml 中的端口映射
   ports:
     - "8081:80"  # 改为其他端口
   ```

2. **权限问题**
   ```bash
   # 重新设置目录权限
   docker-compose exec app chown -R www-data:www-data /var/www/html
   ```

3. **数据库连接失败**
   ```bash
   # 检查数据库服务状态
   docker-compose ps mysql
   
   # 查看数据库日志
   docker-compose logs mysql
   ```

### 日志位置
- Nginx 日志：`/var/log/nginx/`
- PHP-FPM 日志：`/var/log/php-fpm/`
- 应用日志：`./runtime/log/`

## 生产环境部署

### 1. 修改环境配置
```env
APP_DEBUG = false
DB_PASS = <强密码>
```

### 2. 配置 SSL 证书
在 `docker/nginx.conf` 中添加 SSL 配置。

### 3. 设置备份策略
```bash
# 数据库备份
docker-compose exec mysql mysqldump -u root -p petersun_admin > backup.sql
```

### 4. 监控配置
- 配置日志轮转
- 设置资源监控
- 配置告警机制

## 技术支持

如有问题，请查看：
1. Docker 日志
2. 应用日志
3. 数据库日志
4. 网络连接状态

## 更新日志

- v1.0.0: 初始版本，支持基本的 Docker 部署
- 使用 Nginx + PHP-FPM 架构
- 集成 MySQL 8.0 数据库
- 提供 phpMyAdmin 管理界面 