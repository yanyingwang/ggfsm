#lang at-exp racket/base

(require racket/format
         xml gregor
         ming
         "../paths.rkt"
         "../api.rkt"
         "../api-helper.rkt"
         "../stkexg.rkt"
         "../plotly-helper.rkt"
         "../page-helper.rkt"
         "show-helper.rkt"
         )

(provide gen-180d.html)


(define (page str)
  (名 企文 (彐股 str)) ; 企：企业
  (名 米文 (攸以卦(取天文/半年 str))) ;米文：数据相关的内容
  (名 link
      (尚 (􏿰弔 企文 '所)
          [(SH) (sselink (􏿰弔 企文 '代码))]
          [(SZ) (szselink (􏿰弔 企文 '代码))]
          [俖 ""]
          ))
  (名 所码简
      (~a (􏿰弔 企文 '所) (􏿰弔 企文 '代码) (􏿰弔 企文 '简称)))

  `(html
    ,(header (~a "量价卦势图" "-" 所码简))
    (body
     (div ([class "container mt-5"])
          (div ([class "col"])
               (h1 ,所码简)
               (p
                @,~a{英文全称：@(􏿰弔 企文 '英文全称)} (br)
                @,~a{公司上市日期：@(􏿰弔 企文 '上市日期)} (br)
                @,~a{数据更新日期：@(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")} (br)
                (a ([href ,link] [target "_blank"]) "交易所详情")
                )))
     (div ([class "container-fluid"]
           [id "myPlot"])))
    ,(plotly-script 'myPlot 米文)
    ;; (script ([type "text/javascript"]
    ;;          [src "myplot2.js"]))
    )
  )

(名 (gen-180d.html str)
    (parameterize ([current-unescaped-tags html-unescaped-tags])
      (with-output-to-file (public/ (~a str "-180d.html")) #:exists 'replace
        (lambda () (display (xexpr->string (page str)))))))
