#lang at-exp racket/base

(require ming
         ming/number
         http-client
         )

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
;; http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=sz000858&scale=240&ma=5&datalen=64
;; http://hq.sinajs.cn/list=sh601006
;;; ma_price: moving average price

(名 文 '())
(名 重载API? (make-parameter #f))

(名 股号 (make-parameter #f))
(股号 "sh603259") ; 药明康德
;; sh601006 五粮液

(名 sina-api
    (http-connection "http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData"
                     (hasheq 'Content-Type "application/xml")
                     (hasheq)))

;; 文：response/result，api返回的内容
;; 号：symbol，股票代号
;; 分：scale，每个点的时长大小(sina api约定最小值为5)；api定义单位是（分）
;; 量：length，共计多少。默认5分钟为一度，共计返回49个。;每天开盘4小时=240分，÷5分=48，+1=49
(名 (取文 [分 5] [量 49] [号 (股号)])
    (http-response-body
     (http-get sina-api
               #:data (􏿰 'symbol 号
                          'scale 分
                          'ma 分
                          'datalen 量))))

;; 最小值5分钟
;; 每天开盘4小时=240分
;; ÷5分=每天开盘48个5分。
(名 (取分文 [量 49])
    (取文 5 量))

(名 (取分文/三月)
    (取分文 (* 48 25 3)))
(名 (取分文/半年)
    (取分文 (* 48 25 6)))

;; 每天开盘4小时=240分
;; 每月开盘约25天
(名 (取天文 [量 25])
    (取文 240 量))

(名 (取天文/三月)
    (取天文 75))
(名 (取天文/半年)
    (取天文 130))
(名 (取天文/一年)
    (取天文 250))
(名 (取天文/三年)
    (取天文 750))


;; 每周开盘约5天=240*5=1200分
;; 每月开盘约5周
;; 半年25周
;; 一年50周
;; 三年150周
(名 (取周文 [量 50])
    (取文 1200 量))

(名 (取周文/两年)
    (取周文 (* 50 2)))

(名 (取周文/三年)
    (取周文 (* 50 3)))










(名 res/60day
    (http-get sina-stock-data-api
              #:data (􏿰 'scale 240 'ma 5 'datalen )))


;; https://wp.m.163.com/163/page/news/virus_report/index.html
(define (do-request)
  (http-get "https://c.m.163.com"
            #:path "/ug/api/wuhan/app/data/list-total"))


(define (qq/data)
  (and (or (covid-19/reload-data/qq)
           (empty? response))
       (set! response (do-request))
       (covid-19/reload-data/qq #f))
  (hash-ref (hash-ref (http-response-body response) 'data) 'diseaseh5Shelf))


;; (名 res/today
;;     (http-get sina-stock-data-api
;;               #:data (􏿰 'scale 240 'ma 5 'datalen 64)))
(名 res/today
    (http-get sina-stock-api
              #:data (􏿰 'scale 5 'ma 5 'datalen 49))) ;; scale单位是（分）；每天开盘4小时=240分，÷5分=48，+1=49（长度）。

(名 res/60day
    (http-get sina-stock-data-api
              #:data (􏿰 'scale 240 'ma 5 'datalen 60))) ;;每年平均开盘250天，每月约21天，三月约60天。

(名 res/60day
    (http-get sina-stock-data-api
              #:data (􏿰 'scale 240 'ma 5 'datalen 60)))


(名 res/125day
    (http-get sina-stock-data-api
              #:data (􏿰 'scale 240 'ma 5 'datalen 125)))

(名 res/250day
    (http-get sina-stock-data-api
              #:data (􏿰 'scale 240 'ma 5 'datalen 250)))

(名 res/500day
    (http-get sina-stock-data-api
              #:data (􏿰 'scale 240 'ma 5 'datalen 250)))

(名 60日料
    (http-response-body res/60day))

(名 今材 (http-response-body res/today))

;; (名 昨日收盘时间 (􏼃 (~t (-days (now) 1) "YYYY-MM-dd") " " "15:00:00"))
(名 近今收盘材元
    (􏹌 (λ (e) (且 (􏼣? (􏿰弔 e 'day) "15:00:00")
                  (非 (􏼤? (􏿰弔 e 'day) (~t (now) "YYYY-MM-dd")))))
        今材))

(􏹌 (λ (e) (且 (􏼣? (􏿰弔 e 'day) "15:00:00")
              (非 (􏼤? (􏿰弔 e 'day) (~t (now) "YYYY-MM-dd")))))
    今日材)



;; (名 今日前收盘价
;;     (句化米 (􏿰弔 今日前收盘数据 'close)))
;; (名 今日最高价
;;     (􏹔 (* 今日前收盘价 1.1)))
;; (名 今日最低价
;;     (􏹔 (* 今日前收盘价 0.9)))


(名 60日材
    (http-response-body res/60day))
;; (名 60日均量
;;     (􏹓 (/ (垎 + 0 (佫 (入 (e) (句化米 (􏿰弔 e 'volume))) 60日数据)) 60)))






;; (名 今日卦象数据
;;     (佫 (λ (e) (􏿰攸 e )
;;          今日数据)) )

;; https://gu.qq.com/sz000858
;; F10 http://basic.10jqka.com.cn/sz000858
