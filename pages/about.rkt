#lang racket/base

(require racket/format
         ming ming/list racket/list
         "../paths.rkt"
         "../page-helper.rkt"
         )
(provide about.html)


(define page
    (wrapped
     "关于"
     `(div ([class "container my-5"])
           (div ([class "text-center"])
                (h1 "关于")
                (p "本项目源码可见于："
                   (a ((target "_blank") (href "https://github.com/yanyingwang/ggfsm/")) "github.com/yanyingwang/ggfsm"))
                (img ([class "border rounded mb-3 col-6"] [src ,(styles/ "64gua1.jpg")] [alt "64卦图"])))
           )
     )
    )

(define (about.html)
    (gen-html "about" page))
