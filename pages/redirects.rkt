#lang racket/base

(require racket/format
         ming ming/list racket/list ming/number
         "../suo.rkt"
         "../page-helper.rkt"
         )
(provide redirects.html)

(define (redirects.html 股号)
    (define 股名
        (hash-ref (彐股 股号) '简称))
    (define URL
        (~a 股号 "-3md.html"))
    (define page
        `(html
          (head
           (meta ([http-equiv "Refresh"]  [content ,(~a "0; URL=" URL)])))
          (body)))
    (gen-html (~a 股号) page)
    (gen-html (~a 股名) page)
    )

;; (define 股号 "002049") ;紫光国微
;; (redirects.html "002049") ;紫光国微