<?php

use think\migration\Migrator;
use think\migration\db\Column;

class CreateUsersTable extends Migrator
{
    /**
     * 创建用户表
     */
    public function change()
    {
        $table = $this->table('users', ['engine' => 'InnoDB', 'collation' => 'utf8mb4_unicode_ci']);
        $table->addColumn('username', 'string', ['limit' => 50, 'null' => false, 'comment' => '用户名'])
              ->addColumn('password', 'string', ['limit' => 255, 'null' => false, 'comment' => '密码'])
              ->addColumn('email', 'string', ['limit' => 100, 'null' => true, 'comment' => '邮箱'])
              ->addColumn('nickname', 'string', ['limit' => 50, 'null' => true, 'comment' => '昵称'])
              ->addColumn('avatar', 'string', ['limit' => 255, 'null' => true, 'comment' => '头像'])
              ->addColumn('status', 'integer', ['limit' => 1, 'default' => 1, 'comment' => '状态：1启用，0禁用'])
              ->addColumn('last_login_time', 'datetime', ['null' => true, 'comment' => '最后登录时间'])
              ->addColumn('last_login_ip', 'string', ['limit' => 45, 'null' => true, 'comment' => '最后登录IP'])
              ->addColumn('created_at', 'datetime', ['null' => false, 'default' => 'CURRENT_TIMESTAMP', 'comment' => '创建时间'])
              ->addColumn('updated_at', 'datetime', ['null' => false, 'default' => 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP', 'comment' => '更新时间'])
              ->addIndex(['username'], ['unique' => true])
              ->addIndex(['email'], ['unique' => true])
              ->create();
    }
} 