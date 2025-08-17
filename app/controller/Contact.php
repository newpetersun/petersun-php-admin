<?php
declare (strict_types = 1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\Response;
use think\facade\Db;

class Contact extends BaseController
{
    /**
     * 获取联系信息
     */
    public function info()
    {
        try {
            $contact = Db::name('contact')->where('id', 1)->find();
            
            if (!$contact) {
                return json(['code' => 404, 'message' => '联系信息不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'email' => $contact['email'],
                    'wechat' => $contact['wechat'],
                    'qq' => $contact['qq'],
                    'address' => $contact['address'],
                    'github' => $contact['github'],
                    'working_hours' => json_decode($contact['working_hours'], true)
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新联系信息
     */
    public function update(Request $request)
    {
        try {
            $data = $request->only(['email', 'wechat', 'qq', 'address', 'github', 'working_hours']);
            
            // 处理工作时间数据
            if (isset($data['working_hours'])) {
                $data['working_hours'] = json_encode($data['working_hours']);
            }
            
            $result = Db::name('contact')->where('id', 1)->update($data);
            
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
     * 提交留言
     */
    public function message(Request $request)
    {
        try {
            $data = $request->only(['name', 'email', 'subject', 'message']);
            
            // 验证必填字段
            if (empty($data['name']) || empty($data['email']) || empty($data['message'])) {
                return json(['code' => 400, 'message' => '请填写完整信息']);
            }
            
            // 验证邮箱格式
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                return json(['code' => 400, 'message' => '邮箱格式不正确']);
            }
            
            $data['created_at'] = date('Y-m-d H:i:s');
            $data['status'] = 0; // 0: 未读, 1: 已读
            
            $result = Db::name('contact_message')->insert($data);
            
            if ($result) {
                return json(['code' => 200, 'message' => '留言提交成功']);
            } else {
                return json(['code' => 500, 'message' => '留言提交失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取留言列表（后台管理）
     */
    public function messages(Request $request)
    {
        try {
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 10);
            $status = $request->param('status', '');
            
            $where = [];
            if ($status !== '') {
                $where[] = ['status', '=', $status];
            }
            
            $messages = Db::name('contact_message')
                ->where($where)
                ->order('created_at', 'desc')
                ->paginate([
                    'list_rows' => $limit,
                    'page' => $page
                ]);
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $messages
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 标记留言为已读
     */
    public function readMessage($id)
    {
        try {
            $result = Db::name('contact_message')->where('id', $id)->update(['status' => 1]);
            
            if ($result !== false) {
                return json(['code' => 200, 'message' => '标记成功']);
            } else {
                return json(['code' => 500, 'message' => '标记失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除留言
     */
    public function deleteMessage($id)
    {
        try {
            $result = Db::name('contact_message')->where('id', $id)->delete();
            
            if ($result) {
                return json(['code' => 200, 'message' => '删除成功']);
            } else {
                return json(['code' => 500, 'message' => '删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 