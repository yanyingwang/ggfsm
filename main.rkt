#!/usr/bin/env racket

#lang at-exp racket/base

(require racket/format
         ming ming/number ming/list
         gregor
         "pages/hs300.rkt"
         "pages/zz500.rkt"
         "pages/sz50.rkt"
         "pages/sc500.rkt"
         "pages/shows.rkt"
         "pages/redirects.rkt"
         "hs300.rkt"
         "zz500.rkt"
         "sz50.rkt"
         "sc500.rkt"
         )

;; gen indexes
(hs300.html) (zz500.html) (sz50.html) (sc500.html)



;; gen shows
(名 云股
    (𠝤 (􏺈 (􏿝 zz500 sz50 sc500 hs300))))
;; (􏹇  (λ (S) (彐股 S))
;;      (𠝤 (􏺈 (􏿝 zz500 sz50 sc500 hs300))))
(名 失股 ;; 失效
    (􏿴 "002013" "688099" "688005" "688536" "688065" "688208" "688002" "688521" "688006" "688188"
        "688029" "000540" "688088" "688321" "000671" "688289" "600466" "300038" "000732" "688111"
        "688036" "688012" "688169" "688008" "688396" "688363" "688009" "688126"))
(名 文股 (􏹊^ 失股 云股))
(各 (λ (S) (并 (shows.html S) (sleep 5)))
    文股)
(各 redirects.html 文股)




;; (shows.html "603259") ;药明康德
;; (shows.html "300015") ;艾尔眼科
;; (shows.html "600750") ;江中药业
;; (shows.html "600559") ;老白干
;; (shows.html "000858") ;五粮液
;; (shows.html "000568") ;泸州老窖
;; (shows.html "600519") ;贵州茅台
;; (shows.html "002049") ;紫光国微
;; (shows.html "300750") ;宁德时代
;; (shows.html "002594") ;比亚迪
;; (shows.html "002709") ;天赐材料
;; (shows.html "002460") ; ZF锂业
;; (shows.html "600585") ; 海螺水泥
;; (shows.html "600819") ;耀皮玻璃



