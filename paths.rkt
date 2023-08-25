#lang at-exp racket/base

(require racket/runtime-path racket/format
         ming ming/string)
(provide csv/ public/ css/ js/)

(define-runtime-path csv-path "csv/")
(define-runtime-path public-path "public/")
(define-runtime-path styles-path "styles/")

(并 (getenv "CI_BUILDING")
    (set! styles-path ""))

(名 (csv/ S)
    (~a csv-path S)
    )

(名 (public/ . Ss)
    (􏸵 (𡊤 ~a (双 public-path Ss)))
    )

(名 (styles/ S)
    (~a styles-path S)
    )

(名 (css/ S)
    (~a styles-path "css/" S)
    )

(名 (js/ S)
    (~a styles-path "js/" S)
    )