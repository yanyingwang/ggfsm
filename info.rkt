#lang info
(define collection "ggfsm")
(define deps
  '("base"
    "html-parsing"
    "at-exp-lib"
    "gregor-lib"
    "https://github.com/yanyingwang/smtp.git"
    "https://github.com/yanyingwang/http-client.git"
    "https://github.com/yanyingwang/timable.git"
    ))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/yjstock.scrbl" ())))
(define pkg-desc "Gua Grpah For Stock Market")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
