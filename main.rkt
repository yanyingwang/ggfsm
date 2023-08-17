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
         "stkexg.rkt"
         )


;; (股号 "sh603259") ;药明康德
;; (股号 "sz000858") ;五粮液
;; (股号 "sz002049") ;紫光国微


;; (名 沪市A股 '("600" "601" "603"))
;; (名 沪市B股 '("900"))

;; (名 深市A股 '("000"))
;; (名 深市B股 '("200"))

;; (名 科创板 '("688"))
;; (名 创业板 '("300"))
;; (名 中小板 '("002"))

;; (名 早期上市股 '("6006"))
