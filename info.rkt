#lang info
(define collection "ggfsm")
(define deps
  '("base"
    "at-exp-lib"
    "gregor-lib"
    "csv-reading"
    "xmpp"
    "https://github.com/yanyingwang/ming.git#2e33cbcfb33e0bbf26bb8e3b80842f04fd03c09b"
    "https://github.com/yanyingwang/http-client.git"
    ))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define pkg-desc "Gua Grpah For Stock Market")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
