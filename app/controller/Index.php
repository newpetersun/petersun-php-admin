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

    public function china()
    {
		$url = 'https://geojson.cn/api/china/1.6.2/china.json';
		 
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
}
