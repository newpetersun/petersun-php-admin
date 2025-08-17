<?php

use think\migration\Seeder;
use app\model\User;

class UserSeeder extends Seeder
{
    /**
     * 运行数据库种子
     */
    public function run()
    {
        // 创建默认管理员用户
        $admin = new User();
        $admin->username = 'admin';
        $admin->password = User::hashPassword('123456');
        $admin->email = 'admin@example.com';
        $admin->nickname = '管理员';
        $admin->status = 1;
        $admin->save();
        
        // 创建测试用户
        $user = new User();
        $user->username = 'test';
        $user->password = User::hashPassword('123456');
        $user->email = 'test@example.com';
        $user->nickname = '测试用户';
        $user->status = 1;
        $user->save();
        
        $this->output->writeln('用户数据初始化完成');
    }
} 