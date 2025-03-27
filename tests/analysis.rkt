#lang racket/base

(require rackunit json "../analysis.rkt")  ;; 引入被测模块

;; ======================
;; ** 交易量与价格分析函数测试 **
;; ======================

(define test-data-1 (hasheq 'jgua-n 6 'lgua-n 6 'day "2025-03-27"))
(define test-data-2 (hasheq 'jgua-n 6 'lgua-n 1 'day "2025-03-26"))
(define test-data-3 (hasheq 'jgua-n 1 'lgua-n 6 'day "2025-03-25"))
(define test-data-4 (hasheq 'jgua-n 1 'lgua-n 1 'day "2025-03-24"))

(define (test-trade-patterns)
  ;; 天价天量
  (check-true (top-price-top-volume? test-data-1) "天价天量测试")
  ;; 天价地量
  (check-true (top-price-bottom-volume? test-data-2) "天价地量测试")
  ;; 天量地价
  (check-true (top-volume-bottom-price? test-data-3) "天量地价测试")
  ;; 低价低量
  (check-true (low-price-low-volume? test-data-4) "低价低量测试"))

;; ======================
;; ** 交易信号分析测试 **
;; ======================

(define (test-relationship-analysis)
  (define result-1 (analyze-relationship-of-volume-price test-data-1))
  (define result-2 (analyze-relationship-of-volume-price test-data-2))
  (define result-3 (analyze-relationship-of-volume-price test-data-3))
  (define result-4 (analyze-relationship-of-volume-price test-data-4))

  (check-regexp-match "风险提示" result-1 "天价天量的风险提示")
  (check-regexp-match "买入信号" result-3 "天量地价的买入信号")
  (check-regexp-match "观望市场" result-4 "低价低量的观望市场信号"))

;; ======================
;; ** JSON 数据处理测试 **
;; ======================

(define json-test-data '[{"jgua-n":6, "lgua-n":6, "day":"2025-03-27"}
                         {"jgua-n":1, "lgua-n":6, "day":"2025-03-25"}])

(define (test-json-processing)
  (define parsed (analyze-data json-test-data))
  (check-true (string? parsed) "分析 JSON 结果应为字符串")
  (check-true (json-valid? parsed) "JSON 结果应符合格式")
  (check-regexp-match "风险提示" parsed "天价天量 JSON 解析")
  (check-regexp-match "买入信号" parsed "天量地价 JSON 解析"))

;; ======================
;; ** 异常处理测试 **
;; ======================

(define (test-exceptions)
  (check-exn exn:fail? (λ () (analyze-relationship-of-volume-price (hasheq))) "空数据测试")
  (check-exn exn:fail? (λ () (read-json-file "non-existent.json")) "读取不存在的文件"))

;; ======================
;; ** 执行所有测试 **
;; ======================

(displayln "开始执行测试...")
(test-trade-patterns)
(test-relationship-analysis)
(test-json-processing)
(test-exceptions)
(displayln "所有测试通过！")
