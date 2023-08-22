#!/usr/bin/env racket

#lang at-exp racket/base

(require racket/format
         ming ming/number
         "pages/hs300.rkt"
         "pages/zz500.rkt"
         "pages/show.rkt"
         )



;; (名 沪市A股 '("600" "601" "603"))
;; (名 沪市B股 '("900"))

;; (名 深市A股 '("000"))
;; (名 深市B股 '("200"))

;; (名 科创板 '("688"))
;; (名 创业板 '("300"))
;; (名 中小板 '("002"))

;; (名 早期上市股 '("6006"))


(名 strs
    (􏿴 "SH603259" ;药明康德
        "SZ300015" ;艾尔眼科
        "SH600750" ;江中药业
        "SH600559" ;老白干
        "SZ000858" ;五粮液
        "SZ000568" ;泸州老窖
        "SH600519" ;贵州茅台
        "SZ002049" ;紫光国微
        "SZ300750" ;宁德时代
        "SZ002594" ;比亚迪
        "SZ002709" ;天赐材料
        "SZ002460" ; ZF锂业
        "SH600585" ; 海螺水泥
        "SH600819" ;耀皮玻璃
        ))

(佫 show.html strs)



(private.html strs)




(hs300.html)
(zz500.html)
(shows.html "603259")
(shows.html "002594") ;byd
(shows.html "000568") ;lzlj
(shows.html "600750") ;jzyy
