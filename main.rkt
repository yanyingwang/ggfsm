#!/usr/bin/env racket

#lang racket/base

(require ming ming/list racket/list
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
(define raw-stock-lists ;; raw data
    (remove-duplicates (map car (append zz500 sz50 sc500 hs300))))
(define stock-lists ;;
  (filter (λ (S) (find-stocks S))
         (remove-duplicates (amp car (append zixuan zz500 sz50 sc500 hs300)))))

;; gen shows
(for-each redirects.html stock-lists)
(for-each sleepy-shows.html stock-lists)

(for-each redirects.html stock-lists)
(for-each sleepy-shows.html stock-lists)

;; localStorage需要一个域define网站才能使用自选功能，在本地文件通过浏览器打开，不同页面会被认为是不同域define而不能共享自选。