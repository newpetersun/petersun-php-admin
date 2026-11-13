<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use app\service\PosterService;
use think\facade\Db;
use think\Request;
use think\Response;

/**
 * 海报设计（管理员）
 *  - 海报模板管理：列表 / 保存 / 删除 / 设默认
 *  - 预览：根据前端传入的 config 实时渲染（不取真实小程序码，用占位）
 */
class PosterAdmin extends BaseController
{
    public function list(): Response
    {
        $rows = Db::name('poster_designs')
            ->order('is_default', 'desc')
            ->order('id', 'desc')
            ->select()
            ->toArray();
        foreach ($rows as &$r) {
            $cfg       = json_decode((string) ($r['config'] ?? ''), true);
            $r['config'] = is_array($cfg) ? $cfg : new \stdClass();
        }
        return json(['code' => 200, 'message' => '获取成功', 'data' => $rows]);
    }

    public function save(Request $request): Response
    {
        try {
            $src   = $request->post();
            $id    = (int) ($src['id'] ?? 0);
            $type  = in_array(($src['type'] ?? 'cover'), ['cover', 'text'], true) ? $src['type'] : 'cover';
            $postType = (string) ($src['post_type'] ?? '');
            if (!in_array($postType, ['', 'image_text', 'video'], true)) {
                $postType = '';
            }
            $title = trim((string) ($src['title'] ?? ''));
            if ($title === '') {
                return json(['code' => 400, 'message' => '请填写模板名称']);
            }
            $config    = is_array($src['config'] ?? []) ? $src['config'] : [];
            $config['type'] = $type;
            $isDefault = (int) ($src['is_default'] ?? 0) === 1 ? 1 : 0;
            $status    = (int) ($src['status'] ?? 1) === 1 ? 1 : 0;

            $data = [
                'type'       => $type,
                'post_type'  => $postType,
                'title'      => $title,
                'config'     => json_encode($config, JSON_UNESCAPED_UNICODE),
                'is_default' => $isDefault,
                'status'     => $status,
                'update_time' => date('Y-m-d H:i:s'),
            ];

            if ($id > 0) {
                Db::name('poster_designs')->where('id', $id)->update($data);
            } else {
                $data['create_time'] = date('Y-m-d H:i:s');
                $id = Db::name('poster_designs')->insertGetId($data);
            }
            if ($isDefault) {
                Db::name('poster_designs')->where('id', '<>', $id)->update(['is_default' => 0]);
            }
            return json(['code' => 200, 'message' => '保存成功', 'data' => ['id' => $id]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    public function delete($id): Response
    {
        Db::name('poster_designs')->where('id', (int) $id)->delete();
        return json(['code' => 200, 'message' => '删除成功']);
    }

    public function setDefault($id): Response
    {
        $id = (int) $id;
        Db::name('poster_designs')->where('id', $id)->update(['is_default' => 1, 'update_time' => date('Y-m-d H:i:s')]);
        Db::name('poster_designs')->where('id', '<>', $id)->update(['is_default' => 0]);
        return json(['code' => 200, 'message' => '已设为默认模板']);
    }

    public function preview(Request $request): Response
    {
        try {
            $src   = $request->post();
            $config = is_array($src['config'] ?? []) ? $src['config'] : [];
            $type  = in_array(($config['type'] ?? 'cover'), ['cover', 'text'], true) ? $config['type'] : 'cover';
            $config['type'] = $type;
            $png = PosterService::render($config, null);
            return json(['code' => 200, 'data' => ['image' => 'data:image/png;base64,' . base64_encode($png)]]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '生成失败：' . $e->getMessage()]);
        }
    }
}
