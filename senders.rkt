#lang racket/base

(require http-client racket/format)
(provide bark-xr ntfy)


(define icon
  "https://raw.githubusercontent.com/yanyingwang/ggfsm/refs/heads/master/styles/stock.png")
(define xr-api
  (http-connection (getenv "API_DAY_IPHXR")
                   (hasheq 'Content-Type "application/x-www-form-urlencoded")
                   ;; (hasheq 'Content-Type "application/json; charset-utf8")
                   (hasheq 'icon icon 'group "ggfsm-alerts")))
(define (bark-xr title content)
  (http-post xr-api
             #:data  (hasheq 'title title 'body content)))

(define ntfy-api
  (http-connection (getenv "API_NTFY")
                   (hasheq)
                   (hasheq 'icon icon)))
(define (ntfy title message)
  (http-get ntfy-api
            #:path "ggfsm-alerts/publish"
            #:data (hasheq 'message message
                           'title title)))