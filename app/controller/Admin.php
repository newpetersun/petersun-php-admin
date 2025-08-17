<?php
declare (strict_types = 1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\Response;
use think\facade\View;

class Admin extends BaseController
{
    /**
     * 后台首页
     */
    public function index()
    {
        View::assign('title', '仪表盘');
        return View::fetch('admin/index');
    }

    /**
     * 用户信息管理页面
     */
    public function user()
    {
        View::assign('title', '个人信息管理');
        return View::fetch('admin/user');
    }

    /**
     * 项目管理页面
     */
    public function project()
    {
        View::assign('title', '项目管理');
        return View::fetch('admin/project');
    }

    /**
     * 联系信息管理页面
     */
    public function contact()
    {
        View::assign('title', '联系信息管理');
        return View::fetch('admin/contact');
    }

    /**
     * 留言管理页面
     */
    public function message()
    {
        View::assign('title', '留言管理');
        return View::fetch('admin/message');
    }

    /**
     * 系统设置页面
     */
    public function setting()
    {
        View::assign('title', '系统设置');
        return View::fetch('admin/setting');
    }
} 