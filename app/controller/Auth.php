<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\User;
use app\service\JwtService;
use think\Request;
use think\Response;
use think\facade\Validate;

/**
 * 认证控制器
 */
class Auth extends BaseController
{
    protected JwtService $jwtService;
    
    public function __construct(\think\App $app)
    {
        parent::__construct($app);
        $this->jwtService = new JwtService();
    }
    
    /**
     * 用户登录
     * @param Request $request
     * @return Response
     */
    public function login(Request $request): Response
    {
        $data = $request->post();
        
        // 验证输入
        $validate = Validate::rule([
            'username' => 'require|length:3,50',
            'password' => 'require|length:6,50',
        ])->message([
            'username.require' => '用户名不能为空',
            'username.length' => '用户名长度必须在3-50个字符之间',
            'password.require' => '密码不能为空',
            'password.length' => '密码长度必须在6-50个字符之间',
        ]);
        
        if (!$validate->check($data)) {
            return json(['code' => 400, 'message' => $validate->getError()]);
        }
        
        $username = $data['username'];
        $password = $data['password'];
        
        // 查找用户
        $user = User::findByUsername($username);
        if (!$user) {
            return json(['code' => 401, 'message' => '用户名或密码错误']);
        }
        
        // 验证密码
        if (!User::verifyPassword($password, $user->password)) {
            return json(['code' => 401, 'message' => '用户名或密码错误']);
        }
        
        // 检查用户状态
        if ($user->status != 1) {
            return json(['code' => 403, 'message' => '账户已被禁用']);
        }
        
        // 更新登录信息
        $user->updateLoginInfo($request->ip());
        
        // 生成JWT token
        $token = $this->jwtService->generateToken([
            'user_id' => $user->id,
            'username' => $user->username,
        ]);
        
        return json([
            'code' => 200,
            'message' => '登录成功',
            'data' => [
                'token' => $token,
                'user' => [
                    'id' => $user->id,
                    'username' => $user->username,
                    'email' => $user->email,
                    'nickname' => $user->nickname,
                    'name' => $user->name,
                    'code_age' => $user->code_age,
                    'description' => $user->description,
                    'avatar' => $user->avatar,
                    'github' => $user->github,
                    'wechat' => $user->wechat,
                    'last_login_time' => $user->last_login_time,
                ]
            ]
        ]);
    }
    
    /**
     * 用户注册
     * @param Request $request
     * @return Response
     */
    public function register(Request $request): Response
    {
        $data = $request->post();
        
        // 验证输入
        $validate = Validate::rule([
            'username' => 'require|length:3,50|alphaNum|unique:users',
            'password' => 'require|length:6,50',
            'email' => 'email|unique:users',
            'nickname' => 'length:2,50',
        ])->message([
            'username.require' => '用户名不能为空',
            'username.length' => '用户名长度必须在3-50个字符之间',
            'username.alphaNum' => '用户名只能包含字母和数字',
            'username.unique' => '用户名已存在',
            'password.require' => '密码不能为空',
            'password.length' => '密码长度必须在6-50个字符之间',
            'email.email' => '邮箱格式不正确',
            'email.unique' => '邮箱已存在',
            'nickname.length' => '昵称长度必须在2-50个字符之间',
        ]);
        
        if (!$validate->check($data)) {
            return json(['code' => 400, 'message' => $validate->getError()]);
        }
        
        // 检查用户名是否已存在
        if (User::findByUsername($data['username'])) {
            return json(['code' => 400, 'message' => '用户名已存在']);
        }
        
        // 检查邮箱是否已存在
        if (!empty($data['email']) && User::findByEmail($data['email'])) {
            return json(['code' => 400, 'message' => '邮箱已存在']);
        }
        
        // 创建用户
        $user = new User();
        $user->username = $data['username'];
        $user->password = User::hashPassword($data['password']);
        $user->email = $data['email'] ?? '';
        $user->nickname = $data['nickname'] ?? $data['username'];
        $user->status = 1;
        
        if ($user->save()) {
            return json([
                'code' => 200,
                'message' => '注册成功',
                'data' => [
                    'id' => $user->id,
                    'username' => $user->username,
                    'email' => $user->email,
                    'nickname' => $user->nickname,
                ]
            ]);
        } else {
            return json(['code' => 500, 'message' => '注册失败']);
        }
    }
    
    /**
     * 获取当前用户信息
     * @param Request $request
     * @return Response
     */
    public function profile(Request $request): Response
    {
        $token = $request->header('Authorization');
        if (!$token) {
            return json(['code' => 401, 'message' => '未提供认证token']);
        }
        
        // 移除Bearer前缀
        $token = str_replace('Bearer ', '', $token);
        
        try {
            $payload = $this->jwtService->verifyToken($token);
            $userId = $payload->user_id;
            
            $user = User::find($userId);
            if (!$user) {
                return json(['code' => 404, 'message' => '用户不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'id' => $user->id,
                    'username' => $user->username,
                    'email' => $user->email,
                    'nickname' => $user->nickname,
                    'name' => $user->name,
                    'code_age' => $user->code_age,
                    'description' => $user->description,
                    'avatar' => $user->avatar,
                    'github' => $user->github,
                    'wechat' => $user->wechat,
                    'status' => $user->status,
                    'last_login_time' => $user->last_login_time,
                    'last_login_ip' => $user->last_login_ip,
                    'created_at' => $user->created_at,
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 401, 'message' => 'Token无效']);
        }
    }
    
    /**
     * 刷新token
     * @param Request $request
     * @return Response
     */
    public function refresh(Request $request): Response
    {
        $token = $request->header('Authorization');
        if (!$token) {
            return json(['code' => 401, 'message' => '未提供认证token']);
        }
        
        // 移除Bearer前缀
        $token = str_replace('Bearer ', '', $token);
        
        try {
            $newToken = $this->jwtService->refreshToken($token);
            return json([
                'code' => 200,
                'message' => '刷新成功',
                'data' => [
                    'token' => $newToken,
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 401, 'message' => 'Token无效']);
        }
    }
    
    /**
     * 用户登出
     * @param Request $request
     * @return Response
     */
    public function logout(Request $request): Response
    {
        // 这里可以实现token黑名单功能
        // 目前简单返回成功
        return json(['code' => 200, 'message' => '登出成功']);
    }
} 