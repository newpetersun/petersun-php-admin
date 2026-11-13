<?php
declare(strict_types=1);

namespace app\service;

use think\facade\Db;

/**
 * 通知（消息）统一写入 / 读取服务
 *
 * 设计前提：所有「通知（互动提醒）」都必须经过本服务写入 notifications 表，
 * 禁止在控制器里直写该表，以避免各处通知逻辑漂移。
 * 其他控制器（发帖评论 / 点赞 / 关注 / @提及 / 系统广播）统一调用本服务的便捷方法。
 *
 * 通知类型（与前端 message 页类型过滤一致）：
 *   comment 评论 / like 点赞 / at @提及 / follow 关注 / system 系统
 */
class NotificationService
{
    public const TYPE_COMMENT = 'comment';
    public const TYPE_LIKE    = 'like';
    public const TYPE_AT      = 'at';
    public const TYPE_FOLLOW  = 'follow';
    public const TYPE_SYSTEM  = 'system';

    public const TYPES = [
        self::TYPE_COMMENT,
        self::TYPE_LIKE,
        self::TYPE_AT,
        self::TYPE_FOLLOW,
        self::TYPE_SYSTEM,
    ];

    public const SYSTEM_NAME    = '比特回响';
    public const SYSTEM_AVATAR  = '/static/images/logo.jpg';
    public const DEFAULT_AVATAR = '/static/images/default-avatar.jpg';

    // ========================================================
    // 写入（供其他控制器调用）
    // ========================================================

    /**
     * 核心写入：向 toUserId 推送一条通知。
     * 返回新通知 id；以下情况返回 null（不写库）：
     *   - toUserId 为空
     *   - toUserId === fromUserId（不通知自己）
     *
     * @param string $toUserId   接收者用户ID（必填）
     * @param string $type       通知类型（见 TYPE_* 常量）
     * @param string $action     动作文案，如「评论了你的帖子」
     * @param array  $opts       可选：fromUserId / snippet / targetType / targetId
     */
    public function notify(string $toUserId, string $type, string $action, array $opts = []): ?string
    {
        if ($toUserId === '') {
            return null;
        }
        if (!in_array($type, self::TYPES, true)) {
            $type = self::TYPE_SYSTEM;
        }
        $fromUserId = (string) ($opts['fromUserId'] ?? '');
        if ($fromUserId !== '' && $fromUserId === $toUserId) {
            return null; // 不通知自己
        }

        $id = uuid();
        Db::name('notifications')->insert([
            'id'          => $id,
            'user_id'     => $toUserId,
            'sender_id'   => $fromUserId === '' ? null : $fromUserId,
            'type'        => $type,
            'action'      => mb_substr($action, 0, 64),
            'snippet'     => mb_substr((string) ($opts['snippet'] ?? ''), 0, 255),
            'target_type' => isset($opts['targetType']) ? mb_substr((string) $opts['targetType'], 0, 32) : null,
            'target_id'   => isset($opts['targetId']) ? mb_substr((string) $opts['targetId'], 0, 64) : null,
            'is_read'     => 0,
            'create_time' => date('Y-m-d H:i:s'),
        ]);
        return $id;
    }

    /** 评论了你的帖子（顶层评论，通知帖子作者） */
    public function commentNotify(string $toUserId, string $fromUserId, string $snippet, string $postId, string $postTitle = ''): ?string
    {
        return $this->notify($toUserId, self::TYPE_COMMENT, '评论了你的帖子', [
            'fromUserId' => $fromUserId,
            'snippet'    => $snippet,
            'targetType' => 'post',
            'targetId'   => $postId,
        ]);
    }

    /** 回复了你的评论（通知被回复的评论作者） */
    public function replyNotify(string $toUserId, string $fromUserId, string $snippet, string $commentId): ?string
    {
        return $this->notify($toUserId, self::TYPE_COMMENT, '回复了你的评论', [
            'fromUserId' => $fromUserId,
            'snippet'    => $snippet,
            'targetType' => 'comment',
            'targetId'   => $commentId,
        ]);
    }

    /** 赞了你的帖子 */
    public function likeNotify(string $toUserId, string $fromUserId, string $postId, string $postTitle = ''): ?string
    {
        return $this->notify($toUserId, self::TYPE_LIKE, '赞了你的帖子', [
            'fromUserId' => $fromUserId,
            'snippet'    => $postTitle,
            'targetType' => 'post',
            'targetId'   => $postId,
        ]);
    }

    /** 在评论/内容中 @ 提到了你 */
    public function atNotify(string $toUserId, string $fromUserId, string $snippet, string $targetType, string $targetId): ?string
    {
        return $this->notify($toUserId, self::TYPE_AT, '在评论中提到了你', [
            'fromUserId' => $fromUserId,
            'snippet'    => $snippet,
            'targetType' => $targetType,
            'targetId'   => $targetId,
        ]);
    }

    /** 关注了你 */
    public function followNotify(string $toUserId, string $fromUserId): ?string
    {
        return $this->notify($toUserId, self::TYPE_FOLLOW, '关注了你', [
            'fromUserId' => $fromUserId,
        ]);
    }

    /** 系统通知（sender 为系统账号，sender_id 留空） */
    public function systemNotify(string $toUserId, string $action, string $snippet = ''): ?string
    {
        return $this->notify($toUserId, self::TYPE_SYSTEM, $action, [
            'snippet' => $snippet,
        ]);
    }

    // ========================================================
    // 读取 / 格式化（供 Message 控制器复用）
    // ========================================================

    /**
     * 列表（按 type 过滤，分页），并附带未读总数
     */
    public function listForUser(string $userId, string $type, int $page, int $limit): array
    {
        $query = Db::name('notifications')->where('user_id', $userId);
        if ($type !== '' && $type !== 'all' && in_array($type, self::TYPES, true)) {
            $query->where('type', $type);
        }
        $total = $query->count();
        $rows  = $query->order('create_time', 'desc')
            ->page($page, $limit)
            ->select()
            ->toArray();

        $unreadTotal = Db::name('notifications')
            ->where('user_id', $userId)
            ->where('is_read', 0)
            ->count();

        return [
            'list'        => array_map([$this, 'format'], $rows),
            'total'       => (int) $total,
            'page'        => $page,
            'limit'       => $limit,
            'unreadTotal' => (int) $unreadTotal,
        ];
    }

    /** 未读总数 */
    public function unreadCount(string $userId): int
    {
        return (int) Db::name('notifications')
            ->where('user_id', $userId)
            ->where('is_read', 0)
            ->count();
    }

    /**
     * 格式化为前端消息页所需结构。
     * user_key 用 sender_id（uuid）承载，供前端跳转他人主页；系统通知无 sender。
     */
    public function format(array $r): array
    {
        $senderId = (string) ($r['sender_id'] ?? '');
        if ($senderId !== '') {
            $sender = Db::name('users')->where('id', $senderId)
                ->field('nickname, avatar')->find();
            $name   = (string) ($sender['nickname'] ?? '已注销用户');
            $avatar = (string) ($sender['avatar'] ?? self::DEFAULT_AVATAR);
            $key    = $senderId;
        } else {
            $name   = self::SYSTEM_NAME;   // 系统通知
            $avatar = self::SYSTEM_AVATAR;
            $key    = '';
        }

        return [
            'id'         => $r['id'],
            'type'       => (string) ($r['type'] ?? 'system'),
            'read'       => (int) ($r['is_read'] ?? 0) === 1,
            'user'       => [
                'name'     => $name,
                'avatar'   => $avatar,
                'user_key' => $key,
            ],
            'action'     => (string) ($r['action'] ?? ''),
            'snippet'    => (string) ($r['snippet'] ?? ''),
            'targetType' => $r['target_type'] ?? null,
            'targetId'   => $r['target_id'] ?? null,
            'time'       => $this->humanTime((string) ($r['create_time'] ?? '')),
        ];
    }

    /**
     * 相对时间（中文），前端消息页直接展示 time 字段
     */
    public function humanTime(string $datetime): string
    {
        if ($datetime === '') {
            return '';
        }
        $ts = strtotime($datetime);
        if ($ts === false) {
            return $datetime;
        }
        $diff = time() - $ts;
        if ($diff < 60) {
            return '刚刚';
        }
        if ($diff < 3600) {
            return floor($diff / 60) . ' 分钟前';
        }
        if ($diff < 86400) {
            return floor($diff / 3600) . ' 小时前';
        }
        if ($diff < 86400 * 7) {
            return floor($diff / 86400) . ' 天前';
        }
        return date('Y-m-d', $ts);
    }
}
