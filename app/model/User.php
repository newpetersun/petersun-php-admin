<?php
declare(strict_types=1);

namespace app\model;

use think\Model;

/**
 * 用户模型
 */
class User extends Model
{
    // 设置表名
    protected $name = 'users';
    
    // 设置字段信息
    protected $schema = [
        'id'              => 'int',
        'username'        => 'string',
        'password'        => 'string',
        'email'           => 'string',
        'nickname'        => 'string',
        'name'            => 'string',
        'code_age'        => 'string',
        'description'     => 'string',
        'avatar'          => 'string',
        'github'          => 'string',
        'wechat'          => 'string',
        'status'          => 'int',
        'last_login_time' => 'datetime',
        'last_login_ip'   => 'string',
        'created_at'      => 'datetime',
        'updated_at'      => 'datetime',
    ];
    
    // 自动时间戳
    protected $autoWriteTimestamp = true;
    protected $createTime = 'created_at';
    protected $updateTime = 'updated_at';
    
    // 隐藏字段
    protected $hidden = ['openid'];
    
    // 类型转换
    protected $type = [
        'status'          => 'integer',
        'last_login_time' => 'datetime',
        'created_at'      => 'datetime',
        'updated_at'      => 'datetime',
    ];
    
    /**
     * 密码加密
     * @param string $password
     * @return string
     */
    public static function hashPassword(string $password): string
    {
        return password_hash($password, PASSWORD_DEFAULT);
    }
    
    /**
     * 验证密码
     * @param string $password
     * @param string $hash
     * @return bool
     */
    public static function verifyPassword(string $password, string $hash): bool
    {
        return password_verify($password, $hash);
    }
    
    /**
     * 根据用户名查找用户
     * @param string $username
     * @return User|null
     */
    public static function findByUsername(string $username): ?User
    {
        return self::where('username', $username)->where('status', 1)->find();
    }
    
    /**
     * 根据邮箱查找用户
     * @param string $email
     * @return User|null
     */
    public static function findByEmail(string $email): ?User
    {
        return self::where('email', $email)->where('status', 1)->find();
    }
    
    /**
     * 更新最后登录信息
     * @param string $ip
     * @return bool
     */
    public function updateLoginInfo(string $ip): bool
    {
        return $this->save([
            'last_login_time' => date('Y-m-d H:i:s'),
            'last_login_ip'   => $ip,
        ]);
    }
} 