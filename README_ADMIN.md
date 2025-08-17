# 解忧青年作品集后台管理系统

## 项目概述

这是一个基于ThinkPHP 8.0和Bootstrap 5.3.0构建的现代化后台管理系统，用于管理个人作品集网站的内容。

## 功能特性

### 🎯 核心功能
- **个人信息管理** - 管理个人基本信息、头像、描述等
- **项目管理** - 完整的项目CRUD操作，支持分类、标签、技术栈
- **联系信息管理** - 管理联系方式和工作时间
- **留言管理** - 查看、回复、删除访客留言
- **系统设置** - 系统信息查看和缓存管理

### 🎨 界面特性
- **现代化设计** - 基于Bootstrap 5.3.0的最新设计
- **响应式布局** - 完美适配各种设备尺寸
- **渐变色彩** - 美观的紫色渐变主题
- **图标支持** - 使用Bootstrap Icons图标库
- **交互反馈** - 丰富的动画和状态反馈

### 🔧 技术特性
- **RESTful API** - 标准的REST API设计
- **数据库事务** - 确保数据一致性
- **错误处理** - 完善的异常处理机制
- **前端验证** - 客户端表单验证
- **实时更新** - 无需刷新页面的数据更新

## 安装部署

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
# 编辑.env文件，配置数据库连接信息
```

4. **创建数据库**
```bash
# 导入数据库结构
mysql -u username -p database_name < database/migrations/create_tables.sql
```

5. **配置Web服务器**
```apache
# Apache配置示例
<VirtualHost *:80>
    ServerName admin.yourdomain.com
    DocumentRoot /path/to/petersun-php-admin/public
    
    <Directory /path/to/petersun-php-admin/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

## 使用指南

### 访问后台
访问 `http://yourdomain.com/admin` 进入后台管理系统

### 功能模块

#### 1. 仪表盘
- 查看系统概览数据
- 最近项目和留言统计
- 快速访问各功能模块

#### 2. 个人信息管理
- 编辑个人姓名、邮箱、码龄
- 上传头像（支持URL）
- 修改个人描述

#### 3. 项目管理
- **添加项目**：点击"添加项目"按钮
- **编辑项目**：点击项目行的编辑按钮
- **删除项目**：点击项目行的删除按钮
- **项目分类**：支持Web开发、移动开发、桌面应用、数据分析等分类
- **项目标签**：为项目添加多个标签
- **技术栈**：记录项目使用的技术
- **排序功能**：通过排序字段控制项目显示顺序

#### 4. 联系信息管理
- 管理邮箱、微信、QQ、地址、GitHub
- 设置工作时间（工作日、周六、周日）
- 实时更新前端显示的联系信息

#### 5. 留言管理
- 查看所有访客留言
- 标记留言为已读/未读
- 批量操作留言
- 删除垃圾留言
- 按状态筛选留言

#### 6. 系统设置
- 查看系统信息（PHP版本、ThinkPHP版本等）
- 清除系统缓存
- 优化数据库
- 备份数据库
- 查看系统日志

### API接口

#### 用户信息接口
- `GET /api/user/info` - 获取用户信息
- `POST /api/user/update` - 更新用户信息

#### 项目接口
- `GET /api/project/list` - 获取项目列表
- `GET /api/project/detail/:id` - 获取项目详情
- `POST /api/project/create` - 创建项目
- `POST /api/project/update/:id` - 更新项目
- `DELETE /api/project/delete/:id` - 删除项目
- `GET /api/project/categories` - 获取项目分类

#### 联系信息接口
- `GET /api/contact/info` - 获取联系信息
- `POST /api/contact/update` - 更新联系信息
- `POST /api/contact/message` - 提交留言
- `GET /api/contact/messages` - 获取留言列表
- `POST /api/contact/read/:id` - 标记留言为已读
- `DELETE /api/contact/message/:id` - 删除留言

## 数据库结构

### 主要数据表
- `user` - 用户信息表
- `project` - 项目表
- `project_category` - 项目分类表
- `project_tag` - 项目标签表
- `project_technology` - 项目技术栈表
- `contact` - 联系信息表
- `contact_message` - 联系留言表

## 自定义配置

### 修改主题色彩
在 `view/admin/layout.html` 中修改CSS变量：
```css
.sidebar {
    background: linear-gradient(135deg, #your-color1 0%, #your-color2 100%);
}
```

### 添加新的项目分类
在数据库的 `project_category` 表中添加新分类，或通过API接口动态管理。

### 扩展功能模块
1. 在 `app/controller/` 目录下创建新的控制器
2. 在 `route/app.php` 中添加路由配置
3. 在 `view/admin/` 目录下创建对应的视图文件

## 安全建议

1. **修改默认配置**
   - 更改数据库密码
   - 配置HTTPS
   - 设置适当的文件权限

2. **访问控制**
   - 添加登录验证
   - 实现权限管理
   - 限制API访问频率

3. **数据备份**
   - 定期备份数据库
   - 备份上传的文件
   - 测试恢复流程

## 故障排除

### 常见问题

1. **页面无法访问**
   - 检查Web服务器配置
   - 确认URL重写规则
   - 查看错误日志

2. **数据库连接失败**
   - 检查数据库配置
   - 确认数据库服务运行状态
   - 验证用户权限

3. **API请求失败**
   - 检查路由配置
   - 确认控制器方法存在
   - 查看PHP错误日志

### 日志查看
- 应用日志：`runtime/log/`
- Web服务器日志：根据服务器配置查看
- PHP错误日志：`php.ini` 中配置的路径

## 技术支持

如有问题，请通过以下方式联系：
- 邮箱：cto@cvun.net
- GitHub：github.com/Juveniles-Full-Stack-Developer

## 更新日志

### v1.0.0 (2024-01-15)
- 初始版本发布
- 实现基础CRUD功能
- 完成后台管理界面
- 支持项目分类和标签管理 