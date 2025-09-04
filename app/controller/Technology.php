<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

class Technology extends BaseController
{
    /**
     * 获取技术列表
     */
    public function list(Request $request): Response
    {
        try {
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 100);
            $category = $request->param('category', '');
            $status = $request->param('status', '');
            
            $where = [];
            if ($category !== '') {
                $where[] = ['category', '=', $category];
            }
            if ($status !== '') {
                $where[] = ['status', '=', $status];
            }
            
            $technologies = Db::name('technology')
                ->where($where)
                ->order('id', 'asc')
                ->paginate([
                    'list_rows' => $limit,
                    'page' => $page
                ]);
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list' => $technologies->items(),
                    'total' => $technologies->total(),
                    'page' => $technologies->currentPage(),
                    'limit' => $technologies->listRows()
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取技术详情
     */
    public function detail(int $id): Response
    {
        try {
            $technology = Db::name('technology')->where('id', $id)->find();
            
            if (!$technology) {
                return json(['code' => 404, 'message' => '技术不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $technology
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 创建技术
     */
    public function create(Request $request): Response
    {
        try {
            $data = $request->only(['name', 'img', 'sort_order', 'status']);
            
            // 验证必填字段
            if (empty($data['name'])) {
                return json(['code' => 400, 'message' => '技术名称不能为空']);
            }
            
            // 检查技术名称是否已存在
            $exists = Db::name('technology')->where('name', $data['name'])->find();
            if ($exists) {
                return json(['code' => 400, 'message' => '技术名称已存在']);
            }
            
            // 设置默认值
            $data['sort_order'] = $data['sort_order'] ?? 0;
            $data['status'] = $data['status'] ?? 1;
            $data['create_time'] = date('Y-m-d H:i:s');
            $data['update_time'] = date('Y-m-d H:i:s');
            
            $id = Db::name('technology')->insertGetId($data);
            
            if ($id) {
                // 返回创建的技术信息
                $technology = Db::name('technology')->where('id', $id)->find();
                return json([
                    'code' => 200,
                    'message' => '创建成功',
                    'data' => $technology
                ]);
            } else {
                return json(['code' => 500, 'message' => '创建失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新技术
     */
    public function update(int $id, Request $request): Response
    {
        try {
            $data = $request->only(['name', 'category', 'img', 'sort_order', 'status']);
            
            // 检查技术是否存在
            $technology = Db::name('technology')->where('id', $id)->find();
            if (!$technology) {
                return json(['code' => 404, 'message' => '技术不存在']);
            }
            
            // 验证必填字段
            if (empty($data['name'])) {
                return json(['code' => 400, 'message' => '技术名称不能为空']);
            }
            
            // 检查技术名称是否已存在（排除当前记录）
            $exists = Db::name('technology')
                ->where('name', $data['name'])
                ->where('id', '<>', $id)
                ->find();
            if ($exists) {
                return json(['code' => 400, 'message' => '技术名称已存在']);
            }
            
            // 设置更新时间
            $data['update_time'] = date('Y-m-d H:i:s');
            
            $result = Db::name('technology')->where('id', $id)->update($data);
            
            if ($result !== false) {
                // 返回更新后的技术信息
                $updatedTechnology = Db::name('technology')->where('id', $id)->find();
                return json([
                    'code' => 200,
                    'message' => '更新成功',
                    'data' => $updatedTechnology
                ]);
            } else {
                return json(['code' => 500, 'message' => '更新失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除技术
     */
    public function delete(int $id): Response
    {
        try {
            // 检查技术是否存在
            $technology = Db::name('technology')->where('id', $id)->find();
            if (!$technology) {
                return json(['code' => 404, 'message' => '技术不存在']);
            }
            
            $result = Db::name('technology')->where('id', $id)->delete();
            
            if ($result) {
                return json(['code' => 200, 'message' => '删除成功']);
            } else {
                return json(['code' => 500, 'message' => '删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新技术状态
     */
    public function status(int $id, Request $request): Response
    {
        try {
            $status = $request->param('status');
            
            // 检查技术是否存在
            $technology = Db::name('technology')->where('id', $id)->find();
            if (!$technology) {
                return json(['code' => 404, 'message' => '技术不存在']);
            }
            
            // 验证状态值
            if (!in_array($status, [0, 1])) {
                return json(['code' => 400, 'message' => '状态值无效']);
            }
            
            $result = Db::name('technology')
                ->where('id', $id)
                ->update([
                    'status' => $status,
                    'update_time' => date('Y-m-d H:i:s')
                ]);
            
            if ($result !== false) {
                return json(['code' => 200, 'message' => '状态更新成功']);
            } else {
                return json(['code' => 500, 'message' => '状态更新失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取技术分类列表
     */
    public function categories(): Response
    {
        try {
            $categories = Db::name('technology')
                ->field('category')
                ->where('category', '<>', '')
                ->group('category')
                ->column('category');
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $categories
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 批量删除技术
     */
    public function batchDelete(Request $request): Response
    {
        try {
            $ids = $request->param('ids');
            
            if (empty($ids) || !is_array($ids)) {
                return json(['code' => 400, 'message' => '请选择要删除的技术']);
            }
            
            $result = Db::name('technology')->whereIn('id', $ids)->delete();
            
            if ($result) {
                return json(['code' => 200, 'message' => '批量删除成功']);
            } else {
                return json(['code' => 500, 'message' => '批量删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 批量更新技术状态
     */
    public function batchStatus(Request $request): Response
    {
        try {
            $ids = $request->param('ids');
            $status = $request->param('status');
            
            if (empty($ids) || !is_array($ids)) {
                return json(['code' => 400, 'message' => '请选择要更新的技术']);
            }
            
            if (!in_array($status, [0, 1])) {
                return json(['code' => 400, 'message' => '状态值无效']);
            }
            
            $result = Db::name('technology')
                ->whereIn('id', $ids)
                ->update([
                    'status' => $status,
                    'update_time' => date('Y-m-d H:i:s')
                ]);
            
            if ($result !== false) {
                return json(['code' => 200, 'message' => '批量状态更新成功']);
            } else {
                return json(['code' => 500, 'message' => '批量状态更新失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 上传技术图标
     */
    public function uploadImage(Request $request): Response
    {
        try {
            $file = $request->file('image');
            if (!$file) {
                return json(['code' => 400, 'message' => '未上传文件']);
            }

            // 检查是否是图片
            $validate = validate(['image' => [
                'fileSize' => 2 * 1024 * 1024, // 2MB限制
                'fileExt' => 'jpg,jpeg,png,gif,webp',
                'fileMime' => 'image/jpeg,image/png,image/gif,image/webp'
            ]]);

            if (!$validate->check(['image' => $file])) {
                return json(['code' => 400, 'message' => $validate->getError()]);
            }

            // 保存到技术图标目录
            $savePath = '/static/images/exp/';
            $fileName = 'tech_' . uniqid() . '.' . $file->getOriginalExtension();
            $info = $file->move(public_path() . $savePath, $fileName);
            
            if ($info) {
                $url = $savePath . $fileName;
                return json([
                    'code' => 200, 
                    'message' => '上传成功', 
                    'data' => [
                        'url' => $url,
                        'name' => $fileName,
                        'original_name' => $file->getOriginalName()
                    ]
                ]);
            } else {
                return json(['code' => 500, 'message' => $file->getError()]);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
