#lang at-exp racket/base

(require racket/format
         xml gregor
         ming ming/list
         "../paths.rkt"
         "../api.rkt"
         "../api-helper.rkt"
         "../stkexg.rkt"
         "../plotly-helper.rkt"
         "../page-helper.rkt"
         "show-helper.rkt"
         )
(provide show.html)

(名 (page str)
    (名 企文 (彐股 str)) ; 企：企业

    (名 原日文/一年 (取日文/一年 str)) ;750=25*12
    (名 原日文/六月 (􏾝 原日文/一年 (􏹓  (* (巨 原日文/一年) 0.5))))
    (名 原日文/三月 (􏾝 原日文/一年 (􏹓  (* (巨 原日文/一年) 0.25))))
    (名 日文/一年  (攸以卦 原日文/一年))
    (名 日文/六月  (攸以卦 原日文/六月))
    (名 日文/三月 (攸以卦 原日文/三月))

    (名 原周文/三年 (攸以卦(取周文/三年 str)))
    (名 原周文/两年 (􏾝 原周文/三年 (􏹓  (* (巨 原周文/三年) 0.67))))
    (名 原周文/一年 (􏾝 原周文/三年 (􏹓  (* (巨 原周文/三年) 0.34))))
    (名 周文/三年 (攸以卦 原周文/三年))
    (名 周文/两年 (攸以卦 原周文/两年))
    (名 周文/一年 (攸以卦 原周文/一年))

    (名 所 (􏿰弔 企文 '所))
    (名 代码 (􏿰弔 企文 '代码))
    (名 简称 (􏿰弔 企文 '简称))
    (名 所码简 (~a 所 代码 简称))
    (名 英文全称 (􏿰弔 企文 '英文全称))
    (名 上市日期 (􏿰弔 企文 '上市日期))

    `(html
      ,(header (~a "量价卦势图" "-" 所码简))
      (body
       (div ([class "container mt-5"])
            (h1 ,所码简)
            ,(compinfo (~a "英文全称：" 英文全称)
                       (~a "公司上市日期：" 上市日期)
                       (~a "数据更新日期：" (~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm"))
                       (suolink 代码 所) "交易所"
                       (gstlink 代码) "百度股市通"
                       (thslink 代码) "同花顺F10"))
       (hr)
       (div ([class "container-fluid mt-3"])
            ,(pills-tab '3m-day '(div ([id "3m-day"]))
                        (􏿳 '6m-day '(div ([id "6m-day"]))
                            '1y-day '(div ([id "1y-day"]))
                            '1y-week '(div ([id "1y-week"]))
                            '2y-week '(div ([id "2y-week"]))
                            '3y-week '(div ([id "3y-week"]))
                            )
                        ))
       )
      ,(plotly-script '3m-day 日文/三月)
      ,(plotly-script '6m-day 日文/六月)
      ,(plotly-script '1y-day 日文/一年)
      ,(plotly-script '1y-week 周文/一年)
      ,(plotly-script '2y-week 周文/两年)
      ,(plotly-script '3y-week 周文/三年)
      ;; (script ([type "text/javascript"] [src "myplot2.js"]))
      )
    )

(名 (show.html str)
    (parameterize ([current-unescaped-tags html-unescaped-tags])
      (with-output-to-file (public/ str ".html") #:exists 'replace
        (lambda () (display (xexpr->string (page str)))))))


;; (名 str "sh600819")
;; (gen-html str)