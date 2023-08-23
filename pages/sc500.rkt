#lang racket/base

(require racket/format
         gregor
         ming
         "../paths.rkt"
         "../page-helper.rkt"
         "../sc500.rkt"
         "index-helper.rkt"
         )
(provide sc500.html)

(define page
  `(html
    ,(header0 (~a "深成500"))

    (body
     (div ([class "container-fluid my-5 text-center"])
          ,(h1 "深成500" "http://www.cnindex.com.cn/module/index-detail.html?act_menu=1&indexCode=399001")
          (div ([class "row mx-5 p-1 row-cols-2.4 justify-content-center"])
               (div ([class "col"])
                    ,(table2 "1~100" sc1))
               (div ([class "col"])
                    ,(table2 "100~200" sc2))
               (div ([class "col"])
                    ,(table2 "200~300" sc3))
               (div ([class "col"])
                    ,(table2 "300~400" sc4))
               (div ([class "col"])
                    ,(table2 "400~500" sc5))
               ))
     )
    )
  )

(名 (sc500.html)
    (gen-html "sc500" page))
