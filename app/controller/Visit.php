<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\Response;

class Visit extends BaseController
{
    /**
     * 记录访问日志
     */
    public function log(Request $request): Response
    {
        try {
            $data = $request->only(['page', 'referer', 'user_agent']);
            
            // 获取访问者信息
            $ip = $request->ip();
            $userAgent = $request->header('user-agent');
            
            // 检测设备类型
            $deviceType = $this->detectDeviceType($userAgent);
            
            // 检查是否重复访问（同一IP同一页面5分钟内）
            $recentVisit = Db::name('visit_log')
                ->where('ip', $ip)
                ->where('page', $data['page'] ?? '/')
                ->where('create_time', '>', date('Y-m-d H:i:s', time() - 300))
                ->find();
            
            if (!$recentVisit) {
                // 记录访问日志
                $logData = [
                    'ip' => $ip,
                    'page' => $data['page'] ?? '/',
                    'referer' => $data['referer'] ?? '',
                    'user_agent' => $userAgent,
                    'device_type' => $deviceType,
                    'create_time' => date('Y-m-d H:i:s')
                ];
                
                Db::name('visit_log')->insert($logData);
            }
            
            return json(['code' => 200, 'message' => '记录成功']);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取访问统计
     */
    public function stats(Request $request): Response
    {
        try {
            $type = $request->param('type', 'today'); // today, week, month
            
            switch ($type) {
                case 'today':
                    $startTime = date('Y-m-d 00:00:00');
                    break;
                case 'week':
                    $startTime = date('Y-m-d 00:00:00', strtotime('monday this week'));
                    break;
                case 'month':
                    $startTime = date('Y-m-01 00:00:00');
                    break;
                default:
                    $startTime = date('Y-m-d 00:00:00');
            }
            
            $totalVisits = Db::name('visit_log')
                ->where('create_time', '>=', $startTime)
                ->count();
            
            $uniqueVisitors = Db::name('visit_log')
                ->where('create_time', '>=', $startTime)
                ->group('ip')
                ->count();
            
            $popularPages = Db::name('visit_log')
                ->field('page, count(*) as count')
                ->where('create_time', '>=', $startTime)
                ->group('page')
                ->order('count', 'desc')
                ->limit(5)
                ->select()
                ->toArray();
            
            $deviceStats = Db::name('visit_log')
                ->field('device_type, count(*) as count')
                ->where('create_time', '>=', $startTime)
                ->group('device_type')
                ->select()
                ->toArray();
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'total_visits' => $totalVisits,
                    'unique_visitors' => $uniqueVisitors,
                    'popular_pages' => $popularPages,
                    'device_stats' => $deviceStats
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取访问趋势
     */
    public function trend(Request $request): Response
    {
        try {
            $days = $request->param('days', 7);
            $trend = [];
            
            for ($i = $days - 1; $i >= 0; $i--) {
                $date = date('Y-m-d', strtotime("-$i days"));
                $startTime = $date . ' 00:00:00';
                $endTime = $date . ' 23:59:59';
                
                $visits = Db::name('visit_log')
                    ->where('create_time', '>=', $startTime)
                    ->where('create_time', '<=', $endTime)
                    ->count();
                
                $visitors = Db::name('visit_log')
                    ->where('create_time', '>=', $startTime)
                    ->where('create_time', '<=', $endTime)
                    ->group('ip')
                    ->count();
                
                $trend[] = [
                    'date' => $date,
                    'visits' => $visits,
                    'visitors' => $visitors
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
     * 获取实时访问数据
     */
    public function realtime(): Response
    {
        try {
            // 当前在线用户（5分钟内有访问）
            $onlineUsers = Db::name('visit_log')
                ->where('create_time', '>', date('Y-m-d H:i:s', time() - 300))
                ->group('ip')
                ->count();
            
            // 今日访问量
            $todayVisits = Db::name('visit_log')
                ->where('create_time', '>=', date('Y-m-d 00:00:00'))
                ->count();
            
            // 今日访客数
            $todayVisitors = Db::name('visit_log')
                ->where('create_time', '>=', date('Y-m-d 00:00:00'))
                ->group('ip')
                ->count();
            
            // 最近访问记录
            $recentVisits = Db::name('visit_log')
                ->field('ip, page, create_time')
                ->order('create_time', 'desc')
                ->limit(10)
                ->select()
                ->toArray();
            
            foreach ($recentVisits as &$visit) {
                $visit['create_time'] = date('H:i:s', strtotime($visit['create_time']));
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => [
                    'online_users' => $onlineUsers,
                    'today_visits' => $todayVisits,
                    'today_visitors' => $todayVisitors,
                    'recent_visits' => $recentVisits
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取地理位置统计
     */
    public function geo(): Response
    {
        try {
            // 这里应该集成IP地理位置查询服务
            // 暂时返回模拟数据
            $geoData = [
                ['name' => '北京市', 'value' => 150],
                ['name' => '上海市', 'value' => 120],
                ['name' => '广东省', 'value' => 100],
                ['name' => '江苏省', 'value' => 80],
                ['name' => '浙江省', 'value' => 70],
                ['name' => '山东省', 'value' => 60],
                ['name' => '四川省', 'value' => 50],
                ['name' => '湖北省', 'value' => 40],
                ['name' => '河南省', 'value' => 35],
                ['name' => '湖南省', 'value' => 30]
            ];
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $geoData
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 检测设备类型
     */
    private function detectDeviceType(string $userAgent): string
    {
        $userAgent = strtolower($userAgent);
        
        if (strpos($userAgent, 'mobile') !== false || strpos($userAgent, 'android') !== false || strpos($userAgent, 'iphone') !== false) {
            return 'mobile';
        } elseif (strpos($userAgent, 'tablet') !== false || strpos($userAgent, 'ipad') !== false) {
            return 'tablet';
        } else {
            return 'desktop';
        }
    }
} 