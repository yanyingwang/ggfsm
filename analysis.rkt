
#lang at-exp racket/base

(require ming ming/list
         racket/format
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt")
(provide top-price-bottom-volume? top-volume-bottom-price? high-price-shrinked-volume? low-price-voting-volume? low-price-low-volume? top-price-top-volume?
         get-days analysis-gua analysis-relationship-of-volume-price)

(define (top-price-top-volume? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (> (hash-ref d 'lgua-n) 5)))

(define (top-price-bottom-volume? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (< (hash-ref d 'lgua-n) 2)))

(define (top-volume-bottom-price? d)
  (or (< (hash-ref d 'jgua-n) 2)
      (> (hash-ref d 'lgua-n) 5)))

(define (high-price-shrinked-volume? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (or (> (hash-ref d 'lgua-n) 2)
          (< (hash-ref d 'lgua-n) 5))))

(define (low-price-voting-volume? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (or (> (hash-ref d 'lgua-n) 2)
          (< (hash-ref d 'lgua-n) 5))))

(define (low-price-low-volume? d)
  (or (< (hash-ref d 'jgua-n) 2)
      (< (hash-ref d 'lgua-n) 2)))

(define (single-of-buy-in? dn) ; three days of voting on volumes
  (andmap low-price-voting-volume? dn))

(define (single-of-sell-out? dn) ; three consecutive days of shrinking volumes
  (andmap high-price-shrinked-volume? dn))

(define (single-of-great-buy-in? d)
    (top-volume-bottom-price? d))

(define (single-of-risking? d)
    (top-price-bottom-volume? d))

(define (get-days proced dn)
  (map  (lambda (d) (hash-ref d 'day))
        (filter proced dn)))

(define (analysis-gua overlapped-gua)
  @~a{最近一个交易日卦象（overlapped-gua）为: @|overlapped-gua|，序号为：@(list-ref gua64 overlapped-gua)。拆解后，其single-up-gua（量卦）为： @(single-up-gua overlapped-gua)，序号是：@(list-ref gua8 (single-up-gua overlapped-gua))；其single-down-gua（价卦）为： @(single-down-gua overlapped-gua)，序号是：@(list-ref gua8 (single-down-gua overlapped-gua))。})

(define (analysis-relationship-of-volume-price d)
    (define (converting data key)
      (case (hash-ref data key)
            [(5 6 7) "高"]
            [(3 4) "中"]
            [(0 1 2) "低"]
            [else #f]))
  (define (risk d)
        (cond
         [(top-price-top-volume? d) "风险提示：超量超价(多方买入)。"]
         [(top-volume-bottom-price? d) "买入信号：天量地价(超强买入)，可以入场。"]
         [(top-price-bottom-volume? d) "风险提示：天价地量，需密切关注，如已购入，建议减仓。"]
         [(high-price-shrinked-volume? d) "卖出信号：高价缩量(卖出信号)。"]
         [(low-price-voting-volume? d) "买入信号：低价起量(一般买入)。"]
         [(low-price-low-volume? d) "观望市场：低价低量(市场低靡), 不建议操作。"]
         [else "无异常，观望市场。"])
        )
  @~a{@(hash-ref d 'day)当日，本股交易量位于@(converting d 'lgua-n)位，价格位于@(converting d 'jgua-n)位。@(risk d)})