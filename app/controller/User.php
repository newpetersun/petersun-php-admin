<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;
use app\model\User as UserModel;

class User extends BaseController
{
    /**
     * 获取用户信息（单个）
     */
    public function info(Request $request): Response
    {
        try {
            $id = $request->param('id', 1);
            $user = UserModel::find($id);
            if (!$user) {
                return json(['code' => 404, 'message' => '用户信息不存在']);
            }
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取用户列表（支持筛选、分页、搜索）
     */
    public function list(Request $request): Response
    {
        try {
            $keyword = $request->param('keyword', '');
            $role = $request->param('role', '');
            $status = $request->param('status', '');
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 10);

            $where = [];
            if ($keyword) {
                $where[] = ['username|email', 'like', "%$keyword%"];
            }
            if ($role && $role !== '全部角色') {
                $where[] = ['role', '=', $role];
            }
            if ($status && $status !== '全部状态') {
                $where[] = ['status', '=', $status === '活跃' ? 'active' : 'inactive'];
            }

            $users = Db::name('users')
                ->where($where)
                ->order('id', 'asc')
                ->paginate([
                    'list_rows' => $limit,
                    'page' => $page
                ]);

            $list = $users->items();
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list' => $list,
                    'total' => $users->total(),
                    'page' => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 新增用户
     */
    public function create(Request $request): Response
    {
        try {
            $data = $request->only(['username', 'email', 'role', 'status', 'avatar']);
            if (empty($data['username']) || empty($data['email'])) {
                return json(['code' => 400, 'message' => '用户名和邮箱不能为空']);
            }
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                return json(['code' => 400, 'message' => '邮箱格式不正确']);
            }
            // 检查用户名是否重复
            $exists = Db::name('users')->where('username', $data['username'])->find();
            if ($exists) {
                return json(['code' => 400, 'message' => '用户名已存在']);
            }
            $data['role'] = $data['role'] ?? '访客';
            // 修正 status 字段为 1/0
            if (isset($data['status'])) {
                if ($data['status'] === 'active') {
                    $data['status'] = 1;
                } elseif ($data['status'] === 'inactive') {
                    $data['status'] = 0;
                }
            }
            $data['create_time'] = date('Y-m-d H:i:s');
            $data['avatar'] = $data['avatar'] ?? '/static/images/default-avatar.jpg';
            $id = Db::name('users')->insertGetId($data);
            return json(['code' => 200, 'message' => '添加成功', 'data' => ['id' => $id]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }


    /**
     * 删除用户
     */
    public function delete(Request $request): Response
    {
        try {
            $id = $request->param('id', 0);
            if (empty($id)) {
                return json(['code' => 400, 'message' => '缺少用户ID']);
            }
            $result = Db::name('users')->where('id', $id)->delete();
            if ($result) {
                return json(['code' => 200, 'message' => '删除成功']);
            } else {
                return json(['code' => 500, 'message' => '删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 编辑用户（支持指定ID，兼容原有字段）
     */
    public function update(Request $request): Response
    {
        try {
            $id = $request->param('id', 1);
            $data = $request->only(['username', 'email', 'role', 'status', 'avatar', 'name', 'code_age', 'description', 'github', 'wechat']);
            // 兼容前端字段
            if (isset($data['name']) && !isset($data['username'])) {
                $data['username'] = $data['name'];
            }
            if (empty($data['username']) || empty($data['email'])) {
                return json(['code' => 400, 'message' => '用户名和邮箱不能为空']);
            }
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                return json(['code' => 400, 'message' => '邮箱格式不正确']);
            }
            if (isset($data['status'])) {
                if ($data['status'] === 'active') {
                    $data['status'] = 1;
                } elseif ($data['status'] === 'inactive') {
                    $data['status'] = 0;
                }
            }
            $data['updated_at'] = date('Y-m-d H:i:s');
            $result = Db::name('users')->where('id', $id)->update($data);
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

    /**
     * 上传用户头像
     */
    public function uploadAvatar(Request $request): Response
    {
        try {
            $file = $request->file('avatar');
            if (!$file) {
                return json(['code' => 400, 'message' => '未上传文件']);
            }
            // 保存到 public/static/images/avatar 目录，自动重命名为规范图片名
            $savePath = '/static/images/avatar/';
            $ext = $file->getOriginalExtension();
            $filename = uniqid('avatar_') . '.' . $ext;
            $info = $file->move(public_path() . $savePath, $filename);
            if ($info) {
                $url = $savePath . $filename;
                return json(['code' => 200, 'message' => '上传成功', 'data' => ['url' => $url]]);
            } else {
                return json(['code' => 500, 'message' => $file->getError()]);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 