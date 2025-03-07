#lang at-exp racket/base

(require ming racket/list

(require ming
         racket/format

         "8gua.rkt"
         "64gua.rkt")
(provide 复卦 单卦 上单卦 下单卦)


(define (复卦 上卦 下卦)
    (define N (index-of 八卦 上卦))
    (define M (index-of 八卦 下卦))
    (define X (+ (* M 8) N)) ; 62卦是下八卦的每一序卦都依次排布上八卦
    (list-ref 六十四卦 X)
    )

(define (单卦 复卦)
    (define X (index-of 六十四卦 复卦))
    (􏸾 (M N) (􏻓和𥺌 X 8))
    (並 (list-ref 八卦 N)
        (list-ref 八卦 M)))

(define (上单卦 复卦)
    (define X (index-of 六十四卦 复卦))
    (􏸾 (M N) (􏻓和𥺌 X 8))
     (list-ref 八卦 N))

(define (下单卦 复卦)
    (define X (index-of 六十四卦 复卦))
    (􏸾 (M N) (􏻓和𥺌 X 8))
    (list-ref 八卦 M)
    )

