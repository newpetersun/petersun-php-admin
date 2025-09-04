<?php
declare(strict_types=1);

namespace app\controller;

use app\BaseController;
use think\Request;
use think\facade\Db;
use think\facade\Cache;

class Setting extends BaseController
{
    /**
     * 获取系统设置
     */
    public function getSettings(Request $request): Response
    {
        try {
            $group = $request->param('group', '');
            
            $query = Db::name('system_settings');
            if ($group) {
                $query->where('group_name', $group);
            }
            
            $settings = $query->select()->toArray();
            
            // 格式化设置数据
            $formattedSettings = [];
            foreach ($settings as $setting) {
                $value = $this->formatSettingValue($setting['setting_value'], $setting['setting_type']);
                $formattedSettings[$setting['setting_key']] = [
                    'value' => $value,
                    'type' => $setting['setting_type'],
                    'description' => $setting['description'],
                    'group' => $setting['group_name'],
                    'is_system' => (bool)$setting['is_system']
                ];
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $formattedSettings
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 更新系统设置
     */
    public function updateSettings(Request $request): Response
    {
        try {
            $settings = $request->param('settings', []);
            
            if (empty($settings)) {
                return json(['code' => 400, 'message' => '设置数据不能为空']);
            }
            
            Db::startTrans();
            
            foreach ($settings as $key => $value) {
                // 检查设置是否存在
                $setting = Db::name('system_settings')->where('setting_key', $key)->find();
                
                if ($setting) {
                    // 检查是否为系统设置
                    if ($setting['is_system'] && in_array($key, ['system_version'])) {
                        continue; // 跳过系统设置
                    }
                    
                    // 格式化值
                    $formattedValue = $this->formatSettingValueForStorage($value, $setting['setting_type']);
                    
                    // 更新设置
                    Db::name('system_settings')
                        ->where('setting_key', $key)
                        ->update([
                            'setting_value' => $formattedValue,
                            'updated_at' => date('Y-m-d H:i:s')
                        ]);
                }
            }
            
            Db::commit();
            
            // 清除缓存
            Cache::tag('system_settings')->clear();
            
            return json([
                'code' => 200,
                'message' => '设置更新成功'
            ]);
        } catch (\Exception $e) {
            Db::rollback();
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取系统信息
     */
    public function getSystemInfo(): Response
    {
        try {
            // 安全获取磁盘空间信息
            $diskFree = disk_free_space('/');
            $diskTotal = disk_total_space('/');
            
            $info = [
                'version' => $this->getSettingValue('system_version', '1.0.0'),
                'php_version' => PHP_VERSION,
                'server_time' => date('Y-m-d H:i:s'),
                'uptime' => $this->getUptime(),
                'memory_usage' => $this->formatBytes(memory_get_usage(true)),
                'memory_peak' => $this->formatBytes(memory_get_peak_usage(true)),
                'disk_free_space' => $diskFree !== false ? $this->formatBytes($diskFree) : 'Unknown',
                'disk_total_space' => $diskTotal !== false ? $this->formatBytes($diskTotal) : 'Unknown',
                'database_version' => $this->getDatabaseVersion(),
                'server_software' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown',
                'os' => PHP_OS,
                'timezone' => date_default_timezone_get()
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
     * 备份数据
     */
    public function backupData(): Response
    {
        try {
            $backupPath = $this->getSettingValue('backup_path', '/backups/');
            $backupFile = $backupPath . 'backup_' . date('Y-m-d_H-i-s') . '.sql';
            
            // 确保备份目录存在
            if (!is_dir($backupPath)) {
                mkdir($backupPath, 0755, true);
            }
            
            // 获取数据库配置
            $config = config('database.connections.mysql');
            $command = sprintf(
                'mysqldump -h%s -u%s -p%s %s > %s',
                $config['hostname'],
                $config['username'],
                $config['password'],
                $config['database'],
                $backupFile
            );
            
            exec($command, $output, $returnCode);
            
            if ($returnCode === 0) {
                return json([
                    'code' => 200,
                    'message' => '备份成功',
                    'data' => [
                        'backup_file' => $backupFile,
                        'backup_time' => date('Y-m-d H:i:s'),
                        'file_size' => $this->formatBytes(filesize($backupFile))
                    ]
                ]);
            } else {
                return json(['code' => 500, 'message' => '备份失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 恢复数据
     */
    public function restoreData(Request $request): Response
    {
        try {
            $backupFile = $request->param('backup_file', '');
            
            if (empty($backupFile) || !file_exists($backupFile)) {
                return json(['code' => 400, 'message' => '备份文件不存在']);
            }
            
            // 获取数据库配置
            $config = config('database.connections.mysql');
            $command = sprintf(
                'mysql -h%s -u%s -p%s %s < %s',
                $config['hostname'],
                $config['username'],
                $config['password'],
                $config['database'],
                $backupFile
            );
            
            exec($command, $output, $returnCode);
            
            if ($returnCode === 0) {
                return json([
                    'code' => 200,
                    'message' => '恢复成功',
                    'data' => [
                        'restore_time' => date('Y-m-d H:i:s')
                    ]
                ]);
            } else {
                return json(['code' => 500, 'message' => '恢复失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 清除缓存
     */
    public function clearCache(): Response
    {
        try {
            // 清除各种缓存
            Cache::clear();
            
            // 清除模板缓存
            $cachePath = runtime_path() . 'temp/';
            if (is_dir($cachePath)) {
                $this->deleteDirectory($cachePath);
            }
            
            return json([
                'code' => 200,
                'message' => '缓存清除成功',
                'data' => [
                    'clear_time' => date('Y-m-d H:i:s')
                ]
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 获取备份列表
     */
    public function getBackupList(): Response
    {
        try {
            $backupPath = $this->getSettingValue('backup_path', '/backups/');
            $backups = [];
            
            if (is_dir($backupPath)) {
                $files = glob($backupPath . 'backup_*.sql');
                foreach ($files as $file) {
                    $backups[] = [
                        'filename' => basename($file),
                        'filepath' => $file,
                        'size' => $this->formatBytes(filesize($file)),
                        'create_time' => date('Y-m-d H:i:s', filemtime($file))
                    ];
                }
                
                // 按创建时间倒序排列
                usort($backups, function($a, $b) {
                    return strtotime($b['create_time']) - strtotime($a['create_time']);
                });
            }
            
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $backups
            ]);
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 删除备份文件
     */
    public function deleteBackup(Request $request): Response
    {
        try {
            $filename = $request->param('filename', '');
            
            if (empty($filename)) {
                return json(['code' => 400, 'message' => '文件名不能为空']);
            }
            
            $backupPath = $this->getSettingValue('backup_path', '/backups/');
            $filepath = $backupPath . $filename;
            
            if (!file_exists($filepath)) {
                return json(['code' => 404, 'message' => '备份文件不存在']);
            }
            
            if (unlink($filepath)) {
                return json([
                    'code' => 200,
                    'message' => '删除成功'
                ]);
            } else {
                return json(['code' => 500, 'message' => '删除失败']);
            }
        } catch (\Exception $e) {
            return json(['code' => 500, 'message' => '服务器错误：' . $e->getMessage()]);
        }
    }

    /**
     * 格式化设置值
     */
    private function formatSettingValue(string $value, string $type)
    {
        switch ($type) {
            case 'int':
                return (int)$value;
            case 'bool':
                return (bool)$value;
            case 'json':
                return json_decode($value, true);
            default:
                return $value;
        }
    }

    /**
     * 格式化设置值用于存储
     */
    private function formatSettingValueForStorage($value, string $type): string
    {
        switch ($type) {
            case 'json':
                return json_encode($value, JSON_UNESCAPED_UNICODE);
            default:
                return (string)$value;
        }
    }

    /**
     * 获取设置值
     */
    private function getSettingValue(string $key, $default = null)
    {
        $cacheKey = 'setting_' . $key;
        $value = Cache::get($cacheKey);
        
        if ($value === null) {
            $setting = Db::name('system_settings')->where('setting_key', $key)->find();
            if ($setting) {
                $value = $this->formatSettingValue($setting['setting_value'], $setting['setting_type']);
                Cache::set($cacheKey, $value, 3600);
            } else {
                $value = $default;
            }
        }
        
        return $value;
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
     * 获取数据库版本
     */
    private function getDatabaseVersion(): string
    {
        try {
            $version = Db::query('SELECT VERSION() as version');
            return $version[0]['version'] ?? 'Unknown';
        } catch (\Exception $e) {
            return 'Unknown';
        }
    }

    /**
     * 格式化字节数
     */
    private function formatBytes($bytes): string
    {
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        $bytes = max((float)$bytes, 0);
        $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
        $pow = min($pow, count($units) - 1);
        
        $bytes /= pow(1024, $pow);
        
        return round($bytes, 2) . ' ' . $units[$pow];
    }

    /**
     * 删除目录
     */
    private function deleteDirectory(string $dir): bool
    {
        if (!is_dir($dir)) {
            return false;
        }
        
        $files = array_diff(scandir($dir), ['.', '..']);
        foreach ($files as $file) {
            $path = $dir . DIRECTORY_SEPARATOR . $file;
            if (is_dir($path)) {
                $this->deleteDirectory($path);
            } else {
                unlink($path);
            }
        }
        
        return rmdir($dir);
    }
}
