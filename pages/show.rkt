#lang at-exp racket/base

(require racket/format
         gregor xml
         ming
         "../paths.rkt"
         "../api.rkt"
         "../api-helper.rkt"
         "../stkexg.rkt"
         "../plotly-helper.rkt"
         "show-helper.rkt"
         )

(名 str "sz002049") ; 股票代码
(名 企文 (彐股 str)) ; 企：企业
(名 米文 (攸以卦(取天文/半年 str))) ;米文：数据相关的内容
(名 link
    (尚 (阴 (甲 企文))
        [(SH)
         (~a "http://www.sse.com.cn/assortment/stock/list/info/company/index.shtml?COMPANY_CODE=" (阴 (乙 企文)))]
        [(SZ)
         (~a "http://www.szse.cn/certificate/individual/index.html?code=" (阴 (乙 企文)))]
        [否则 ""]
        ))

(define page
  `(html
    (head
     (title @,~a{八卦走势图 - @(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")})
     (meta ([name "viewport"]
            [content "width=device-width, initial-scale=0.9"]))
     (meta ([http-equiv "content-type"]
            [content "text/html; charset=utf-8"]))
     (link ([rel "stylesheet"]
            [type "text/css"]
            [title "default"]
            [href "main.css"]))
     ;; (style "body { background-color: linen; }")
     ;; (script ([type "text/javascript"]
     ;;          [src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"]))
     ;; (script ([type "text/javascript"]
     ;; [src "styles/js/plotly-latest.min.js"]))
     (script ([type "text/javascript"]
              [src "plotly-2.25.2.min.js"]))
     (script ([type "text/javascript"]
              [src "plotly-locale-zh-cn-latest.js"]))
     (script "Plotly.setPlotConfig({locale: 'zh-CN'})")
     (script ([type "text/javascript"]
              [src "d3.v3.min.js"]))
     )
    (body
     (div ((class "main"))
          (div
           (h1 ,(~a (阴 (甲 企文)) (阴 (乙 企文)) (阴 (丙 企文))))
           (p ((class "subtext"))
              @,~a{更新日期：@(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")}
              (br)
              (a ((href ,link)) "交易所详情"))
           )
          (div ((class "text"))
               (div ((class "sub"))
                    (h2 ((style "margin-bottom: 6px;")) "")
                    (p ((style "margin-top: 6px;")) "")
                    (div ([id "myPlot"]))
                    )
               )
          ))
    ,(plotly-script 'myPlot 米文)
    ;; (script ([type "text/javascript"]
    ;;          [src "myplot2.js"]))
    )
  )


(module+ main
  (parameterize ([current-unescaped-tags html-unescaped-tags])
    (with-output-to-file (~a public/ str "-180d.html") #:exists 'replace
      (lambda () (display (xexpr->string page)))))
  )