<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 站内私信控制器（私信留言）
 *
 * 会话 ID 生成规则：将双方 user_id 按字典序拼接后取 md5，
 * 保证同一对用户的会话 ID 稳定可复现（两端计算结果一致）。
 */
class Message extends BaseController
{
    /** 会话列表：每个会话的最新一条 + 未读数 */
    public function conversations(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }
            [$page, $limit] = $this->paging($request);

            // 我参与的会话
            $rows = Db::name('user_messages')->alias('m')
                ->where('m.from_id', $uid)
                ->whereOr('m.to_id', $uid)
                ->field('m.conversation_id, MAX(m.create_time) AS last_time')
                ->group('m.conversation_id')
                ->order('last_time', 'desc')
                ->page($page, $limit)
                ->select()
                ->toArray();

            $list = [];
            foreach ($rows as $r) {
                $cid = (string) $r['conversation_id'];
                $peerId = $this->peerId($cid, $uid);
                $peer = Db::name('users')->where('id', $peerId)
                    ->field('id, nickname, avatar')->find();

                $last = Db::name('user_messages')->where('conversation_id', $cid)
                    ->order('create_time', 'desc')->find();
                $unread = Db::name('user_messages')->where('conversation_id', $cid)
                    ->where('to_id', $uid)->where('is_read', 0)->count();

                $list[] = [
                    'id'         => $cid,
                    'peerId'     => $peerId,
                    'name'       => (string) ($peer['nickname'] ?? '已注销用户'),
                    'avatar'     => (string) ($peer['avatar'] ?? ''),
                    'last'       => $last ? mb_substr((string) $last['content'], 0, 30) : '',
                    'time'       => (string) $r['last_time'],
                    'unread'     => (int) $unread,
                    'lastFromMe' => $last ? ((string) $last['from_id'] === $uid) : false,
                ];
            }

            $total = Db::name('user_messages')->alias('m')
                ->where('m.from_id', $uid)->whereOr('m.to_id', $uid)
                ->distinct(true)->count('m.conversation_id');

            $unreadAll = Db::name('user_messages')->where('to_id', $uid)
                ->where('is_read', 0)->count();

            return $this->ok([
                'list'       => $list,
                'total'      => (int) $total,
                'page'       => $page,
                'limit'      => $limit,
                'unreadTotal' => (int) $unreadAll,
            ]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 某个会话的消息列表（同时标记已读） */
    public function messages(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $cid = trim((string) $request->param('conversation_id', ''));
            if ($cid === '') {
                return json(['code' => 400, 'message' => '会话ID不能为空']);
            }
            [$page, $limit] = $this->paging($request);

            $total = Db::name('user_messages')->where('conversation_id', $cid)->count();
            $rows = Db::name('user_messages')->where('conversation_id', $cid)
                ->order('create_time', 'asc')
                ->page($page, $limit)
                ->select()
                ->toArray();

            $list = [];
            foreach ($rows as $r) {
                $list[] = [
                    'id'      => $r['id'],
                    'fromId'  => (string) $r['from_id'],
                    'me'      => (string) $r['from_id'] === $uid,
                    'content' => (string) $r['content'],
                    'time'    => (string) $r['create_time'],
                ];
            }

            // 标记本会话中发给我的消息为已读
            Db::name('user_messages')->where('conversation_id', $cid)
                ->where('to_id', $uid)->where('is_read', 0)
                ->update(['is_read' => 1, 'read_time' => date('Y-m-d H:i:s')]);

            return $this->ok(['list' => $list, 'total' => (int) $total, 'page' => $page, 'limit' => $limit]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 发送私信：to_id 为接收者 */
    public function send(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $toId = trim((string) $request->param('to_id', ''));
            $content = trim((string) $request->param('content', ''));

            if ($toId === '') {
                return json(['code' => 400, 'message' => '请选择接收人']);
            }
            if ($toId === $uid) {
                return json(['code' => 400, 'message' => '不能给自己发送私信']);
            }
            if ($content === '') {
                return json(['code' => 400, 'message' => '消息内容不能为空']);
            }
            if (mb_strlen($content) > 1000) {
                return json(['code' => 400, 'message' => '消息内容不能超过1000个字符']);
            }
            if (!Db::name('users')->where('id', $toId)->where('status', 1)->find()) {
                return json(['code' => 404, 'message' => '接收人不存在或已禁用']);
            }

            $id = uuid();
            $now = date('Y-m-d H:i:s');
            Db::name('user_messages')->insert([
                'id'              => $id,
                'conversation_id' => $this->makeConversationId($uid, $toId),
                'from_id'         => $uid,
                'to_id'           => $toId,
                'content'         => $content,
                'is_read'         => 0,
                'create_time'     => $now,
            ]);

            return $this->ok(['id' => $id, 'time' => $now], '发送成功');
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 未读总数（铃铛角标 / 私信页） */
    public function unreadCount(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }
            $n = Db::name('user_messages')->where('to_id', $uid)->where('is_read', 0)->count();

            return $this->ok(['unread' => (int) $n]);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    // ========================================================
    // 内部方法
    // ========================================================

    /**
     * 生成会话 ID
     * 双方 ID 按字典序拼接后取 md5，保证两端算出同一结果
     */
    private function makeConversationId(string $a, string $b): string
    {
        $pair = [$a, $b];
        sort($pair, SORT_STRING);
        return md5($pair[0] . ':' . $pair[1]);
    }

    /**
     * 取会话对端用户ID
     * md5 不可逆，故从该会话的消息中取非自己的参与者
     */
    private function peerId(string $conversationId, string $selfId): string
    {
        $peer = Db::name('user_messages')->where('conversation_id', $conversationId)
            ->where('from_id', '<>', $selfId)
            ->order('create_time', 'desc')->value('from_id');
        if ((string) $peer !== '') {
            return (string) $peer;
        }
        return (string) Db::name('user_messages')->where('conversation_id', $conversationId)
            ->where('to_id', '<>', $selfId)
            ->order('create_time', 'desc')->value('to_id');
    }

    /** 当前登录用户ID */
    private function uid(Request $request): string
    {
        return (string) ($request->userId ?? '');
    }

    /** 分页参数 [page, limit] */
    private function paging(Request $request): array
    {
        $page  = max(1, (int) $request->param('page', 1));
        $limit = min(100, max(1, (int) $request->param('limit', 20)));
        return [$page, $limit];
    }

    /** 统一成功响应 */
    private function ok($data = null, string $message = '获取成功'): Response
    {
        return json(['code' => 200, 'message' => $message, 'data' => $data]);
    }

    /** 统一异常响应 */
    private function err(\Exception $e): Response
    {
        return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
    }
}
