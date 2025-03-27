#lang racket/base

(require rackunit json "../calc-gua.rkt")  ;; 引入被测模块

;; ** 测试数据准备 **
(define mock-data
  (list
   (hasheq 'high "100.0" 'low "90.0" 'volume "5000")
   (hasheq 'high "110.0" 'low "95.0" 'volume "6000")
   (hasheq 'high "120.0" 'low "80.0" 'volume "4000")
   (hasheq 'high "130.0" 'low "85.0" 'volume "7000")
   (hasheq 'high "90.0"  'low "70.0" 'volume "3000")))

;; 生成随机测试数据
(define (generate-random-data n)
  (for/list ([i n])
    (hasheq 'high (number->string (+ 80 (random 20 150)))
            'low (number->string (+ 60 (random 10 100)))
            'volume (number->string (+ 3000 (random 2000 10000))))))

(define random-data (generate-random-data 10)) ;; 生成10组随机数据

;; ** 单元测试 **
(define (test-find-price-volume)
  (check-equal? (find-top-price mock-data) (fourth mock-data) "最高价测试")
  (check-equal? (find-bottom-price mock-data) (fifth mock-data) "最低价测试")
  (check-equal? (find-top-volume mock-data) (fourth mock-data) "最高成交量测试")
  (check-equal? (find-bottom-volume mock-data) (fifth mock-data) "最低成交量测试"))

(define (test-price-amplitude)
  (check-equal? (calculate-price-amplitude "120.0" "80.0") 40.0 "计算振幅测试")
  (check-equal? (calculate-price-amplitude "140.0" "100.0") 40.0 "计算振幅测试"))

(define (test-statistics)
  (check-equal? (find-average-price mock-data) 101.67 0.01 "均价计算测试")
  (check-equal? (find-median-price mock-data) 100.0 "中位数计算测试"))

(define (test-normalization)
  (check-equal? (normalize-price 100.0 140.0 80.0) 0.3333 0.001 "归一化测试")
  (check-equal? (normalize-price 80.0 140.0 80.0) 0.0 "归一化边界测试")
  (check-equal? (normalize-price 140.0 140.0 80.0) 1.0 "归一化边界测试"))

(define (test-gua-calculations)
  (define H (hasheq 'high "110.0" 'low "90.0" 'volume "6000"))
  (set-gua-of-price H 140.0 80.0)
  (check-true (hash-has-key? H 'avg-price) "价格卦象计算")
  (check-true (hash-has-key? H 'jgua) "价格卦象赋值")

  (set-gua-of-volume H 10000.0 3000.0)
  (check-true (hash-has-key? H 'lgua) "成交量卦象计算")

  (set-gua-of-merged H)
  (check-true (hash-has-key? H 'bgua) "合并卦象计算")
  (check-true (hash-has-key? H 'bgua-n) "合并卦象编号")
  (check-true (hash-has-key? H 'lgua-n) "成交量卦象编号")
  (check-true (hash-has-key? H 'jgua-n) "价格卦象编号"))

(define (test-batch-gua)
  (define enriched-data (set-gua mock-data))
  (check-true (every? (λ (H) (hash-has-key? H 'bgua)) enriched-data) "批量卦象计算")
  (check-true (every? (λ (H) (hash-has-key? H 'lgua)) enriched-data) "批量成交量卦象")
  (check-true (every? (λ (H) (hash-has-key? H 'jgua)) enriched-data) "批量价格卦象"))

(define (test-random-data)
  (define enriched-random-data (set-gua random-data))
  (for/all ([H enriched-random-data])
    (check-true (hash-has-key? H 'bgua) "随机数据卦象计算")
    (check-true (hash-has-key? H 'lgua) "随机数据成交量卦象")
    (check-true (hash-has-key? H 'jgua) "随机数据价格卦象")))

;; ** 执行测试 **
(displayln "开始执行单元测试...")
(test-find-price-volume)
(test-price-amplitude)
(test-statistics)
(test-normalization)
(test-gua-calculations)
(test-batch-gua)
(test-random-data)
(displayln "所有测试通过！")
