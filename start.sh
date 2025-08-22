#!/bin/bash

# PeterSun作品集项目快速启动脚本

echo "=== PeterSun作品集项目启动脚本 ==="
echo ""

# 检查PHP版本
echo "检查PHP版本..."
php_version=$(php -v | head -n 1 | cut -d " " -f 2 | cut -d "." -f 1-2)
required_version="8.0"

if [ "$(printf '%s\n' "$required_version" "$php_version" | sort -V | head -n1)" = "$required_version" ]; then
    echo "✅ PHP版本检查通过: $php_version"
else
    echo "❌ PHP版本过低: $php_version (需要 >= $required_version)"
    exit 1
fi

# 检查Composer
echo "检查Composer..."
if command -v composer &> /dev/null; then
    echo "✅ Composer已安装"
else
    echo "❌ Composer未安装，请先安装Composer"
    exit 1
fi

# 检查MySQL连接
echo "检查数据库连接..."
if command -v mysql &> /dev/null; then
    echo "✅ MySQL客户端已安装"
else
    echo "⚠️  MySQL客户端未安装，请确保数据库服务正在运行"
fi

# 安装依赖
echo "安装PHP依赖..."
if [ -f "composer.json" ]; then
    composer install --no-dev --optimize-autoloader
    echo "✅ 依赖安装完成"
else
    echo "❌ composer.json文件不存在"
    exit 1
fi

# 检查环境配置文件
echo "检查环境配置..."
if [ ! -f ".env" ]; then
    if [ -f ".example.env" ]; then
        cp .example.env .env
        echo "✅ 已创建.env文件，请编辑配置数据库连接信息"
    else
        echo "❌ .example.env文件不存在"
        exit 1
    fi
else
    echo "✅ 环境配置文件已存在"
fi

# 创建必要的目录
echo "创建必要目录..."
mkdir -p runtime/cache
mkdir -p runtime/log
mkdir -p public/static/uploads
mkdir -p public/static/images/projects
mkdir -p public/static/images/avatar

# 设置目录权限
echo "设置目录权限..."
chmod -R 755 runtime/
chmod -R 755 public/static/

echo ""
echo "=== 启动完成 ==="
echo ""
echo "下一步操作："
echo "1. 编辑 .env 文件，配置数据库连接信息"
echo "2. 创建数据库并导入 database/init.sql"
echo "3. 启动Web服务器"
echo "4. 访问 http://localhost 测试API"
echo ""
echo "数据库初始化命令："
echo "mysql -u root -p -e 'CREATE DATABASE petersun_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;'"
echo "mysql -u root -p petersun_portfolio < database/init.sql"
echo ""
echo "API测试命令："
echo "php test_api.php"
echo ""
echo "默认管理员账号："
echo "用户名: admin"
echo "密码: 123456" 