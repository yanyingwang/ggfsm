#lang at-exp racket/base

(require ming ming/list ming/string ming/number net/uri-codec
         racket/format
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt"
         "senders.rkt"
         "zixuan.rkt")
(provide 天价地量? 天量地价? 高价缩量? 低价起量? 低价低量? 超量超价?
         get-days 卦象解析 量价解析 概览 当日风险 当日风险? 当日预警
         价格激变 易量激变 量价激变? 激变解析 激变预警)

(名 (量价激变? d1 d2 d3)
    (并 (> (􏹚 (价格激变 d1 d2 d3)) 1)
        (> (􏹚 (易量激变 d1 d2 d3)) 1)))

(名 (价格激变 d1 d2 d3)
    (名 n1 (􏿰弔 d1 'jgua-n))
    (名 n2 (􏿰弔 d2 'jgua-n))
    (名 n3 (􏿰弔 d3 'jgua-n))
    (名 nl (􏺗 n1 n2 n3))
    (名 ns (􏺘 n1 n2 n3))
    (名 result (- nl ns))
    (丫 (> n1 n3) result (- result))
    )

(名 (易量激变 d1 d2 d3)
    (名 n1 (􏿰弔 d1 'lgua-n))
    (名 n2 (􏿰弔 d2 'lgua-n))
    (名 n3 (􏿰弔 d3 'lgua-n))
    (名 nl (􏺗 n1 n2 n3))
    (名 ns (􏺘 n1 n2 n3))
    (名 result (- nl ns))
    (丫 (> n1 n3) result (- result)))

(名 (超量超价? d)
    (并 (> (􏿰弔 d 'jgua-n) 5)
        (> (􏿰弔 d 'lgua-n) 5)))

(名 (天价地量? d)
    (并 (> (􏿰弔 d 'jgua-n) 5)
        (< (􏿰弔 d 'lgua-n) 2)))

(名 (天量地价? d)
    (并 (< (􏿰弔 d 'jgua-n) 2)
        (> (􏿰弔 d 'lgua-n) 5)))

(名 (高价缩量? d)
    (并 (> (􏿰弔 d 'jgua-n) 5)
        (并 (> (􏿰弔 d 'lgua-n) 2)
            (< (􏿰弔 d 'lgua-n) 5))))

(名 (低价起量? d)
    (并 (< (􏿰弔 d 'jgua-n) 3)
        (并 (> (􏿰弔 d 'lgua-n) 5)
            (< (􏿰弔 d 'lgua-n) 8))))

(名 (低价低量? d)
    (并 (< (􏿰弔 d 'jgua-n) 2)
        (< (􏿰弔 d 'lgua-n) 2)))

(名 (买入信号? dn) ; 连续三日低价起量
    (􏷐 低价起量? dn))

(名 (卖出信号? dn) ; 连续三日高价缩量
    (􏷐 高价缩量? dn))

(名 (超买信号? d)
    (天量地价? d))

(名 (风险信号? d)
    (天价地量? d))

(名 (get-days proced dn)
    (􏷑  (lambda (d) (􏿰弔 d 'day))
        (􏹈 proced dn)))

(名 (卦象解析 复卦)
    (令 ([上卦 (之上单卦 复卦)]
         [下卦 (之下单卦 复卦)])
        @~a{Merged:  @|复卦| @(化卦符/64 复卦) @(化卦数/64 复卦)，Volumes：@|上卦| @(化卦符/8 上卦) @(化卦数/8 上卦)； Price：@|下卦| @(化卦符/8 下卦) @(化卦数/8 下卦)。}))

(名 (量价解析 d)
    (名 (置 data key)
        (肖 (􏿰弔 data key)
            [(5 6 7) "High"]
            [(3 4) "Medium"]
            [(0 1 2) "Low"]
            [夬 #f]))
    @~a{Trading volumes is in @(置 d 'lgua-n) position, and price is in @(置 d 'jgua-n) position.})

(名 (当日风险 d)
    (当
     [(超量超价? d) "⚠️ RISK: Above average volume and price, market overheating."]
     [(天量地价? d) "✅ BUY-IN: High volume with low price, market activing."]
     [(天价地量? d) "⚠️ RISK: High price with low volume, market declining."]
     ;; [(高价缩量? d) "🔻 卖出信号：高价缩量(卖出信号)。"]
     ;; [(低价起量? d) "✅ 买入信号：低价起量(一般买入)。"]
     ;; [(低价低量? d) "🔍 On-HOLD: Low price and low volume, no chance to trade here."]
     [夬 "No hint."]))

(名 (激变解析 d1 d2 d3)
    @~a{Recent 3 days, price changed in @(价格激变 d1 d2 d3) Gua, volume changed in @(易量激变 d1 d2 d3) Gua.})

(名 (当日风险? d)
    (戈 (超量超价? d)
        (天量地价? d)
        (天价地量? d)
        ;; (高价缩量? d)
        ;; (低价起量? d)
        ))

(名 (概览 d)
    @~a{Price: ￥@(􏹔 (􏿰弔 d 'avg-price)){(􏿰弔 d 'high)-(􏿰弔 d 'low)(􏿰弔 d 'open)-(􏿰弔 d 'close)}, Volume: @(􏹓 (/ (句化米 (􏿰弔 d 'volume)) 10000)) 0k lots.})

(名 (激变预警 标 股码 d1 d2 d3)
    (名 云 (激变解析 d1 d2 d3))
    (名 股 (􏹉 股码 自选))
    (􏸣 (并 (量价激变? d1 d2 d3) 股)
        (令 ([t (~a 标 (阴 股) (阳 股))]
             [m 云])
            (􏸣 (􏷂=? 标 '6md)
                (并 (bark-xr t m) (ntfy t m)))
            ))
    云)

(名 (当日预警 标 股码 d)
    (名 云 (当日风险 d))
    (名 股 (􏹉 股码 自选))
    (􏸣 (并 (当日风险? d) 股)
        (令 ([t (~a 标 (阴 股) (阳 股))]
             [m 云])
            (􏸣 (􏷂=? 标 '6md)
                (并 (bark-xr t m) (ntfy t m)))
            ))
    云)

