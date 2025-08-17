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
        return View::fetch('admin/index');
    }

    /**
     * 用户信息管理页面
     */
    public function user()
    {
        return View::fetch('admin/user');
    }

    /**
     * 项目管理页面
     */
    public function project()
    {
        return View::fetch('admin/project');
    }

    /**
     * 联系信息管理页面
     */
    public function contact()
    {
        return View::fetch('admin/contact');
    }

    /**
     * 留言管理页面
     */
    public function message()
    {
        return View::fetch('admin/message');
    }

    /**
     * 系统设置页面
     */
    public function setting()
    {
        return View::fetch('admin/setting');
    }
} 