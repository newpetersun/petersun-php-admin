<?php
declare (strict_types = 1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\Response;
use think\facade\View;

class Test extends BaseController
{
    /**
     * 测试页面
     */
    public function index()
    {
        // 直接返回HTML内容，不使用模板
        return '<h1>测试页面</h1><p>如果您看到这个页面，说明控制器工作正常。</p>';
    }

    /**
     * 测试模板
     */
    public function template()
    {
        // 传递变量到模板
        View::assign('title', '测试模板');
        View::assign('message', '模板渲染测试');
        return View::fetch('test');
    }
} 