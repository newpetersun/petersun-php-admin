<?php
declare(strict_types=1);

namespace app\command;

use app\service\VirtualPayService;
use think\console\Command;
use think\console\Input;
use think\console\Output;

// 虚拟支付兜底查单：发货推送丢失时，主动调用 query_order 补发货
//
// 建议 crontab 每 5 分钟执行一次：
//   */5 * * * * cd /path/to/petersun-php-admin && php think virtualpay:sync >> /tmp/vp_sync.log 2>&1
class VirtualPaySync extends Command
{
    protected function configure(): void
    {
        $this->setName('virtualpay:sync')
            ->setDescription('虚拟支付兜底查单：扫描未发货订单并补发货');
    }

    protected function execute(Input $input, Output $output): int
    {
        $limit = (int) config('virtualpay.query_limit', 100);
        $list  = VirtualPayService::pendingOrders($limit);

        if (empty($list)) {
            $output->writeln('[' . date('Y-m-d H:i:s') . '] 无待发货订单');
            return 0;
        }

        $stat = ['delivered' => 0, 'already_delivered' => 0, 'unpaid' => 0, 'query_failed' => 0, 'deliver_failed' => 0];

        foreach ($list as $order) {
            $result = VirtualPayService::syncOrder($order);
            $key    = $result['result'] ?? 'query_failed';
            $stat[$key] = ($stat[$key] ?? 0) + 1;
            $output->writeln(sprintf(
                '[%s] %s => %s (platform_status=%s)',
                date('Y-m-d H:i:s'),
                $result['out_trade_no'],
                $key,
                $result['status'] ?? '-'
            ));
        }

        $output->writeln('汇总：' . json_encode($stat, JSON_UNESCAPED_UNICODE));
        return 0;
    }
}
