<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;
use app\service\JwtService;

/**
 * 微信认证控制器 - 更新版本
 * 使用合并后的统一用户表
 */
class WechatAuth extends BaseController
{
    // 微信小程序配置
    private $appId = 'wx63617f985d8c028c';
    private $appSecret = 'a0a3d18cc49c5f70174245bf5e79d558';
    
    /**
     * 微信登录 - 通过code获取openid
     * 更新：使用统一的 users 表
     */
    public function login(Request $request): Response
    {
        try {
            $code = $request->param('code', '');
            
            if (empty($code)) {
                return json(['code' => 400, 'message' => 'code不能为空']);
            }
            
            // 通过code获取openid
            $openid = $this->getOpenidByCode($code);
            
            if (!$openid) {
                return json(['code' => 400, 'message' => '获取openid失败']);
            }
            
            // 检查用户是否存在 - 使用统一的 users 表
            $user = Db::name('users')->where('openid', $openid)->find();
            
            if ($user) {
                // 老用户登录
                $token = $this->generateToken($user['id']);
                $this->updateUserToken($user['id'], $token);
                
                return json([
                    'code' => 200,
                    'message' => '登录成功',
                    'data' => [
                        'token' => $token,
                        'is_new_user' => false,
                        'user_info' => [
                            'id' => $user['id'],
                            'openid' => $user['openid'],
                            'nickname' => $user['nickname'],
                            'avatar' => $user['avatar'],
                            'visit_count' => $user['visit_count'],
                            'like_count' => $user['like_count'],
                            'user_type' => $user['user_type']
                        ]
                    ]
                ]);
            } else {
                // 新用户，需要获取微信信息
                $token = $this->generateToken(0); // 临时token
                
                return json([
                    'code' => 201,
                    'message' => '新用户，需要完善信息',
                    'data' => [
                        'token' => $token,
                        'is_new_user' => true,
                        'openid' => $openid
                    ]
                ]);
            }
            
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 完善用户信息 - 新用户填写头像昵称
     * 更新：使用统一的 users 表
     */
    public function completeUserInfo(Request $request): Response
    {
        try {
            $data = $request->only([
                'openid', 'nickName', 'avatarUrl', 'gender', 'country', 
                'province', 'city', 'language'
            ]);
            
            if (empty($data['openid']) || empty($data['nickName']) || empty($data['avatarUrl'])) {
                return json(['code' => 400, 'message' => 'openid、昵称和头像不能为空']);
            }
            
            // 生成用户唯一标识
            $userKey = md5($data['openid'] . $data['nickName'] . $data['avatarUrl']);
            
            // 检查是否已存在 - 使用统一的 users 表
            $existingUser = Db::name('users')->where('openid', $data['openid'])->find();
            
            if ($existingUser) {
                return json(['code' => 400, 'message' => '用户已存在']);
            }
            
            // 创建新用户 - 使用统一的 users 表
            $insertData = [
                'openid' => $data['openid'],
                'user_key' => $userKey,
                'nickname' => $data['nickName'],
                'avatar' => $data['avatarUrl'], // 字段名统一为 avatar
                'gender' => $data['gender'] ?? 0,
                'country' => $data['country'] ?? '',
                'province' => $data['province'] ?? '',
                'city' => $data['city'] ?? '',
                'language' => $data['language'] ?? 'zh_CN',
                'visit_count' => 0,
                'like_count' => 0,
                'is_new_user' => 0,
                'user_type' => 'wechat', // 统一用户类型
                'status' => 1,
                'role' => '访客',
                'create_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s'),
                'last_login_time' => date('Y-m-d H:i:s')
            ];
            
            $userId = Db::name('users')->insertGetId($insertData);
            
            // 生成正式token
            $token = $this->generateToken($userId);
            $this->updateUserToken($userId, $token);
            
            return json([
                'code' => 200,
                'message' => '用户信息完善成功',
                'data' => [
                    'token' => $token,
                    'user_info' => [
                        'id' => $userId,
                        'openid' => $data['openid'],
                        'nickname' => $data['nickName'],
                        'avatar' => $data['avatarUrl'],
                        'visit_count' => 0,
                        'like_count' => 0,
                        'user_type' => 'wechat'
                    ]
                ]
            ]);
            
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 通过code获取openid
     */
    private function getOpenidByCode($code)
    {
        $url = "https://api.weixin.qq.com/sns/jscode2session";
        $params = [
            'appid' => $this->appId,
            'secret' => $this->appSecret,
            'js_code' => $code,
            'grant_type' => 'authorization_code'
        ];
        
        $url .= '?' . http_build_query($params);
        
        $response = file_get_contents($url);
        $data = json_decode($response, true);
        
        if (isset($data['openid'])) {
            return $data['openid'];
        }
        
        return false;
    }
    
    /**
     * 生成JWT token
     */
    private function generateToken($userId)
    {
        $jwtService = new JwtService();
        $payload = [
            'user_id' => $userId,
            'type' => 'wechat_user'
        ];
        
        return $jwtService->generateToken($payload);
    }
    
    /**
     * 更新用户token
     * 更新：使用统一的 users 表
     */
    private function updateUserToken($userId, $token)
    {
        $expireTime = date('Y-m-d H:i:s', time() + (7 * 24 * 60 * 60));
        
        Db::name('users') // 使用统一的 users 表
            ->where('id', $userId)
            ->update([
                'token' => $token,
                'token_expire_time' => $expireTime,
                'last_login_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s')
            ]);
    }
    
    /**
     * 验证token
     * 更新：使用统一的 users 表
     */
    public function verifyToken(Request $request): Response
    {
        try {
            $token = $request->header('Authorization');
            
            if (!$token) {
                return json(['code' => 401, 'message' => 'token不能为空']);
            }
            
            // 移除Bearer前缀
            $token = str_replace('Bearer ', '', $token);
            
            $jwtService = new JwtService();
            $payload = $jwtService->verifyToken($token);
            
            if (!$payload) {
                return json(['code' => 401, 'message' => 'token无效']);
            }
            
            // 检查token是否过期
            if (isset($payload->exp) && $payload->exp < time()) {
                return json(['code' => 401, 'message' => 'token已过期']);
            }
            
            // 获取用户信息 - 使用统一的 users 表
            $user = Db::name('users')->where('id', $payload->user_id)->find();
            
            if (!$user) {
                return json(['code' => 404, 'message' => '用户不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => 'token有效',
                'data' => [
                    'user_id' => $user['id'],
                    'openid' => $user['openid'],
                    'nickname' => $user['nickname'],
                    'avatar' => $user['avatar'],
                    'visit_count' => $user['visit_count'],
                    'like_count' => $user['like_count'],
                    'user_type' => $user['user_type']
                ]
            ]);
            
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 获取用户信息
     * 新增：统一的用户信息获取接口
     */
    public function getUserInfo(Request $request): Response
    {
        try {
            $userId = $request->param('user_id');
            
            if (!$userId) {
                return json(['code' => 400, 'message' => '用户ID不能为空']);
            }
            
            $user = Db::name('users')->where('id', $userId)->find();
            
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
                    'gender' => $user['gender'],
                    'country' => $user['country'],
                    'province' => $user['province'],
                    'city' => $user['city'],
                    'language' => $user['language'],
                    'visit_count' => $user['visit_count'],
                    'like_count' => $user['like_count'],
                    'user_type' => $user['user_type'],
                    'status' => $user['status'],
                    'role' => $user['role'],
                    'email' => $user['email'],
                    'phone' => $user['phone'],
                    'qq' => $user['qq'],
                    'wechat' => $user['wechat'],
                    'github' => $user['github'],
                    'web_url' => $user['web_url'],
                    'working_hours' => $user['working_hours'],
                    'create_time' => $user['create_time'],
                    'last_login_time' => $user['last_login_time']
                ]
            ]);
            
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
