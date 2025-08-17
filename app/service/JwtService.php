<?php
declare(strict_types=1);

namespace app\service;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use think\facade\Config;

/**
 * JWT服务类
 */
class JwtService
{
    /**
     * JWT密钥
     * @var string
     */
    private string $secret;
    
    /**
     * 算法
     * @var string
     */
    private string $algorithm;
    
    /**
     * Token过期时间（秒）
     * @var int
     */
    private int $expireTime;
    
    public function __construct()
    {
        $this->secret = 'your-super-secret-jwt-key-change-in-production';
        $this->algorithm = 'HS256';
        $this->expireTime = 7200; // 默认2小时
    }
    
    /**
     * 生成JWT token
     * @param array $payload
     * @return string
     */
    public function generateToken(array $payload): string
    {
        $time = time();
        $payload = array_merge([
            'iat' => $time,        // 签发时间
            'exp' => $time + $this->expireTime, // 过期时间
            'nbf' => $time,        // 生效时间
        ], $payload);
        
        return JWT::encode($payload, $this->secret, $this->algorithm);
    }
    
    /**
     * 验证JWT token
     * @param string $token
     * @return object
     * @throws \Exception
     */
    public function verifyToken(string $token): object
    {
        try {
            return JWT::decode($token, new Key($this->secret, $this->algorithm));
        } catch (\Exception $e) {
            throw new \Exception('Token验证失败: ' . $e->getMessage());
        }
    }
    
    /**
     * 从token中获取用户ID
     * @param string $token
     * @return int|null
     */
    public function getUserIdFromToken(string $token): ?int
    {
        try {
            $payload = $this->verifyToken($token);
            return $payload->user_id ?? null;
        } catch (\Exception $e) {
            return null;
        }
    }
    
    /**
     * 刷新token
     * @param string $token
     * @return string
     * @throws \Exception
     */
    public function refreshToken(string $token): string
    {
        $payload = $this->verifyToken($token);
        $payloadArray = (array) $payload;
        
        // 移除时间相关字段
        unset($payloadArray['iat'], $payloadArray['exp'], $payloadArray['nbf']);
        
        return $this->generateToken($payloadArray);
    }
} 