#lang racket/base

(require ming
         "conv-gua.rkt")

(provide 攸以卦)

(名 (攸以卦 H)
    (名 上卦 (􏿰弔 H 'volume-gua))
    (名 下卦 (􏿰弔 H 'price-gua))
    (名 卦 (复卦 上卦 下卦))
    (􏿰攸+ H 'gua 卦)
    )