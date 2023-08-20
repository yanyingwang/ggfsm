#lang at-exp racket/base

(require racket/runtime-path racket/format
         ming)
(provide csv-path public-path styles-path
         csv/ public/
         styles/ styles/css/ styles/js/)

(define-runtime-path csv-path "csv/")
(define-runtime-path public-path "public/")
(define-runtime-path styles-path "styles/")


(名 (csv/ S)
    (~a csv-path S)
    )

(名 (public/ . Ss)
    (𡊤 ~a (双 public-path Ss))
    )

(名 (styles/ S)
    (~a styles-path S)
    )

(名 (styles/css/ S)
    (~a styles-path "css/" S)
    )

(名 (styles/js/ S)
    (~a styles-path "js/" S)
    )