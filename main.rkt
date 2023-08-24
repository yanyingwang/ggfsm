#!/usr/bin/env racket

#lang at-exp racket/base

(require racket/format
         ming ming/number ming/list
         gregor
         "suo.rkt"
         "pages/index.rkt"
         "pages/hs300.rkt"
         "pages/zz500.rkt"
         "pages/sz50.rkt"
         "pages/sc500.rkt"
         "pages/redirects.rkt"
         "pages/shows.rkt"
         "hs300.rkt"
         "zz500.rkt"
         "sz50.rkt"
         "sc500.rkt"
         )

;; gen indexes
(index.html) (hs300.html) (zz500.html) (sz50.html) (sc500.html)


;; stock lists
(名 云股 ;; 云：未处理的数据
    (𠝤 (􏺈 (􏿝 zz500 sz50 sc500 hs300))))
(名 文股 ;;文：已处理的数据，选出csv文件中存在的
    (􏹈  (λ (S) (彐股 S))
         (𠝤 (􏺈 (􏿝 zz500 sz50 sc500 hs300)))))

;; gen shows
(各 redirects.html 文股)
(各 sleepy-shows.html 文股)


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



