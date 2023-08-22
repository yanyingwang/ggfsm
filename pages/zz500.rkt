#lang racket/base

(require racket/format
         gregor
         ming
         "../page-helper.rkt"
         "../zz500.rkt"
         "index-helper.rkt"
         )
(provide zz500.html)

(define page
  `(html
    ,(header0 (~a "中证500"))
    (body
     (div ([class "container-fluid my-5 text-center"])
          ,(h1 "中证500" "https://www.csindex.com.cn/zh-CN/indices/index-detail/000905#/indices/family/detail?indexCode=000905")
          (div ([class "row mx-5 p-1 row-cols-2.4 justify-content-center"])
               (div ([class "col"])
                    ,(table "1~100" zz1))
               (div ([class "col"])
                    ,(table "100~200" zz2))
               (div ([class "col"])
                    ,(table "200~300" zz3))
               (div ([class "col"])
                    ,(table "300~400" zz4))
               (div ([class "col"])
                    ,(table "400~500" zz5))
               ))
     )
    )
  )

(名 (zz500.html)
    (gen-html "zz500" page))
