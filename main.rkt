#lang at-exp racket/base

(require racket/format
         ming ming/number
         gregor xml
         "api.rkt"
         "api-helper.rkt"
         "add-gua.rkt"
         "64gua.rkt"
         "8gua.rkt"
         "xpage.rkt"
         "jscode-helper.rkt"
         )


;; (股号 "sh603259") ;药明康德
;; (股号 "sz000858") ;五粮液
(股号 "SZ002049") ;紫光国微
(名 文 (取天文/半年))
(名 顶价 (彐顶价 文))
(名 底价 (彐底价 文))
(名 顶量 (彐顶量 文))
(名 底量 (彐底量 文))

(名 卦文
    (佫 (λ (H)
          (攸以复卦 (攸以量卦 (攸以价卦 H 顶价 底价)
                            顶量 底量)))
        文))

(名 data
    (􏿴 (gen-trace "量" (xs 卦文) (ys/量卦 卦文) (ts/量 卦文) 1)
        (gen-trace "价" (xs 卦文) (ys/价卦 卦文) (ts/均价 卦文) 1 (ts/其他价 卦文))
        (gen-trace "并" (xs 卦文) (ys/复卦 卦文) (ts/复卦 卦文) #;(ts/复卦数 卦文))
        ))

(名 jscode
    (gen-plotly-jscode "myPlot" data))

(parameterize ([current-unescaped-tags html-unescaped-tags])
  (with-output-to-file "public/ggsm.html" #:exists 'replace
    (lambda () (display (xexpr->string (xpage jscode))))))






;; (名 沪市A股 '("600" "601" "603"))
;; (名 沪市B股 '("900"))

;; (名 深市A股 '("000"))
;; (名 深市B股 '("200"))

;; (名 科创板 '("688"))
;; (名 创业板 '("300"))
;; (名 中小板 '("002"))

;; (名 早期上市股 '("6006"))
