# PeterSun作品集项目部署说明

## 项目概述

这是一个基于ThinkPHP 8.0和Vue3 + UniApp的个人作品集项目，包含前端展示和后台管理系统。

## 后端部署 (petersun-php-admin)

### 环境要求

- PHP >= 8.0
- MySQL >= 5.7
- Composer
- Web服务器 (Apache/Nginx)

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd petersun-php-admin
```

2. **安装依赖**
```bash
composer install
```

3. **配置环境**
```bash
cp .example.env .env
```

编辑 `.env` 文件，配置数据库连接：
```env
APP_DEBUG = true

DB_TYPE = mysql
DB_HOST = 127.0.0.1
DB_NAME = petersun_portfolio
DB_USER = root
DB_PASS = your_password
DB_PORT = 3306
DB_CHARSET = utf8mb4

DEFAULT_LANG = zh-cn
```

4. **创建数据库**
```sql
CREATE DATABASE petersun_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

5. **导入数据库结构**
```bash
mysql -u root -p petersun_portfolio < database/init.sql
```

6. **设置目录权限**
```bash
chmod -R 755 runtime/
chmod -R 755 public/static/
```

7. **配置Web服务器**

**Apache配置 (.htaccess已包含)**
```apache
<VirtualHost *:80>
    ServerName your-domain.com
    DocumentRoot /path/to/petersun-php-admin/public
    
    <Directory /path/to/petersun-php-admin/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

**Nginx配置**
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /path/to/petersun-php-admin/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

### API接口说明

#### 基础信息
- **基础URL**: `https://your-domain.com`
- **API版本**: v1.0.0
- **数据格式**: JSON
- **字符编码**: UTF-8

#### 主要接口

1. **用户相关**
   - `GET /user/info` - 获取用户信息
   - `POST /user/update` - 更新用户信息
   - `GET /user/technologies` - 获取技术栈列表
   - `GET /user/map-data` - 获取地图数据

2. **项目相关**
   - `GET /project/list` - 获取项目列表
   - `GET /project/detail/:id` - 获取项目详情
   - `GET /project/categories` - 获取项目分类
   - `GET /project/featured` - 获取首页推荐项目
   - `POST /project/create` - 创建项目
   - `POST /project/update/:id` - 更新项目
   - `DELETE /project/delete/:id` - 删除项目
   - `POST /project/status/:id` - 更新项目状态

3. **联系相关**
   - `GET /contact/info` - 获取联系信息
   - `POST /contact/update` - 更新联系信息
   - `GET /contact/messages` - 获取留言列表
   - `POST /contact/message` - 提交留言
   - `POST /contact/read/:id` - 标记留言为已读
   - `DELETE /contact/message/:id` - 删除留言

4. **后台管理**
   - `POST /auth/login` - 管理员登录
   - `GET /admin/dashboard` - 获取仪表盘数据
   - `GET /admin/stats` - 获取系统统计
   - `GET /admin/visit-trend` - 获取访问趋势

5. **访问统计**
   - `POST /visit/log` - 记录访问日志
   - `GET /visit/stats` - 获取访问统计
   - `GET /visit/trend` - 获取访问趋势
   - `GET /visit/realtime` - 获取实时访问数据

## 前端部署 (petersun)

### 环境要求

- Node.js >= 14.0
- HBuilderX (推荐)
- 微信开发者工具 (小程序发布)

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd petersun
```

2. **安装依赖**
```bash
npm install
```

3. **配置API地址**

编辑 `config/config.js` 文件，修改API基础地址：
```javascript
// 开发环境
development: {
    API_BASE_URL: 'http://127.0.0.5', // 修改为你的后端地址
    // ...
}

// 生产环境
production: {
    API_BASE_URL: 'https://your-domain.com', // 修改为你的生产环境地址
    // ...
}
```

4. **编译发布**

**H5版本**
```bash
# 在HBuilderX中运行到浏览器
# 或使用命令行
npm run build:h5
```

**微信小程序**
```bash
# 在HBuilderX中运行到小程序模拟器
# 或使用微信开发者工具打开 unpackage/dist/dev/mp-weixin 目录
```

**App版本**
```bash
# 在HBuilderX中运行到手机或模拟器
# 或打包为APK/IPA
```

### 发布说明

1. **H5版本**
   - 编译后的文件在 `unpackage/dist/build/h5/` 目录
   - 上传到Web服务器即可

2. **微信小程序**
   - 在微信开发者工具中上传代码
   - 提交审核并发布

3. **App版本**
   - 在HBuilderX中云打包
   - 生成APK/IPA文件

## 数据库结构

### 主要数据表

1. **users** - 用户表
2. **project** - 项目表
3. **tag** - 标签表
4. **technology** - 技术栈表
5. **project_tag** - 项目标签关联表
6. **project_technology** - 项目技术栈关联表
7. **contact** - 联系信息表
8. **message** - 留言表
9. **visit_log** - 访问日志表

### 默认数据

- 管理员账号: `admin` / `123456`
- 默认联系信息已配置
- 示例项目和标签已创建

## 常见问题

### 1. 数据库连接失败
- 检查数据库配置是否正确
- 确认数据库服务是否启动
- 检查数据库用户权限

### 2. 文件上传失败
- 检查 `public/static/` 目录权限
- 确认PHP上传配置
- 检查文件大小限制

### 3. 跨域问题
- 检查CORS配置
- 确认前端API地址配置
- 检查Web服务器配置

### 4. 小程序发布失败
- 检查小程序AppID配置
- 确认域名白名单设置
- 检查SSL证书

## 技术支持

如有问题，请联系：
- 邮箱: cto@cvun.net
- 微信: cto-peter
- GitHub: https://github.com/petersun 