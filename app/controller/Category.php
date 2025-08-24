<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

class Category extends BaseController
{
    /**
     * 获取项目分类列表
     */
    public function list(Request $request): Response
    {
        try {
            $keyword = $request->param('keyword', '');
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 10);
            
            $where = [];
            if (!empty($keyword)) {
                $where[] = ['name|description', 'like', "%$keyword%"];
            }
            
            $categories = Db::name('project_category')
                ->where($where)
                ->order('sort_order', 'asc')
                ->paginate([
                    'list_rows' => $limit,
                    'page' => $page
                ]);
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list' => $categories->items(),
                    'total' => $categories->total(),
                    'page' => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 获取所有可用的分类（不分页）
     */
    public function all(): Response
    {
        try {
            $categories = Db::name('project_category')
                ->where('status', 1)
                ->order('sort_order', 'asc')
                ->select()
                ->toArray();
            
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
     * 添加分类
     */
    public function create(Request $request): Response
    {
        try {
            $data = $request->only(['name', 'key', 'description', 'icon', 'sort_order', 'status']);
            
            // 验证必填字段
            if (empty($data['name']) || empty($data['key'])) {
                return json(['code' => 400, 'message' => '分类名称和标识不能为空']);
            }
            
            // 检查key是否已存在
            $exists = Db::name('project_category')->where('key', $data['key'])->find();
            if ($exists) {
                return json(['code' => 400, 'message' => '分类标识已存在']);
            }
            
            // 设置默认值
            $data['sort_order'] = $data['sort_order'] ?? 0;
            $data['status'] = isset($data['status']) ? (int)$data['status'] : 1;
            
            $id = Db::name('project_category')->insertGetId($data);
            
            return json([
                'code' => 200,
                'message' => '添加成功',
                'data' => ['id' => $id]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 更新分类
     */
    public function update(Request $request, $id): Response
    {
        try {
            $data = $request->only(['name', 'key', 'description', 'icon', 'sort_order', 'status']);
            
            // 验证必填字段
            if (empty($data['name']) || empty($data['key'])) {
                return json(['code' => 400, 'message' => '分类名称和标识不能为空']);
            }
            
            // 检查key是否已存在（除了当前记录）
            $exists = Db::name('project_category')
                ->where('key', $data['key'])
                ->where('id', '<>', $id)
                ->find();
                
            if ($exists) {
                return json(['code' => 400, 'message' => '分类标识已存在']);
            }
            
            Db::name('project_category')->where('id', $id)->update($data);
            
            return json([
                'code' => 200,
                'message' => '更新成功'
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 删除分类
     */
    public function delete($id): Response
    {
        try {
            // 检查是否有项目使用此分类
            $count = Db::name('project')->where('category_id', $id)->count();
            if ($count > 0) {
                return json(['code' => 400, 'message' => '该分类下有' . $count . '个项目，无法删除']);
            }
            
            Db::name('project_category')->where('id', $id)->delete();
            
            return json([
                'code' => 200,
                'message' => '删除成功'
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 获取分类详情
     */
    public function detail($id): Response
    {
        try {
            $category = Db::name('project_category')->where('id', $id)->find();
            
            if (!$category) {
                return json(['code' => 404, 'message' => '分类不存在']);
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $category
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
    
    /**
     * 更新分类状态
     */
    public function status(Request $request, $id): Response
    {
        try {
            $status = $request->param('status', 0);
            
            Db::name('project_category')->where('id', $id)->update(['status' => (int)$status]);
            
            return json([
                'code' => 200,
                'message' => '状态更新成功'
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}