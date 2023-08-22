#lang at-exp racket/base

(require racket/format
         xml gregor
         ming
         "../paths.rkt"
         "../suo.rkt"
         "../page-helper.rkt"
         )

(provide index.html)



(名 (所+码 s)
    (~a (􏿰弔 (彐股 s) '所) (􏿰弔 (彐股 s) '代码))
    )

(define (page strs)
  `(html
    ,(header (~a "股票索引"))
    (body
     (div ([class "container m-5"])
          (h1 ([class "text-center m-5"]) "股票索引")
          (table ([class "table table-bordered m-5"]) #;table-borderless
                 (thead
                  (tr
                   (th ((scope "col")) "简称")
                   (th ((scope "col")) "代码链接")
                   ))
                 (tbody
                  ,@(佫 (λ (s)
                         `(tr #;(th ((scope "row")) "1")
                              (td ,(􏿰弔 (彐股 s) '简称))
                              (td (a ([href ,(~a (所+码 s) ".html")])
                                     ,(所+码 s)))
                              )
                         )
                       strs)
                  )))
     )
    )
  )


(名 (index.html strs)
    (parameterize ([current-unescaped-tags html-unescaped-tags])
      (with-output-to-file (public/ "index.html") #:exists 'replace
        (lambda () (display (xexpr->string (page strs)))))))
