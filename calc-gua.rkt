#lang at-exp racket/base

(require racket/format
         racket/list
         racket/symbol
         racket/math
         "8gua.rkt"
         "64gua.rkt"
         "gua-helper.rkt")

(provide set-gua-of-price set-gua-of-volume set-gua-of-merged set-gua
         find-top-price find-bottom-price find-top-volume find-bottom-volume
         find-gua-data calculate-price-amplitude normalize-price)

;; =======================
;; ** 数据分析函数 **
;; =======================

;; 获取最高价
(define (find-top-price data)
  (apply argmax (map (λ (e) (string->number (hash-ref e 'high))) data)))

;; 获取最低价
(define (find-bottom-price data)
  (apply argmin (map (λ (e) (string->number (hash-ref e 'low))) data)))

;; 获取最高成交量
(define (find-top-volume data)
  (apply argmax (map (λ (e) (string->number (hash-ref e 'volume))) data)))

;; 获取最低成交量
(define (find-bottom-volume data)
  (apply argmin (map (λ (e) (string->number (hash-ref e 'volume))) data)))

;; 计算价格振幅
(define (calculate-price-amplitude high low)
  (- (string->number high) (string->number low)))

;; 计算平均价格
(define (find-average-price data)
  (let* ([prices (map (λ (e) (/ (+ (string->number (hash-ref e 'high))
                                   (string->number (hash-ref e 'low)))
                                2))
                      data)])
    (/ (apply + prices) (length prices))))

;; 计算中位数价格
(define (find-median-price data)
  (let* ([prices (sort (map (λ (e) (/ (+ (string->number (hash-ref e 'high))
                                         (string->number (hash-ref e 'low)))
                                      2))
                            data)
                       <)]
         [mid (quotient (length prices) 2)])
    (if (odd? (length prices))
        (list-ref prices mid)
        (/ (+ (list-ref prices mid) (list-ref prices (sub1 mid))) 2))))

;; 归一化价格，使其映射到 [0, 1] 区间
(define (normalize-price price top bottom)
  (/ (- price bottom) (- top bottom)))

;; 过滤八卦数据
(define (filter-gua-data data gua)
  (filter (λ (H) (symbol=? (hash-ref H 'price-gua) gua)) data))

;; 查找指定卦象的数据
(define (find-gua-data data gua)
  (findf (λ (H) (symbol=? (hash-ref H 'price-gua) gua)) data))


;; =======================
;; ** 计算八卦函数 **
;; =======================

;; 计算价格的卦象
(define (set-gua-of-price H top-price bottom-price)
  (let* ([step-price (/ (- top-price bottom-price) 64)]
         [ordered-gua (build-list 64 (λ (N) (+ bottom-price (* step-price (add1 N)))))]
         [average-price (/ (+ (string->number (hash-ref H 'low))
                              (string->number (hash-ref H 'high))) 2)]
         [gua-of-price (list-ref gua64 (index-where ordered-gua (λ (p) (>= p average-price))))])
    (hash-set* H 'avg-price average-price 'jgua gua-of-price)))

;; 计算成交量的卦象
(define (set-gua-of-volume H top-volume bottom-volume)
  (let* ([step-volume (/ (- top-volume bottom-volume) 64)]
         [ordered-gua (build-list 64 (λ (N) (+ bottom-volume (* step-volume (add1 N)))))]
         [real-volume (string->number (hash-ref H 'volume))]
         [gua-of-volume (list-ref gua64 (index-where ordered-gua (λ (l) (>= l real-volume))))])
    (hash-set* H 'lgua gua-of-volume)))

;; 计算合并后的卦象
(define (set-gua-of-merged H)
  (let* ([up-gua (down-single-gua (hash-ref H 'lgua))]
         [down-gua (down-single-gua (hash-ref H 'jgua))]
         [merged-gua (overlapped-gua up-gua down-gua)])
    (hash-set*! H
      'bgua merged-gua
      'bgua-n (list-index gua64 merged-gua)
      'lgua-n (list-index 8gua up-gua)
      'jgua-n (list-index 8gua down-gua))))

;; 批量计算数据的八卦信息
(define (set-gua data)
  (let* ([top-price (find-top-price data)]
         [bottom-price (find-bottom-price data)]
         [top-volume (find-top-volume data)]
         [bottom-volume (find-bottom-volume data)])
    (map (λ (H)
           (set-gua-of-merged
            (set-gua-of-volume
             (set-gua-of-price H top-price bottom-price)
             top-volume bottom-volume)))
         data)))

;; ;; =======================
;; ;; ** 测试 **
;; ;; =======================
;; (define test-data
;;   (list (hash 'high "120" 'low "110" 'volume "5000")
;;         (hash 'high "130" 'low "115" 'volume "6000")
;;         (hash 'high "125" 'low "118" 'volume "5500")))

;; (define processed-data (set-gua test-data))

;; (for-each
;;  (λ (H)
;;    (printf "平均价格: ~a, 价格卦象: ~a, 成交量卦象: ~a, 合并卦象: ~a~n"
;;            (hash-ref H 'avg-price)
;;            (hash-ref H 'jgua)
;;            (hash-ref H 'lgua)
;;            (hash-ref H 'bgua)))
;;  processed-data)