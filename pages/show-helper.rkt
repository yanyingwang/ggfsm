#lang racket/base

(require racket/format
         ming ming/number
         "../64gua.rkt"
         "../plotly-helper.rkt")
(provide xs
         ys/价卦 ys/并卦 ys/量卦
         ts/量 ts/并卦
         ts/其他价 ts/均价
         plotly-data plotly-script
         sselink szselink suolink
         thslink gstlink
         compinfo pills-tab
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

(名 (gstlink 代码)
    (􏼃 "https://gushitong.baidu.com/stock/ab-" 代码))
(名 (thslink 代码)
    (􏼃 "http://basic.10jqka.com.cn/" 代码))

(名 (compinfo p1 p2 p3
              p4hf p4tt
              p5hf p5tt
              p6hf p6tt)
    `(div ([class "row justify-content-start"])
          (div ([class "col-12"]) ,p1)
          (div ([class "col-12"]) ,p2)
          (div ([class "col-12"]) ,p3)
          (div ([class "col-12 p1-0"])
               (a ([class "me-2"] [href ,p4hf] [target "_blank"]) ,p4tt)
               (a ([class "me-2"] [href ,p5hf] [target "_blank"]) ,p5tt)
               (a ([class "me-2"] [href ,p6hf] [target "_blank"]) ,p6tt)))
    )

(名 (pills-tab t1 c1 tcs)
    `(div
      (ul
       ([class "nav nav-pills mb-3 text-center justify-content-md-center"] [id "pills-tab"] [role "tablist"])
       (li
        ((class "nav-item") (role "presentation"))
        (button
         ((aria-controls "pills-t1")
          (aria-selected "true")
          (class "nav-link active")
          (data-bs-target "#pills-t1")
          (data-bs-toggle "pill")
          (id "pills-t1-tab")
          (role "tab")
          (type "button"))
         ,(~a t1)))
       ,@(佫 (λ (tc)
               `(li
                 ((class "nav-item") (role "presentation"))
                 (button
                  ((aria-controls ,(~a "pills-" (阳 tc)))
                   (aria-selected "false")
                   (class "nav-link")
                   (data-bs-target ,(~a "#pills-" (阳 tc)))
                   (data-bs-toggle "pill")
                   (id ,(~a "pills-" (阳 tc) "-tab"))
                   (role "tab")
                   (type "button"))
                  ,(~a (阳 tc)))))
             tcs)
       )
      (div
       ((class "tab-content") (id "pills-tabContent"))
       (div
        ((aria-labelledby "pills-t1-tab")
         (class "tab-pane fade show active")
         (id "pills-t1")
         (role "tabpanel")
         (tabindex "0"))
        ,c1)
       ,@(佫 (λ (tc)
               `(div
                 ((aria-labelledby ,(~a "pills-" (阳 tc) "-tab"))
                  (class "tab-pane fade")
                  (id ,(~a "pills-" (阳 tc)))
                  (role "tabpanel")
                  (tabindex "0"))
                 ,(阴 tc)))
             tcs)
       )
      )
    )