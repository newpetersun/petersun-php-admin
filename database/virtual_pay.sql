-- ------------------------------------------------------------
-- 微信小程序「虚拟支付：个人」配套表
-- 导入：mysql -u root -p <database> < database/virtual_pay.sql
-- ------------------------------------------------------------

-- 虚拟支付订单
DROP TABLE IF EXISTS `virtual_pay_order`;
CREATE TABLE `virtual_pay_order` (
  `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `out_trade_no`   VARCHAR(32)  NOT NULL COMMENT '业务单号，8-32 位，不以下划线开头，全局唯一',
  `wx_order_id`    VARCHAR(64)  DEFAULT NULL COMMENT '平台单号，跟踪/幂等/对账以此为准',
  `openid`         VARCHAR(64)  NOT NULL DEFAULT '' COMMENT '用户 openid',
  `product_id`     VARCHAR(64)  NOT NULL DEFAULT '' COMMENT '道具 ID',
  `product_name`   VARCHAR(128) NOT NULL DEFAULT '' COMMENT '道具名称快照',
  `quantity`       INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '购买数量',
  `goods_price`    INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '道具单价（分）',
  `pay_fee`        INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单总金额（分）',
  `attach`         VARCHAR(512) NOT NULL DEFAULT '' COMMENT '透传数据',
  `env`            TINYINT      NOT NULL DEFAULT 0 COMMENT '0现网 1沙箱',
  `status`         VARCHAR(16)  NOT NULL DEFAULT 'pending' COMMENT 'pending待支付 / paid已支付 / closed已关闭',
  `deliver_status` TINYINT      NOT NULL DEFAULT 0 COMMENT '0未发货 1已发货（幂等依据）',
  `paid_time`      DATETIME     DEFAULT NULL COMMENT '支付时间',
  `deliver_time`   DATETIME     DEFAULT NULL COMMENT '发货时间',
  `create_time`    DATETIME     DEFAULT NULL,
  `update_time`    DATETIME     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_out_trade_no` (`out_trade_no`),
  UNIQUE KEY `uk_wx_order_id` (`wx_order_id`),
  KEY `idx_openid` (`openid`),
  KEY `idx_deliver` (`deliver_status`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='虚拟支付订单';

-- 用户权益（发货结果）
DROP TABLE IF EXISTS `user_entitlement`;
CREATE TABLE `user_entitlement` (
  `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `openid`      VARCHAR(64)  NOT NULL DEFAULT '' COMMENT '用户 openid',
  `product_id`  VARCHAR(64)  NOT NULL DEFAULT '' COMMENT '道具 ID',
  `quantity`    INT          NOT NULL DEFAULT 0 COMMENT '累计发放数量（可为负，退款时扣减）',
  `wx_order_id` VARCHAR(64)  NOT NULL DEFAULT '' COMMENT '来源平台单号，唯一索引防重复发放',
  `create_time` DATETIME     DEFAULT NULL,
  `update_time` DATETIME     DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wx_order_id` (`wx_order_id`),
  KEY `idx_openid_product` (`openid`, `product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户虚拟权益';
