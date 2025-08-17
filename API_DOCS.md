# PeterSun作品集API文档

## 概述

本文档描述了PeterSun作品集项目的所有API接口，包括前端展示接口和后台管理接口。

## 基础信息

- **基础URL**: `https://your-domain.com`
- **API版本**: v1.0.0
- **数据格式**: JSON
- **字符编码**: UTF-8

## 通用响应格式

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
- `401`: 未授权
- `404`: 资源不存在
- `500`: 服务器内部错误

## 用户相关接口

### 1. 获取用户信息

**接口地址**: `GET /user/info`

**请求参数**: 无

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "name": "PeterSun",
        "email": "cto@cvun.net",
        "code_age": 8,
        "description": "一位热衷于创建视觉元素、主题制作和嵌入式开发的全栈工程师。",
        "avatar": "/static/images/peter.jpg",
        "github": "https://github.com/petersun",
        "wechat": "cto-peter"
    }
}
```

### 2. 更新用户信息

**接口地址**: `POST /user/update`

**请求参数**:
```json
{
    "name": "PeterSun",
    "email": "cto@cvun.net",
    "code_age": 8,
    "description": "个人描述",
    "avatar": "/static/images/peter.jpg",
    "github": "https://github.com/petersun",
    "wechat": "cto-peter"
}
```

### 3. 获取技术栈列表

**接口地址**: `GET /user/technologies`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "img": "/static/images/exp/html.png",
            "name": "HTML"
        },
        {
            "img": "/static/images/exp/vue.png",
            "name": "Vue"
        }
    ]
}
```

### 4. 获取地图数据

**接口地址**: `GET /user/map-data`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "name": "北京市",
            "value": 100,
            "level": "核心服务区"
        }
    ]
}
```

## 项目相关接口

### 1. 获取项目列表

**接口地址**: `GET /project/list`

**请求参数**:
- `category` (可选): 分类标识，如 'web', 'mobile'
- `page` (可选): 页码，默认1
- `limit` (可选): 每页数量，默认10

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "list": [
            {
                "id": 1,
                "title": "LikeSee短视频管理系统",
                "description": "现代化UI设计，符合2025年审美",
                "image": "/static/images/projects/likesee-vue-admin/login.jpg",
                "category_id": 1,
                "tags": ["Vue3", "Web开发", "响应式"],
                "technologies": ["Vue 3", "Vite", "Element Plus"],
                "create_time": "2024-01-15"
            }
        ],
        "total": 10,
        "page": 1,
        "limit": 10
    }
}
```

### 2. 获取项目详情

**接口地址**: `GET /project/detail/:id`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "id": 1,
        "title": "LikeSee短视频管理系统",
        "description": "现代化UI设计，符合2025年审美",
        "full_description": "这是一个现代化的短视频管理系统...",
        "image": "/static/images/projects/likesee-vue-admin/login.jpg",
        "tags": ["Vue3", "Web开发", "响应式"],
        "technologies": ["Vue 3", "Vite", "Element Plus"],
        "features": ["用户权限管理", "内容审核系统"],
        "create_time": "2024-01-15"
    }
}
```

### 3. 获取项目分类

**接口地址**: `GET /project/categories`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "id": 0,
            "key": "all",
            "name": "全部",
            "status": 1
        },
        {
            "id": 1,
            "key": "web",
            "name": "Web开发",
            "status": 1
        }
    ]
}
```

### 4. 获取首页推荐项目

**接口地址**: `GET /project/featured`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "id": 1,
            "title": "LikeSee短视频管理系统",
            "description": "现代化UI设计，符合2025年审美",
            "image": "/static/images/projects/likesee-vue-admin/login.jpg",
            "tags": ["Vue3", "Web开发", "响应式"]
        }
    ]
}
```

### 5. 创建项目

**接口地址**: `POST /project/create`

**请求参数**:
```json
{
    "title": "项目标题",
    "description": "项目描述",
    "full_description": "完整描述",
    "image": "/static/images/project.jpg",
    "category_id": 1,
    "tags": ["Vue3", "Web开发"],
    "technologies": ["Vue 3", "Vite"],
    "features": ["功能1", "功能2"],
    "sort_order": 0,
    "is_featured": 1
}
```

### 6. 更新项目

**接口地址**: `POST /project/update/:id`

**请求参数**: 同创建项目

### 7. 删除项目

**接口地址**: `DELETE /project/delete/:id`

### 8. 更新项目状态

**接口地址**: `POST /project/status/:id`

**请求参数**:
```json
{
    "status": 1
}
```

## 联系相关接口

### 1. 获取联系信息

**接口地址**: `GET /contact/info`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "email": "cto@cvun.net",
        "wechat": "cto-peter",
        "qq": "21312314",
        "address": "河南省郑州市",
        "github": "https://github.com/petersun",
        "working_hours": [
            {
                "day": "工作日",
                "time": "09:00 - 18:00"
            }
        ]
    }
}
```

### 2. 更新联系信息

**接口地址**: `POST /contact/update`

**请求参数**:
```json
{
    "email": "cto@cvun.net",
    "wechat": "cto-peter",
    "qq": "21312314",
    "address": "河南省郑州市",
    "github": "https://github.com/petersun",
    "working_hours": [
        {
            "day": "工作日",
            "time": "09:00 - 18:00"
        }
    ]
}
```

### 3. 获取留言列表

**接口地址**: `GET /contact/messages`

**请求参数**:
- `page` (可选): 页码，默认1
- `limit` (可选): 每页数量，默认10
- `status` (可选): 状态，0未读，1已读

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "list": [
            {
                "id": 1,
                "name": "张三",
                "email": "zhangsan@example.com",
                "subject": "项目合作",
                "message": "您好，我对您的项目很感兴趣...",
                "is_read": 0,
                "create_time": "2024-01-15 14:30:00"
            }
        ],
        "total": 10,
        "page": 1,
        "limit": 10
    }
}
```

### 4. 提交留言

**接口地址**: `POST /contact/message`

**请求参数**:
```json
{
    "name": "张三",
    "email": "zhangsan@example.com",
    "subject": "项目合作",
    "message": "您好，我对您的项目很感兴趣..."
}
```

### 5. 标记留言为已读

**接口地址**: `POST /contact/read/:id`

### 6. 删除留言

**接口地址**: `DELETE /contact/message/:id`

### 7. 获取留言统计

**接口地址**: `GET /contact/stats`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "total_messages": 156,
        "unread_messages": 8,
        "today_messages": 5
    }
}
```

### 8. 批量标记为已读

**接口地址**: `POST /contact/batch-read`

**请求参数**:
```json
{
    "ids": [1, 2, 3]
}
```

### 9. 批量删除留言

**接口地址**: `POST /contact/batch-delete`

**请求参数**:
```json
{
    "ids": [1, 2, 3]
}
```

## 后台管理接口

### 1. 管理员登录

**接口地址**: `POST /admin/login`

**请求参数**:
```json
{
    "username": "admin",
    "password": "123456"
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "登录成功",
    "data": {
        "token": "md5_token_string",
        "user": {
            "username": "admin",
            "role": "admin",
            "login_time": "2024-01-15 14:30:00"
        }
    }
}
```

### 2. 获取仪表盘数据

**接口地址**: `GET /admin/dashboard`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "stats": {
            "total_projects": 12,
            "total_messages": 156,
            "unread_messages": 8,
            "today_visits": 234
        },
        "recent_activities": [
            {
                "id": "project_1",
                "type": "project",
                "title": "新增项目：LikeSee短视频管理系统",
                "time": "2小时前",
                "color": "#10b981"
            }
        ],
        "project_categories": {
            "Web开发": 8,
            "移动开发": 3,
            "UI设计": 1
        }
    }
}
```

### 3. 获取系统统计

**接口地址**: `GET /admin/stats`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "visits": {
            "today": 234,
            "week": 1247,
            "month": 8920
        },
        "messages": {
            "total": 156,
            "unread": 8,
            "today": 5
        },
        "projects": {
            "total": 12,
            "featured": 6
        },
        "devices": [
            {
                "type": "desktop",
                "count": 564,
                "percentage": 45.2
            }
        ]
    }
}
```

### 4. 获取访问趋势

**接口地址**: `GET /admin/visit-trend`

**请求参数**:
- `days` (可选): 天数，默认7

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "date": "2024-01-15",
            "count": 234
        }
    ]
}
```

### 5. 获取热门页面

**接口地址**: `GET /admin/popular-pages`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "page": "/",
            "count": 1247
        }
    ]
}
```

### 6. 获取系统信息

**接口地址**: `GET /admin/system-info`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "version": "1.0.0",
        "php_version": "8.0.0",
        "server_time": "2024-01-15 14:30:00",
        "uptime": "15天 8小时 32分钟",
        "memory_usage": 1048576,
        "disk_free_space": 1073741824,
        "disk_total_space": 10737418240
    }
}
```

## 访问统计接口

### 1. 记录访问日志

**接口地址**: `POST /visit/log`

**请求参数**:
```json
{
    "page": "/",
    "referer": "https://google.com",
    "user_agent": "Mozilla/5.0..."
}
```

### 2. 获取访问统计

**接口地址**: `GET /visit/stats`

**请求参数**:
- `type` (可选): 统计类型，today/week/month

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "total_visits": 1247,
        "unique_visitors": 892,
        "popular_pages": [
            {
                "page": "/",
                "count": 1247
            }
        ],
        "device_stats": [
            {
                "device_type": "desktop",
                "count": 564
            }
        ]
    }
}
```

### 3. 获取访问趋势

**接口地址**: `GET /visit/trend`

**请求参数**:
- `days` (可选): 天数，默认7

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "date": "2024-01-15",
            "visits": 234,
            "visitors": 156
        }
    ]
}
```

### 4. 获取实时访问数据

**接口地址**: `GET /visit/realtime`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "online_users": 15,
        "today_visits": 234,
        "today_visitors": 156,
        "recent_visits": [
            {
                "ip": "127.0.0.1",
                "page": "/",
                "create_time": "14:30:00"
            }
        ]
    }
}
```

### 5. 获取地理位置统计

**接口地址**: `GET /visit/geo`

**响应示例**:
```json
{
    "code": 200,
    "message": "获取成功",
    "data": [
        {
            "name": "北京市",
            "value": 150
        }
    ]
}
```

## 错误处理

### 常见错误码

- `400`: 请求参数错误
  ```json
  {
      "code": 400,
      "message": "用户名和密码不能为空"
  }
  ```

- `401`: 未授权
  ```json
  {
      "code": 401,
      "message": "用户名或密码错误"
  }
  ```

- `404`: 资源不存在
  ```json
  {
      "code": 404,
      "message": "项目不存在"
  }
  ```

- `500`: 服务器错误
  ```json
  {
      "code": 500,
      "message": "服务器错误：具体错误信息"
  }
  ```

## 使用示例

### JavaScript示例

```javascript
// 获取用户信息
fetch('/user/info')
    .then(response => response.json())
    .then(data => {
        if (data.code === 200) {
            console.log('用户信息:', data.data);
        }
    });

// 提交留言
fetch('/contact/message', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
        name: '张三',
        email: 'zhangsan@example.com',
        message: '您好，我对您的项目很感兴趣'
    })
})
.then(response => response.json())
.then(data => {
    if (data.code === 200) {
        console.log('留言提交成功');
    }
});
```

### PHP示例

```php
// 获取项目列表
$url = 'https://your-domain.com/project/list';
$response = file_get_contents($url);
$data = json_decode($response, true);

if ($data['code'] === 200) {
    $projects = $data['data']['list'];
    foreach ($projects as $project) {
        echo $project['title'] . "\n";
    }
}
```

## 更新日志

### v1.0.0 (2024-01-15)
- 初始版本发布
- 支持用户信息、项目管理、留言管理
- 支持后台管理功能
- 支持访问统计功能 