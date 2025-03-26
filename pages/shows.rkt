#lang at-exp racket/base

(require racket/format
         xml gregor
         racket/list
         "../paths.rkt"
         "../api.rkt"
         "../api-helper.rkt"
         "../suo.rkt"
         "../plotly-helper.rkt"
         "../page-helper.rkt"
         "shows-helper.rkt"
         )
(provide shows.html
         sleepy-shows.html)

(require "../gu-helper.rkt"
         "../gua-helper.rkt"
         "../analysis-helper.rkt")

(define (pages stock-code)
  (define company-data (find-stock stock-code)) ; 企：企业
  (define exchange (hash-ref company-data '所))
  (define exchange-code (~a (hash-ref company-data '所) (hash-ref company-data '代码)))
  (define code (hash-ref company-data '代码))
  (define short-name (hash-ref company-data '简称))
  (define enlish-company-name (hash-ref company-data '英文全称))
  (define IPO-date (hash-ref company-data '上市日期))

  ;; 云：未处理的数据
  ;; data：规整的数据，加工过的数据

  (define raw-day-data/one-year (get-day-文/one-year exchange-code)) ;; 250

  (define raw-day-data/six-months (member-of (reverse raw-day-data/one-year) 0 125))
  (define raw-day-data/three-months (member-of (reverse raw-day-data/one-year) 0 65))
  (define day-data/one-year (set-gua raw-day-data/one-year))
  (define day-data/six-months (set-gua raw-day-data/six-months))
  (define day-data/three-months (set-gua raw-day-data/three-months))

  (define week-data/five-years (get-week-文five-years exchange-code)) ;; 280
  (define week-data/three-years (member-of (reverse week-data/five-years) 0 165))
  (define week-data/two-years (member-of (reverse week-data/five-years) 0 110))
  (define week-data/five-years (set-gua week-raw-data/five-years))
  (define week-data/three-years (set-gua week-data/three-years))
  (define week-data/two-years (set-gua week-data/two-years))

  (define (html tag data)
    (wrapped
     (~a "量价卦势图" "-" short-name code)
     `(div ([class "container mt-5"])
           ,(compinfo exchange code short-name enlish-company-name IPO-date))
     `(div ([class "container-fluid mt-3"])
           ,(nav-tabs code tag)
           (div ([id ,(~a tag)])))
     `(div ([class "container mt-4"])
           (div
            (div ([class "row text-center justify-content-center"])
                 (h2 "今日解析")
                 (p "当日卦象：" ,(analysis-gua (hash-ref (last data) 'bgua)))
                 (p "当日卦象所反应出的量价关系：" ,(analysis-relationship-of-volume-price (last data))))
            (div ([class "row text-center justify-content-center"])
                 (h2 "历史回顾")
                 (p "超量超价(多方买入)：" ,@(map (lambda (d) `(a ((href "this.html")) ,d)) (get-days top-price-top-volume? data)))
                 (p "天价地量(风险信号)：" ,@(map (lambda (d) `(a ((href "this.html")) ,d)) (get-days top-price-bottom-volume? data)))
                 (p "天量地价(超强买入)：" ,@(map (lambda (d) `(a ((href "this.html")) ,d)) (get-days top-volume-bottom-price? data)))
                 (p "高价缩量(卖出信号)：" ,@(map (lambda (d) `(a ((href "this.html")) ,d)) (get-days high-price-shrinked-volume? data)))
                 (p "低价起量(买入信号)：" ,@(map (lambda (d) `(a ((href "this.html")) ,d)) (get-days low-price-voting-volume? data)))
                 (p "低价低量(市场低靡)：" ,@(map (lambda (d) `(a ((href "this.html")) ,d)) (get-days low-price-low-volume? data)))
                 )
            ))
     (plotly-script tag data)
     `(script ([type "text/javascript"] [src ,(js/ "zixuan.js")]))
     `(script "zixuanShow()")))
  (association-list '3md (html '3md day-data/three-months)
                    '6md (html '6md day-data/six-months)
                    '1yd (html '1yd day-data/one-year)
                    '2yw (html '2yw week-data/two-years)
                    '3yw (html '3yw week-data/three-years)
                    '5yw (html '5yw week-datafive-years)
                    )
  )



(define (shows.html stock-code)
  (for-each (λ (AL) (gen-html (~a stock-code "-" (car AL)) (cdr AL)))
       (pages stock-code))
    )

;; in the case of sina api returning errors for shows.html
(define (sleepy-shows.html stock-code)
    (and (printf "stock-code：~a~n" stock-code) (shows.html stock-code) (sleep 2)))


;; (define stock-code "600819")
;; (define stock-code "600819") "002238"
;; (shows.html "600819")
