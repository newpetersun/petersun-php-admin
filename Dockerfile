# 使用官方PHP 8.1 FPM镜像作为基础镜像
FROM php:8.1-fpm

# 设置工作目录
WORKDIR /var/www/html

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    nginx \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 复制项目文件
COPY . /var/www/html/

# 设置目录权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/runtime \
    && chmod -R 777 /var/www/html/public

# 安装PHP依赖
RUN composer install --no-dev --optimize-autoloader

# 复制nginx配置文件
COPY docker/nginx.conf /etc/nginx/sites-available/default

# 复制PHP-FPM配置
COPY docker/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# 创建环境配置文件
RUN cp .example.env .env

# 创建启动脚本
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# 暴露端口
EXPOSE 80

# 启动服务
CMD ["/start.sh"] 