#lang racket/base

(require ming
         ming/number
         http-client
         )

(provide stock-code get-data
         get-minutes-data get-minutes-data/three-months get-minutes-data/half-year
         get-day-data get-day-data/three-months get-day-data/half-year get-day-data/one-year get-day-data/three-years
         get-week-data get-week-data/two-years get-week-data/three-years get-week-datafive-years
         )

;; https://gu.qq.com/sz000858
;; F10 http://basic.10jqka.com.cn/sz000858
;; http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=sz000858&scale=240&ma=5&datalen=64
;; http://hq.sinajs.cn/list=sh601006
;;; ma_price: moving average price

(define stock-code (make-parameter #f))

(define sina-api
    (http-connection "http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData"
                     (hasheq 'Content-Type "application/xml")
                     (hasheq)))

;; data：response/result，api返回的内容
;; code：symbol，股票代号
;; minute：scale，每个点的时长大小(sina api约定最小值为5)；api定义单位是（分）
;; volume：length，共计多少。默认5分钟为一度，共计返回49个。;每天开盘4小时=240分，÷5分=48，+1=49
(define (get-data [minute 5] [volume 49] [code (stock-code)])
    (http-response-body
     (http-get sina-api
               #:data (hash 'symbol code
                          'scale minutes
                          'ma minutes
                          'datalen volume))))

;; 最小值5分钟 ;; 每天开盘4小时=240minute ;; ÷5分=每天开盘48个5分。
(define (get-minutes-data [volume 49] [code (stock-code)])
    (get-data 5 volume code))

(define (get-minutes-data/three-months [code (stock-code)])
    (get-minutes-data (* 48 25 3) code))
(define (get-minutes-data/half-year [code (stock-code)])
    (get-minutes-data (* 48 25 6) code))

;; 每天开盘4小时=240minute ;; 每月开盘约25天
(define (get-day-data [volume 25] [code (stock-code)]) ;一月
    (get-data 240 volume code))

(define (get-day-data/three-months [code (stock-code)])
    (get-day-data 75 code))
(define (get-day-data/half-year [code (stock-code)])
    (get-day-data 130 code))
(define (get-day-data/one-year [code (stock-code)])
    (get-day-data 250 code))
(define (get-day-data/three-years [code (stock-code)])
    (get-day-data 750 code))


;; 每周开盘约5天=240*5=1200minute ;; 每月开盘约5周 ;; 半年25周 ;; 一年50周 ;; 三年150周
(define (get-week-data [volume 50] [code (stock-code)])
    (get-data 1200 volume code))

(define (get-week-data/two-years [code (stock-code)])
    (get-week-data 110 code))

(define (get-week-data/three-years [code (stock-code)])
    (get-week-data 160 code))
(define (get-week-datafive-years [code (stock-code)])
    (get-week-data 280 code))



(define yesterday-colse-time (string-append (~t (-days (now) 1) "YYYY-MM-dd") " " "15:00:00"))
(define closest-close-raw-data
  (findf (λ (e) (and (string-suffix? (hash-ref e 'day) "15:00:00")
                     (not (string-prefix? (hash-ref e 'day) (~t (now) "YYYY-MM-dd")))))
         raw-day-today))
(findf (λ (e) (and (string-suffix? (hash-ref e 'day) "15:00:00")
                   (not (string-prefix? (hash-ref e 'day) (~t (now) "YYYY-MM-dd")))))
       raw-day-today)


(define last-close-price
    (string->number (hash-ref yesterday-colse-time 'close)))
(define top-price-of-today
  (round (* last-colse-price 1.1)))
(define bottom-price-of-today
  (round (* last-close-price 0.9)))

(define gua-data-of-today
    (map (λ (e) (hash-set e )


;; 卄卄卅卅卌卌
;; 一十：十
;; 二十：廿
;; 三十：卅
;; 四十：卌
;; 五十：圩
;; 六十：圆
;; 七十：进
;; 八十：枯
;; 九十：枠
