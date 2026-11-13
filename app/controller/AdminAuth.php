<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\facade\Cache;
use think\Response;
use app\service\JwtService;
use app\service\VirtualPayService;

/**
 * 后台登录（与原 WechatAuth 拆分的后台专属登录：密码登录 / 扫码登录 / 图形验证码）
 * 小程序微信登录仍留在 WechatAuth，职责分离。
 */
class AdminAuth extends BaseController
{
    /**
     * 管理员密码登录
     */
    public function passwordLogin(Request $request): Response
    {
        try {
            $username = trim((string) $request->param('username', ''));
            $password = (string) $request->param('password', '');

            if ($username === '' || $password === '') {
                return json(['code' => 400, 'message' => '手机号和密码不能为空']);
            }

            // 图形验证码校验（防爆破）：一次性、5 分钟过期，错误即失效
            $captchaId = (string) $request->param('captchaId', '');
            $captcha   = (string) $request->param('captcha', '');
            if ($captchaId === '' || $captcha === '') {
                return json(['code' => 400, 'message' => '请输入验证码']);
            }
            $cached = Cache::get('admin_captcha_' . $captchaId);
            if (!$cached || strtolower($captcha) !== strtolower((string) $cached)) {
                Cache::delete('admin_captcha_' . $captchaId);
                return json(['code' => 400, 'message' => '验证码错误']);
            }
            Cache::delete('admin_captcha_' . $captchaId);

            // 直接查 users 表：启用且已设置密码的账号可密码登录
            $user = Db::name('users')
                ->where('phone', $username)
                ->where('status', 1)
                ->field('id, nickname, phone, avatar, role_id, password')
                ->find();

            if (!$user || empty($user['password']) || !password_verify($password, $user['password'])) {
                return json(['code' => 401, 'message' => '手机号或密码错误']);
            }

            $token = (new JwtService())->generateToken([
                'user_id' => $user['id'],
                'type'    => 'user',
            ]);

            // 角色：主角色 code（用于跳转/兼容）+ 完整角色列表（多角色切换）
            $roleList = Db::name('user_roles')->alias('ur')
                ->leftJoin('roles r', 'r.id = ur.role_id')
                ->where('ur.user_id', $user['id'])
                ->where('r.status', 1)
                ->field('r.id as id, r.name as name, r.code as code')
                ->select()
                ->toArray();
            $primaryCode = '';
            if (!empty($user['role_id'])) {
                $primaryCode = (string) (Db::name('roles')->where('id', $user['role_id'])->value('code') ?? '');
                // 主角色兜底：老数据主角色未写进 user_roles 时补入列表
                if ($primaryCode && !in_array($primaryCode, array_column($roleList, 'code'), true)) {
                    $pr = Db::name('roles')->where('id', $user['role_id'])->field('id, name, code')->find();
                    if ($pr) {
                        $roleList[] = ['id' => $pr['id'], 'name' => $pr['name'], 'code' => $pr['code']];
                    }
                }
            }

            return json([
                'code'    => 200,
                'message' => '登录成功',
                'data'    => [
                    'token' => $token,
                    'user'  => [
                        'id'       => $user['id'],
                        'nickname' => $user['nickname'],
                        'avatar'   => $user['avatar'],
                        'role'     => $primaryCode,
                        'role_list'=> $roleList,
                    ],
                ],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 创建扫码登录票据，返回小程序码（base64）
     * 小程序码指向 subpkg/scan-login/scan-login?ticket=xxx
     */
    public function scanTicket(Request $request): Response
    {
        try {
            $ticket = bin2hex(random_bytes(16));
            Db::name('admin_scan_tickets')->insert([
                'ticket'      => $ticket,
                'status'      => 0, // 0 待扫
                'expire_time' => date('Y-m-d H:i:s', time() + 120),
                'create_time' => date('Y-m-d H:i:s'),
            ]);

            $path   = 'subpkg/scan-login/scan-login?ticket=' . $ticket;
            $qrcode = $this->genMiniCode($path);

            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => [
                    'ticket' => $ticket,
                    'qrcode' => $qrcode, // 小程序码（base64），为空时前端用 ticket 降级提示
                    'expire' => 120,
                ],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 轮询扫码状态
     * 202 等待确认；200 登录成功（返回 token）；410 已过期；404 不存在
     */
    public function scanStatus(Request $request): Response
    {
        try {
            $ticket = (string) $request->param('ticket', '');
            $row    = Db::name('admin_scan_tickets')->where('ticket', $ticket)->find();

            if (!$row) {
                return json(['code' => 404, 'message' => '票据不存在']);
            }
            if ($row['status'] == 2 || strtotime($row['expire_time']) < time()) {
                return json(['code' => 410, 'message' => '二维码已过期，请刷新']);
            }
            if ($row['status'] == 1) {
                $user = Db::name('users')
                    ->where('id', $row['user_id'])
                    ->where('status', 1)
                    ->field('id, nickname, avatar, role_id')
                    ->find();
                if (!$user) {
                    return json(['code' => 403, 'message' => '登录账号无效']);
                }
                $token = (new JwtService())->generateToken([
                    'user_id' => $user['id'],
                    'type'    => 'user',
                ]);
                // 标记已使用，防止重复领取
                Db::name('admin_scan_tickets')
                    ->where('ticket', $ticket)
                    ->update(['status' => 3]);

                // 角色 code（用于前端按身份跳转/拉取对应菜单）
                $roleCode = '';
                if (!empty($user['role_id'])) {
                    $roleCode = (string) (Db::name('roles')
                        ->where('id', $user['role_id'])
                        ->value('code') ?? '');
                }

                return json([
                    'code'    => 200,
                    'message' => '登录成功',
                    'data'    => [
                        'token' => $token,
                        'user'  => [
                            'id'       => $user['id'],
                            'nickname' => $user['nickname'],
                            'avatar'   => $user['avatar'],
                            'role'     => $roleCode,
                        ],
                    ],
                ]);
            }

            return json([
                'code' => 202,
                'message' => '等待扫码确认',
                'data' => ['status' => (int) $row['status']],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取登录图形验证码：返回 captchaId + base64 图片
     * 答案以 admin_captcha_{id} 存入缓存，5 分钟有效，登录成功后一次性删除
     */
    public function captcha(): Response
    {
        try {
            $code = $this->genCaptchaCode(4);
            $id   = bin2hex(random_bytes(8));
            Cache::set('admin_captcha_' . $id, strtolower($code), 300);
            $img  = $this->renderCaptchaImage($code);
            return json([
                'code'    => 200,
                'message' => '获取成功',
                'data'    => [
                    'captchaId' => $id,
                    'image'     => 'data:image/png;base64,' . base64_encode($img),
                ],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 小程序码版本：release=正式版, trial=体验版, develop=开发版
     * 当前用 develop（开发版），无需上传体验版即可本地联调；
     * 注意：develop 版小程序码只能在真机调试中由开发者本人扫描打开。
     * 上线前改回 'release'。
     */
    private function miniEnvVersion(): string
    {
        return 'develop';
    }

    /**
     * 生成小程序码（getwxacode，支持 path 带 ?ticket= 参数）。失败时返回空串，由前端降级。
     */
    private function genMiniCode(string $path): string
    {
        try {
            $accessToken = VirtualPayService::getAccessToken();
            $url  = 'https://api.weixin.qq.com/wxa/getwxacode?access_token=' . $accessToken;
            $raw  = json_encode([
                'path'        => $path,
                'width'       => 430,
                'auto_color'  => false,
                'line_color'  => ['r' => 37, 'g' => 99, 'b' => 235],
                'is_hyaline'  => true,
                'env_version' => $this->miniEnvVersion(),
            ]);
            $img = $this->httpPostRaw($url, $raw);
            // 微信成功返回图片二进制；失败返回 JSON {errcode,errmsg}
            if (substr(trim($img), 0, 1) === '{') {
                return '';
            }
            return 'data:image/png;base64,' . base64_encode($img);
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    private function httpPostRaw(string $url, string $raw): string
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_POST           => true,
            CURLOPT_HTTPHEADER     => ['Content-Type: application/json', 'Content-Length: ' . strlen($raw)],
            CURLOPT_POSTFIELDS     => $raw,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_SSL_VERIFYHOST => false,
        ]);
        $res = curl_exec($ch);
        curl_close($ch);
        return (string) $res;
    }

    /**
     * 生成验证码字符（去掉易混淆的 0/O/1/l/I）
     */
    private function genCaptchaCode(int $len): string
    {
        $pool = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        $max  = strlen($pool) - 1;
        $out  = '';
        for ($i = 0; $i < $len; $i++) {
            $out .= $pool[rand(0, $max)];
        }
        return $out;
    }

    /**
     * 用 GD 内置字体绘制验证码图片（不依赖外部 TTF 字体文件）
     */
    private function renderCaptchaImage(string $code): string
    {
        if (!extension_loaded('gd')) {
            throw new \RuntimeException('GD extension not available');
        }
        $w = 110;
        $h = 40;
        $img = imagecreatetruecolor($w, $h);
        $bg  = imagecolorallocate($img, 245, 247, 250);
        imagefill($img, 0, 0, $bg);

        // 干扰线
        for ($i = 0; $i < 6; $i++) {
            $c = imagecolorallocate($img, rand(180, 225), rand(180, 225), rand(180, 225));
            imageline($img, rand(0, $w), rand(0, $h), rand(0, $w), rand(0, $h), $c);
        }
        // 干扰点
        for ($i = 0; $i < 40; $i++) {
            $c = imagecolorallocate($img, rand(180, 225), rand(180, 225), rand(180, 225));
            imagesetpixel($img, rand(0, $w), rand(0, $h), $c);
        }
        // 字符（内置字体 4~5，无需 TTF）
        $len = strlen($code);
        for ($i = 0; $i < $len; $i++) {
            $color = imagecolorallocate($img, rand(40, 120), rand(40, 120), rand(40, 160));
            $font  = rand(4, 5);
            $x = 12 + $i * (($w - 24) / $len);
            $y = rand(8, 16);
            imagestring($img, $font, (int) $x, $y, $code[$i], $color);
        }

        ob_start();
        imagepng($img);
        $data = ob_get_contents();
        ob_end_clean();
        imagedestroy($img);
        return $data;
    }
} 
