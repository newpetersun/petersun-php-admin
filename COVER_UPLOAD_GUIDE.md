# 用户封面上传功能使用指南

## 功能概述

为用户管理系统添加了封面图片上传功能，用户可以在编辑个人信息时上传自定义封面图片，该封面将显示在首页用户信息卡片的背景中。

## 后端实现

### 1. 数据库变更

需要执行数据库迁移，添加以下字段到 `users` 表：

```sql
ALTER TABLE `users` ADD COLUMN `cover` varchar(500) DEFAULT NULL COMMENT '封面图URL' AFTER `avatar`;
ALTER TABLE `users` ADD COLUMN `weibo` varchar(255) DEFAULT NULL COMMENT '微博地址' AFTER `github`;
ALTER TABLE `users` ADD COLUMN `douyin` varchar(255) DEFAULT NULL COMMENT '抖音号' AFTER `weibo`;
```

迁移文件位置：`database/migrations/add_cover_and_social_fields_to_users.sql`

### 2. 新增接口

#### 上传封面接口

**接口地址：** `POST /user/uploadCover`

**请求参数：**
- `cover`: 文件类型，封面图片

**返回示例：**
```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "url": "/static/images/cover/cover_123456789.jpg"
  }
}
```

**文件限制：**
- 支持格式：jpg, jpeg, png, gif, webp
- 最大大小：5MB
- 存储路径：`public/static/images/cover/`

#### 更新用户信息接口

**接口地址：** `POST /user/update`

**新增字段：**
- `cover`: 封面图片 URL
- `weibo`: 微博地址
- `douyin`: 抖音号

### 3. 路由配置

已在 `route/app.php` 中添加路由：

```php
Route::post('upload-cover', 'User/uploadCover'); // 上传用户封面
```

## 前端实现

### 1. 用户管理页面 (admin/user.vue)

在编辑用户弹窗中添加了封面上传组件：

**功能特性：**
- 封面预览区域（160px 高度）
- 支持上传/更换封面
- 支持删除封面
- 实时预览上传的封面图片

**使用方法：**
1. 进入用户管理页面
2. 点击编辑用户
3. 在弹窗中找到"封面"字段
4. 点击"上传"按钮选择图片
5. 图片上传成功后会显示预览
6. 点击"保存"按钮保存用户信息

### 2. 首页展示 (index/index.vue)

首页用户信息卡片背景会自动使用用户上传的封面：

**显示逻辑：**
- 如果用户有自定义封面，使用 `userInfo.cover`
- 如果没有封面，使用默认背景图片

**样式特性：**
- 背景图片自适应（cover）
- 居中显示
- 80% 透明度

## 测试步骤

### 1. 数据库准备

```bash
# 执行数据库迁移
mysql -u root -p your_database < database/migrations/add_cover_and_social_fields_to_users.sql
```

### 2. 创建上传目录

```bash
# 确保上传目录存在且有写权限
mkdir -p public/static/images/cover
chmod 755 public/static/images/cover
```

### 3. 测试上传功能

1. 登录管理后台
2. 进入用户管理页面
3. 点击编辑用户
4. 上传封面图片
5. 保存用户信息

### 4. 验证显示效果

1. 访问首页
2. 查看用户信息卡片背景
3. 确认封面图片正确显示

## API 测试示例

### 使用 cURL 测试上传接口

```bash
curl -X POST http://your-domain/user/uploadCover \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "cover=@/path/to/your/image.jpg"
```

### 使用 Postman 测试

1. 创建 POST 请求到 `/user/uploadCover`
2. 在 Body 中选择 form-data
3. 添加 key 为 `cover`，类型为 File
4. 选择要上传的图片文件
5. 发送请求

## 注意事项

1. **文件大小限制**：单个文件不超过 5MB
2. **文件格式**：仅支持 jpg, jpeg, png, gif, webp
3. **权限要求**：需要管理员权限才能编辑用户信息
4. **存储路径**：确保 `public/static/images/cover/` 目录存在且可写
5. **图片比例**：建议使用 16:9 或 2:1 的横向图片以获得最佳显示效果

## 故障排查

### 上传失败

1. 检查文件大小是否超过 5MB
2. 检查文件格式是否支持
3. 检查上传目录权限
4. 查看服务器错误日志

### 封面不显示

1. 检查数据库中 cover 字段是否有值
2. 检查图片 URL 是否正确
3. 检查图片文件是否存在
4. 检查浏览器控制台是否有错误

### 权限问题

1. 确保已登录且有管理员权限
2. 检查 JWT token 是否有效
3. 检查中间件配置是否正确

## 未来优化建议

1. 添加图片裁剪功能
2. 支持图片压缩
3. 添加图片预加载
4. 支持多种尺寸生成
5. 添加 CDN 支持
