#!/bin/bash

# 创建必要的目录
mkdir -p /var/log/nginx
mkdir -p /var/log/php-fpm
mkdir -p /var/lib/php/sessions
mkdir -p /tmp

# 设置权限
chown -R www-data:www-data /var/log/nginx
chown -R www-data:www-data /var/log/php-fpm
chown -R www-data:www-data /var/lib/php/sessions
chown -R www-data:www-data /tmp

# 启动PHP-FPM
php-fpm -D

# 启动nginx
nginx -g "daemon off;" 