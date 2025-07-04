#!/usr/bin/env racket

#lang racket/base

(require ming ming/list
         "suo.rkt"
         "pages/index.rkt"
         "pages/about.rkt"
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
         "zixuan.rkt"
         )

;; gen indexes
(index.html) (about.html)
(hs300.html) (zz500.html) (sz50.html) (sc500.html)



;; stock lists
(名 云股 ;; 云：杂乱未处理的数据
    (𠝤 (􏺈 (􏿝 sc500 hs300)))) ;; zz500  sz50
(名 文股 ;; 文：已处理的数据，选出csv文件中存在的
    (􏹈 (λ (S) (彐股 S))
        (𠝤 (􏺈 (􏿝 zixuan sc500 hs300))))) ;;  zz500 sz50

;; gen shows
(􏷒 redirects.html 文股)
(􏷒 sleepy-shows.html 文股)
;; (shows.html "000858")
;; (shows.html "600819")
;; (shows.html "002238")
;; (shows.html "603259")

;; localStorage需要一个域名网站才能使用自选功能，在本地文件通过浏览器打开，不同页面会被认为是不同域名而不能共享自选。
