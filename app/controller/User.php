<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

class User extends BaseController
{
    /**
     * 获取用户信息
     */
    public function info(): Response
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
    public function update(Request $request): Response
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

    /**
     * 获取技术栈列表
     */
    public function technologies(): Response
    {
        try {
            $technologies = [
                ['img' => '/static/images/exp/html.png', 'name' => 'HTML'],
                ['img' => '/static/images/exp/php.png', 'name' => 'PHP'],
                ['img' => '/static/images/exp/vue.png', 'name' => 'Vue'],
                ['img' => '/static/images/exp/java.png', 'name' => 'Java'],
                ['img' => '/static/images/exp/python.png', 'name' => 'Python'],
                ['img' => '/static/images/exp/thinkphp.png', 'name' => 'ThinkPHP'],
                ['img' => '/static/images/exp/laravel.png', 'name' => 'Laravel'],
                ['img' => '/static/images/exp/bootstrap.png', 'name' => 'BootStrap'],
                ['img' => '/static/images/exp/webpack.png', 'name' => 'Webpack'],
                ['img' => '/static/images/exp/vite.png', 'name' => 'Vite'],
                ['img' => '/static/images/exp/fastadmin.png', 'name' => 'FastAdmin'],
                ['img' => '/static/images/exp/uniapp.png', 'name' => 'Uniapp'],
                ['img' => '/static/images/exp/flutter.png', 'name' => 'Flutter'],
                ['img' => '/static/images/exp/pycharm.png', 'name' => 'PyCharm'],
                ['img' => '/static/images/exp/ps.png', 'name' => 'PS'],
                ['img' => '/static/images/exp/pr.png', 'name' => 'PR'],
                ['img' => '/static/images/exp/ai.png', 'name' => 'AI'],
                ['img' => '/static/images/exp/c4d.png', 'name' => 'C4D'],
                ['img' => '/static/images/exp/figma.png', 'name' => 'Figma'],
                ['img' => '/static/images/exp/sketch.png', 'name' => 'Sketch'],
                ['img' => '/static/images/exp/fastapi.png', 'name' => 'FastAPI']
            ];
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $technologies
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取地图数据
     */
    public function mapData(): Response
    {
        try {
            $mapData = [
                ['name' => '北京市', 'value' => 100, 'level' => '核心服务区'],
                ['name' => '上海市', 'value' => 95, 'level' => '核心服务区'],
                ['name' => '广东省', 'value' => 90, 'level' => '核心服务区'],
                ['name' => '江苏省', 'value' => 85, 'level' => '重点服务区'],
                ['name' => '浙江省', 'value' => 80, 'level' => '重点服务区'],
                ['name' => '山东省', 'value' => 75, 'level' => '重点服务区'],
                ['name' => '四川省', 'value' => 70, 'level' => '重点服务区'],
                ['name' => '湖北省', 'value' => 65, 'level' => '一般服务区'],
                ['name' => '河南省', 'value' => 60, 'level' => '一般服务区'],
                ['name' => '湖南省', 'value' => 55, 'level' => '一般服务区'],
                ['name' => '福建省', 'value' => 50, 'level' => '一般服务区'],
                ['name' => '安徽省', 'value' => 45, 'level' => '一般服务区'],
                ['name' => '河北省', 'value' => 40, 'level' => '一般服务区'],
                ['name' => '陕西省', 'value' => 35, 'level' => '一般服务区'],
                ['name' => '江西省', 'value' => 30, 'level' => '待开发区域'],
                ['name' => '重庆市', 'value' => 25, 'level' => '待开发区域'],
                ['name' => '天津市', 'value' => 20, 'level' => '待开发区域'],
                ['name' => '云南省', 'value' => 15, 'level' => '待开发区域'],
                ['name' => '广西壮族自治区', 'value' => 10, 'level' => '待开发区域'],
                ['name' => '山西省', 'value' => 5, 'level' => '待开发区域']
            ];
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $mapData
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 