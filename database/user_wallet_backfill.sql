-- 回填：把已充值用户的 user_entitlements 累计金币并入 user_wallet（仅迁移一次）
-- 说明：user_entitlements.quantity 即实际发放的金币数（已乘 grant），按 openid 汇总后写入对应用户钱包。
INSERT INTO `user_wallet` (`id`, `user_id`, `balance`, `frozen`, `total_earned`, `total_spent`, `create_time`, `update_time`)
SELECT UUID(), u.`id`, COALESCE(SUM(e.`quantity`), 0), 0, COALESCE(SUM(e.`quantity`), 0), 0, NOW(), NOW()
FROM `users` u
LEFT JOIN `user_entitlements` e ON e.`openid` = u.`openid`
GROUP BY u.`id`
HAVING COALESCE(SUM(e.`quantity`), 0) > 0
ON DUPLICATE KEY UPDATE
  `balance`      = `balance` + VALUES(`balance`),
  `total_earned` = `total_earned` + VALUES(`total_earned`),
  `update_time`  = NOW();
