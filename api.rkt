#lang racket/base

(require ming
         ming/number
         http-client
         )

(provide #;股号 取文
         取分文 取分文/三月 取分文/半年
         取日文 取日文/三月 取日文/半年 取日文/一年 取日文/三年
         取周文 取周文/两年 取周文/三年 取周文/五年
         )

;; https://gu.qq.com/sz000858
;; F10 http://basic.10jqka.com.cn/sz000858

;; http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=sz000858&scale=240&ma=5&datalen=64
;; http://hq.sinajs.cn/list=sh601006
;;; ma_price: moving average price

;; (名 文 '())
;; (名 重载API? (make-parameter #f))

(名 股号 (make-parameter #f))

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
(名 (取分文 [量 49] [号 (股号)])
    (取文 5 量  号))

(名 (取分文/三月 [号 (股号)])
    (取分文 (* 48 25 3) 号))
(名 (取分文/半年 [号 (股号)])
    (取分文 (* 48 25 6) 号))

;; 每天开盘4小时=240分
;; 每月开盘约25天
(名 (取日文 [量 25] [号 (股号)]) ;一月
    (取文 240 量 号))

(名 (取日文/三月 [号 (股号)])
    (取日文 75 号))
(名 (取日文/半年 [号 (股号)])
    (取日文 130 号))
(名 (取日文/一年 [号 (股号)])
    (取日文 250 号))
(名 (取日文/三年 [号 (股号)])
    (取日文 750 号))


;; 每周开盘约5天=240*5=1200分
;; 每月开盘约5周
;; 半年25周
;; 一年50周
;; 三年150周
(名 (取周文 [量 50] [号 (股号)])
    (取文 1200 量 号))

(名 (取周文/两年 [号 (股号)])
    (取周文 110 号))

(名 (取周文/三年 [号 (股号)])
    (取周文 160 号))
(名 (取周文/五年 [号 (股号)])
    (取周文 280 号))



;; ;; (名 昨日收盘时间 (􏼃 (~t (-days (now) 1) "YYYY-MM-dd") " " "15:00:00"))
;; (名 近今收盘材元
;;     (􏹌 (λ (e) (且 (􏼣? (􏿰弔 e 'day) "15:00:00")
;;                   (非 (􏼤? (􏿰弔 e 'day) (~t (now) "YYYY-MM-dd")))))
;;         今材))

;; (􏹌 (λ (e) (且 (􏼣? (􏿰弔 e 'day) "15:00:00")
;;               (非 (􏼤? (􏿰弔 e 'day) (~t (now) "YYYY-MM-dd")))))
;;     今日材)


;; (名 今日前收盘价
;;     (句化米 (􏿰弔 今日前收盘数据 'close)))
;; (名 今日最高价
;;     (􏹔 (* 今日前收盘价 1.1)))
;; (名 今日最低价
;;     (􏹔 (* 今日前收盘价 0.9)))


;; (名 今日卦象数据
;;     (佫 (λ (e) (􏿰攸 e )
;;          今日数据)) )


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
