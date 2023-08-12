#lang at-exp racket/base

(require ming
         ming/number
         gregor
         xml
         racket/format
         ;; "jscode.rkt"
         )

(provide xpage)

(define (xpage jscode)
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
            [href "public/main.css"]))
     ;; (style "body { background-color: linen; }")
     ;; (script ([type "text/javascript"]
     ;;          [src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"]))
     (script ([type "text/javascript"]
              [src "https://cdn.plot.ly/plotly-latest.min.js"]))
     (script ([type "text/javascript"]
              [src "https://cdn.plot.ly/plotly-locale-zh-cn-latest.js"]))
     (script "Plotly.setPlotConfig({locale: 'zh-CN'})")
     (script ([type "text/javascript"]
              [src "https://d3js.org/d3.v3.min.js"]))

     )
    (body
     (div ((class "main"))
          (div
           (h1 "ggfsm")
               (p ((class "subtext"))
                  "数据来源：Sina"
                  (br)
                  @,~a{更新日期：@(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")}
                  #;(br)
                  #;(a ((href "https://www.yanying.wang/daily-report")) "原连接")
                  #;(entity 'nbsp)
                  #;(a ((href "https://github.com/yanyingwang/daily-report")) "源代码")
))
          (div ((class "text"))
               (div ((class "sub"))
                    (h2 ((style "margin-bottom: 6px;")) "h2222222")
                    (p ((style "margin-top: 6px;")) "Ploty.js")
                    (div ([id "myPlot"]
                          ;; [style "width:100%;max-width:1200px"]
                          ))
                    )
               )
          ))
    ;; (script ([type "text/javascript"]
    ;;          [src "public/myplot.js"]))
    ;; (script ,(my-plot.jscode x y tt))
    (script ,jscode)
    )
  )

;; (with-output-to-file "ggsm.html" #:exists 'replace
;;   (lambda () (display (xexpr->string xpage))))
