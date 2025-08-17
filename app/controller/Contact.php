<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

class Contact extends BaseController
{
    /**
     * 获取联系信息
     */
    public function info(): Response
    {
        try {
            $contact = Db::name('contact')->where('id', 1)->find();
            
            if (!$contact) {
                return json(['code' => 404, 'message' => '联系信息不存在']);
            }
            
            // 解析工作时间
            $workingHours = json_decode($contact['working_hours'], true) ?: [];
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'email' => $contact['email'],
                    'wechat' => $contact['wechat'],
                    'qq' => $contact['qq'],
                    'address' => $contact['address'],
                    'github' => $contact['github'],
                    'working_hours' => $workingHours
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新联系信息
     */
    public function update(Request $request): Response
    {
        try {
            $data = $request->only(['email', 'wechat', 'qq', 'address', 'github', 'working_hours']);
            
            // 验证必填字段
            if (empty($data['email'])) {
                return json(['code' => 400, 'message' => '邮箱不能为空']);
            }
            
            // 验证邮箱格式
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                return json(['code' => 400, 'message' => '邮箱格式不正确']);
            }
            
            // 处理工作时间数据
            if (isset($data['working_hours']) && is_array($data['working_hours'])) {
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
     * 获取留言列表
     */
    public function messages(Request $request): Response
    {
        try {
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 10);
            $status = $request->param('status', ''); // 0未读 1已读
            
            $where = [];
            if ($status !== '') {
                $where[] = ['is_read', '=', $status];
            }
            
            $messages = Db::name('contact_message')
                ->where($where)
                ->order('create_time', 'desc')
                ->paginate([
                    'list_rows' => $limit,
                    'page' => $page
                ]);
            
            $list = $messages->items();
            
            // 格式化时间
            foreach ($list as &$message) {
                $message['create_time'] = date('Y-m-d H:i:s', strtotime($message['create_time']));
                $message['read_time'] = $message['read_time'] ? date('Y-m-d H:i:s', strtotime($message['read_time'])) : '';
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list' => $list,
                    'total' => $messages->total(),
                    'page' => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 提交留言
     */
    public function message(Request $request): Response
    {
        try {
            $data = $request->only(['name', 'email', 'subject', 'message']);
            
            // 验证必填字段
            if (empty($data['name']) || empty($data['email']) || empty($data['message'])) {
                return json(['code' => 400, 'message' => '姓名、邮箱和留言内容不能为空']);
            }
            
            // 验证邮箱格式
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                return json(['code' => 400, 'message' => '邮箱格式不正确']);
            }
            
            // 检查是否重复提交（5分钟内相同邮箱和内容）
            $recentMessage = Db::name('contact_message')
                ->where('email', $data['email'])
                ->where('message', $data['message'])
                ->where('create_time', '>', date('Y-m-d H:i:s', time() - 300))
                ->find();
            
            if ($recentMessage) {
                return json(['code' => 400, 'message' => '请勿重复提交相同内容']);
            }
            
            $messageData = [
                'name' => $data['name'],
                'email' => $data['email'],
                'subject' => $data['subject'] ?? '',
                'message' => $data['message'],
                'ip' => $request->ip(),
                'user_agent' => $request->header('user-agent'),
                'is_read' => 0,
                'create_time' => date('Y-m-d H:i:s')
            ];
            
            $result = Db::name('contact_message')->insert($messageData);
            
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
     * 标记留言为已读
     */
    public function markAsRead($id): Response
    {
        try {
            $result = Db::name('contact_message')
                ->where('id', $id)
                ->update([
                    'is_read' => 1,
                    'read_time' => date('Y-m-d H:i:s')
                ]);
            
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
    public function deleteMessage($id): Response
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

    /**
     * 获取留言统计
     */
    public function stats(): Response
    {
        try {
            $totalMessages = Db::name('contact_message')->count();
            $unreadMessages = Db::name('contact_message')->where('is_read', 0)->count();
            $todayMessages = Db::name('contact_message')
                ->where('create_time', '>=', date('Y-m-d 00:00:00'))
                ->count();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'total_messages' => $totalMessages,
                    'unread_messages' => $unreadMessages,
                    'today_messages' => $todayMessages
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 批量标记为已读
     */
    public function batchMarkAsRead(Request $request): Response
    {
        try {
            $ids = $request->param('ids', []);
            
            if (empty($ids) || !is_array($ids)) {
                return json(['code' => 400, 'message' => '请选择要标记的留言']);
            }
            
            $result = Db::name('contact_message')
                ->whereIn('id', $ids)
                ->update([
                    'is_read' => 1,
                    'read_time' => date('Y-m-d H:i:s')
                ]);
            
            if ($result !== false) {
                return json(['code' => 200, 'message' => '批量标记成功']);
            } else {
                return json(['code' => 500, 'message' => '批量标记失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 批量删除留言
     */
    public function batchDelete(Request $request): Response
    {
        try {
            $ids = $request->param('ids', []);
            
            if (empty($ids) || !is_array($ids)) {
                return json(['code' => 400, 'message' => '请选择要删除的留言']);
            }
            
            $result = Db::name('contact_message')->whereIn('id', $ids)->delete();
            
            if ($result) {
                return json(['code' => 200, 'message' => '批量删除成功']);
            } else {
                return json(['code' => 500, 'message' => '批量删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 