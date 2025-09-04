<?php

namespace app\controller;

use app\BaseController;
use app\model\User as UserModel;
use think\Request;
use think\facade\Db;
use think\facade\Cache;

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

    public function china()
    {
		$url = 'https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json';
		 
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true); // 跟随重定向
		curl_setopt($ch, CURLOPT_TIMEOUT, 10); // 超时时间（秒）
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // 跳过 SSL 验证（仅测试环境使用）
		 
		$jsonData = curl_exec($ch);
		$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		$error = curl_error($ch);
		curl_close($ch);
		 
		if ($httpCode === 200 && $jsonData !== false) {

			$a = json_decode($jsonData);
			return json([
			    'code' => 200,
			    'message' => 'success',
			    'data' => $a
			]);
		} else {
		    http_response_code(500);
		    echo json_encode([
		        'error' => 'Failed to fetch JSON data',
		        'details' => $error,
		        'http_code' => $httpCode
		    ]);
		}
    }
	public function info(Request $request)
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
            $user = UserModel::find(1);
			$user['site_description'] = $formattedSettings['site_description']['value'];
			$user['subdescription'] = $formattedSettings['subdescription']['value'];
            return json([
                'code' => 200,
                'message' => '获取成功',
                'data' => $user
            ]);
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
}
