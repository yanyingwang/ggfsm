#lang info
(define collection "ggfsm")
(define deps
  '("base"
    "at-exp-lib"
    "gregor-lib"
    "csv-reading"
    "https://github.com/yanyingwang/ming.git#61e7a5eb8bfe7e2691a4df8f70ae5577ac4f10ac"
    "https://github.com/yanyingwang/http-client.git"
    ))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define pkg-desc "Gua Grpah For Stock Market")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
