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
	public function index(){
		return json(['code' => 200, 'message' => '用户管理接口']);
	}
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
     * 更新：使用统一的 users 表
     */
    public function list(Request $request): Response
    {
        try {
            $keyword = $request->param('keyword', '');
            $role = $request->param('role', '');
            $status = $request->param('status', '');
            $userType = $request->param('user_type', '');
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 10);

            $where = [];
            if ($keyword) {
                $where[] = ['nickname', 'like', "%$keyword%"];
            }
            if ($role && $role !== '全部角色') {
                $where[] = ['role', '=', $role];
            }
            if ($status && $status !== '全部状态') {
                $where[] = ['status', '=', $status === '活跃' ? 1 : 0];
            }
            if ($userType && $userType !== '全部类型') {
                $where[] = ['user_type', '=', $userType];
            }

            $users = Db::name('users')->where($where)
                ->order('id', 'desc')
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
     * 新增用户（管理员手动创建）
     * 更新：使用统一的 users 表
     */
    public function create(Request $request): Response
    {
        try {
            $data = $request->only(['nickname', 'role', 'status', 'avatar', 'email', 'phone', 'qq', 'wechat', 'github', 'web_url']);
            if (empty($data['nickname'])) {
                return json(['code' => 400, 'message' => '昵称不能为空']);
            }
            
            $data['user_type'] = 'admin';
            $data['status'] = $data['status'] ?? 1;
            $data['role'] = $data['role'] ?? '管理员';
            $data['create_time'] = date('Y-m-d H:i:s');
            $data['update_time'] = date('Y-m-d H:i:s');
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
     * 更新：使用统一的 users 表，移除密码相关字段
     */
    public function update(Request $request): Response
    {
        try {
            $id = $request->param('id');
            $data = $request->only(['role', 'status', 'avatar', 'nickname', 'email', 'phone', 'qq', 'wechat', 'github', 'web_url', 'working_hours']);
            if (isset($data['status'])) {
                if ($data['status'] === 'active') {
                    $data['status'] = 1;
                } elseif ($data['status'] === 'inactive') {
                    $data['status'] = 0;
                }
            }
            $data['update_time'] = date('Y-m-d H:i:s');
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
            // 从technology表中获取启用的技术
            $technologies = Db::name('technology')
                ->field('id, name, img, sort_order')
                ->where('status', 1)
                ->order('id', 'asc')
                ->select()
                ->toArray();
            
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



    /**
     * 保存用户信息
     */
    public function saveUserInfo(Request $request): Response
    {
        try {
            $data = $request->only([
                'nickName', 'avatarUrl', 'gender', 'country', 'province', 
                'city', 'language', 'visitCount', 'likeCount', 'loginTime'
            ]);
            
            // 生成唯一用户ID（基于微信信息）
            $userKey = md5($data['nickName'] . $data['avatarUrl']);
            
            // 检查用户是否已存在 - 使用统一的 users 表
            $existingUser = Db::name('users')->where('user_key', $userKey)->find();
            
            if ($existingUser) {
                // 更新用户信息
                $updateData = [
                    'nickname' => $data['nickName'],
                    'avatar' => $data['avatarUrl'], // 字段名统一为 avatar
                    'gender' => $data['gender'] ?? 0,
                    'country' => $data['country'] ?? '',
                    'province' => $data['province'] ?? '',
                    'city' => $data['city'] ?? '',
                    'language' => $data['language'] ?? '',
                    'visit_count' => $data['visitCount'] ?? 0,
                    'like_count' => $data['likeCount'] ?? 0,
                    'last_login_time' => date('Y-m-d H:i:s'),
                    'update_time' => date('Y-m-d H:i:s')
                ];
                
                Db::name('users')->where('id', $existingUser['id'])->update($updateData);
                $userId = $existingUser['id'];
            } else {
                // 创建新用户
                $insertData = [
                    'user_key' => $userKey,
                    'nickname' => $data['nickName'],
                    'avatar' => $data['avatarUrl'], // 字段名统一为 avatar
                    'gender' => $data['gender'] ?? 0,
                    'country' => $data['country'] ?? '',
                    'province' => $data['province'] ?? '',
                    'city' => $data['city'] ?? '',
                    'language' => $data['language'] ?? '',
                    'visit_count' => $data['visitCount'] ?? 0,
                    'like_count' => $data['likeCount'] ?? 0,
                    'user_type' => 'wechat', // 统一用户类型
                    'status' => 1,
                    'role' => '访客',
                    'create_time' => date('Y-m-d H:i:s'),
                    'update_time' => date('Y-m-d H:i:s')
                ];
                
                $userId = Db::name('users')->insertGetId($insertData);
            }
            
            return json([
                'code' => 200,
                'message' => '保存成功',
                'data' => [
                    'user_id' => $userId,
                    'user_key' => $userKey
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取用户信息
     */
    public function getUserInfo(Request $request): Response
    {
        try {
            $userKey = $request->param('user_key', '');
            
            if (empty($userKey)) {
                return json(['code' => 400, 'message' => '用户标识不能为空']);
            }
            
            $user = Db::name('users')->where('user_key', $userKey)->find();
            
            if (!$user) {
                return json(['code' => 404, 'message' => '用户不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'nickName' => $user['nickname'],
                    'avatarUrl' => $user['avatar'],
                    'gender' => $user['gender'],
                    'country' => $user['country'],
                    'province' => $user['province'],
                    'city' => $user['city'],
                    'language' => $user['language'],
                    'visitCount' => $user['visit_count'],
                    'likeCount' => $user['like_count'],
                    'createTime' => $user['create_time'],
                    'lastLoginTime' => $user['last_login_time']
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新用户统计信息
     */
    public function updateUserStats(Request $request): Response
    {
        try {
            $userKey = $request->param('user_key', '');
            $type = $request->param('type', ''); // 'visit' 或 'like'
            
            if (empty($userKey) || empty($type)) {
                return json(['code' => 400, 'message' => '参数不完整']);
            }
            
            $user = Db::name('users')->where('user_key', $userKey)->find();
            
            if (!$user) {
                return json(['code' => 404, 'message' => '用户不存在']);
            }
            
            $updateData = [
                'update_time' => date('Y-m-d H:i:s')
            ];
            
            if ($type === 'visit') {
                $updateData['visit_count'] = $user['visit_count'] + 1;
            } elseif ($type === 'like') {
                $updateData['like_count'] = $user['like_count'] + 1;
            } else {
                return json(['code' => 400, 'message' => '无效的统计类型']);
            }
            
            Db::name('users')->where('id', $user['id'])->update($updateData);
            
            return json([
                'code' => 200,
                'message' => '更新成功',
                'data' => $updateData
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 