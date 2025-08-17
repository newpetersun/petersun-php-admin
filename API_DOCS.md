# 解忧青年作品集 API 文档

## 概述

这是一个基于 ThinkPHP 8.0 的 RESTful API 服务，为解忧青年作品集前端提供数据支持。

## 基础信息

- **基础URL**: `http://localhost:8000`
- **API版本**: 1.0.0
- **数据格式**: JSON
- **字符编码**: UTF-8

## 响应格式

所有API响应都遵循以下格式：

```json
{
    "code": 200,
    "message": "操作成功",
    "data": {}
}
```

### 状态码说明

- `200`: 成功
- `400`: 请求参数错误
- `404`: 资源不存在
- `500`: 服务器内部错误

## API 接口

### 1. 用户信息相关

#### 1.1 获取用户信息

- **URL**: `GET /api/user/info`
- **描述**: 获取用户基本信息
- **响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "name": "解忧青年",
        "email": "example@email.com",
        "code_age": "3年",
        "description": "前端开发工程师",
        "avatar": "/uploads/avatar.jpg",
        "github": "https://github.com/example",
        "wechat": "wechat_id"
    }
}
```

#### 1.2 更新用户信息

- **URL**: `POST /api/user/update`
- **描述**: 更新用户基本信息
- **请求参数**:
```json
{
    "name": "解忧青年",
    "email": "example@email.com",
    "code_age": "3年",
    "description": "前端开发工程师",
    "avatar": "/uploads/avatar.jpg",
    "github": "https://github.com/example",
    "wechat": "wechat_id"
}
```

### 2. 项目相关

#### 2.1 获取项目列表

- **URL**: `GET /api/project/list`
- **描述**: 获取项目列表，支持分页和筛选
- **查询参数**:
  - `page`: 页码（默认1）
  - `limit`: 每页数量（默认10）
  - `category`: 分类筛选
  - `status`: 状态筛选（0-禁用，1-启用）
- **响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "total": 10,
        "per_page": 10,
        "current_page": 1,
        "data": [
            {
                "id": 1,
                "title": "项目名称",
                "description": "项目描述",
                "full_description": "详细描述",
                "image": "/uploads/project.jpg",
                "category": "前端",
                "sort_order": 1,
                "status": 1,
                "created_at": "2024-01-01 00:00:00",
                "tags": ["Vue", "React"],
                "technologies": ["JavaScript", "CSS"]
            }
        ]
    }
}
```

#### 2.2 获取项目详情

- **URL**: `GET /api/project/detail/{id}`
- **描述**: 获取指定项目的详细信息
- **路径参数**:
  - `id`: 项目ID

#### 2.3 创建项目

- **URL**: `POST /api/project/create`
- **描述**: 创建新项目
- **请求参数**:
```json
{
    "title": "项目名称",
    "description": "项目描述",
    "full_description": "详细描述",
    "image": "/uploads/project.jpg",
    "category": "前端",
    "sort_order": 1,
    "status": 1,
    "tags": ["Vue", "React"],
    "technologies": ["JavaScript", "CSS"]
}
```

#### 2.4 更新项目

- **URL**: `POST /api/project/update/{id}`
- **描述**: 更新指定项目信息
- **路径参数**:
  - `id`: 项目ID

#### 2.5 删除项目

- **URL**: `DELETE /api/project/delete/{id}`
- **描述**: 删除指定项目
- **路径参数**:
  - `id`: 项目ID

#### 2.6 更新项目状态

- **URL**: `POST /api/project/status/{id}`
- **描述**: 启用或禁用项目
- **路径参数**:
  - `id`: 项目ID
- **请求参数**:
```json
{
    "status": 1
}
```

### 3. 联系信息相关

#### 3.1 获取联系信息

- **URL**: `GET /api/contact/info`
- **描述**: 获取联系信息
- **响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "email": "contact@example.com",
        "phone": "13800138000",
        "address": "北京市朝阳区",
        "wechat": "wechat_id",
        "qq": "123456789"
    }
}
```

#### 3.2 更新联系信息

- **URL**: `POST /api/contact/update`
- **描述**: 更新联系信息
- **请求参数**:
```json
{
    "email": "contact@example.com",
    "phone": "13800138000",
    "address": "北京市朝阳区",
    "wechat": "wechat_id",
    "qq": "123456789"
}
```

#### 3.3 获取留言列表

- **URL**: `GET /api/contact/messages`
- **描述**: 获取留言列表
- **查询参数**:
  - `page`: 页码（默认1）
  - `limit`: 每页数量（默认10）
  - `status`: 状态筛选（0-未读，1-已读）

#### 3.4 提交留言

- **URL**: `POST /api/contact/message`
- **描述**: 提交访客留言
- **请求参数**:
```json
{
    "name": "访客姓名",
    "email": "visitor@email.com",
    "subject": "留言主题",
    "message": "留言内容"
}
```

#### 3.5 标记留言为已读

- **URL**: `POST /api/contact/message/read/{id}`
- **描述**: 标记指定留言为已读
- **路径参数**:
  - `id`: 留言ID

#### 3.6 删除留言

- **URL**: `DELETE /api/contact/message/delete/{id}`
- **描述**: 删除指定留言
- **路径参数**:
  - `id`: 留言ID

## 错误处理

当API发生错误时，会返回相应的错误信息：

```json
{
    "code": 400,
    "message": "错误描述"
}
```

常见错误码：
- `400`: 请求参数错误
- `404`: 资源不存在
- `500`: 服务器内部错误

## 使用示例

### JavaScript (Axios)

```javascript
// 获取用户信息
axios.get('/api/user/info')
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.error('Error:', error.response.data);
    });

// 创建项目
axios.post('/api/project/create', {
    title: '新项目',
    description: '项目描述',
    category: '前端'
})
.then(response => {
    console.log('项目创建成功');
})
.catch(error => {
    console.error('创建失败:', error.response.data);
});
```

### cURL

```bash
# 获取用户信息
curl -X GET http://localhost:8000/api/user/info

# 创建项目
curl -X POST http://localhost:8000/api/project/create \
  -H "Content-Type: application/json" \
  -d '{"title":"新项目","description":"项目描述"}'
```

## 注意事项

1. 所有请求都应该包含 `Content-Type: application/json` 头
2. 时间格式统一使用 `YYYY-MM-DD HH:mm:ss`
3. 图片路径为相对路径，需要配合前端域名使用
4. 分页参数从1开始计数
5. 状态字段：0表示禁用/未读，1表示启用/已读

## 部署说明

1. 确保PHP版本 >= 8.0
2. 安装Composer依赖：`composer install`
3. 配置数据库连接（.env文件）
4. 导入数据库结构（database/migrations/create_tables.sql）
5. 设置Web服务器指向public目录
6. 确保storage目录可写权限 