#lang racket/base

(require ming ming/list ming/string
         racket/format
         "senders.rkt"
         "zixuan.rkt")
(provide 用规 规化句 规化句0)

(名 (用规 rules 􏵞)
    (􏹈 (λ (s)
          ((􏷜 s) 􏵞))
        rules))

(名 (规化句 s)
    (~a "・" (􏷛 s) "，" (􏷚 s) "，" (􏷙 s) "，" (􏷘 s)"。"))
(名 (规化句0 s)
    (~a (􏷛 s) "，" (􏷚 s) "。"))
