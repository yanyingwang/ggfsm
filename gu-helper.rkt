#lang racket/base

(require "hs300.rkt"
         "zz500.rkt"
         "sz50.rkt"
         "sc500.rkt"
         racket/format
         ming ming/number ming/string ming/list
         )

(provide 板块 股指)



(名 (板块 号)
    (尚 (句􏾝 号 0 3)
        [("600" "601" "603") '沪市A股]
        [("900") '沪市B股]
        [("000") '深市A股]
        [("200") '深市B股]
        [("688") '科创板]
        [("300") '创业板]
        [("002") '中小板]
     ))

;; (名 早期上市股 '("6006"))

(名 (股指 号)
    (􏺈
     (􏹈 (λ (P)
           (􏹋 号 (阴 P)))
         (􏿳 "沪深300" (佫 甲 hs300)
             "中证500" (佫 甲 zz500)
             "上证50" (佫 甲 sz50)
             "深成500" (佫 甲 sc500))))

    )