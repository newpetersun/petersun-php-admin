<?php
declare(strict_types=1);

namespace app\service;

use think\facade\Db;

/**
 * 海报合成服务（基于 GD）
 *  - 支持两种模板类型：cover（单封面海报）/ text（纯文字海报）
 *  - 后端直接合成 PNG，返回二进制；admin 预览与帖子分享共用
 *  - 小程序码统一嵌入右下角（帖子分享时取真实码，预览用占位）
 */
class PosterService
{
    // ------------------------------------------------------------------
    // 对外入口
    // ------------------------------------------------------------------

    /**
     * 渲染海报，返回 PNG 二进制
     * @param array      $cfg  设计配置（来自 poster_designs.config，或前端预览直接传）
     * @param array|null $post 帖子数据：{title,content,cover,code_path}；为 null 表示管理端预览
     */
    public static function render(array $cfg, ?array $post = null): string
    {
        $type      = in_array(($cfg['type'] ?? 'cover'), ['cover', 'text'], true) ? $cfg['type'] : 'cover';
        $width     = max(200, min(2000, (int) ($cfg['width'] ?? 600)));
        $height    = max(200, min(3000, (int) ($cfg['height'] ?? 840)));
        $bgColor   = $cfg['bg_color'] ?? '#ffffff';
        $bgImage   = $cfg['bg_image'] ?? '';
        $title     = $post['title']   ?? ($cfg['title']   ?? '');
        $titleColor = $cfg['title_color'] ?? '#1f2937';
        $titleSize = max(10, min(120, (int) ($cfg['title_size'] ?? 30)));
        $content   = $post['content'] ?? ($cfg['content'] ?? '');
        $contentColor = $cfg['content_color'] ?? '#4b5563';
        $contentSize = max(8, min(80, (int) ($cfg['content_size'] ?? 18)));
        $footer    = $cfg['footer_text'] ?? '长按识别小程序码';
        $footerColor = $cfg['footer_color'] ?? '#9ca3af';
        $codeSize  = max(40, min(600, (int) ($cfg['code_size'] ?? 160)));
        $cover     = ($type === 'cover') ? ($post['cover'] ?? ($cfg['cover'] ?? '')) : '';

        $font = self::fontPath();

        $im = imagecreatetruecolor($width, $height);
        imagealphablending($im, true);
        imagesavealpha($im, true);

        // 背景
        imagefilledrectangle($im, 0, 0, $width, $height, self::col($im, $bgColor));
        if ($bgImage) {
            $bgIm = self::loadImage($bgImage);
            if ($bgIm) {
                self::coverFit($im, $bgIm, 0, 0, $width, $height);
                imagedestroy($bgIm);
            }
        }

        $padX   = (int) ($width * 0.06);
        $titleC = self::col($im, $titleColor);
        $contC  = self::col($im, $contentColor);
        $footC  = self::col($im, $footerColor);

        // 封面区域（仅 cover 类型且有封面时）
        $coverH = 0;
        if ($type === 'cover' && $cover) {
            $coverH = (int) ($height * 0.5);
            $coverIm = self::loadImage($cover);
            if ($coverIm) {
                self::coverFit($im, $coverIm, 0, 0, $width, $coverH);
                imagedestroy($coverIm);
            } else {
                // 封面加载失败：占位渐变
                $g = imagecolorallocate($im, 229, 231, 235);
                imagefilledrectangle($im, 0, 0, $width, $coverH, $g);
            }
        }

        $bodyTop = $coverH > 0 ? $coverH + $padX : $padX;

        // 内容可用高度（标题 + 正文），底部给小程序码预留
        $codeY      = $height - $padX - $codeSize;
        $availBottom = $codeY - 16;

        $y = $bodyTop;
        // 标题（最多 2 行）
        if ($title !== '' && $font) {
            $titleLines = self::wrap($font, $titleSize, $title, $width - 2 * $padX, 2);
            $lh = (int) ($titleSize * 1.35);
            foreach ($titleLines as $ln) {
                imagettftext($im, $titleSize, 0, $padX, $y + $titleSize, $titleC, $font, $ln);
                $y += $lh;
            }
            $y += (int) ($titleSize * 0.4);
        }

        // 正文（按剩余空间限制行数）
        if ($content !== '' && $font) {
            $lh = (int) ($contentSize * 1.5);
            $maxLines = max(1, (int) (($availBottom - $y) / $lh));
            $contentLines = self::wrap($font, $contentSize, $content, $width - 2 * $padX, $maxLines);
            foreach ($contentLines as $ln) {
                imagettftext($im, $contentSize, 0, $padX, $y + $contentSize, $contC, $font, $ln);
                $y += $lh;
            }
        }

        // 小程序码（右下角） + 左侧提示
        $codeX = $width - $padX - $codeSize;
        self::roundRectFilled($im, $codeX - 8, $codeY - 8, $codeSize + 16, $codeSize + 16, 10, self::col($im, '#ffffff'));

        $codeIm = null;
        if (!empty($post['code_path'])) {
            $bin = self::fetchWxacode($post['code_path']);
            if ($bin) {
                $tmp = tempnam(sys_get_temp_dir(), 'wx_');
                file_put_contents($tmp, $bin);
                $codeIm = @imagecreatefrompng($tmp);
                @unlink($tmp);
            }
        }
        if ($codeIm) {
            imagecopyresampled($im, $codeIm, $codeX, $codeY, 0, 0, $codeSize, $codeSize, imagesx($codeIm), imagesy($codeIm));
            imagedestroy($codeIm);
        } else {
            // 占位：灰底 + 文字
            imagefilledrectangle($im, $codeX, $codeY, $codeX + $codeSize, $codeY + $codeSize, self::col($im, '#e5e7eb'));
            if ($font) {
                imagettftext($im, (int) ($codeSize * 0.16), 0, $codeX + 6, $codeY + (int) ($codeSize * 0.55), self::col($im, '#9ca3af'), $font, '小程序码');
            }
        }

        // 左侧提示文字
        if ($font) {
            $hint1 = $footer ?: '长按识别小程序码';
            $hint2 = '查看原文 · 知识社区';
            $baseY = $codeY + (int) ($codeSize * 0.4);
            imagettftext($im, 16, 0, $padX, $baseY, $footC, $font, $hint1);
            imagettftext($im, 13, 0, $padX, $baseY + 22, self::col($im, '#9ca3af'), $font, $hint2);
        }

        ob_start();
        imagepng($im);
        $bin = ob_get_clean();
        imagedestroy($im);
        return $bin;
    }

    /**
     * 取得用于分享的模板配置
     *  - 指定 designId：直接使用该模板
     *  - 未指定：按帖子类型自动匹配（post_type 精确匹配 → 通用模板 → 默认模板 → 任意一个 → 内置兜底）
     * @param int    $designId 指定模板ID（0=按帖子类型自动选）
     * @param string $postType 帖子类型：image_text / video
     */
    public static function getDesignConfig(int $designId = 0, string $postType = ''): array
    {
        $row = null;
        if ($designId > 0) {
            $row = Db::name('poster_designs')->where('id', $designId)->where('status', 1)->find();
        } else {
            if ($postType !== '') {
                // 1) 类型精确匹配
                $row = Db::name('poster_designs')->where('post_type', $postType)->where('status', 1)->find();
                // 2) 通用模板（post_type 为空）
                if (!$row) {
                    $row = Db::name('poster_designs')->where('post_type', '')->where('status', 1)->find();
                }
            }
            // 3) 默认模板
            if (!$row) {
                $row = Db::name('poster_designs')->where('is_default', 1)->where('status', 1)->find();
            }
            // 4) 任意一个启用模板
            if (!$row) {
                $row = Db::name('poster_designs')->where('status', 1)->order('id', 'asc')->find();
            }
        }
        if (!$row) {
            return self::defaultConfig();
        }
        $cfg = json_decode((string) ($row['config'] ?? ''), true);
        if (!is_array($cfg)) {
            $cfg = [];
        }
        $cfg['type'] = $row['type'] ?? 'cover';
        return $cfg;
    }

    /**
     * 内置默认配置（无任何模板时也能正常出图）
     */
    public static function defaultConfig(): array
    {
        return [
            'type'           => 'cover',
            'width'          => 600,
            'height'         => 840,
            'bg_color'       => '#ffffff',
            'bg_image'       => '',
            'title'          => '',
            'title_color'    => '#1f2937',
            'title_size'     => 30,
            'content'        => '',
            'content_color'  => '#4b5563',
            'content_size'   => 18,
            'footer_text'    => '长按识别小程序码',
            'footer_color'   => '#9ca3af',
            'code_size'      => 160,
            'cover'          => '',
        ];
    }

    // ------------------------------------------------------------------
    // 内部工具
    // ------------------------------------------------------------------

    private static function fontPath(): string
    {
        $candidates = [
            public_path() . 'static/font/tencent.ttf',
            public_path() . 'static/font/NotoSansCJK.ttc',
            '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
            '/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',
            '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
            'C:\\Windows\\Fonts\\msyh.ttc',
            'C:\\Windows\\Fonts\\simhei.ttf',
        ];
        foreach ($candidates as $f) {
            if (is_file($f)) {
                return $f;
            }
        }
        return '';
    }

    private static function col($im, string $hex): int
    {
        [$r, $g, $b] = self::hex2rgb($hex);
        return imagecolorallocate($im, $r, $g, $b);
    }

    private static function hex2rgb(string $hex): array
    {
        $hex = ltrim($hex, '#');
        if (strlen($hex) === 3) {
            $hex = $hex[0] . $hex[0] . $hex[1] . $hex[1] . $hex[2] . $hex[2];
        }
        $int = hexdec($hex);
        return [($int >> 16) & 255, ($int >> 8) & 255, $int & 255];
    }

    /**
     * 加载图片（本地相对 public 的路径，或远程 URL），失败返回 null
     */
    private static function loadImage(string $path)
    {
        if ($path === '') {
            return null;
        }
        if (preg_match('/^https?:\/\//i', $path)) {
            $tmp = tempnam(sys_get_temp_dir(), 'pimg_');
            $ch  = curl_init($path);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT        => 15,
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_SSL_VERIFYHOST => 2,
                CURLOPT_FOLLOWLOCATION => true,
            ]);
            $bin = curl_exec($ch);
            curl_close($ch);
            if (!$bin) {
                return null;
            }
            file_put_contents($tmp, $bin);
            $path = $tmp;
        } else {
            $local = public_path() . ltrim($path, '/');
            if (!is_file($local)) {
                return null;
            }
            $path = $local;
        }

        $info = @getimagesize($path);
        if (!$info) {
            return null;
        }
        switch ($info[2]) {
            case IMAGETYPE_PNG:
                $im = imagecreatefrompng($path);
                break;
            case IMAGETYPE_JPEG:
                $im = imagecreatefromjpeg($path);
                break;
            case IMAGETYPE_WEBP:
                $im = imagecreatefromwebp($path);
                break;
            case IMAGETYPE_GIF:
                $im = imagecreatefromgif($path);
                break;
            default:
                return null;
        }
        return $im ?: null;
    }

    /**
     * 将源图等比裁剪填充到目标矩形
     */
    private static function coverFit($dst, $src, int $dx, int $dy, int $dw, int $dh): void
    {
        $sw = imagesx($src);
        $sh = imagesy($src);
        if ($sw <= 0 || $sh <= 0) {
            return;
        }
        $srcRatio = $sw / $sh;
        $dstRatio = $dw / $dh;
        if ($srcRatio > $dstRatio) {
            $nh = $sh;
            $nw = (int) ($sh * $dstRatio);
            $sx = (int) (($sw - $nw) / 2);
            $sy = 0;
        } else {
            $nw = $sw;
            $nh = (int) ($sw / $dstRatio);
            $sx = 0;
            $sy = (int) (($sh - $nh) / 2);
        }
        imagecopyresampled($dst, $src, $dx, $dy, $sx, $sy, $dw, $dh, $nw, $nh);
    }

    /**
     * 文字自动换行（CJK 逐字断行，拉丁文亦可）
     * @param int $maxLines 0=不限
     */
    private static function wrap(string $font, int $size, string $text, int $maxWidth, int $maxLines = 0): array
    {
        $lines = [];
        $cur   = '';
        $chars = preg_split('//u', $text, -1, PREG_SPLIT_NO_EMPTY);
        if ($chars === false) {
            $chars = str_split($text);
        }
        foreach ($chars as $ch) {
            $test = $cur . $ch;
            $box  = imagettfbbox($size, 0, $font, $test);
            $w    = $box[2] - $box[0];
            if ($w > $maxWidth && $cur !== '') {
                $lines[] = $cur;
                $cur     = $ch;
                if ($maxLines > 0 && count($lines) >= $maxLines) {
                    break;
                }
            } else {
                $cur = $test;
            }
        }
        if ($cur !== '' && ($maxLines === 0 || count($lines) < $maxLines)) {
            $lines[] = $cur;
        }
        // 超出则给最后一行加省略号
        if ($maxLines > 0 && count($lines) >= $maxLines) {
            $last = end($lines);
            if (mb_strlen($last, 'UTF-8') > 1) {
                $lines[count($lines) - 1] = mb_substr($last, 0, -1, 'UTF-8') . '…';
            }
        }
        return $lines;
    }

    /**
     * 填充圆角矩形
     */
    private static function roundRectFilled($im, int $x, int $y, int $w, int $h, int $r, int $color): void
    {
        $r = min($r, (int) ($w / 2), (int) ($h / 2));
        imagefilledrectangle($im, $x + $r, $y, $x + $w - $r, $y + $h, $color);
        imagefilledrectangle($im, $x, $y + $r, $x + $w, $y + $h - $r, $color);
        imagefilledellipse($im, $x + $r, $y + $r, $r * 2, $r * 2, $color);
        imagefilledellipse($im, $x + $w - $r, $y + $r, $r * 2, $r * 2, $color);
        imagefilledellipse($im, $x + $r, $y + $h - $r, $r * 2, $r * 2, $color);
        imagefilledellipse($im, $x + $w - $r, $y + $h - $r, $r * 2, $r * 2, $color);
    }

    /**
     * 获取微信小程序码二进制（透明 PNG）；失败返回 null
     */
    private static function fetchWxacode(string $path): ?string
    {
        try {
            $token = VirtualPayService::getAccessToken();
            $url   = 'https://api.weixin.qq.com/wxa/getwxacode?access_token=' . $token;
            $raw   = json_encode([
                'path'       => $path,
                'width'      => 430,
                'auto_color' => false,
                'line_color' => ['r' => 37, 'g' => 99, 'b' => 235],
                'is_hyaline' => true,
            ]);
            $ch = curl_init($url);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_POST           => true,
                CURLOPT_POSTFIELDS     => $raw,
                CURLOPT_HTTPHEADER     => ['Content-Type: application/json'],
                CURLOPT_TIMEOUT        => 10,
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_SSL_VERIFYHOST => 2,
            ]);
            $res = curl_exec($ch);
            curl_close($ch);
            if ($res === false || substr(trim($res), 0, 1) === '{') {
                return null;
            }
            return $res;
        } catch (\Throwable $e) {
            return null;
        }
    }
}
