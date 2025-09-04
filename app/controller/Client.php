<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;
use app\model\User as UserModel;

/**
 * 客户管理控制器
 * 通过users表筛选user_type=wechat的用户作为客户
 */
class Client extends BaseController
{
    /**
     * 获取客户列表
     */
    public function list(Request $request): Response
    {
        try {
            $limit = $request->param('limit', 10);
            $page = $request->param('page', 1);
            $keyword = $request->param('keyword', '');
            $status = $request->param('status', '');
            
            $query = UserModel::where('user_type', 'wechat');
            
            // 关键字搜索
            if (!empty($keyword)) {
                $query->where(function ($q) use ($keyword) {
                    $q->where('nickname', 'like', "%{$keyword}%")
                      ->whereOr('email', 'like', "%{$keyword}%")
                      ->whereOr('phone', 'like', "%{$keyword}%");
                });
            }
            
            // 状态过滤
            if ($status !== '') {
                $query->where('status', (int)$status);
            }
            
            // 获取总数
            $total = $query->count();
            
            // 获取分页数据
            $clients = $query->page($page, $limit)
                ->order('id', 'desc')
                ->select()
                ->toArray();
            
            // 简化返回字段，客户不需要返回敏感信息
            $result = [];
            foreach ($clients as $client) {
                $result[] = [
                    'id' => $client['id'],
                    'name' => $client['nickname'],  // 用昵称作为客户名称
                    'contact' => $client['nickname'], // 联系人默认用昵称
                    'phone' => $client['phone'] ?? '',
                    'email' => $client['email'] ?? '',
                    'avatar' => $client['avatar'] ?? '',
                    'city' => ($client['province'] ?? '') . ' ' . ($client['city'] ?? ''),
                    'status' => $client['status'],
                    'create_time' => $client['create_time'],
                    'update_time' => $client['update_time']
                ];
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list' => $result,
                    'total' => $total,
                    'page' => (int)$page,
                    'limit' => (int)$limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 获取客户详情
     */
    public function detail(int $id): Response
    {
        try {
            $client = UserModel::where('id', $id)
                ->where('user_type', 'wechat')
                ->find();
                
            if (!$client) {
                return json(['code' => 404, 'message' => '客户不存在']);
            }
            
            $result = [
                'id' => $client->id,
                'name' => $client->nickname,
                'contact' => $client->nickname,
                'phone' => $client->phone ?? '',
                'email' => $client->email ?? '',
                'avatar' => $client->avatar ?? '',
                'city' => ($client->province ?? '') . ' ' . ($client->city ?? ''),
                'status' => $client->status,
                'wechat' => $client->wechat ?? '',
                'qq' => $client->qq ?? '',
                'github' => $client->github ?? '',
                'web_url' => $client->web_url ?? '',
                'description' => $client->description ?? '',
                'create_time' => $client->create_time,
                'update_time' => $client->update_time
            ];
            
            // 获取关联的项目
            $projects = Db::name('project')
                ->where('client_id', $id)
                ->order('create_time', 'desc')
                ->select()
                ->toArray();
            
            $result['projects'] = $projects;
            
            return json(['code' => 200, 'message' => '获取成功', 'data' => $result]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 更新客户状态
     */
    public function updateStatus(int $id, Request $request): Response
    {
        try {
            $status = $request->param('status', 0);
            
            $client = UserModel::where('id', $id)
                ->where('user_type', 'wechat')
                ->find();
                
            if (!$client) {
                return json(['code' => 404, 'message' => '客户不存在']);
            }
            
            $client->status = $status;
            $client->save();
            
            return json(['code' => 200, 'message' => '更新成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 获取客户的项目列表
     */
    public function projects(int $id): Response
    {
        try {
            // 检查客户是否存在
            $client = UserModel::where('id', $id)
                ->where('user_type', 'wechat')
                ->find();
                
            if (!$client) {
                return json(['code' => 404, 'message' => '客户不存在']);
            }
            
            // 获取该客户的所有项目
            $projects = Db::name('project')
                ->where('client_id', $id)
                ->order('create_time', 'desc')
                ->select()
                ->toArray();
            
            return json(['code' => 200, 'message' => '获取成功', 'data' => $projects]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
