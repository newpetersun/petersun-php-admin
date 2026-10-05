<?php
declare(strict_types=1);

namespace app\service;

use think\facade\Db;

/**
 * 虚拟支付配置中心
 *
 * 读取优先级：数据库 virtualpay_config 表 > .env（env()）
 * 这样密钥等敏感/易变配置可集中在数据库（或后台）管理，不必改 .env；
 * 数据库未配置该项时自动回退到 .env，保证平滑迁移。
 */
class VpConfig
{
    // 进程内缓存，避免同一请求内对同一个 key 反复查库
    private static $cache = [];

    /**
     * 取单个配置（DB 优先，缺失回退 .env）
     * @param mixed $default
     * @return mixed
     */
    public static function get(string $name, $default = '')
    {
        if (array_key_exists($name, self::$cache)) {
            return self::$cache[$name];
        }

        $row = Db::name('virtualpay_config')->where('name', $name)->value('value');
        if ($row === null || $row === false) {
            $value = env($name, $default);          // 回退到 .env
        } else {
            $value = $row;
        }

        self::$cache[$name] = $value;
        return $value;
    }

    /** 覆盖写入（后台保存配置时调用） */
    public static function set(string $name, string $value): void
    {
        $exists = Db::name('virtualpay_config')->where('name', $name)->find();
        $now    = date('Y-m-d H:i:s');
        if ($exists) {
            Db::name('virtualpay_config')->where('name', $name)->update([
                'value'       => $value,
                'update_time' => $now,
            ]);
        } else {
            Db::name('virtualpay_config')->insert([
                'name'        => $name,
                'value'       => $value,
                'create_time' => $now,
                'update_time' => $now,
            ]);
        }
        self::$cache[$name] = $value;
    }
}
