<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

/**
 * 项目进度管理控制器
 */
class Progress extends BaseController
{
    /**
     * 获取项目需求列表
     */
    public function getRequirements(Request $request): Response
    {
        try {
            $projectId = $request->param('project_id');
            
            if (!$projectId) {
                return json(['code' => 400, 'message' => '项目ID不能为空']);
            }
            
            // 验证项目是否存在
            $project = Db::name('project')->where('id', $projectId)->find();
            if (!$project) {
                return json(['code' => 404, 'message' => '项目不存在']);
            }
            
            // 获取需求列表
            $requirements = Db::name('project_requirements')
                ->where('project_id', $projectId)
                ->order('create_time', 'desc')
                ->select()
                ->toArray();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $requirements
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 创建需求
     */
    public function createRequirement(Request $request): Response
    {
        try {
            $data = $request->post();
            
            // 验证必填字段
            if (empty($data['project_id']) || empty($data['title']) || empty($data['description'])) {
                return json(['code' => 400, 'message' => '项目ID、需求标题和描述不能为空']);
            }
            
            // 验证项目是否存在
            $project = Db::name('project')->where('id', $data['project_id'])->find();
            if (!$project) {
                return json(['code' => 404, 'message' => '项目不存在']);
            }
            
            // 验证状态
            $validStatuses = ['pending', 'progress', 'completed'];
            if (!empty($data['status']) && !in_array($data['status'], $validStatuses)) {
                return json(['code' => 400, 'message' => '无效的状态值']);
            }
            
            // 准备插入数据
            $insertData = [
                'project_id' => $data['project_id'],
                'title' => trim($data['title']),
                'description' => trim($data['description']),
                'status' => $data['status'] ?? 'pending',
                'priority' => $data['priority'] ?? 'medium',
                'estimated_hours' => $data['estimated_hours'] ?? null,
                'assignee' => $data['assignee'] ?? null,
                'assignee_id' => $data['assignee_id'] ?? null,
                'template_id' => $data['template_id'] ?? null,
                'create_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s')
            ];
            
            // 插入数据
            $requirementId = Db::name('project_requirements')->insertGetId($insertData);
            
            if ($requirementId) {
                return json([
                    'code' => 200,
                    'message' => '需求创建成功',
                    'data' => ['id' => $requirementId]
                ]);
            } else {
                return json(['code' => 500, 'message' => '需求创建失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新需求
     */
    public function updateRequirement(Request $request): Response
    {
        try {
            $id = $request->param('id');
            $data = $request->post();
            
            if (!$id) {
                return json(['code' => 400, 'message' => '需求ID不能为空']);
            }
            
            // 验证需求是否存在
            $requirement = Db::name('project_requirements')->where('id', $id)->find();
            if (!$requirement) {
                return json(['code' => 404, 'message' => '需求不存在']);
            }
            
            // 验证必填字段
            if (empty($data['title']) || empty($data['description'])) {
                return json(['code' => 400, 'message' => '需求标题和描述不能为空']);
            }
            
            // 验证状态
            $validStatuses = ['pending', 'progress', 'completed'];
            if (!empty($data['status']) && !in_array($data['status'], $validStatuses)) {
                return json(['code' => 400, 'message' => '无效的状态值']);
            }
            
            // 准备更新数据
            $updateData = [
                'title' => trim($data['title']),
                'description' => trim($data['description']),
                'update_time' => date('Y-m-d H:i:s')
            ];
            
            // 如果提供了状态，则更新状态
            if (!empty($data['status'])) {
                $updateData['status'] = $data['status'];
            }
            
            // 如果提供了优先级，则更新优先级
            if (isset($data['priority'])) {
                $updateData['priority'] = $data['priority'];
            }
            
            // 如果提供了预估工时，则更新预估工时
            if (isset($data['estimated_hours'])) {
                $updateData['estimated_hours'] = $data['estimated_hours'];
            }
            
            // 如果提供了负责人，则更新负责人
            if (isset($data['assignee'])) {
                $updateData['assignee'] = $data['assignee'];
            }
            
            // 如果提供了负责人ID，则更新负责人ID
            if (isset($data['assignee_id'])) {
                $updateData['assignee_id'] = $data['assignee_id'];
            }
            
            // 如果提供了模板ID，则更新模板ID
            if (isset($data['template_id'])) {
                $updateData['template_id'] = $data['template_id'];
            }
            
            // 更新数据
            $result = Db::name('project_requirements')
                ->where('id', $id)
                ->update($updateData);
            
            if ($result !== false) {
                return json([
                    'code' => 200,
                    'message' => '需求更新成功'
                ]);
            } else {
                return json(['code' => 500, 'message' => '需求更新失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除需求
     */
    public function deleteRequirement(Request $request): Response
    {
        try {
            $id = $request->param('id');
            
            if (!$id) {
                return json(['code' => 400, 'message' => '需求ID不能为空']);
            }
            
            // 验证需求是否存在
            $requirement = Db::name('project_requirements')->where('id', $id)->find();
            if (!$requirement) {
                return json(['code' => 404, 'message' => '需求不存在']);
            }
            
            // 删除需求
            $result = Db::name('project_requirements')->where('id', $id)->delete();
            
            if ($result) {
                return json([
                    'code' => 200,
                    'message' => '需求删除成功'
                ]);
            } else {
                return json(['code' => 500, 'message' => '需求删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取需求统计
     */
    public function getRequirementStats(Request $request): Response
    {
        try {
            $projectId = $request->param('project_id');
            
            if (!$projectId) {
                return json(['code' => 400, 'message' => '项目ID不能为空']);
            }
            
            // 验证项目是否存在
            $project = Db::name('project')->where('id', $projectId)->find();
            if (!$project) {
                return json(['code' => 404, 'message' => '项目不存在']);
            }
            
            // 统计各状态的需求数量
            $stats = Db::name('project_requirements')
                ->where('project_id', $projectId)
                ->field('status, count(*) as count')
                ->group('status')
                ->select()
                ->toArray();
            
            // 格式化统计数据
            $result = [
                'pending' => 0,
                'progress' => 0,
                'completed' => 0,
                'total' => 0
            ];
            
            foreach ($stats as $stat) {
                $result[$stat['status']] = (int)$stat['count'];
                $result['total'] += (int)$stat['count'];
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $result
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取需求模板列表
     */
    public function getTemplates(): Response
    {
        try {
            $templates = Db::name('requirement_templates')
                ->order('usage_count', 'desc')
                ->order('create_time', 'desc')
                ->select()
                ->toArray();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $templates
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取工程师列表
     */
    /**
     * 获取工程师列表
     * 更新：使用统一的 users 表
     */
    public function getEngineers(): Response
    {
        try {
            $engineers = Db::name('users')
                ->where('is_engineer', 1)
                ->field('id, nickname, avatar')
                ->order('nickname asc')
                ->select()
                ->toArray();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $engineers
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 创建需求模板
     */
    public function createTemplate(Request $request): Response
    {
        try {
            $data = $request->post();
            
            // 验证必填字段
            if (empty($data['name']) || empty($data['title_template']) || empty($data['description_template'])) {
                return json(['code' => 400, 'message' => '模板名称、标题模板和描述模板不能为空']);
            }
            
            // 准备插入数据
            $insertData = [
                'name' => trim($data['name']),
                'title_template' => trim($data['title_template']),
                'description_template' => trim($data['description_template']),
                'category' => $data['category'] ?? '',
                'is_system' => 0,
                'usage_count' => 0,
                'create_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s')
            ];
            
            // 插入数据
            $templateId = Db::name('requirement_templates')->insertGetId($insertData);
            
            if ($templateId) {
                return json([
                    'code' => 200,
                    'message' => '模板创建成功',
                    'data' => ['id' => $templateId]
                ]);
            } else {
                return json(['code' => 500, 'message' => '模板创建失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取需求详情（包含附件和评论）
     */
    public function getRequirementDetail(Request $request): Response
    {
        try {
            $id = $request->param('id');
            
            if (!$id) {
                return json(['code' => 400, 'message' => '需求ID不能为空']);
            }
            
            // 获取需求基本信息
            $requirement = Db::name('project_requirements')->where('id', $id)->find();
            if (!$requirement) {
                return json(['code' => 404, 'message' => '需求不存在']);
            }
            
            // 获取附件
            $attachments = Db::name('requirement_attachments')
                ->where('requirement_id', $id)
                ->order('create_time', 'desc')
                ->select()
                ->toArray();
            
            // 获取评论
            $comments = Db::name('requirement_comments')
                ->where('requirement_id', $id)
                ->where('parent_id', null)
                ->order('create_time', 'asc')
                ->select()
                ->toArray();
            
            // 获取子评论
            foreach ($comments as &$comment) {
                $comment['replies'] = Db::name('requirement_comments')
                    ->where('parent_id', $comment['id'])
                    ->order('create_time', 'asc')
                    ->select()
                    ->toArray();
            }
            
            // 获取工时记录
            $timeLogs = Db::name('requirement_time_logs')
                ->where('requirement_id', $id)
                ->order('log_date', 'desc')
                ->select()
                ->toArray();
            
            $requirement['attachments'] = $attachments;
            $requirement['comments'] = $comments;
            $requirement['time_logs'] = $timeLogs;
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $requirement
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 添加工时记录
     */
    public function addTimeLog(Request $request): Response
    {
        try {
            $data = $request->post();
            
            // 验证必填字段
            if (empty($data['requirement_id']) || empty($data['hours']) || empty($data['log_date'])) {
                return json(['code' => 400, 'message' => '需求ID、工时和日期不能为空']);
            }
            
            // 验证需求是否存在
            $requirement = Db::name('project_requirements')->where('id', $data['requirement_id'])->find();
            if (!$requirement) {
                return json(['code' => 404, 'message' => '需求不存在']);
            }
            
            // 准备插入数据
            $insertData = [
                'requirement_id' => $data['requirement_id'],
                'user_name' => $data['user_name'] ?? 'PeterSun',
                'hours' => $data['hours'],
                'description' => $data['description'] ?? '',
                'log_date' => $data['log_date'],
                'create_time' => date('Y-m-d H:i:s')
            ];
            
            // 插入数据
            $logId = Db::name('requirement_time_logs')->insertGetId($insertData);
            
            if ($logId) {
                // 更新需求的实际工时
                $totalHours = Db::name('requirement_time_logs')
                    ->where('requirement_id', $data['requirement_id'])
                    ->sum('hours');
                
                Db::name('project_requirements')
                    ->where('id', $data['requirement_id'])
                    ->update(['actual_hours' => $totalHours]);
                
                return json([
                    'code' => 200,
                    'message' => '工时记录添加成功',
                    'data' => ['id' => $logId, 'total_hours' => $totalHours]
                ]);
            } else {
                return json(['code' => 500, 'message' => '工时记录添加失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 添加评论
     */
    public function addComment(Request $request): Response
    {
        try {
            $data = $request->post();
            
            // 验证必填字段
            if (empty($data['requirement_id']) || empty($data['content'])) {
                return json(['code' => 400, 'message' => '需求ID和评论内容不能为空']);
            }
            
            // 验证需求是否存在
            $requirement = Db::name('project_requirements')->where('id', $data['requirement_id'])->find();
            if (!$requirement) {
                return json(['code' => 404, 'message' => '需求不存在']);
            }
            
            // 准备插入数据
            $insertData = [
                'requirement_id' => $data['requirement_id'],
                'parent_id' => $data['parent_id'] ?? null,
                'content' => trim($data['content']),
                'author' => $data['author'] ?? 'PeterSun',
                'author_avatar' => $data['author_avatar'] ?? '/static/images/peter.jpg',
                'is_system' => $data['is_system'] ?? 0,
                'create_time' => date('Y-m-d H:i:s'),
                'update_time' => date('Y-m-d H:i:s')
            ];
            
            // 插入数据
            $commentId = Db::name('requirement_comments')->insertGetId($insertData);
            
            if ($commentId) {
                return json([
                    'code' => 200,
                    'message' => '评论添加成功',
                    'data' => ['id' => $commentId]
                ]);
            } else {
                return json(['code' => 500, 'message' => '评论添加失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 上传附件
     */
    public function uploadAttachment(Request $request): Response
    {
        try {
            $requirementId = $request->param('requirement_id');
            
            if (!$requirementId) {
                return json(['code' => 400, 'message' => '需求ID不能为空']);
            }
            
            // 验证需求是否存在
            $requirement = Db::name('project_requirements')->where('id', $requirementId)->find();
            if (!$requirement) {
                return json(['code' => 404, 'message' => '需求不存在']);
            }
            
            // 获取上传的文件
            $file = $request->file('file');
            if (!$file) {
                return json(['code' => 400, 'message' => '请选择要上传的文件']);
            }
            
            // 验证文件大小（限制10MB）
            if ($file->getSize() > 10 * 1024 * 1024) {
                return json(['code' => 400, 'message' => '文件大小不能超过10MB']);
            }
            
            // 验证文件类型
            $allowedTypes = ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'zip', 'rar'];
            $extension = strtolower($file->getOriginalExtension());
            if (!in_array($extension, $allowedTypes)) {
                return json(['code' => 400, 'message' => '不支持的文件类型']);
            }
            
            // 生成文件名
            $filename = date('YmdHis') . '_' . uniqid() . '.' . $extension;
            $uploadPath = 'uploads/requirements/' . date('Y/m/d/');
            
            // 确保目录存在
            if (!is_dir($uploadPath)) {
                mkdir($uploadPath, 0755, true);
            }
            
            // 移动文件
            $filePath = $uploadPath . $filename;
            $file->move($uploadPath, $filename);
            
            // 保存附件信息
            $insertData = [
                'requirement_id' => $requirementId,
                'filename' => $filename,
                'original_name' => $file->getOriginalName(),
                'file_path' => $filePath,
                'file_size' => $file->getSize(),
                'file_type' => $file->getMime(),
                'uploader' => 'PeterSun',
                'create_time' => date('Y-m-d H:i:s')
            ];
            
            $attachmentId = Db::name('requirement_attachments')->insertGetId($insertData);
            
            if ($attachmentId) {
                return json([
                    'code' => 200,
                    'message' => '文件上传成功',
                    'data' => [
                        'id' => $attachmentId,
                        'filename' => $filename,
                        'original_name' => $file->getOriginalName(),
                        'file_path' => $filePath,
                        'file_size' => $file->getSize()
                    ]
                ]);
            } else {
                return json(['code' => 500, 'message' => '文件上传失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除附件
     */
    public function deleteAttachment(Request $request): Response
    {
        try {
            $id = $request->param('id');
            
            if (!$id) {
                return json(['code' => 400, 'message' => '附件ID不能为空']);
            }
            
            // 获取附件信息
            $attachment = Db::name('requirement_attachments')->where('id', $id)->find();
            if (!$attachment) {
                return json(['code' => 404, 'message' => '附件不存在']);
            }
            
            // 删除文件
            if (file_exists($attachment['file_path'])) {
                unlink($attachment['file_path']);
            }
            
            // 删除数据库记录
            $result = Db::name('requirement_attachments')->where('id', $id)->delete();
            
            if ($result) {
                return json([
                    'code' => 200,
                    'message' => '附件删除成功'
                ]);
            } else {
                return json(['code' => 500, 'message' => '附件删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }
}
