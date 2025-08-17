<?php

use think\migration\Migrator;
use think\migration\db\Column;

class UpdateUsersTable extends Migrator
{
    /**
     * 更新用户表，添加个人信息字段
     */
    public function change()
    {
        $table = $this->table('users');
        
        // 添加新字段
        $table->addColumn('name', 'string', ['limit' => 100, 'null' => true, 'comment' => '姓名'])
              ->addColumn('code_age', 'string', ['limit' => 50, 'null' => true, 'comment' => '编程年龄'])
              ->addColumn('description', 'text', ['null' => true, 'comment' => '个人描述'])
              ->addColumn('github', 'string', ['limit' => 255, 'null' => true, 'comment' => 'GitHub链接'])
              ->addColumn('wechat', 'string', ['limit' => 100, 'null' => true, 'comment' => '微信号'])
              ->update();
    }
} 