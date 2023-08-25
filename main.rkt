#!/usr/bin/env racket

#lang racket/base

(require ming ming/list
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
(名 云股 ;; 云：杂乱未处理的数据
    (𠝤 (􏺈 (􏿝 zz500 sz50 sc500 hs300))))
(名 文股 ;; 文：已处理的数据，选出csv文件中存在的
    (􏹈  (λ (S) (彐股 S))
         (𠝤 (􏺈 (􏿝 zz500 sz50 sc500 hs300)))))

;; gen shows
(各 redirects.html 文股)
(各 sleepy-shows.html 文股)
