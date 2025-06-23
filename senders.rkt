#lang racket/base

(require http-client racket/format smtp)
(provide bark-xr nxq-weatherd-ai)


(define icon
  "https://raw.githubusercontent.com/yanyingwang/ggfsm/refs/heads/master/styles/stock.png")
(define xr-api
  (http-connection (getenv "API_DAY_IPHXR")
                   (hasheq)
                   (hasheq 'icon icon)
                   (hasheq 'group "GGFSM")))
(define (bark-xr title content)
  (http-get xr-api
            #:path (~a title  "/" content))
  )

(define ntfy-api
  (http-connection (getenv "API_NTFY")
                   (hasheq)
                   (hasheq 'icon icon)))

(define (nxq-weatherd-ai title message)
  (http-get ntfy-api
            #:path "nxq-weatherd-ai/publish"
            #:data (hasheq 'message message
                           'title title)))
