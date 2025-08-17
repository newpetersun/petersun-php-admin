<?php
declare (strict_types = 1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\Response;
use think\facade\Db;

class User extends BaseController
{
    /**
     * 获取用户信息
     */
    public function info()
    {
        try {
            $user = Db::name('user')->where('id', 1)->find();
            
            if (!$user) {
                return json(['code' => 404, 'message' => '用户信息不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'name' => $user['name'],
                    'email' => $user['email'],
                    'code_age' => $user['code_age'],
                    'description' => $user['description'],
                    'avatar' => $user['avatar'],
                    'github' => $user['github'],
                    'wechat' => $user['wechat']
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新用户信息
     */
    public function update(Request $request)
    {
        try {
            $data = $request->only(['name', 'email', 'code_age', 'description', 'avatar', 'github', 'wechat']);
            
            // 验证必填字段
            if (empty($data['name']) || empty($data['email'])) {
                return json(['code' => 400, 'message' => '姓名和邮箱不能为空']);
            }
            
            // 验证邮箱格式
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                return json(['code' => 400, 'message' => '邮箱格式不正确']);
            }
            
            $result = Db::name('user')->where('id', 1)->update($data);
            
            if ($result !== false) {
                return json(['code' => 200, 'message' => '更新成功']);
            } else {
                return json(['code' => 500, 'message' => '更新失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 