<?php

use think\migration\Migrator;
use think\migration\db\Column;

class AddProjectImages extends Migrator
{
    /**
     * 执行迁移
     *
     * @return void
     */
    public function up()
    {
        // 创建项目图片表
        $this->table('project_images')
            ->setComment('项目图片表')
            ->addColumn('project_id', 'integer', ['comment' => '项目ID'])
            ->addColumn('image_url', 'string', ['comment' => '图片URL', 'limit' => 255])
            ->addColumn('sort_order', 'integer', ['comment' => '排序', 'default' => 0])
            ->addColumn('create_time', 'datetime', ['comment' => '创建时间', 'null' => false, 'default' => 'CURRENT_TIMESTAMP'])
            ->addIndex('project_id', ['name' => 'idx_project_id'])
            ->create();
        
        // 添加索引
        $this->table('project_images')
            ->addIndex(['project_id', 'sort_order'], ['name' => 'idx_project_sort'])
            ->save();
    }

    /**
     * 回滚迁移
     *
     * @return void
     */
    public function down()
    {
        $this->dropTable('project_images');
    }
}