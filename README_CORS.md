# CORS跨域配置说明

## 概述
本项目已配置完整的CORS（跨域资源共享）中间件，解决前端跨域请求问题。

## 功能特性

- ✅ 自动处理跨域请求
- ✅ 支持预检请求（OPTIONS）
- ✅ 允许携带认证头（Authorization）
- ✅ 可配置的跨域策略
- ✅ 支持所有常用HTTP方法
- ✅ 预检请求缓存优化

## 配置说明

### 1. CORS配置文件
位置：`config/cors.php`

```php
return [
    // 允许的域名，* 表示允许所有域名
    'allow_origin' => '*',
    
    // 允许的请求头
    'allow_headers' => [
        'Authorization',
        'Content-Type',
        'If-Match',
        'If-Modified-Since',
        'If-None-Match',
        'If-Unmodified-Since',
        'X-CSRF-TOKEN',
        'X-Requested-With',
        'Accept',
        'Origin',
        'Cache-Control',
        'X-File-Name'
    ],
    
    // 允许的请求方法
    'allow_methods' => [
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
    ],
    
    // 是否允许携带凭证
    'allow_credentials' => true,
    
    // 预检请求缓存时间（秒）
    'max_age' => 86400,
    
    // 是否暴露响应头
    'expose_headers' => [
        'Content-Length',
        'Content-Range'
    ],
    
    // 是否启用CORS
    'enabled' => true,
];
```

### 2. 中间件配置
位置：`config/middleware.php`

```php
return [
    'alias' => [
        'JwtAuth' => \app\middleware\JwtAuth::class,
        'Cors' => \app\middleware\Cors::class,
    ],
    'priority' => [],
];
```

### 3. 路由配置
所有API路由都已应用CORS中间件：

```php
// 全局CORS中间件
Route::group('', function () {
    // 所有API路由
    Route::group('auth', function () {
        // 认证相关接口
    });
    
    Route::group('user', function () {
        // 用户相关接口
    });
    
    // ... 其他路由组
})->middleware('Cors');
```

## 响应头说明

CORS中间件会自动添加以下响应头：

| 响应头 | 说明 | 示例值 |
|--------|------|--------|
| Access-Control-Allow-Origin | 允许的域名 | `*` |
| Access-Control-Allow-Headers | 允许的请求头 | `Authorization, Content-Type, ...` |
| Access-Control-Allow-Methods | 允许的请求方法 | `GET, POST, PUT, PATCH, DELETE, OPTIONS` |
| Access-Control-Allow-Credentials | 是否允许携带凭证 | `true` |
| Access-Control-Max-Age | 预检请求缓存时间 | `86400` |
| Access-Control-Expose-Headers | 暴露的响应头 | `Content-Length, Content-Range` |

## 使用示例

### 前端JavaScript调用

#### 1. 用户登录
```javascript
fetch('http://your-domain.com/auth/login', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
        username: 'admin',
        password: '123456'
    })
})
.then(response => response.json())
.then(data => {
    console.log('登录成功:', data);
    // 保存token
    localStorage.setItem('token', data.data.token);
})
.catch(error => {
    console.error('登录失败:', error);
});
```

#### 2. 获取用户信息（需要认证）
```javascript
const token = localStorage.getItem('token');

fetch('http://your-domain.com/auth/profile', {
    method: 'GET',
    headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
    }
})
.then(response => response.json())
.then(data => {
    console.log('用户信息:', data);
})
.catch(error => {
    console.error('获取用户信息失败:', error);
});
```

#### 3. 刷新Token
```javascript
const token = localStorage.getItem('token');

fetch('http://your-domain.com/auth/refresh', {
    method: 'POST',
    headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
    }
})
.then(response => response.json())
.then(data => {
    console.log('Token刷新成功:', data);
    // 更新token
    localStorage.setItem('token', data.data.token);
})
.catch(error => {
    console.error('Token刷新失败:', error);
});
```

### jQuery调用示例

```javascript
// 登录
$.ajax({
    url: 'http://your-domain.com/auth/login',
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    data: JSON.stringify({
        username: 'admin',
        password: '123456'
    }),
    success: function(data) {
        console.log('登录成功:', data);
        localStorage.setItem('token', data.data.token);
    },
    error: function(xhr, status, error) {
        console.error('登录失败:', error);
    }
});

// 获取用户信息
$.ajax({
    url: 'http://your-domain.com/auth/profile',
    method: 'GET',
    headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`,
        'Content-Type': 'application/json'
    },
    success: function(data) {
        console.log('用户信息:', data);
    },
    error: function(xhr, status, error) {
        console.error('获取用户信息失败:', error);
    }
});
```

### Axios调用示例

```javascript
// 配置axios默认设置
axios.defaults.baseURL = 'http://your-domain.com';
axios.defaults.headers.common['Content-Type'] = 'application/json';

// 请求拦截器：自动添加token
axios.interceptors.request.use(config => {
    const token = localStorage.getItem('token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

// 登录
axios.post('/auth/login', {
    username: 'admin',
    password: '123456'
})
.then(response => {
    console.log('登录成功:', response.data);
    localStorage.setItem('token', response.data.data.token);
})
.catch(error => {
    console.error('登录失败:', error);
});

// 获取用户信息
axios.get('/auth/profile')
.then(response => {
    console.log('用户信息:', response.data);
})
.catch(error => {
    console.error('获取用户信息失败:', error);
});
```

## 生产环境配置

### 1. 限制允许的域名
```php
// config/cors.php
'allow_origin' => 'https://your-frontend-domain.com',
```

### 2. 配置多个允许的域名
```php
// 在Cors中间件中动态设置
$allowedOrigins = [
    'https://your-frontend-domain.com',
    'https://admin.your-domain.com',
    'http://localhost:3000' // 开发环境
];

$origin = $request->header('Origin');
if (in_array($origin, $allowedOrigins)) {
    $response->header('Access-Control-Allow-Origin', $origin);
}
```

### 3. 安全配置
```php
// 禁用不必要的请求头
'allow_headers' => [
    'Authorization',
    'Content-Type',
    'Accept'
],

// 限制允许的方法
'allow_methods' => [
    'GET',
    'POST',
    'PUT',
    'DELETE'
],
```

## 常见问题

### 1. 预检请求失败
**问题**：浏览器发送OPTIONS请求时返回错误
**解决**：确保CORS中间件正确处理OPTIONS请求

### 2. 认证头被拒绝
**问题**：Authorization头被CORS策略阻止
**解决**：确保`allow_headers`包含`Authorization`

### 3. 凭证无法发送
**问题**：Cookie等凭证无法跨域发送
**解决**：设置`allow_credentials`为`true`

### 4. 特定域名访问被拒绝
**问题**：只有特定域名可以访问API
**解决**：配置`allow_origin`为具体域名

## 测试方法

### 1. 运行测试脚本
```bash
php test_cors_basic.php
```

### 2. 浏览器开发者工具
1. 打开浏览器开发者工具
2. 切换到Network标签
3. 发送跨域请求
4. 检查响应头是否包含CORS相关字段

### 3. 命令行测试
```bash
# 测试OPTIONS预检请求
curl -X OPTIONS http://your-domain.com/auth/login \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type" \
  -v

# 测试实际请求
curl -X POST http://your-domain.com/auth/login \
  -H "Origin: http://localhost:3000" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"123456"}' \
  -v
```

## 更新日志

- 2024-12-01: 初始版本，实现基础CORS功能
- 支持所有常用HTTP方法
- 自动处理预检请求
- 可配置的跨域策略 