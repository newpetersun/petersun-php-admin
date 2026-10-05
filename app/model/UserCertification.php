<?php
declare(strict_types=1);

namespace app\model;

use think\Model;

/**
 * 用户认证模型
 */
class UserCertification extends Model
{
    // 设置表名
    protected $name = 'user_certifications';

    // 设置字段信息
    protected $schema = [
        'id'            => 'string',
        'user_id'       => 'string',
        'type'          => 'string',
        'cert_name'     => 'string',
        'status'        => 'string',
        'real_name'     => 'string',
        'id_card'       => 'string',
        'company_name'  => 'string',
        'license_no'    => 'string',
        'contact_phone' => 'string',
        'materials'     => 'string',
        'description'   => 'string',
        'reject_reason' => 'string',
        'audit_time'    => 'datetime',
        'create_time'   => 'datetime',
        'update_time'   => 'datetime',
    ];

    // 自动时间戳
    protected $autoWriteTimestamp = true;
    protected $createTime = 'create_time';
    protected $updateTime = 'update_time';

    // 类型转换
    protected $type = [
        'audit_time'  => 'datetime',
        'create_time' => 'datetime',
        'update_time' => 'datetime',
    ];

    /**
     * 查询某用户的认证记录
     * @param string $userId
     * @return UserCertification|null
     */
    public static function findByUser(string $userId): ?UserCertification
    {
        return self::where('user_id', $userId)->order('create_time', 'desc')->find();
    }

    /**
     * 查询某用户指定类型的认证记录
     * @param string $userId
     * @param string $type
     * @return UserCertification|null
     */
    public static function findByUserAndType(string $userId, string $type): ?UserCertification
    {
        return self::where('user_id', $userId)
            ->where('type', $type)
            ->order('create_time', 'desc')
            ->find();
    }
}
