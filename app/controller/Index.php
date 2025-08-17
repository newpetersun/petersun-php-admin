<?php

namespace app\controller;

use app\BaseController;

class Index extends BaseController
{
    public function index()
    {
        return json([
            'code' => 200,
            'message' => 'success',
            'data' => 'api管理系统'
        ]);
    }
}
