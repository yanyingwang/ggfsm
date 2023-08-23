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
         "show-helper.rkt"
         )
(provide shows.html)


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
    (名 日云/六月 (􏾝 日云/一年 125))
    (名 日云/三月 (􏾝 日云/一年 175))
    (名 日文/一年 (攸以卦 日云/一年))
    (名 日文/六月 (攸以卦 日云/六月))
    (名 日文/三月 (攸以卦 日云/三月))

    (名 周云/三年 (取周文/三年 所号)) ;; 160
    (名 周云/两年 (􏾝 周云/三年 55))
    (名 周云/一年 (􏾝 周云/三年 105))
    (名 周文/三年 (攸以卦 周云/三年))
    (名 周文/两年 (攸以卦 周云/两年))
    (名 周文/一年 (攸以卦 周云/一年))

    (名 (html 标 文)
        `(html
          ,(header (~a "量价卦势图" "-" 代码 简称))
          (body
           (div ([class "container mt-5"])
                ,(compinfo 所 代码 简称 英文全称 上市日期))
           (div ([class "container-fluid mt-3"])
                ,(nav-tabs 代码 标)
                (div ([id ,(~a 标)])))
           )
          ,(plotly-script 标 文)
          ;; (script ([type "text/javascript"] [src "myplot2.js"]))
          )
        )
    (􏿳 '3md (html '3md 日文/三月)
        '6md (html '6md 日文/六月)
        '1yd (html '1yd 日文/一年)
        '1yw (html '1yw 周文/一年)
        '2yw (html '2yw 周文/两年)
        '3yw (html '3yw 周文/三年)
        )
    )

(名 (shows.html 股号)
    (各 (λ (AL) (gen-html (@~a 股号 "-" (阳 AL)) (阴 AL)))
        (pages 股号))
    )

;; (名 股号 "600819")
;; (shows.html "600819")
