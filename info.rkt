#lang info
(define collection "ggfsm")
(define deps
  '("base"
    "at-exp-lib"
    "gregor-lib"
    "csv-reading"
    "https://github.com/yanyingwang/ming.git#e61188d6e8df507be827863db965b68fd167e195"
    "https://github.com/yanyingwang/http-client.git"
    ))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define pkg-desc "Gua Grpah For Stock Market")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
