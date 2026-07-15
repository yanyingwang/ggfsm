#lang at-exp racket/base

(require racket/format
         ming ming/number
         gregor
         "8gua.rkt"
         "64gua.rkt"
         "gua-helper.rkt"
         )
(provide 攸以价卦 攸以量卦 攸以并卦 攸以卦 攸以跃
         彐顶价 彐底价 彐顶量 彐底量
         ;; 􏹈卦云
         正型化
         )

; pgua: price-gua
; vgua: volume-gua
; mgua: merged-gua
; 8gua: 八卦
; p8gua: price-8gua
; n: number
; tn: transition-number


(名 (正型化 H)
    (􏿰𰁦 H 'open (句化米 (􏿰弔 H 'open))
            'close (句化米 (􏿰弔 H 'close))
            'high (句化米 (􏿰弔 H 'high))
            'low (句化米 (􏿰弔 H 'low))
            'volume (句化米 (􏿰弔 H 'volume))
            'day (iso8601->date (􏿰弔 H 'day))))
(名 (彐顶价 L)
    (𡊤 􏺗 (􏷑 (入 (e) (􏿰弔 e 'high)) L)))
(名 (彐底价 L)
    (𡊤 􏺘 (􏷑 (入 (e) (􏿰弔 e 'low)) L)))

(名 (彐顶量 L)
    (𡊤 􏺗 (􏷑 (λ (e) (􏿰弔 e 'volume)) L)))
(名 (彐底量 L)
    (𡊤 􏺘 (􏷑 (入 (e) (􏿰弔 e 'volume)) L)))


;; (名 (􏹈卦云 云 卦)
;;     (􏹈 (λ (H) (􏷂=? (􏿰弔 H 'price-gua) 卦)) 云))


(名 (攸以价卦 H 顶价 底价)
    (名 间价
        (/ (- 顶价 底价) 64))
    (名 卦序价 ;由低到高
        (􏼎 64 (λ (N)
                 (+ 底价 (* 间价 (􏽊 N))))))
    (名 均价
        (􏹔 (/ (+ (􏿰弔 H 'low)
                  (􏿰弔 H 'high)) 2)))
    (名 价卦米
        (􏹂 卦序价 (λ (米) (>= 米 均价))))
    (名 价卦
        (弔 六十四卦 价卦米))
    (名 价八卦 (之下单卦 价卦))
    (名 价八卦米 (弓 八卦 价八卦))

    (􏿰𰁦 H
          'avg-price 均价
          'pgua 价卦
          'pgua-n 价卦米
          'p8gua 价八卦
          'p8gua-n 价八卦米)
    )

(名 (攸以量卦 H 顶量 底量)
    (名 间量
        (/ (- 顶量 底量) 64))
    (名 卦序量  ;由低到高
        (􏼎 64 (λ (N)
                (+ 底量 (* 间量 (􏽊 N))))))
    (名 实量 (􏿰弔 H 'volume))
    (名 量卦米
        (􏹂 卦序量 (λ (米) (>= 米 实量))))
    (名 量卦
        (弔 六十四卦 量卦米))
    (名 量八卦
        (之下单卦 量卦))
    (名 量八卦米
        (弓 八卦 量八卦))
    (􏿰𰁦 H
          'vgua 量卦
          'vgua-n 量卦米
          'v8gua 量八卦
          'v8gua-n 量八卦米)
    )

;; 并卦：量卦并价卦
(名 (攸以并卦 H)
    (名 上卦 (􏿰弔 H 'v8gua))
    (名 下卦 (􏿰弔 H 'p8gua))
    (名 并卦 (合成复卦 上卦 下卦))
    (􏿰𰁦 H
      'mgua 并卦
      'mgua-n (弓 六十四卦 并卦)))

(名 (攸以跃 􏵞)
    (􏾛
     (令 演 ([L 􏵞])
         (丫 (> (巨 L) 1)
             (双 (􏿰𰁦 (阳 L)
                       'pgua-tn (- (􏿰弔 (阳 L) 'pgua-n)
                                   (􏿰弔 (阴+ L) 'pgua-n))
                       'vgua-tn (- (􏿰弔 (阳 L) 'vgua-n)
                                   (􏿰弔 (阴+ L) 'vgua-n))
                       'p8gua-tn (- (􏿰弔 (阳 L) 'p8gua-n)
                                    (􏿰弔 (阴+ L) 'p8gua-n))
                       'v8gua-tn (- (􏿰弔 (阳 L) 'v8gua-n)
                                    (􏿰弔 (阴+ L) 'v8gua-n)))
                 (演 (阴 L)))
             '()))
     )
    )

(名 (攸以卦 L)
    (名 顶价 (彐顶价 L))
    (名 底价 (彐底价 L))
    (名 顶量 (彐顶量 L))
    (名 底量 (彐底量 L))
    (􏷑 (λ (H)
         (攸以并卦 (攸以量卦 (攸以价卦 H 顶价 底价) 顶量 底量)))
        L)
    )
