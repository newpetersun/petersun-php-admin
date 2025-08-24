<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

class Project extends BaseController
{
    /**
     * 获取项目列表
     */
    public function list(Request $request): Response
    {
        try {
            $category = $request->param('category', '');
            $page = $request->param('page', 1);
            $limit = $request->param('limit', 10);
            
            $where = [];
            if (!empty($category) && $category !== 'all') {
                $where[] = ['category', '=', $category];
            }
            $where[] = ['status', '=', 1]; // 只显示已发布的项目
            
            $projects = Db::name('project')
                ->where($where)
                ->order('sort_order', 'asc')
                ->order('create_time', 'desc')
                ->paginate([
                    'list_rows' => $limit,
                    'page' => $page
                ]);
            
            $list = $projects->items();
            
            // 处理项目数据
            foreach ($list as &$project) {
                // 获取项目标签
                $tags = Db::name('project_tag')
                    ->alias('pt')
                    ->join('tag t', 'pt.tag_id = t.id')
                    ->where('pt.project_id', $project['id'])
                    ->column('t.name');
                $project['tags'] = $tags;
                
                // 获取项目技术栈
                $technologies = Db::name('project_technology')
                    ->alias('pt')
                    ->join('technology t', 'pt.technology_id = t.id')
                    ->where('pt.project_id', $project['id'])
                    ->column('t.name');
                $project['technologies'] = $technologies;
                
                // 获取项目所有图片
                $images = Db::name('project_images')
                    ->where('project_id', $project['id'])
                    ->order('sort_order', 'asc')
                    ->column('image_url');
                    
                // 如果有图片，覆盖单图字段为数组，否则使用当前封面图构建数组
                if (!empty($images)) {
                    $project['image'] = $images;
                } else if (!empty($project['image'])) {
                    $project['image'] = [$project['image']];
                } else {
                    $project['image'] = [];
                }
                
                // 格式化时间
                $project['create_time'] = date('Y-m-d', strtotime($project['create_time']));
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'list' => $list,
                    'total' => $projects->total(),
                    'page' => $page,
                    'limit' => $limit
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取项目详情
     */
    public function detail($id): Response
    {
        try {
            $project = Db::name('project')->where('id', $id)->find();
            
            if (!$project) {
                return json(['code' => 404, 'message' => '项目不存在']);
            }
            
            // 获取项目标签
            $tags = Db::name('project_tag')
                ->alias('pt')
                ->join('tag t', 'pt.tag_id = t.id')
                ->where('pt.project_id', $id)
                ->column('t.name');
            
            // 获取项目技术栈
            $technologies = Db::name('project_technology')
                ->alias('pt')
                ->join('technology t', 'pt.technology_id = t.id')
                ->where('pt.project_id', $id)
                ->column('t.name');
            
            // 获取项目功能特性
            $features = explode(',', $project['features']);
            $features = array_filter($features); // 移除空值
            
            // 获取项目图片
            $images = Db::name('project_images')
                ->where('project_id', $id)
                ->order('sort_order', 'asc')
                ->column('image_url');
            
            $project['tags'] = $tags;
            $project['technologies'] = $technologies;
            $project['features'] = $features;
            $project['images'] = $images; // 添加图片数组
            $project['create_time'] = date('Y-m-d', strtotime($project['create_time']));
            
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
     * 获取项目分类
     */
    public function categories(): Response
    {
        try {
            $categories = Db::name('project_category')
                ->where('status', 1)
                ->order('sort_order', 'asc')
                ->select()
                ->toArray();
            
            // 添加"全部"选项
            array_unshift($categories, [
                'id' => 0,
                'key' => 'all',
                'name' => '全部',
                'status' => 1
            ]);
            
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
     * 获取首页推荐项目
     */
    public function featured(): Response
    {
        try {
            $projects = Db::name('project')
                ->where('status', 1)
                ->where('is_featured', 1)
                ->order('sort_order', 'asc')
                ->limit(6)
                ->select()
                ->toArray();
            
            // 处理项目数据
            foreach ($projects as &$project) {
                // 获取项目标签
                $tags = Db::name('project_tag')
                    ->alias('pt')
                    ->join('tag t', 'pt.tag_id = t.id')
                    ->where('pt.project_id', $project['id'])
                    ->column('t.name');
                $project['tags'] = $tags;
            }
            
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
     * 创建项目
     */
    public function create(Request $request): Response
    {
        try {
            $data = $request->only([
                'title', 'description', 'full_description', 'image', 'images', 'category_id',
                'tags', 'technologies', 'features', 'sort_order', 'is_featured'
            ]);
            
            // 验证必填字段
            if (empty($data['title']) || empty($data['description'])) {
                return json(['code' => 400, 'message' => '项目标题和描述不能为空']);
            }
            
            // 验证图片
            if (empty($data['image'])) {
                return json(['code' => 400, 'message' => '项目图片不能为空']);
            }
            
            Db::startTrans();
            try {
                // 创建项目
                $projectData = [
                    'title' => $data['title'],
                    'description' => $data['description'],
                    'full_description' => $data['full_description'] ?? '',
                    'image' => $data['image'] ?? '',
                    'category_id' => $data['category_id'] ?? 1,
                    'features' => is_array($data['features']) ? implode(',', $data['features']) : '',
                    'sort_order' => $data['sort_order'] ?? 0,
                    'is_featured' => $data['is_featured'] ?? 0,
                    'status' => 1,
                    'create_time' => date('Y-m-d H:i:s')
                ];
                
                $projectId = Db::name('project')->insertGetId($projectData);
                
                // 处理多图片
                if (!empty($data['images']) && is_array($data['images'])) {
                    $sortOrder = 0;
                    foreach ($data['images'] as $imageUrl) {
                        Db::name('project_images')->insert([
                            'project_id' => $projectId,
                            'image_url' => $imageUrl,
                            'sort_order' => $sortOrder++,
                            'create_time' => date('Y-m-d H:i:s')
                        ]);
                    }
                }
                
                // 处理标签关联
                if (!empty($data['tags']) && is_array($data['tags'])) {
                    foreach ($data['tags'] as $tagName) {
                        $tagId = $this->getOrCreateTag($tagName);
                        Db::name('project_tag')->insert([
                            'project_id' => $projectId,
                            'tag_id' => $tagId
                        ]);
                    }
                }
                
                // 处理技术栈关联
                if (!empty($data['technologies']) && is_array($data['technologies'])) {
                    foreach ($data['technologies'] as $techName) {
                        $techId = $this->getOrCreateTechnology($techName);
                        Db::name('project_technology')->insert([
                            'project_id' => $projectId,
                            'technology_id' => $techId
                        ]);
                    }
                }
                
                Db::commit();
                return json(['code' => 200, 'message' => '创建成功']);
            } catch (\Exception $e) {
                Db::rollback();
                throw $e;
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新项目
     */
    public function update(Request $request, $id): Response
    {
        try {
            $data = $request->only([
                'title', 'description', 'full_description', 'image', 'images', 'category_id',
                'tags', 'technologies', 'features', 'sort_order', 'is_featured'
            ]);
            
            // 验证必填字段
            if (empty($data['title']) || empty($data['description'])) {
                return json(['code' => 400, 'message' => '项目标题和描述不能为空']);
            }
            
            // 验证图片
            if (empty($data['image'])) {
                return json(['code' => 400, 'message' => '项目图片不能为空']);
            }
            
            Db::startTrans();
            try {
                // 更新项目
                $projectData = [
                    'title' => $data['title'],
                    'description' => $data['description'],
                    'full_description' => $data['full_description'] ?? '',
                    'image' => $data['image'] ?? '',
                    'category_id' => $data['category_id'] ?? 1,
                    'features' => is_array($data['features']) ? implode(',', $data['features']) : '',
                    'sort_order' => $data['sort_order'] ?? 0,
                    'is_featured' => $data['is_featured'] ?? 0,
                    'update_time' => date('Y-m-d H:i:s')
                ];
                
                Db::name('project')->where('id', $id)->update($projectData);
                
                // 处理多图片 - 先删除原有图片
                Db::name('project_images')->where('project_id', $id)->delete();
                if (!empty($data['images']) && is_array($data['images'])) {
                    $sortOrder = 0;
                    foreach ($data['images'] as $imageUrl) {
                        Db::name('project_images')->insert([
                            'project_id' => $id,
                            'image_url' => $imageUrl,
                            'sort_order' => $sortOrder++,
                            'create_time' => date('Y-m-d H:i:s')
                        ]);
                    }
                }
                
                // 删除旧的标签和技术栈关联
                Db::name('project_tag')->where('project_id', $id)->delete();
                Db::name('project_technology')->where('project_id', $id)->delete();
                
                // 处理标签关联
                if (!empty($data['tags']) && is_array($data['tags'])) {
                    foreach ($data['tags'] as $tagName) {
                        $tagId = $this->getOrCreateTag($tagName);
                        Db::name('project_tag')->insert([
                            'project_id' => $id,
                            'tag_id' => $tagId
                        ]);
                    }
                }
                
                // 处理技术栈关联
                if (!empty($data['technologies']) && is_array($data['technologies'])) {
                    foreach ($data['technologies'] as $techName) {
                        $techId = $this->getOrCreateTechnology($techName);
                        Db::name('project_technology')->insert([
                            'project_id' => $id,
                            'technology_id' => $techId
                        ]);
                    }
                }
                
                Db::commit();
                return json(['code' => 200, 'message' => '更新成功']);
            } catch (\Exception $e) {
                Db::rollback();
                throw $e;
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除项目
     */
    public function delete($id): Response
    {
        try {
            Db::startTrans();
            try {
                // 删除项目关联数据
                Db::name('project_tag')->where('project_id', $id)->delete();
                Db::name('project_technology')->where('project_id', $id)->delete();
                Db::name('project_images')->where('project_id', $id)->delete();
                
                // 删除项目
                Db::name('project')->where('id', $id)->delete();
                
                Db::commit();
                return json(['code' => 200, 'message' => '删除成功']);
            } catch (\Exception $e) {
                Db::rollback();
                throw $e;
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新项目状态
     */
    public function updateStatus(Request $request, $id): Response
    {
        try {
            $status = $request->param('status', 1);
            
            $result = Db::name('project')->where('id', $id)->update(['status' => $status]);
            
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
     * 更新项目状态（API路径 /project/status 对应的方法）
     */
    public function status(Request $request, $id): Response
    {
        // 调用已实现的updateStatus方法
        return $this->updateStatus($request, $id);
    }

    /**
     * 获取或创建标签
     */
    private function getOrCreateTag($tagName)
    {
        $tag = Db::name('tag')->where('name', $tagName)->find();
        if ($tag) {
            return $tag['id'];
        }
        
        return Db::name('tag')->insertGetId([
            'name' => $tagName,
            'create_time' => date('Y-m-d H:i:s')
        ]);
    }

    /**
     * 上传项目图片
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
                'fileSize' => 5 * 1024 * 1024, // 5MB限制
                'fileExt' => 'jpg,jpeg,png,gif,webp',
                'fileMime' => 'image/jpeg,image/png,image/gif,image/webp'
            ]]);

            if (!$validate->check(['image' => $file])) {
                return json(['code' => 400, 'message' => $validate->getError()]);
            }

            // 保存到项目图片目录
            $savePath = '/static/images/projects/';
            $fileName = 'project_' . uniqid() . '.' . $file->getOriginalExtension();
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

    /**
     * 获取或创建技术栈
     */
    private function getOrCreateTechnology($techName)
    {
        $tech = Db::name('technology')->where('name', $techName)->find();
        if ($tech) {
            return $tech['id'];
        }
        
        return Db::name('technology')->insertGetId([
            'name' => $techName,
            'create_time' => date('Y-m-d H:i:s')
        ]);
    }
} 