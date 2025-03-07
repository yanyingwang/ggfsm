#lang at-exp racket/base

(require racket/format
         ming ming/number racket/list racket/symbol
         "8gua.rkt" "64gua.rkt" "gua-helper.rkt")
(provide 攸以价卦 攸以量卦 攸以并卦 攸以卦
         彐顶价 彐底价 彐顶量 彐底量 􏹈卦文)

(define (彐顶价 文)
    (apply argmax (map (入 (e) (string->number (hash-ref e 'high))) 文)))
(define (彐底价 文)
    (apply  argmin (map (入 (e) (string->number (hash-ref e 'low))) 文)))

(define (彐顶量 文)
    (apply argmax (map (λ (e) (string->number (hash-ref e 'volume))) 文)))
(define (彐底量 文)
    (apply  argmin (map (入 (e) (string->number (hash-ref e 'volume))) 文)))

(define (filter  卦文 文 卦)
    (filter (λ (H) (symbol=? (hash-ref H 'price-gua) 卦)) 文))

(define (彐顶价 文)
    (𡊤 􏺗 (􏷑 (入 (e) (句化米 (􏿰弔 e 'high))) 文)))
(define (彐底价 文)
    (𡊤 􏺘 (􏷑 (入 (e) (句化米 (􏿰弔 e 'low))) 文)))

(define (彐顶量 文)
    (𡊤 􏺗 (􏷑 (λ (e) (句化米 (􏿰弔 e 'volume))) 文)))
(define (彐底量 文)
    (𡊤 􏺘 (􏷑 (入 (e) (句化米 (􏿰弔 e 'volume))) 文)))
(define (􏹈卦文 文 卦)
    (􏹈 (λ (H) (􏷂=? (􏿰弔 H 'price-gua) 卦)) 文))
(define (攸以价卦 H 顶价 底价)
    (define 间价
        (/ (- 顶价 底价) 64))
    (define 卦序价 ;由低到高
        (build-list 64 (λ (N)
                 (+ 底价 (* 间价 (add1 N))))))
    (define 均价
        (/ (+ (string->number (hash-ref H 'low))
              (string->number (hash-ref H 'high))) 2))
    (define 价卦
        (list-ref 六十四卦 (index-where 卦序价 (λ (价) (>= 价 均价)))))
    (hash-set* H 'avg-price 均价 'jgua 价卦)
    )
(define (攸以量卦 H 顶量 底量)
    (define 间量
        (/ (- 顶量 底量) 64))
    (define 卦序量  ;由低到高
        (build-list 64 (λ (N)
                (+ 底量 (* 间量 (add1 N))))))
    (define 实量 (string->number (hash-ref H 'volume)))
    (define 量卦
        (list-ref 六十四卦 (index-where 卦序量 (λ (量) (>= 量 实量)))))
    (hash-set H 'lgua 量卦)
    )
;; 并卦：量卦并价卦
(define (攸以并卦 H)
    (define 上卦 (下单卦 (hash-ref H 'lgua)))
    (define 下卦 (下单卦 (hash-ref H 'jgua)))
    (define 并卦 (复卦 上卦 下卦))
    (hash-set* H 'bgua 并卦)
    )
(define (攸以卦 文)
    (define 顶价 (彐顶价 文))
    (define 底价 (彐底价 文))
    (define 顶量 (彐顶量 文))
    (define 底量 (彐底量 文))
    (map (λ (H)

(define (攸以并卦 H)
    (define 上卦 (下单卦 (􏿰弔 H 'lgua)))
    (define 下卦 (下单卦 (􏿰弔 H 'jgua)))
    (define 并卦 (复卦 上卦 下卦))
    (􏿰攸+ H
      'bgua 并卦
      'bgua-n (弓 六十四卦 并卦)
      'lgua-n (弓 八卦 上卦)
      'jgua-n (弓 八卦 下卦))
    )

(define (攸以卦 文)
    (define 顶价 (彐顶价 文))
    (define 底价 (彐底价 文))
    (define 顶量 (彐顶量 文))
    (define 底量 (彐底量 文))
    (􏷑 (λ (H)
         (攸以并卦 (攸以量卦 (攸以价卦 H 顶价 底价)
                              顶量 底量)))
        文)
    )
