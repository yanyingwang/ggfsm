#lang at-exp racket/base

(require racket/format
         xml gregor
         ming ming/list racket/list
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

(define (pages 股号)
    (define 企文 (彐股 股号)) ; 企：企业
    (define 所 (hash-ref 企文 '所))
    (define 所号 (~a (hash-ref 企文 '所) (hash-ref 企文 '代码)))
    (define 代码 (hash-ref 企文 '代码))
    (define 简称 (hash-ref 企文 '简称))
    (define 英文全称 (hash-ref 企文 '英文全称))
    (define 上市日期 (hash-ref 企文 '上市日期))

    ;; 云：未处理的数据
    ;; 文：规整的数据，加工过的数据

    (define 日云/一年 (取日文/一年 所号)) ;; 250

    (define 日云/六月 (􏾝 (reverse 日云/一年) 0 125))
    (define 日云/三月 (􏾝 (reverse 日云/一年) 0 65))
    (define 日文/一年 (攸以卦 日云/一年))
    (define 日文/六月 (攸以卦 日云/六月))
    (define 日文/三月 (攸以卦 日云/三月))

    (define 周云/五年 (取周文/五年 所号)) ;; 280
    (define 周云/三年 (􏾝 (reverse 周云/五年) 0 165))
    (define 周云/两年 (􏾝 (reverse 周云/五年) 0 110))
    (define 周文/五年 (攸以卦 周云/五年))
    (define 周文/三年 (攸以卦 周云/三年))
    (define 周文/两年 (攸以卦 周云/两年))

    (define (html 标 文)
        (wrapped
         (~a "量价卦势图" "-" 简称 代码)
         `(div ([class "container mt-5"])
               ,(compinfo 所 代码 简称 英文全称 上市日期))
         `(div ([class "container-fluid mt-3"])
               ,(nav-tabs 代码 标)
               (div ([id ,(~a 标)])))
         `(div ([class "container mt-4"])
               (div
                    (div ([class "row text-center justify-content-center"])
                         (h2 "今日解析")
                     (p "当日卦象：" ,(卦象解析 (􏿰弔 (末 文) 'bgua)))
                     (p "当日卦象所反应出的量价关系：" ,(量价解析 (末 文))))
                    (div ([class "row text-center justify-content-center"])
                     (h2 "历史回顾")
                     (p "超量超价(多方买入)：" ,@(􏷑 (入 (d) `(a ((href "this.html")) ,d)) (get-days 超量超价? 文)))
                     (p "天价地量(风险信号)：" ,@(􏷑 (入 (d) `(a ((href "this.html")) ,d)) (get-days 天价地量? 文)))
                     (p "天量地价(超强买入)：" ,@(􏷑 (入 (d) `(a ((href "this.html")) ,d)) (get-days 天量地价? 文)))
                     (p "高价缩量(卖出信号)：" ,@(􏷑 (入 (d) `(a ((href "this.html")) ,d)) (get-days 高价缩量? 文)))
                     (p "低价起量(买入信号)：" ,@(􏷑 (入 (d) `(a ((href "this.html")) ,d)) (get-days 低价起量? 文)))
                     (p "低价低量(市场低靡)：" ,@(􏷑 (入 (d) `(a ((href "this.html")) ,d)) (get-days 低价低量? 文)))
                     )
                    ))
         (plotly-script 标 文)
         `(script ([type "text/javascript"] [src ,(js/ "zixuan.js")]))
         `(script "zixuanShow()")))
    (􏿳 '3md (html '3md 日文/三月)
        '6md (html '6md 日文/六月)
        '1yd (html '1yd 日文/一年)
        '2yw (html '2yw 周文/两年)
        '3yw (html '3yw 周文/三年)
        '5yw (html '5yw 周文/五年)
        )
    )



(define (shows.html 股号)
  (for-each (λ (AL) (gen-html (~a 股号 "-" (阳 AL)) (阴 AL)))
       (pages 股号))
    )

;; in the case of sina api returning errors for shows.html
(define (sleepy-shows.html 股号)
    (and (printf "股号：~a~n" 股号) (shows.html 股号) (sleep 2)))


;; (define 股号 "600819")
;; (名 股号 "600819") "002238"
;; (shows.html "600819")
