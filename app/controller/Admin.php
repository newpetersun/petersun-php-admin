<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

class Admin extends BaseController
{

    /**
     * 获取仪表盘数据
     */
    public function dashboard(): Response
    {
        try {
            // 统计数据
            $totalProjects = Db::name('project')->where('status', 1)->count();
            $totalMessages = Db::name('contact_message')->count();
            $unreadMessages = Db::name('contact_message')->where('is_read', 0)->count();
            $todayVisits = $this->getTodayVisits();
            
            // 最近活动
            $recentActivities = $this->getRecentActivities();
            
            // 项目分类统计
            $projectCategories = Db::name('project')
                ->alias('p')
                ->join('project_category pc', 'p.category_id = pc.id')
                ->where('p.status', 1)
                ->group('pc.name')
                ->column('pc.name, count(*) as count');
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'stats' => [
                        'total_projects' => $totalProjects,
                        'total_messages' => $totalMessages,
                        'unread_messages' => $unreadMessages,
                        'today_visits' => $todayVisits
                    ],
                    'recent_activities' => $recentActivities,
                    'project_categories' => $projectCategories
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取系统统计
     */
    public function stats(): Response
    {
        try {
            // 访问统计
            $todayVisits = $this->getTodayVisits();
            $weekVisits = $this->getWeekVisits();
            $monthVisits = $this->getMonthVisits();
            
            // 留言统计
            $totalMessages = Db::name('contact_message')->count();
            $unreadMessages = Db::name('contact_message')->where('is_read', 0)->count();
            $todayMessages = Db::name('contact_message')
                ->where('create_time', '>=', date('Y-m-d 00:00:00'))
                ->count();
            
            // 项目统计
            $totalProjects = Db::name('project')->where('status', 1)->count();
            $featuredProjects = Db::name('project')->where('is_featured', 1)->where('status', 1)->count();
            
            // 设备统计
            $deviceStats = $this->getDeviceStats();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'visits' => [
                        'today' => $todayVisits,
                        'week' => $weekVisits,
                        'month' => $monthVisits
                    ],
                    'messages' => [
                        'total' => $totalMessages,
                        'unread' => $unreadMessages,
                        'today' => $todayMessages
                    ],
                    'projects' => [
                        'total' => $totalProjects,
                        'featured' => $featuredProjects
                    ],
                    'devices' => $deviceStats
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取访问趋势数据
     */
    public function visitTrend(Request $request): Response
    {
        try {
            $days = $request->param('days', 7);
            $trend = [];
            
            for ($i = $days - 1; $i >= 0; $i--) {
                $date = date('Y-m-d', strtotime("-$i days"));
                $count = $this->getVisitsByDate($date);
                $trend[] = [
                    'date' => $date,
                    'count' => $count
                ];
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $trend
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取热门页面
     */
    public function popularPages(): Response
    {
        try {
            $pages = Db::name('visit_log')
                ->field('page, count(*) as count')
                ->group('page')
                ->order('count', 'desc')
                ->limit(10)
                ->select()
                ->toArray();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $pages
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取系统信息
     */
    public function systemInfo(): Response
    {
        try {
            $info = [
                'version' => '1.0.0',
                'php_version' => PHP_VERSION,
                'server_time' => date('Y-m-d H:i:s'),
                'uptime' => $this->getUptime(),
                'memory_usage' => memory_get_usage(true),
                'disk_free_space' => disk_free_space('/'),
                'disk_total_space' => disk_total_space('/')
            ];
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $info
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取今日访问量
     */
    private function getTodayVisits(): int
    {
        return Db::name('visit_log')
            ->where('create_time', '>=', date('Y-m-d 00:00:00'))
            ->count();
    }

    /**
     * 获取本周访问量
     */
    private function getWeekVisits(): int
    {
        $weekStart = date('Y-m-d 00:00:00', strtotime('monday this week'));
        return Db::name('visit_log')
            ->where('create_time', '>=', $weekStart)
            ->count();
    }

    /**
     * 获取本月访问量
     */
    private function getMonthVisits(): int
    {
        $monthStart = date('Y-m-01 00:00:00');
        return Db::name('visit_log')
            ->where('create_time', '>=', $monthStart)
            ->count();
    }

    /**
     * 获取指定日期的访问量
     */
    private function getVisitsByDate(string $date): int
    {
        return Db::name('visit_log')
            ->where('create_time', '>=', $date . ' 00:00:00')
            ->where('create_time', '<', $date . ' 23:59:59')
            ->count();
    }

    /**
     * 获取设备统计
     */
    private function getDeviceStats(): array
    {
        $stats = Db::name('visit_log')
            ->field('device_type, count(*) as count')
            ->group('device_type')
            ->select()
            ->toArray();
        
        $total = array_sum(array_column($stats, 'count'));
        $result = [];
        
        foreach ($stats as $stat) {
            $result[] = [
                'type' => $stat['device_type'],
                'count' => $stat['count'],
                'percentage' => $total > 0 ? round(($stat['count'] / $total) * 100, 2) : 0
            ];
        }
        
        return $result;
    }

    /**
     * 获取最近活动
     */
    private function getRecentActivities(): array
    {
        $activities = [];
        
        // 最近的项目
        $recentProjects = Db::name('project')
            ->where('status', 1)
            ->order('create_time', 'desc')
            ->limit(3)
            ->select()
            ->toArray();
        
        foreach ($recentProjects as $project) {
            $activities[] = [
                'id' => 'project_' . $project['id'],
                'type' => 'project',
                'title' => '新增项目：' . $project['title'],
                'time' => $this->getTimeAgo($project['create_time']),
                'color' => '#10b981'
            ];
        }
        
        // 最近的留言
        $recentMessages = Db::name('contact_message')
            ->order('create_time', 'desc')
            ->limit(3)
            ->select()
            ->toArray();
        
        foreach ($recentMessages as $message) {
            $activities[] = [
                'id' => 'message_' . $message['id'],
                'type' => 'message',
                'title' => '收到新留言：' . $message['name'],
                'time' => $this->getTimeAgo($message['create_time']),
                'color' => '#f59e0b'
            ];
        }
        
        // 按时间排序
        usort($activities, function($a, $b) {
            return strtotime($b['time']) - strtotime($a['time']);
        });
        
        return array_slice($activities, 0, 5);
    }

    /**
     * 获取运行时间
     */
    private function getUptime(): string
    {
        // 这里应该从系统获取真实运行时间，暂时返回模拟数据
        $days = rand(1, 30);
        $hours = rand(0, 23);
        $minutes = rand(0, 59);
        
        return "{$days}天 {$hours}小时 {$minutes}分钟";
    }

    /**
     * 获取时间差
     */
    private function getTimeAgo(string $time): string
    {
        $diff = time() - strtotime($time);
        
        if ($diff < 60) {
            return '刚刚';
        } elseif ($diff < 3600) {
            return floor($diff / 60) . '分钟前';
        } elseif ($diff < 86400) {
            return floor($diff / 3600) . '小时前';
        } else {
            return floor($diff / 86400) . '天前';
        }
    }
} 