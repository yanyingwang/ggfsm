#lang racket/base

(require racket/format
         gregor
         ming
         "../paths.rkt"
         "../page-helper.rkt"
         "../sz50.rkt"
         "index-helper.rkt"
         )
(provide sz50.html)

(define page
  `(html
    ,(header0 (~a "上证50"))

    (body
     (div ([class "container my-5 text-center"])
          ,(h1 "上证50" "http://www.sse.com.cn/market/sseindex/indexlist/s/i000016/intro.shtml?INDEX_Code=000016")
          (div ([class "row row-cols-3 justify-content-center"])
               (div ([class "col"])
                    ,(table2 "1~25" sz1))
               (div ([class "col"])
                    ,(table2 "25~50" sz2))
               ))
     )
    )
  )

(名 (sz50.html)
    (gen-html "sz50" page))
