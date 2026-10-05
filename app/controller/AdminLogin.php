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
 * 后台登录
 *  - 管理员密码登录：账号=站长昵称(nickname)/密码(bcrypt)，仅 user_type=webmaster 可登录 -> 签发用户 JWT
 *  - 创作者扫码登录：网页生成票据 -> 服务端生成小程序码 -> 小程序扫码确认 -> 网页轮询拿 JWT
 */
class AdminLogin extends BaseController
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
                return json(['code' => 400, 'message' => '用户名和密码不能为空']);
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

            // 直接查 users 表：仅 webmaster 且启用、且已设置密码的账号可密码登录
            $user = Db::name('users')
                ->where('nickname', $username)
                ->where('user_type', 'webmaster')
                ->where('status', 1)
                ->field('id, nickname, avatar, password')
                ->find();

            if (!$user || empty($user['password']) || !password_verify($password, $user['password'])) {
                return json(['code' => 401, 'message' => '用户名或密码错误']);
            }

            $token = (new JwtService())->generateToken([
                'user_id' => $user['id'],
                'type'    => 'user',
            ]);

            return json([
                'code'    => 200,
                'message' => '登录成功',
                'data'    => [
                    'token' => $token,
                    'user'  => [
                        'id'       => $user['id'],
                        'nickname' => $user['nickname'],
                        'avatar'   => $user['avatar'],
                    ],
                ],
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 创建扫码登录票据，返回小程序码（base64）
     * 小程序码指向 pages/scan-login/scan-login?ticket=xxx
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

            $path   = 'pages/scan-login/scan-login?ticket=' . $ticket;
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
                    ->where('user_type', 'webmaster')
                    ->where('status', 1)
                    ->field('id, nickname, avatar')
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

                return json([
                    'code'    => 200,
                    'message' => '登录成功',
                    'data'    => [
                        'token' => $token,
                        'user'  => [
                            'id'       => $user['id'],
                            'nickname' => $user['nickname'],
                            'avatar'   => $user['avatar'],
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
     * 小程序端确认登录（需用户 JWT；仅 webmaster 可登录后台）
     */
    public function scanConfirm(Request $request): Response
    {
        try {
            $userId = $request->userId ?? '';
            $ticket = (string) $request->param('ticket', '');

            if (empty($userId)) {
                return json(['code' => 401, 'message' => '请先登录小程序']);
            }
            $row = Db::name('admin_scan_tickets')
                ->where('ticket', $ticket)
                ->where('status', 0)
                ->find();
            if (!$row) {
                return json(['code' => 404, 'message' => '票据不存在或已使用']);
            }
            if (strtotime($row['expire_time']) < time()) {
                return json(['code' => 410, 'message' => '二维码已过期']);
            }

            $user = Db::name('users')->where('id', $userId)->find();
            if (!$user) {
                return json(['code' => 404, 'message' => '用户不存在']);
            }
            if ($user['user_type'] !== 'webmaster') {
                return json(['code' => 403, 'message' => '仅站点主理人(创作者)可登录后台']);
            }
            if ($user['status'] != 1) {
                return json(['code' => 403, 'message' => '账号已被禁用']);
            }

            Db::name('admin_scan_tickets')
                ->where('ticket', $ticket)
                ->update(['status' => 1, 'user_id' => $userId]);

            return json(['code' => 200, 'message' => '已确认，请在网页端完成登录']);
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
            return '';
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
