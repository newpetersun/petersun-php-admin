# 用户认证API文档

## 概述
本系统使用JWT（JSON Web Token）进行用户认证，所有需要认证的接口都需要在请求头中携带有效的JWT token。

## 认证流程
1. 用户通过登录接口获取JWT token
2. 在后续请求中，将token放在请求头的`Authorization`字段中
3. 格式：`Authorization: Bearer <token>`

## API接口

### 1. 用户登录
**接口地址：** `POST /auth/login`

**请求参数：**
```json
{
    "username": "admin",
    "password": "123456"
}
```

**响应示例：**
```json
{
    "code": 200,
    "message": "登录成功",
    "data": {
        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
        "user": {
            "id": 1,
            "username": "admin",
            "email": "admin@example.com",
            "nickname": "管理员",
            "avatar": null,
            "last_login_time": "2024-12-01 10:30:00"
        }
    }
}
```

### 2. 用户注册
**接口地址：** `POST /auth/register`

**请求参数：**
```json
{
    "username": "newuser",
    "password": "123456",
    "email": "newuser@example.com",
    "nickname": "新用户"
}
```

**响应示例：**
```json
{
    "code": 200,
    "message": "注册成功",
    "data": {
        "id": 3,
        "username": "newuser",
        "email": "newuser@example.com",
        "nickname": "新用户"
    }
}
```

### 3. 获取用户信息
**接口地址：** `GET /auth/profile`

**请求头：**
```
Authorization: Bearer <token>
```

**响应示例：**
```json
{
    "code": 200,
    "message": "获取成功",
    "data": {
        "id": 1,
        "username": "admin",
        "email": "admin@example.com",
        "nickname": "管理员",
        "avatar": null,
        "status": 1,
        "last_login_time": "2024-12-01 10:30:00",
        "last_login_ip": "127.0.0.1",
        "created_at": "2024-12-01 09:00:00"
    }
}
```

### 4. 刷新Token
**接口地址：** `POST /auth/refresh`

**请求头：**
```
Authorization: Bearer <token>
```

**响应示例：**
```json
{
    "code": 200,
    "message": "刷新成功",
    "data": {
        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
    }
}
```

### 5. 用户登出
**接口地址：** `POST /auth/logout`

**请求头：**
```
Authorization: Bearer <token>
```

**响应示例：**
```json
{
    "code": 200,
    "message": "登出成功"
}
```

## 错误码说明

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未认证或token无效 |
| 403 | 账户被禁用 |
| 404 | 用户不存在 |
| 500 | 服务器内部错误 |

## 使用示例

### JavaScript (Fetch API)
```javascript
// 登录
const loginResponse = await fetch('/auth/login', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({
        username: 'admin',
        password: '123456'
    })
});

const loginData = await loginResponse.json();
const token = loginData.data.token;

// 获取用户信息
const profileResponse = await fetch('/auth/profile', {
    headers: {
        'Authorization': `Bearer ${token}`
    }
});

const profileData = await profileResponse.json();
```

### PHP (cURL)
```php
// 登录
$loginData = [
    'username' => 'admin',
    'password' => '123456'
];

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'http://your-domain.com/auth/login');
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($loginData));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$loginResult = json_decode($response, true);
$token = $loginResult['data']['token'];

// 获取用户信息
curl_setopt($ch, CURLOPT_URL, 'http://your-domain.com/auth/profile');
curl_setopt($ch, CURLOPT_POST, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Authorization: Bearer ' . $token
]);

$response = curl_exec($ch);
$profileResult = json_decode($response, true);
```

## 安全注意事项

1. **JWT密钥**：请在生产环境中修改`config/jwt.php`中的密钥
2. **HTTPS**：建议在生产环境中使用HTTPS
3. **Token过期**：Token默认2小时过期，请及时刷新
4. **密码安全**：密码使用bcrypt加密存储
5. **输入验证**：所有输入都经过验证和过滤

## 数据库表结构

### users表
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | int | 主键ID |
| username | varchar(50) | 用户名（唯一） |
| password | varchar(255) | 加密密码 |
| email | varchar(100) | 邮箱（唯一） |
| nickname | varchar(50) | 昵称 |
| avatar | varchar(255) | 头像URL |
| status | tinyint | 状态：1启用，0禁用 |
| last_login_time | datetime | 最后登录时间 |
| last_login_ip | varchar(45) | 最后登录IP |
| created_at | datetime | 创建时间 |
| updated_at | datetime | 更新时间 | 