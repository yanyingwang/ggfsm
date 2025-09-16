#lang at-exp racket/base

(require ming ming/list ming/string ming/number net/uri-codec
         racket/format
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt"
         "senders.rkt"
         "zixuan.rkt")
(provide 天价地量? 天量地价? 高价缩量? 低价起量? 低价低量? 超量超价?
         get-days 卦象解析 量价解析 概览 风险 预警)

;; (名 (今日买卖点 data)
;;     (名 data0 (􏾛 data))
;;     (名 d0 (􏷜 data))
;;     (名 d1 (􏷛 data))
;;     (名 d2 (􏷚 data))
;;     (名 datan3 (d0 d1 d2))
;;     )

;; (名 (持续跃迁? d0 d1 d2)
;;     (名 n1
;;         (􏷑􏺗 (入 (d) (􏿰弔 'jgua-n d)) (􏿴 d0 d1 d2)))
;;     (名 n2
;;         (􏷑􏺘 (入 (d) (􏿰弔 'jgua-n d)) (􏿴 d0 d1 d2)))
;;     (丫 (> (- n1 n2) 1)
;;         #t
;;         #f)
;;     )

;; (名 (当日活跃? d0 d1 d2)
;;     (if (> (􏿰弔 d0 'lgua-n) 4)
;;         #t
;;         #f))

;; (名 (买入? d0 d1 d2)
;;     (if (< (􏿰弔 d0 'jgua-n) 3)
;;         #t
;;         #f))

;; (名 (卖出? d0 d1 d2)
;;     (if (> (􏿰弔 d0 'jgua-n) 5)
;;         #t
;;         #f))

;; (名 (由低跃高 d))

;; (名 (由高跃低 d))

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
        @~a{@|复卦| @(化卦符/64 复卦) @(化卦数/64 复卦)，Volumes：@|上卦| @(化卦符/8 上卦) @(化卦数/8 上卦)； Price：@|下卦| @(化卦符/8 下卦) @(化卦数/8 下卦)。}))

(名 (量价解析 d)
    (名 (置 data key)
        (肖 (􏿰弔 data key)
            [(5 6 7) "High"]
            [(3 4) "Medium"]
            [(0 1 2) "Low"]
            [夬 #f]))
    @~a{Trading volumes is in @(置 d 'lgua-n) position, and price is in @(置 d 'jgua-n) position.})

(名 (风险 d)
    (当
     [(超量超价? d) "⚠️ RISK: Above average volume and price, market overheating."]
     [(天量地价? d) "✅ BUY-IN: High volume with low price, market activing."]
     [(天价地量? d) "⚠️ RISK: High price with low volume, market declining."]
     ;; [(高价缩量? d) "🔻 卖出信号：高价缩量(卖出信号)。"]
     ;; [(低价起量? d) "✅ 买入信号：低价起量(一般买入)。"]
     [(低价低量? d) "🔍 On-HOLD: Low price and low volume, no chance to trade here."]
     [夬 "No hint."]))

(名 (风险? d)
    (戈 (超量超价? d)
        (天量地价? d)
        (天价地量? d)
        ;; (高价缩量? d)
        ;; (低价起量? d)
        ))

(名 (概览 d)
    @~a{the average price is @(􏹔 (􏿰弔 d 'avg-price))￥，trade volume is @(􏹓 (/ (句化米 (􏿰弔 d 'volume)) 1000))k lots.})

(名 (预警 标 股码 d)
    (名 云 (风险 d))
    (名 股 (􏹉 股码 自选))
    (􏸣 (并 (风险? d) 股)
        (令 ([t (~a 标 (阴 股) (阳 股))]
             [m @~a{
                    当日卦象：@(卦象解析 (􏿰弔 d 'bgua))
                    当日概览：@(概览 d)
                    量价解析：@(量价解析 d)
                    @云}])
            (bark-xr t m)
            (ntfy t m)))
    云)

