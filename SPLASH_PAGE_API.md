# 启动页数据接口文档

## 功能概述

启动页（splash）从后端接口动态获取数据，包括用户头像和欢迎语，实现内容的灵活配置。

## 数据来源

### 1. 头像
- **来源表**: `users`
- **获取规则**: 获取 `id = 1` 的用户头像
- **字段**: `avatar`
- **默认值**: `/static/images/peter.jpg`

### 2. 欢迎语
- **来源表**: `system_settings`
- **获取规则**: 获取 `setting_key = 'subdescription'` 的设置值
- **字段**: `setting_value`
- **默认值**: 乔布斯于科技世界种下创新种子，罗永浩在行业浪潮里坚守情怀高地...

## API 接口

### 获取启动页数据

**接口地址**: `GET /user/splash-data`

**请求参数**: 无

**返回示例**:
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "avatar": "/static/images/avatar/avatar_123456.jpg",
    "welcome_text": "乔布斯于科技世界种下创新种子，罗永浩在行业浪潮里坚守情怀高地，都让我着迷。我仿佛看到老罗和乔布斯在科技和人文的十字路口探讨人生，所以我带着这份情怀，期待在这里与你相遇。"
  }
}
```

**错误返回**:
```json
{
  "code": 500,
  "message": "服务器错误：具体错误信息"
}
```

## 前端实现

### 页面文件
`petersun-uniapp/pages/splash/splash.vue`

### 调用方式
```javascript
import ApiService from '@/utils/api.js';

// 获取启动页数据
const data = await ApiService.user.getSplashData();
```

### 数据使用
1. **头像显示**: 动态绑定到头像 image 组件
2. **欢迎语**: 使用打字机效果逐字显示

### 动画流程
1. 页面加载时调用接口获取数据
2. 数据获取成功后启动动画序列
3. 头像从底部漂浮上来（1.2s 动画）
4. 延迟 1.5s 后开始打字机效果
5. 延迟 4s 后显示"进入应用"按钮

## 配置方法

### 修改头像
1. 登录管理后台
2. 进入用户管理
3. 编辑 ID 为 1 的用户
4. 上传新头像
5. 保存

### 修改欢迎语
1. 登录管理后台
2. 进入系统设置
3. 找到 `subdescription` 设置项
4. 修改设置值
5. 保存

或者直接在数据库中修改：
```sql
UPDATE system_settings 
SET setting_value = '你的欢迎语内容' 
WHERE setting_key = 'subdescription';
```

## 测试步骤

### 1. 测试接口
```bash
# 使用 curl 测试
curl http://your-domain/user/splash-data

# 或使用浏览器直接访问
http://your-domain/user/splash-data
```

### 2. 测试前端显示
1. 打开小程序/H5 应用
2. 查看启动页
3. 确认头像正确显示
4. 确认欢迎语打字机效果正常

### 3. 测试数据更新
1. 修改数据库中的头像或欢迎语
2. 重新打开应用
3. 确认显示已更新

## 性能优化

### 1. 缓存策略
- 接口响应速度快，无需额外缓存
- 如需缓存，可在前端使用 localStorage 缓存 1 小时

### 2. 错误处理
- 接口失败时使用默认值
- 不影响动画正常播放
- 静默处理错误，不显示错误提示

### 3. 加载优化
- 接口调用与动画并行
- 数据获取完成后立即启动动画
- 避免阻塞页面渲染

## 扩展功能建议

### 1. 多语言支持
在 system_settings 中添加多语言版本的欢迎语：
- `subdescription_en`: 英文版本
- `subdescription_zh`: 中文版本

### 2. 个性化配置
根据用户类型显示不同的欢迎语：
- 新用户：欢迎新用户的文案
- 老用户：欢迎回来的文案

### 3. 动态背景
添加背景图片配置：
- 在 system_settings 中添加 `splash_background` 设置
- 支持上传自定义背景图片

### 4. A/B 测试
支持多个欢迎语版本：
- 随机显示不同版本
- 统计用户偏好
- 优化文案效果

## 故障排查

### 头像不显示
1. 检查 users 表 id=1 的记录是否存在
2. 检查 avatar 字段值是否正确
3. 检查图片文件是否存在
4. 检查图片路径是否正确

### 欢迎语不显示
1. 检查 system_settings 表是否有 subdescription 记录
2. 检查 setting_value 字段是否有值
3. 检查前端是否正确接收数据
4. 查看浏览器控制台是否有错误

### 接口报错
1. 检查路由配置是否正确
2. 检查控制器方法是否存在
3. 检查数据库连接是否正常
4. 查看服务器错误日志

## 相关文件

### 后端
- 控制器: `app/controller/User.php`
- 路由: `route/app.php`
- 数据表: `users`, `system_settings`

### 前端
- 页面: `pages/splash/splash.vue`
- API: `utils/api.js`
- 配置: `config/config.js`

## 更新日志

### 2026-01-05
- 创建启动页数据接口
- 实现头像和欢迎语动态获取
- 添加错误处理和默认值
- 完成前后端对接
