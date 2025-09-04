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
     * 用户登录（已废弃，统一使用微信登录）
     * @param Request $request
     * @return Response
     */
    public function login(Request $request): Response
    {
        return json([
            'code' => 400, 
            'message' => '用户名密码登录已废弃，请使用微信小程序登录'
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
        
        return json([
            'code' => 400, 
            'message' => '用户注册已废弃，请使用微信小程序登录'
        ]);
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
            
            // 使用统一的 users 表
            $user = \think\facade\Db::name('users')->where('id', $userId)->find();
            if (!$user) {
                return json(['code' => 404, 'message' => '用户不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'id' => $user['id'],
                    'openid' => $user['openid'],
                    'nickname' => $user['nickname'],
                    'avatar' => $user['avatar'],
                    'email' => $user['email'],
                    'phone' => $user['phone'],
                    'qq' => $user['qq'],
                    'wechat' => $user['wechat'],
                    'github' => $user['github'],
                    'web_url' => $user['web_url'],
                    'user_type' => $user['user_type'],
                    'status' => $user['status'],
                    'role' => $user['role'],
                    'visit_count' => $user['visit_count'],
                    'like_count' => $user['like_count'],
                    'last_login_time' => $user['last_login_time'],
                    'create_time' => $user['create_time'],
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