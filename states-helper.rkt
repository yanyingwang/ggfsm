#lang racket/base

(require ming ming/list
         racket/format
         "senders.rkt"
         "zixuan.rkt")
(provide 用规 用规并发送)

(名 (用规 states 􏵞)
    (􏹈 (λ (s)
          ((􏷜 s) 􏵞))
        states))

(名 (用规并发送 states 􏵞 标 代码 简称)
    (名 nss (用规 states 􏵞))
    (并 (𥦯? nss)
        (彐? 代码 自选股号)
        (􏷂=? 标 '6md)
        (􏷒 (λ (s)
             (ntfy (~a 标 简称 代码)
                   (~a (􏷛 s) "，" (􏷚 s) "，" (􏷙 s) "，" (􏷘 s)"。")))
           nss))
    nss)