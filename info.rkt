#lang info
(define collection "ggfsm")
(define deps
  '("base"
    "at-exp-lib"
    "gregor-lib"
    "csv-reading"
    "https://github.com/yanyingwang/ming.git#98c959f8fa8043b8879cc877f821e54c9cc9ea5e"
    "https://github.com/yanyingwang/smtp.git"
    "https://github.com/yanyingwang/http-client.git"
    ))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define pkg-desc "Gua Grpah For Stock Market")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
