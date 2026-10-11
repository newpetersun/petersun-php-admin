<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 账号绑定控制器（绑定账号）
 *
 * user_accounts 记录用户绑定的第三方/自有账号；
 * provider：wechat 微信 / alipay 支付宝 / phone 手机号 / weibo 微博 / qq QQ
 * 前端展示顺序与名称由 PLATFORMS 定义，bound=false 的平台也会返回以便展示“去绑定”。
 */
class Account extends BaseController
{
    /** 平台元信息（顺序即展示顺序） */
    private const PLATFORMS = [
        'wechat' => ['name' => '微信',   'color' => '#07C160'],
        'alipay' => ['name' => '支付宝', 'color' => '#1677FF'],
        'phone'  => ['name' => '手机号', 'color' => '#3549F5'],
        'weibo'  => ['name' => '微博',   'color' => '#E6162D'],
        'qq'     => ['name' => 'QQ',    'color' => '#12B7F5'],
    ];

    /** 绑定列表：含未绑定平台 */
    public function list(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $rows = Db::name('user_accounts')->where('user_id', $uid)
                ->where('status', 1)
                ->field('provider, account, bind_time')
                ->select()
                ->toArray();

            $bound = [];
            foreach ($rows as $r) {
                $bound[(string) $r['provider']] = $r;
            }

            $list = [];
            foreach (self::PLATFORMS as $key => $meta) {
                $row = $bound[$key] ?? null;
                $list[] = [
                    'key'    => $key,
                    'name'   => $meta['name'],
                    'color'  => $meta['color'],
                    'bound'  => $row !== null,
                    'account' => $row ? $this->mask((string) $row['account']) : '',
                    'bindTime' => $row ? (string) ($row['bind_time'] ?? '') : '',
                ];
            }

            return $this->ok($list);
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /**
     * 绑定账号
     * @param provider 平台标识
     * @param account  账号值（手机号平台传手机号，会做格式校验）
     */
    public function bind(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $provider = trim((string) $request->param('provider', ''));
            $account  = trim((string) $request->param('account', ''));

            if (!isset(self::PLATFORMS[$provider])) {
                return json(['code' => 400, 'message' => '不支持的绑定平台']);
            }
            if ($account === '') {
                return json(['code' => 400, 'message' => '请填写账号']);
            }
            if ($provider === 'phone' && !preg_match('/^1[3-9]\d{9}$/', $account)) {
                return json(['code' => 400, 'message' => '手机号格式不正确']);
            }
            if (mb_strlen($account) > 100) {
                return json(['code' => 400, 'message' => '账号长度不能超过100个字符']);
            }

            // 手机号唯一性校验（不含自己）
            if ($provider === 'phone') {
                $dup = Db::name('user_accounts')->where('provider', 'phone')
                    ->where('account', $account)->where('status', 1)
                    ->where('user_id', '<>', $uid)->count();
                if ($dup > 0) {
                    return json(['code' => 400, 'message' => '该手机号已绑定其他账号']);
                }
            }

            $now = date('Y-m-d H:i:s');
            $exists = Db::name('user_accounts')->where('user_id', $uid)
                ->where('provider', $provider)->find();

            if ($exists) {
                Db::name('user_accounts')->where('id', $exists['id'])->update([
                    'account'   => $account,
                    'status'    => 1,
                    'bind_time' => $now,
                ]);
            } else {
                Db::name('user_accounts')->insert([
                    'id'         => uuid(),
                    'user_id'    => $uid,
                    'provider'   => $provider,
                    'account'    => $account,
                    'status'     => 1,
                    'bind_time'  => $now,
                    'create_time' => $now,
                ]);
            }

            // 手机号绑定后同步回 users.phone，便于手机号登录
            if ($provider === 'phone') {
                Db::name('users')->where('id', $uid)->update(['phone' => $account]);
            }

            return $this->ok(['provider' => $provider, 'account' => $this->mask($account)], '绑定成功');
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    /** 解绑账号（手机号平台同时清空 users.phone） */
    public function unbind(Request $request): Response
    {
        try {
            $uid = $this->uid($request);
            if ($uid === '') {
                return json(['code' => 401, 'message' => '未登录或登录已过期']);
            }

            $provider = trim((string) $request->param('provider', ''));
            if (!isset(self::PLATFORMS[$provider])) {
                return json(['code' => 400, 'message' => '不支持的绑定平台']);
            }

            $row = Db::name('user_accounts')->where('user_id', $uid)
                ->where('provider', $provider)->where('status', 1)->find();
            if (!$row) {
                return json(['code' => 404, 'message' => '该平台尚未绑定']);
            }

            Db::name('user_accounts')->where('id', $row['id'])->update([
                'status'    => 0,
                'bind_time' => null,
            ]);
            if ($provider === 'phone') {
                Db::name('users')->where('id', $uid)->update(['phone' => '']);
            }

            return $this->ok(null, '已解绑');
        } catch (\Exception $e) {
            return $this->err($e);
        }
    }

    // ========================================================
    // 内部方法
    // ========================================================

    /** 账号脱敏：保留首尾各 2 位 */
    private function mask(string $account): string
    {
        $len = mb_strlen($account);
        if ($len <= 4) {
            return $account;
        }
        return mb_substr($account, 0, 2) . str_repeat('*', $len - 4) . mb_substr($account, -2);
    }

    /** 当前登录用户ID */
    private function uid(Request $request): string
    {
        return (string) ($request->userId ?? '');
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
