#lang racket/base

(require racket/format
         ming ming/number ming/list
         gregor
         "../64gua.rkt"
         "../plotly-helper.rkt"
         "../gu-helper.rkt")
(provide xs
         ys/价卦 ys/并卦 ys/量卦
         ts/量 ts/并卦
         ts/其他价 ts/均价
         plotly-data plotly-script
         sselink szselink suolink
         thslink gstlink
         compinfo nav-tabs
         )

(名 (xs 文)
    (佫 (λ (e) (􏿰弔 e 'day)) 文))

(名 (n-to-y n)
    (名 n1 (- n 32))
    (若 (􏺡? n1)
        (􏽊 n1)
        n1))

(名 (ys/并卦 文)
    (佫 (λ (H)
          (n-to-y (弓 六十四卦 (􏿰弔 H 'bgua))))
        文))

(名 (ys/价卦 文)
    (佫 (λ (H)
          (n-to-y (弓 六十四卦 (􏿰弔 H 'jgua))))
        文))

(名 (ys/量卦 文)
    (佫 (λ (H)
          (n-to-y (弓 六十四卦 (􏿰弔 H 'lgua))))
        文))

(名 (ts/其他价 文)
    (佫 (λ (H)
          (􏿴
           (􏹔 (句化米 (􏿰弔 H 'open)))
           (􏹔 (句化米 (􏿰弔 H 'close)))
           (􏹔 (句化米 (􏿰弔 H 'high)))
           (􏹔 (句化米 (􏿰弔 H 'low)))
           ))
        文))

(名 (ts/均价 文)
    (佫 (λ (H)
          (􏹔 (􏿰弔 H 'avg-price)))
        文))

(名 (ts/量 文)
    (佫 (λ (H) (~a (􏹓 (/ (句化米 (􏿰弔 H 'volume)) 10000)) "万手"))
        文))

(名 (ts/并卦 文)
    (佫 (λ (H)
          (~a (􏹔 (􏿰弔 H 'avg-price)) "元"
              "/"
              (􏹓 (/ (句化米 (􏿰弔 H 'volume)) 10000)) "万手"
              ))
        文))


(名 (plotly-data 文)
    (􏿴 (gen-trace "量" (xs 文) (ys/量卦 文) (ts/量 文) 1)
        (gen-trace "价" (xs 文) (ys/价卦 文) (ts/均价 文) 1 (ts/其他价 文))
        (gen-trace "并" (xs 文) (ys/并卦 文) (ts/并卦 文) #;(ts/复卦数 文))
        ))

(名 (plotly-script div 文)
    `(script ,(gen-plotly-jscode (~a div) (plotly-data 文)))
    )


(名 (sselink 代码)
    (􏼃 "http://www.sse.com.cn/assortment/stock/list/info/company/index.shtml?COMPANY_CODE=" 代码))
(名 (szselink 代码)
    (􏼃 "http://www.szse.cn/certificate/individual/index.html?code=" 代码))
(名 (suolink 代码 所)
    (尚 所
        [(SH) (sselink 代码)]
        [(SZ) (szselink 代码)]
        [俖 ""]
        ))

(名 (gstlink 股号)
    (􏼃 "https://gushitong.baidu.com/stock/ab-" 股号))
(名 (thslink 股号)
    (􏼃 "http://basic.10jqka.com.cn/" 股号))

(名 (compinfo 所 股号 中文简称 英文全称 上市日期)
    `(div ([class "row text-center justify-content-center"])
          (h1 ([id "stock-name-code"])
              ,(~a 中文简称 "（" 股号 "）")
              (button ([type "button"]
                       [id "zixuan-add-item-button"]
                       [class "btn btn-success"]
                       [onclick "zixuanAddItem()"])
                      "加自选")
              )
          (div ([class "col-12 mb-0"]) ,英文全称 )
          (div ([class "col-12 mb-0"]) ,(~a "数据更新日期：" (~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")))
          (div ([class "col-12 mb-0"])
               (a ([class "me-3"] [href ,(suolink 股号 所)] [target "_blank"]) "在交易所")
               (a ([class "me-3"] [href ,(gstlink 股号)] [target "_blank"]) "股市通")
               (a ([class "me-3"] [href ,(thslink 股号)] [target "_blank"]) "同花顺F10"))
          (div ([class "col-md-6"])
               (table ([class "table text-center"])
                      (tbody
                       (tr (td ,(~a "交易所：" 所))
                           (td ,(~a "上市日期：" 上市日期)))
                       (tr (td ,(~a "板块：" (板块 股号)))
                           (td ,(~a "股指：" (􏼪 (股指 股号) "/")))
                           ))))
          )
    )

(名 (nav-tabs 股号 active)
    (名 AL (􏿳
            '3md "三月/日"
            '6md "六月/日"
            '1yd "一年/日"
            '2yw "两年/周"
            '3yw "三年/周"
            '5yw "五年/周"))
    `(ul ([class "nav nav-pills justify-content-center"])
         ,@(佫 (λ (AP)
                 `(li ([class "nav-item"])
                      (a ([class ,(若 (勺=? (阳 AP) active) "nav-link active" "nav-link")]
                          ;; [aria-current ,(若 (勺=? (阳 P) active) "true" "false")]
                          [href ,(~a 股号 "-" (阳 AP) ".html")]) ,(阴 AP)))
                 )
               AL)
         )
    )
