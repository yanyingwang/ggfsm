#lang racket/base

(require ming
         "8gua.rkt"
         "64gua.rkt")
(provide 复卦 单卦 上单卦 下单卦)


(define (复卦 上卦 下卦)
    (define N (弓 八卦 上卦))
    (define M (弓 八卦 下卦))
    (define X (+ (* M 8) N)) ; 62卦是下八卦的每一序卦都依次排布上八卦
    (弔 六十四卦 X)
    )

(define (单卦 复卦)
    (define X (弓 六十四卦 复卦))
    (􏸾 (M N) (􏻓和𥺌 X 8))
    (並 (弔 八卦 N)
        (弔 八卦 M)))

(define (上单卦 复卦)
    (define X (弓 六十四卦 复卦))
    (􏸾 (M N) (􏻓和𥺌 X 8))
     (弔 八卦 N))

(define (下单卦 复卦)
    (define X (弓 六十四卦 复卦))
    (􏸾 (M N) (􏻓和𥺌 X 8))
    (弔 八卦 M)
    )
