#lang at-exp racket/base

(require ming ming/list ming/string ming/number net/uri-codec
         racket/format
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt"
         "senders.rkt"
         "zixuan.rkt")
(provide )



(名 (pgua-n H)
    (􏿰弔 H 'pgua-n))
(名 (vgua-n H)
    (􏿰弔 H 'vgua-n))
(名 (pgua-tn H)
    (􏿰弔 H 'pgua-tn))
(名 (vgua-tn H)
    (􏿰弔 H 'vgua-tn))
(名 (p8gua-n H)
    (􏿰弔 H 'p8gua-n))
(名 (v8gua-n H)
    (􏿰弔 H 'v8gua-n))
(名 (p8gua-tn H)
    (􏿰弔 H 'p8gua-tn))
(名 (v8gua-tn H)
    (􏿰弔 H 'v8gua-tn))


;; 市场状态（Market States）
;; 这是最基础的一层，不产生交易信号。
;; ID	中文	English	判断条件
;; ST1	价低位	Price Bottom Zone	p8gua-n <= 1
;; ST2	价中位	Price Middle Zone	2 <= p8gua-n <= 4
;; ST3	价高位	Price Upper Zone	p8gua-n >= 5
;; ST4	量低位	Low Volume	v8gua-n <= 1
;; ST5	量中位	Normal Volume	2 <= v8gua-n <= 4
;; ST6	量高位	High Volume	v8gua-n >= 5
(名 (价底位 H)
    (<= (p8gua-n H) 1))
(名 (价中位 H)
    (并 (>= (p8gua-n H) 2)
        (<= (p8gua-n H) 4)))
(名 (价高位 H)
    (并 (>= (p8gua-n H) 2)
        (<= (p8gua-n H) 4)))
(名 (量底位 H)
    (<= (v8gua-n H) 1))
(名 (量中位 H)
    (并 (>= (v8gua-n H) 2)
        (<= (v8gua-n H) 4)))
(名 (量高位 H)
    (并 (>= (v8gua-n H) 2)
        (<= (v8gua-n H) 4)))

;; 跃迁状态（Transition States）
;; 这是GGFSM最核心的一层。
;; Price Transition
;; ID	中文	English	判断
;; PT1	强涨迁  	Strong Price Transition Up	p8gua-tn >= 2
;; PT2	上涨迁  	Price Transition Up    	p8gua-tn = 1
;; PT3	横稳定  	Stable Price Transition	p8gua-tn = 0
;; PT4	下跌迁  	Price Transition Down   	p8gua-tn = -1
;; PT5	强跌迁  	Strong Price Transition Down	p8gua-tn <= -2
(名 (强涨迁 H)
    (>= (p8gua-tn H) 2))
(名 (上涨迁 H)
    (= (p8gua-tn H) 1))
(名 (横稳定 H)
    (= (p8gua-tn H) 0))
(名 (下跌迁 H)
    (= (p8gua-tn H) -1))
(名 (强跌迁 H)
    (<= (p8gua-tn H) -2))

;; Fine Price Transition
;; ID	中文	English	判断
;; FPT1	价强迁	Strong Fine Price Transition	pgua-tn >= 5
;; FPT2	价中迁	Medium Fine Price Transition	2 <= pgua-tn < 5
;; FPT3	价微易	Minor Fine Price Transition	-2 < pgua-tn < 2
;; FPT4	价中落	Medium Fine Price Decline	-5 < pgua-tn <= -2
;; FPT5	价强落	Strong Fine Price Decline	pgua-tn <= -5
