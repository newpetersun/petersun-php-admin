<?php
declare (strict_types = 1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\Response;
use think\facade\Db;

class Project extends BaseController
{
    /**
     * 获取项目列表
     */
    public function list(Request $request)
    {
        try {
            $category = $request->param('category', '');
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 10);
            
            $where = [];
            if ($category) {
                $where[] = ['category', '=', $category];
            }
            
            $projects = Db::name('project')
                ->where($where)
                ->order('sort_order', 'asc')
                ->order('id', 'desc')
                ->paginate([
                    'list_rows' => $limit,
                    'page' => $page
                ]);
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $projects
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取项目详情
     */
    public function detail($id)
    {
        try {
            $project = Db::name('project')->where('id', $id)->find();
            
            if (!$project) {
                return json(['code' => 404, 'message' => '项目不存在']);
            }
            
            // 获取项目标签
            $tags = Db::name('project_tag')->where('project_id', $id)->column('tag_name');
            $project['tags'] = $tags;
            
            // 获取项目技术栈
            $technologies = Db::name('project_technology')->where('project_id', $id)->column('tech_name');
            $project['technologies'] = $technologies;
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $project
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 创建项目
     */
    public function create(Request $request)
    {
        try {
            $data = $request->only([
                'title', 'description', 'full_description', 'image', 
                'category', 'sort_order', 'status'
            ]);
            
            Db::startTrans();
            
            $projectId = Db::name('project')->insertGetId($data);
            
            // 保存标签
            $tags = $request->param('tags', []);
            foreach ($tags as $tag) {
                Db::name('project_tag')->insert([
                    'project_id' => $projectId,
                    'tag_name' => $tag
                ]);
            }
            
            // 保存技术栈
            $technologies = $request->param('technologies', []);
            foreach ($technologies as $tech) {
                Db::name('project_technology')->insert([
                    'project_id' => $projectId,
                    'tech_name' => $tech
                ]);
            }
            
            Db::commit();
            
            return json(['code' => 200, 'message' => '创建成功']);
        } catch (\Exception $e) {
            Db::rollback();
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新项目
     */
    public function update(Request $request, $id)
    {
        try {
            $data = $request->only([
                'title', 'description', 'full_description', 'image', 
                'category', 'sort_order', 'status'
            ]);
            
            Db::startTrans();
            
            Db::name('project')->where('id', $id)->update($data);
            
            // 更新标签
            $tags = $request->param('tags', []);
            Db::name('project_tag')->where('project_id', $id)->delete();
            foreach ($tags as $tag) {
                Db::name('project_tag')->insert([
                    'project_id' => $id,
                    'tag_name' => $tag
                ]);
            }
            
            // 更新技术栈
            $technologies = $request->param('technologies', []);
            Db::name('project_technology')->where('project_id', $id)->delete();
            foreach ($technologies as $tech) {
                Db::name('project_technology')->insert([
                    'project_id' => $id,
                    'tech_name' => $tech
                ]);
            }
            
            Db::commit();
            
            return json(['code' => 200, 'message' => '更新成功']);
        } catch (\Exception $e) {
            Db::rollback();
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除项目
     */
    public function delete($id)
    {
        try {
            Db::startTrans();
            
            Db::name('project')->where('id', $id)->delete();
            Db::name('project_tag')->where('project_id', $id)->delete();
            Db::name('project_technology')->where('project_id', $id)->delete();
            
            Db::commit();
            
            return json(['code' => 200, 'message' => '删除成功']);
        } catch (\Exception $e) {
            Db::rollback();
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取项目分类
     */
    public function categories()
    {
        try {
            $categories = Db::name('project_category')->order('sort_order', 'asc')->select();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $categories
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
} 