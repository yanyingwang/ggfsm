#lang racket/base

(require racket/format
         ming ming/list ming/number
         "../suo.rkt"
         "../page-helper.rkt"
         )
(provide redirects.html)

(名 (redirects.html 股号)
    (名 股名
        (􏿰弔 (彐股 股号) '简称))
    (名 URL
        (~a 股名 "-3md.html"))
    (名 page
        `(html
          (head
           (meta ([http-equiv "Refresh"]  [content ,(~a "0; URL=" URL)])))
          (body
           (div ,(~a "将重定向至：" URL)))))
    (gen-html (~a 股号) page)
    (gen-html (~a 股名) page)
    )

;; (名 股号 "002049") ;紫光国微
;; (redirects.html "002049") ;紫光国微