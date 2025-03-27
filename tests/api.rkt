#lang racket/base

(require rackunit json "../api.rkt") ;; 引入被测模块

;; =======================
;; ** 测试参数 **
;; =======================
;; 测试股票代码参数
(parameterize ([stock-code "sh600519"])
  (check-equal? (stock-code) "sh600519"))

;; =======================
;; ** 模拟数据 **
;; =======================
(define mock-day-data
  (list (hasheq 'day "2025-03-25 15:00:00" 'close "100.0")
        (hasheq 'day "2025-03-24 15:00:00" 'close "95.0")))

(define extreme-day-data
  (list (hasheq 'day "2025-03-25 15:00:00" 'close "200.0")
        (hasheq 'day "2025-03-24 15:00:00" 'close "50.0")))

(define low-volatility-data
  (list (hasheq 'day "2025-03-25 15:00:00" 'close "100.5")
        (hasheq 'day "2025-03-24 15:00:00" 'close "100.0")))

;; 生成随机数据
(define (generate-random-day-data n)
  (for/list ([i n])
    (hasheq 'day (format "2025-03-~a 15:00:00" (+ 10 i))
            'close (number->string (+ 90 (random 20))))))

(define random-day-data (generate-random-day-data 10))

;; =======================
;; ** 计算测试 **
;; =======================
(define (test-price-limits)
  (let-values ([(up down) (calculate-price-limits mock-day-data)])
    (check-equal? up 110 "涨停计算")
    (check-equal? down 90 "跌停计算"))

  (let-values ([(up down) (calculate-price-limits extreme-day-data)])
    (check-equal? up 220 "极端市场涨停计算")
    (check-equal? down 180 "极端市场跌停计算"))

  (let-values ([(up down) (calculate-price-limits low-volatility-data)])
    (check-equal? up 110.55 "低波动涨停计算")
    (check-equal? down 90.45 "低波动跌停计算")))

(define (test-time-range-mapping)
  (check-equal? (get-time-range 20) "最近 1 个月" "时间范围 20 天")
  (check-equal? (get-time-range 100) "最近 6 个月" "时间范围 100 天")
  (check-equal? (get-time-range 800) "长期趋势" "时间范围 800 天"))

;; =======================
;; ** API 测试 **
;; =======================
(define (test-api-responses)
  (define minute-data (get-minutes-data 10 "sh600519"))
  (define day-data (get-day-data 5 "sh600519"))
  (define week-data (get-week-data 2 "sh600519"))

  (check-true (string? (jsexpr->string minute-data)) "分钟数据格式")
  (check-true (string? (jsexpr->string day-data)) "日数据格式")
  (check-true (string? (jsexpr->string week-data)) "周数据格式")

  (check-not-false (json-valid? (jsexpr->string minute-data)) "分钟数据 JSON 有效性")
  (check-not-false (json-valid? (jsexpr->string day-data)) "日数据 JSON 有效性")
  (check-not-false (json-valid? (jsexpr->string week-data)) "周数据 JSON 有效性"))

(define (test-api-requests)
  (check-equal? (handle-api-request "sh600519" "minute" "short") (get-minutes-data 49 "sh600519") "分钟数据请求")
  (check-equal? (handle-api-request "sh600519" "day" "long") (get-day-data 250 "sh600519") "长期日数据请求")
  (check-equal? (handle-api-request "sh600519" "week" "mid") (get-week-data/two-years "sh600519") "周数据请求"))

;; =======================
;; ** 异常测试 **
;; =======================
(define (test-exceptions)
  (check-exn exn:fail? (λ () (handle-api-request "sh600519" "hour" "short")) "非法时间单位")
  (check-exn exn:fail? (λ () (handle-api-request "sh600519" "day" "unknown")) "未知范围")
  (check-exn exn:fail? (λ () (handle-api-request "invalid-code" "day" "long")) "无效股票代码"))

;; =======================
;; ** 执行测试 **
;; =======================
(displayln "开始执行测试...")
(test-price-limits)
(test-time-range-mapping)
(test-api-responses)
(test-api-requests)
(test-exceptions)
(displayln "所有测试通过！")
