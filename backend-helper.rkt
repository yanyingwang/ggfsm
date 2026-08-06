#lang racket/base

(require ming ming/list ming/string
         racket/format
         "senders.rkt"
         "zixuan.rkt"
         "rules.rkt"
         "rules-helper.rkt")


(名 (发送提醒 􏵞 标 代码 简称)
    (名 stt1 (用规 BSs 􏵞))
    (名 stt2 (用规 WCs 􏵞))
    (名 标题 (~a 标 简称 代码))
    (名 内容 (~a (􏿴􏵷句 (􏷑 规化句 stt1) "\n")
                 "\n观测指标：\n"
                 (􏿴􏵷句 (􏷑 规化句 stt2) "\n")))
    (并 (𥦯? stt1)
        (彐? 代码 自选股号)
        (􏷂=? 标 '6md)
        (ntfy 标题 内容)))
