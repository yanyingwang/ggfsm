#lang racket/base

(require http-client racket/format)
(provide bark-xr)


(define icon
  "https://raw.githubusercontent.com/yanyingwang/ggfsm/refs/heads/master/styles/stock.png")
(define xr-api
  (http-connection (getenv "API_DAY_IPHXR")
                   (hasheq)
                   (hasheq 'icon icon 'group "GGFSM")))
(define (bark-xr title content)
  (http-get xr-api
            #:path (~a title  "/" content))
  )

