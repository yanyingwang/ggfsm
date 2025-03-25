#lang at-exp racket/base

(require http-client
         json
         racket/cmdline
         racket/match)

(provide stock-code fetch-stock-data get-minutes-data get-day-data get-week-data
         get-minutes-data/three-months get-minutes-data/half-year
         get-day-data/three-months get-day-data/half-year get-day-data/one-year get-day-data/three-years
         get-week-data/two-years get-week-data/three-years get-week-data/five-years
         calculate-price-limits)

(define stock-code (make-parameter #f))

(define sina-api
  (http-connection
   "http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData"
   (hasheq 'Content-Type "application/xml")
   (hasheq)))

;; ======================
;;  数据获取函数
;; ======================
;; data：response/result，api返回的内容
;; code：symbol，股票代号
;; minute：scale，每个点的时长大小(sina api约定最小值为5)；api定义单位是（分）
;; volume：length，共计多少。默认5分钟为一度，共计返回49个。;每天开盘4小时=240分，÷5分=48，+1=49
;; 日志输出函数，记录 API 请求
(define (log-stock-request minute volume code)
  (printf "Fetching stock data: scale=~a, volume=~a, code=~a\n" minute volume code))

;; 统一的股票数据获取函数
(define/contract (fetch-stock-data minute volume [code (stock-code)])
  (-> exact-positive-integer? exact-positive-integer? (or/c string? #f) any)
  (log-stock-request minute volume code)
  (http-response-body
   (http-get sina-api
             #:data (hash 'symbol code
                          'scale minute
                          'ma minute
                          'datalen volume))))

;; ======================
;;  获取不同时间范围的数据
;; ======================

;; 获取分钟级数据（默认 5 分钟，49 个数据点）
;; 最小值5分钟 ;; 每天开盘4小时=240minute ;; ÷5分=每天开盘48个5分。
(define (get-minutes-data [volume 49] [code (stock-code)])
  (fetch-stock-data 5 volume code))

;; 获取 3 个月的分钟级数据
(define (get-minutes-data/three-months [code (stock-code)])
  (get-minutes-data (* 48 25 3) code))

;; 获取半年（6 个月）的分钟级数据
(define (get-minutes-data/half-year [code (stock-code)])
  (get-minutes-data (* 48 25 6) code))

;; 获取日级数据（默认 25 个数据点，即 1 个月）
;; 每天开盘4小时=240minute ;; 每月开盘约25天
(define (get-day-data [volume 25] [code (stock-code)])
  (fetch-stock-data 240 volume code))

;; 获取 3 个月的日级数据
(define (get-day-data/three-months [code (stock-code)])
  (get-day-data 75 code))

;; 获取半年（6 个月）的日级数据
(define (get-day-data/half-year [code (stock-code)])
  (get-day-data 130 code))

;; 获取 1 年的日级数据
(define (get-day-data/one-year [code (stock-code)])
  (get-day-data 250 code))

;; 获取 3 年的日级数据
(define (get-day-data/three-years [code (stock-code)])
  (get-day-data 750 code))

;; 获取周级数据（默认 50 周，即 1 年）
(define (get-week-data [volume 50] [code (stock-code)])
  (fetch-stock-data 1200 volume code))

;; 获取 2 年的周级数据
(define (get-week-data/two-years [code (stock-code)])
  (get-week-data 110 code))

;; 获取 3 年的周级数据
(define (get-week-data/three-years [code (stock-code)])
  (get-week-data 160 code))

;; 获取 5 年的周级数据
(define (get-week-data/five-years [code (stock-code)])
  (get-week-data 280 code))


;; ======================
;;  计算涨跌停价格
;; ======================
;; 计算最近交易日的收盘时间
(define yesterday-close-time
  (string-append (~t (-days (now) 1) "YYYY-MM-dd") " 15:00:00"))

;; 查找最近的收盘数据
(define (find-last-close-price raw-day-data)
  (define result
    (findf (lambda (e)
             (and (string-suffix? (hash-ref e 'day) "15:00:00")
                  (not (string-prefix? (hash-ref e 'day) (~t (now) "YYYY-MM-dd")))))
           raw-day-data))
  (if result
      (string->number (hash-ref result 'close))
      #f))

;; 计算涨跌停价格
(define (calculate-price-limits raw-day-data)
  (define last-close-price (find-last-close-price raw-day-data))
  (if last-close-price
      (values (round (* last-close-price 1.1))  ;; 涨停价
              (round (* last-close-price 0.9))) ;; 跌停价
      (values #f #f)))

;; ======================
;;  时间范围匹配
;; ======================
;; 获取时间范围描述
(define (get-time-range days)
  (match days
    [(<= 25) "最近 1 个月"]
    [(<= 75) "最近 3 个月"]
    [(<= 130) "最近 6 个月"]
    [(<= 250) "最近 1 年"]
    [(<= 750) "最近 3 年"]
    [_ "长期趋势"]))

;; ======================
;;  输出调试信息
;; ======================

;; 计算并输出涨跌停价格
(define (print-price-limits raw-day-data)
  (define-values (top bottom) (calculate-price-limits raw-day-data))
  (if top
      (printf "今日涨停价: ~a, 跌停价: ~a\n" top bottom)
      (printf "无法计算涨跌停价格，可能数据缺失。\n")))



;; ======================
;;  命令行参数解析
;; ======================

(define (parse-args)
  (define-values (code type duration)
    (command-line
     #:program "api.rkt"
     #:usage-help "Usage: ./api.rkt <stock-code> <type> <duration>\n\n  type: minute, day, week\n  duration: short, mid, long"
     #:args (code type duration)
     (values code type duration)))
  (values code type duration))

;; ======================
;;  处理 API 调用
;; ======================

(define (handle-api-request code type duration)
  (stock-code code)
  (define result
    (match* (type duration)
      [("minute" "short") (get-minutes-data 49 code)]
      [("minute" "mid") (get-minutes-data/three-months code)]
      [("minute" "long") (get-minutes-data/half-year code)]

      [("day" "short") (get-day-data 25 code)]
      [("day" "mid") (get-day-data/three-months code)]
      [("day" "long") (get-day-data/one-year code)]

      [("week" "short") (get-week-data 50 code)]
      [("week" "mid") (get-week-data/two-years code)]
      [("week" "long") (get-week-data/three-years code)]
      [_ "Invalid parameters! Please use: ./api.rkt <stock-code> <type> <duration>"]))
  ;; 输出 JSON 格式数据
  (displayln (jsexpr->string result)))

;; ======================
;;  执行 API 请求
;; ======================

(define (main)
  (define-values (code type duration) (parse-args))
  (handle-api-request code type duration))
(main)
