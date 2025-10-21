#lang at-exp racket/base

(provide shows.html
         sleepy-shows.html)

(require racket/format
         xml gregor
         ming ming/list
         "../paths.rkt"
         "../api.rkt"
         "../api-helper.rkt"
         "../suo.rkt"
         "../plotly-helper.rkt"
         "../page-helper.rkt"
         "../gu-helper.rkt"
         "../gua-helper.rkt"
         "../analysis-helper.rkt"
         "../senders.rkt"
         "shows-helper.rkt")

(名 (pages 股号)
    (名 企文 (彐股 股号)) ; 企：企业
    (名 所 (􏿰弔 企文 '所))
    (名 所号 (~a (􏿰弔 企文 '所) (􏿰弔 企文 '代码)))
    (名 代码 (􏿰弔 企文 '代码))
    (名 简称 (􏿰弔 企文 '简称))
    (名 英文全称 (􏿰弔 企文 '英文全称))
    (名 上市日期 (􏿰弔 企文 '上市日期))

    ;; 云：未处理的数据
    ;; 文：规整的数据，加工过的数据
    (名 日云/一年 (取日文/一年 所号)) ;; 250
    (名 日云/三年 (取日文/三年 所号)) ;; 750
    (名 日云/六月 (􏾝 (􏾛 日云/一年) 0 125))
    (名 日云/三月 (􏾝 (􏾛 日云/一年) 0 65))

    (名 日文/一年 (攸以卦 (􏾛 日云/一年)))
    (名 日文/三年 (攸以卦 日云/三年))
    (名 日文/六月 (攸以卦 日云/六月))
    (名 日文/三月 (攸以卦 日云/三月))

    (名 周云/五年 (取周文/五年 所号)) ;; 280
    (名 周云/三年 (􏾝 (􏾛 周云/五年) 0 165))
    (名 周云/两年 (􏾝 (􏾛 周云/五年) 0 110))
    (名 周文/五年 (攸以卦 周云/五年))
    (名 周文/三年 (攸以卦 周云/三年))
    (名 周文/两年 (攸以卦 周云/两年))

    ;; 㞢 艸 芔 芒 芠 㓙 are chars that means: raw data, processed data, formal data, a bunch of data
    (名 (html 标 文)
        (wrapped
         (~a "volume-price in gua graph(量价卦势图)" "-" 简称 代码)
         `(div ([class "container mt-5"])
               ,(compinfo 所 代码 简称 英文全称 上市日期))
         `(div ([class "container-fluid mt-3"])
               ,(nav-tabs 代码 标)
               (div ([style "min-width: 1200px; overflow-x:scroll;"] [id ,(~a 标)])))
         `(div ([class "container mt-4"])
               (div ([class "row text-center justify-content-center"])
                    (h2 "Today's analysis")
                    (div ([class "col-md-10"])
                         (table ([class "table table-hover"])
                                (tbody
                                 (tr (td ([class "text-nowrap"]) "Gua result: ")
                                     (td ,(卦象解析 (􏿰弔 (􏷜 文) 'bgua))))
                                 (tr (td ([class "text-nowrap"]) "Summary：")
                                     (td ,(概览 (􏷜 文))))
                                 (tr (td ([class "text-nowrap"]) "Volume-Price Analysis：")
                                     (td ,(量价解析 (􏷜 文)) ,(当日风险 (􏷜 文))))
                                 (tr (td ([class "text-nowrap"]) "volume-price jumps：")
                                     (td ([class "text-nowrap"]) ,(激变预警 标 代码 (􏷜 文) (􏷛 文) (􏷚 文))))
                                 (tr (td ([class "text-nowrap"]) "Trade hint：")
                                     (td ([class "text-info"]) ,(当日预警 标 代码 (􏷜 文))))
                                 ))))
               )
         (plotly-script 标 文)
         `(script ([type "text/javascript"] [src ,(js/ "zixuan.js")]))
         `(script "zixuanShow()")))

    (􏿝 (􏿳 '3md (html '3md 日文/三月)
            '6md (html '6md 日文/六月)
            '1yd (html '1yd 日文/一年)
            '2yw (html '2yw 周文/两年)
            '3yw (html '3yw 周文/三年)
            '5yw (html '5yw 周文/五年))
        )
    )

(名 (shows.html 股号)
    (􏷒 (λ (AL) (gen-html (~a 股号 "-" (阳 AL)) (阴 AL)))
        (pages 股号))
    )

;; in the case of sina api returning errors for shows.html
(名 (sleepy-shows.html 股号)
    (并
     (printf "股号：~a~n" 股号)
     (shows.html 股号)
     (sleep 2)))

;; (名 股号 "600750") "002238"
;; (shows.html "600819") ;玻璃
;; (shows.html "002238")
;; (shows.html "603259")
;; (shows.html "600750")
