<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\facade\Db;
use think\Request;

/**
 * 后台菜单（数据库驱动，按登录用户角色返回）
 *  - 登录且启用即可访问（路由挂在 JwtAuth + AdminAuth 中间件下，不再判断 user_type）
 *  - 菜单表 menus：parent_id=0 为分组，其余为分组下的菜单项
 *  - 菜单 role 字段：逗号分隔的角色 code；登录用户按 role_id 对应角色过滤，空字符串表示全部角色可见
 */
class Menu extends BaseController
{
    public function index(Request $request): \think\Response
    {
        $userId = $request->userId ?? 0;

        // 按登录用户的所有角色 code 过滤（user_roles 关联 + 主角色 role_id 兼容）
        $roleCodes = [];
        if ($userId) {
            $roleIds = Db::name('user_roles')->where('user_id', $userId)->column('role_id');
            $mainRoleId = Db::name('users')->where('id', $userId)->value('role_id');
            if ($mainRoleId) {
                $roleIds[] = $mainRoleId;
            }
            $roleIds = array_values(array_unique(array_filter($roleIds)));
            if ($roleIds) {
                $roleCodes = Db::name('roles')->where('id', 'in', $roleIds)->column('code');
            }
        }

        // 前端角色切换：指定 active_role 时只展示该角色菜单（必须是用户自身拥有的角色）
        $activeRole = (string) $request->param('active_role', '');
        if ($activeRole !== '' && in_array($activeRole, $roleCodes, true)) {
            $roleCodes = [$activeRole];
        }

        $list = Db::name('menus')
            ->where('status', 1)
            ->order('sort', 'asc')
            ->select()
            ->toArray();

        // 按角色过滤（用户拥有任一匹配角色即可见）
        $list = array_filter($list, function ($m) use ($roleCodes) {
            if (empty($m['role'])) {
                return true; // 空=全部角色可见
            }
            $roles = array_map('trim', explode(',', $m['role']));
            foreach ($roleCodes as $code) {
                if (in_array($code, $roles, true)) {
                    return true;
                }
            }
            return false;
        });

        // 组装分组 -> 菜单项 的嵌套结构
        $itemsByParent = [];
        foreach ($list as $m) {
            if ($m['parent_id'] != 0) {
                $itemsByParent[$m['parent_id']][] = [
                    'icon'  => $m['icon'],
                    'title' => $m['title'],
                    'path'  => $m['path'],
                ];
            }
        }

        $result = [];
        foreach ($list as $m) {
            if ($m['parent_id'] == 0) {
                $result[] = [
                    'title' => $m['title'],
                    'items' => $itemsByParent[$m['id']] ?? [],
                ];
            }
        }

        return json([
            'code'    => 200,
            'message' => '获取成功',
            'data'    => $result,
        ]);
    }

    // 角色列表
    public function roleList(): \think\Response
    {
        $list = Db::name('roles')->order('sort', 'asc')->select()->toArray();
        return json(['code' => 200, 'message' => '获取成功', 'data' => $list]);
    }

    /**
     * 角色新增/更新（有 id 则更新）
     * 仅接受 roles 表白名单字段，避免前端透传树形/展示用字段导致
     * 「数据表字段不存在」错误
     */
    public function roleSave(Request $request): \think\Response
    {
        try {
            $src  = $request->post();
            $id   = (int) ($src['id'] ?? 0);
            $data = $this->pick($src, ['name', 'code', 'remark', 'status', 'sort', 'is_default']);

            if (trim((string) ($data['name'] ?? '')) === '' || trim((string) ($data['code'] ?? '')) === '') {
                return json(['code' => 400, 'message' => '角色名称与标识不能为空']);
            }

            if ($id > 0) {
                Db::name('roles')->where('id', $id)->update($data);
            } else {
                $data['create_time'] = date('Y-m-d H:i:s');
                $data['update_time'] = date('Y-m-d H:i:s');
                $id = Db::name('roles')->insertGetId($data);
            }

            // 默认注册角色全局仅一个：开启当前角色时，清除其它角色的默认标记
            if (!empty($data['is_default'])) {
                Db::name('roles')->where('id', '<>', $id)->update(['is_default' => 0]);
            }

            return json(['code' => 200, 'message' => '保存成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    // 角色删除
    public function roleDelete($id): \think\Response
    {
        Db::name('roles')->where('id', $id)->delete();
        return json(['code' => 200, 'message' => '删除成功']);
    }

    // 菜单列表（含分组，供前端表格与上级选择使用）
    // 支持 role（角色 code，空 role 项视为全部角色可见，两种类型下都返回）
    // 与 keyword（标题/路径模糊匹配）后端筛选
    public function menuList(Request $request): \think\Response
    {
        $role = (string) $request->param('role', '');
        $keyword = (string) $request->param('keyword', '');

        $query = Db::name('menus');
        if ($role !== '') {
            $query->where(function ($q) use ($role) {
                $q->where('role', 'like', "%{$role}%")->whereOr('role', '');
            });
        }
        if ($keyword !== '') {
            $query->where(function ($q) use ($keyword) {
                $q->where('title', 'like', "%{$keyword}%")
                  ->whereOr('path', 'like', "%{$keyword}%");
            });
        }

        $list = $query->order('sort', 'asc')->select()->toArray();
        return json(['code' => 200, 'message' => '获取成功', 'data' => $list]);
    }

    /**
     * 菜单新增/更新
     * 仅接受 menus 表白名单字段。前端表格为树形结构（带 children 等展示用字段），
     * 若整体透传会触发「数据表字段不存在:[children]」
     */
    public function menuSave(Request $request): \think\Response
    {
        try {
            $src  = $request->post();
            $id   = (int) ($src['id'] ?? 0);
            $data = $this->pick($src, ['parent_id', 'title', 'icon', 'path', 'role', 'status', 'sort']);

            if (trim((string) ($data['title'] ?? '')) === '') {
                return json(['code' => 400, 'message' => '菜单标题不能为空']);
            }
            $data['parent_id'] = max(0, (int) ($data['parent_id'] ?? 0));
            $data['status']    = (int) ($data['status'] ?? 1) === 1 ? 1 : 0;
            $data['sort']      = (int) ($data['sort'] ?? 0);

            if ($id > 0) {
                Db::name('menus')->where('id', $id)->update($data);
            } else {
                $data['create_time'] = date('Y-m-d H:i:s');
                $data['update_time'] = date('Y-m-d H:i:s');
                Db::name('menus')->insert($data);
            }
            return json(['code' => 200, 'message' => '保存成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    // 菜单删除
    public function menuDelete($id): \think\Response
    {
        try {
            $row = Db::name('menus')->where('id', (int) $id)->find();
            if (!$row) {
                return json(['code' => 404, 'message' => '菜单不存在']);
            }
            // 存在子菜单时禁止删除，避免产生孤立节点
            $childCount = Db::name('menus')->where('parent_id', (int) $id)->count();
            if ($childCount > 0) {
                return json(['code' => 400, 'message' => '该菜单下还有 ' . $childCount . ' 个子菜单，无法删除']);
            }

            Db::name('menus')->where('id', (int) $id)->delete();
            return json(['code' => 200, 'message' => '删除成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    // ========================================================
    // 内部方法
    // ========================================================

    /**
     * 按白名单提取字段（只保留表字段，丢弃前端透传的展示用字段）
     *
     * @param array $src   数据源（通常是 $request->post()）
     * @param array $fields 允许的字段名
     */
    private function pick(array $src, array $fields): array
    {
        $data = [];
        foreach ($fields as $f) {
            if (array_key_exists($f, $src)) {
                $data[$f] = is_scalar($src[$f]) ? trim((string) $src[$f]) : $src[$f];
            }
        }
        return $data;
    }
}
