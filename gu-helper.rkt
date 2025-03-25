#lang racket/base

(require "hs300.rkt"
         "zz500.rkt"
         "sz50.rkt"
         "sc500.rkt"
         racket/format
         ming ming/number ming/string racket/string ming/list racket/list
         )

(provide industry stock-index)


(define (industry code)
  (case (substring code 0 3)
    (case (substring code 0 3)
      [("600" "601" "603") '沪市A股]
      [("900") '沪市B股]
      [("000") '深市A股]
      [("200") '深市B股]
      [("688") '科创板]
      [("300") '创业板]
      [("002") '中小板]
      ))

  (define earlier-IPO '("6006"))

  (define (stock-index code)
    (map car
     (filter (λ (P)
               (member code (cdr P)))
             (association-list "沪深300" (map first hs300)
                               "中证500" (map first zz500)
                               "上证50" (map first sz50)
                               "深成500" (map first sc500))))
    (findf (λ (P)
             (find-cars code (cdr P)))
           (association-list "沪深300" (map first hs300)
                             "中证500" (map first zz500)
                             "上证50" (map first sz50)
                             "深成500" (map first sc500))))

  )
