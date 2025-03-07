#lang racket/base

(require "hs300.rkt"
         "zz500.rkt"
         "sz50.rkt"
         "sc500.rkt"
         racket/format
         ming ming/number ming/string racket/string ming/list racket/list
         )

(provide 板块 股指)



(名 (板块 号)
    (case (substring 号 0 3)
      (肖 (邭 号 0 3)
          [("600" "601" "603") '沪市A股]
        [("900") '沪市B股]
        [("000") '深市A股]
        [("200") '深市B股]
        [("688") '科创板]
        [("300") '创业板]
        [("002") '中小板]
        ))

;; (define 早期上市股 '("6006"))

(define (股指 号)
    (􏺈
     (filter (λ (P)
           (member 号 (cdr P)))
         (􏿳 "沪深300" (map first hs300)
             "中证500" (map first zz500)
             "上证50" (map first sz50)
             "深成500" (map first sc500))))
  (􏹈 (λ (P)
           (􏹋 号 (阴 P)))
         (􏿳 "沪深300" (􏷑 􏷜 hs300)
             "中证500" (􏷑 􏷜 zz500)
             "上证50" (􏷑 􏷜 sz50)
             "深成500" (􏷑 􏷜 sc500))))

    )