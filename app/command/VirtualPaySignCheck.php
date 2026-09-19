<?php
declare(strict_types=1);

namespace app\command;

use app\service\VirtualPayService;
use think\console\Command;
use think\console\Input;
use think\console\Output;

/**
 * 签名自检：与官方文档（企业版 2.6 节）给出的签名示例逐位比对
 *
 * 验收清单第 8 条「服务器验签逻辑通过（签名函数与官方文档签名示例核对一致）」
 * 运行：php think virtualpay:signcheck
 */
class VirtualPaySignCheck extends Command
{
    protected function configure(): void
    {
        $this->setName('virtualpay:signcheck')
            ->setDescription('校验 paySig / signature 签名函数与微信官方示例是否一致');
    }

    protected function execute(Input $input, Output $output): int
    {
        $res    = VirtualPayService::selfCheckSignature();
        $detail = $res['detail'];

        foreach (['pay_sig', 'signature'] as $name) {
            $item = $detail[$name];
            $output->writeln(sprintf(
                '%-10s %s',
                $name,
                $item['match'] ? 'PASS' : 'FAIL'
            ));
            $output->writeln('  expected: ' . $item['expected']);
            $output->writeln('  actual  : ' . $item['actual']);
        }

        $output->writeln($res['ok']
            ? '结果：签名算法与官方示例一致'
            : '结果：签名算法与官方示例不一致，请检查 hash_hmac 实现');

        return $res['ok'] ? 0 : 1;
    }
}
