#lang at-exp racket/base

(require racket/runtime-path racket/format
         ming ming/string racket/string)
(provide csv/ public/ styles/ css/ js/)

(define-runtime-path csv-path "csv/")
(define-runtime-path public-path "public/")
(define-runtime-path styles-path "styles/")

(and (getenv "CI_BUILDING")
    (set! styles-path ""))

(define (csv/ S)
    (~a csv-path S)
    )

(define (public/ . Ss)
    (string-simplify-spaces (apply ~a (cons public-path Ss)))
    )

(define (styles/ S)
    (~a styles-path S)
    )

(define (css/ S)
    (~a styles-path "css/" S)
    )

(define (js/ S)
    (~a styles-path "js/" S)
    )