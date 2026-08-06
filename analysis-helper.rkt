#lang at-exp racket/base

(require ming ming/list ming/string ming/number
         racket/format
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt"
         "senders.rkt"
         "zixuan.rkt"
         "rules.rkt"
         "rules-helper.rkt"
         "data-helper.rkt")

(provide 卦象详情 量价详情 激变解析 量价解析
         发送提醒
         )

(名 (卦象详情 H)
    (令* ([复卦 (􏿰弔 H 'mgua)]
          [上卦 (之上单卦 复卦)]
          [下卦 (之下单卦 复卦)])
         @~a{@|复卦| @(化卦符/64 复卦) @(化卦数/64 复卦)。量：@|上卦| @(化卦符/8 上卦) @(化卦数/8 上卦)； 价：@|下卦| @(化卦符/8 下卦) @(化卦数/8 下卦)。}))

(名 (量价详情 H)
    @~a{量: @(􏹓 (/ (􏿰弔 H 'volume) 10000))万手。价: ￥@(􏿰弔 H 'avg-price), ↑@(􏿰弔 H 'high)-@(􏿰弔 H 'low)↓, →@(􏿰弔 H 'open)-@(􏿰弔 H 'close)←。})
(名 (量价解析 H)
    @~a{
        P：@(P H), ΔP：@(dP H)。
        V：@(V H)，ΔV：@(dV H)。
        p: @(p H)，Δp：@(dp H)。
        v：@(v H)，Δv：@(dv H)。}
    )

(名 (价格激变 L)
    (名 h1 (􏷜 L))
    (名 h2 (􏷛 L))
    (名 h3 (􏷚 L))
    (名 n1 (􏿰弔 h1 'p8gua-n))
    (名 n2 (􏿰弔 h2 'p8gua-n))
    (名 n3 (􏿰弔 h3 'p8gua-n))
    (名 nl (􏺗 n1 n2 n3))
    (名 ns (􏺘 n1 n2 n3))
    (名 result (- nl ns))
    (丫 (> n1 n3) result (- result)))
(名 (易量激变 L)
    (名 h1 (􏷜 L))
    (名 h2 (􏷛 L))
    (名 h3 (􏷚 L))
    (名 n1 (􏿰弔 h1 'v8gua-n))
    (名 n2 (􏿰弔 h2 'v8gua-n))
    (名 n3 (􏿰弔 h3 'v8gua-n))
    (名 nl (􏺗 n1 n2 n3))
    (名 ns (􏺘 n1 n2 n3))
    (名 result (- nl ns))
    (丫 (> n1 n3) result (- result)))
(名 (激变解析 L)
    @~a{近三日，价易@(价格激变 L)卦, 量易@(易量激变 L)卦。})

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
