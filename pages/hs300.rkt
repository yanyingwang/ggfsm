#lang racket/base

(require racket/format
         gregor
         ming
         "../paths.rkt"
         "../page-helper.rkt"
         "../hs300.rkt"
         "index-helper.rkt"
         )
(provide hs300.html)

(define page
  `(html
    ,(header0 (~a "沪深300"))

    (body
     (div ([class "container my-5 text-center"])
          ,(h1 "沪深300" "https://www.csindex.com.cn/en/indices/index-detail/000300#/indices/family/detail?indexCode=000300")
          (div ([class "row row-cols-4 justify-content-center"])
               (div ([class "col"])
                    ,(table "1~100" hs1))
               (div ([class "col"])
                    ,(table "100~200" hs2))
               (div ([class "col"])
                    ,(table "200~300" hs3))))
     )
    )
  )

(名 (hs300.html)
    (gen-html "hs300" page))
