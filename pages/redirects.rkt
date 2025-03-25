#lang racket/base

(require racket/format
         ming ming/list racket/list ming/number
         "../suo.rkt"
         "../page-helper.rkt"
         )
(provide redirects.html)

(define (redirects.html stock-code)
    (define 股名
        (hash-ref (find-stock stock-code) '简称))
    (define URL
        (~a stock-code "-3md.html"))
    (define page
        `(html
          (head
           (meta ([http-equiv "Refresh"]  [content ,(~a "0; URL=" URL)])))
          (body)))
    (gen-html (~a stock-code) page)
    (gen-html (~a 股名) page)
    )

;; (define stock-code "002049") ;紫光国微
;; (redirects.html "002049") ;紫光国微