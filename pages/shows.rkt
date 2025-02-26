#lang at-exp racket/base

(require racket/format
         xml gregor
         ming ming/list
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

(require "../gu-helper.rkt")

(define (pages 股号)
    (define 企文 (彐股 股号)) ; 企：企业
    (define 所 (􏿰弔 企文 '所))
    (define 所号 (~a (􏿰弔 企文 '所) (􏿰弔 企文 '代码)))
    (define 代码 (􏿰弔 企文 '代码))
    (define 简称 (􏿰弔 企文 '简称))
    (define 英文全称 (􏿰弔 企文 '英文全称))
    (define 上市日期 (􏿰弔 企文 '上市日期))

    ;; 云：未处理的数据
    ;; 文：规整的数据，加工过的数据
    (define 日云/一年 (取日文/一年 所号)) ;; 250

    (define 日云/六月 (􏾝 (􏾛 日云/一年) 0 125))
    (define 日云/三月 (􏾝 (􏾛 日云/一年) 0 65))
    (define 日文/一年 (攸以卦 日云/一年))
    (define 日文/六月 (攸以卦 日云/六月))
    (define 日文/三月 (攸以卦 日云/三月))

    (define 周云/五年 (取周文/五年 所号)) ;; 280
    (define 周云/三年 (􏾝 (􏾛 周云/五年) 0 165))
    (define 周云/两年 (􏾝 (􏾛 周云/五年) 0 110))
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
    (各 (λ (AL) (gen-html (~a 股号 "-" (阳 AL)) (阴 AL)))
        (pages 股号))
    )

;; in the case of sina api returning errors for shows.html
(define (sleepy-shows.html 股号)
    (并 (printf "股号：~a~n" 股号) (shows.html 股号) (sleep 2)))

;; (define 股号 "600819")
;; (shows.html "600819")
