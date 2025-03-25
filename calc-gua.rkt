#lang at-exp racket/base

(require racket/format
         ming ming/number racket/list racket/symbol
         "8gua.rkt" "64gua.rkt" "gua-helper.rkt")
(provide set-gua-of-price set-gua-of-volume set-gua-of-merged set-gua
         find-top-price find-bottom-price find-top-volume find-bottom-volume find-gua-data)

(define (find-top-price data)
    (apply argmax (map (lambda (e) (string->number (hash-ref e 'high))) data)))
(define (find-bottom-price data)
    (apply  argmin (map (lambda (e) (string->number (hash-ref e 'low))) data)))

(define (find-top-volume data)
    (apply argmax (map (λ (e) (string->number (hash-ref e 'volume))) data)))
(define (find-bottom-volume data)
    (apply  argmin (map (lambda (e) (string->number (hash-ref e 'volume))) data)))

(define (filter  gua-data data gua)
    (filter (λ (H) (symbol=? (hash-ref H 'price-gua) gua)) data))

(define (find-top-price data)
    (apply argmax (map (lambda (e) (string->number (hash-ref e 'high))) data)))
(define (find-bottom-price data)
    (apply argmin (map (lambda (e) (string->number (hash-ref e 'low))) data)))

(define (find-top-volume data)
    (apply argmax (map (λ (e) (string->number (hash-ref e 'volume))) data)))
(define (find-bottom-volume data)
    (apply argmin (map (lambda (e) (string->number (hash-ref e 'volume))) data)))
(define (find-gua-data data gua)
    (findf (λ (H) (symbol=? (hash-ref H 'price-gua) gua)) data))
(define (set-gua-of-price H top-price bottom-price)
    (define step-price
        (/ (- top-price bottom-price) 64))
  (define orderd-gua ;form lower to higher
        (build-list 64 (λ (N)
                 (+ bottom-price (* step-price (add1 N))))))
    (define average-price
        (/ (+ (string->number (hash-ref H 'low))
              (string->number (hash-ref H 'high))) 2))
    (define gua-of-price
        (list-ref gua64 (index-where orderd-gua (λ (p) (>= p average-price)))))
    (hash-set* H 'avg-price average-price 'jgua gua-of-price)
    )
(define (set-gua-of-volume H top-volume bottom-price)
    (define step-price
        (/ (- top-volume bottom-price) 64))
    (define orderd-gua-of-volume  ;由低到高
        (build-list 64 (λ (N)
                (+ bottom-price (* step-price (add1 N))))))
    (define real-volume (string->number (hash-ref H 'volume)))
    (define gua-of-volume
        (list-ref gua64 (index-where orderd-gua-of-volume (λ (l) (>= l real-volume)))))
    (hash-set H 'lgua gua-of-volume)
    )
;; merged-gua：gua-of-volume-merged-gua-of-price
(define (set-gua-of-merged H)
    (define up-gua (down-single-gua (hash-ref H 'lgua)))
    (define down-gua (down-single-gua (hash-ref H 'jgua)))
    (define merged-gua (overlapped-gua up-gua down-gua))
    (hash-set* H 'bgua merged-gua)
    )
(define (set-gua data)
    (define top-price (find-top-price data))
    (define bottom-price (find-bottom-price data))
    (define top-volume (find-top-volume data))
    (define bottom-price (find-bottom-volume data))
    (map (λ (H)

(define (set-gua-of-merged H)
    (define up-gua (down-single-gua (hash-ref H 'lgua)))
    (define down-gua (down-single-gua (hash-ref H 'jgua)))
    (define merged-gua (overlapped-gua up-gua down-gua))
    (hash-set*! H
      'bgua merged-gua
      'bgua-n (list-index gua64 merged-gua)
      'lgua-n (list-index 八gua up-gua)
      'jgua-n (list-index 八gua down-gua))
    )

(define (set-gua data)
    (define top-price (find-top-price data))
    (define bottom-price (find-bottom-price data))
    (define top-volume (find-top-volume data))
    (define bottom-price (find-bottom-volume data))
    (map (λ (H)
         (set-gua-of-merged (set-gua-of-volume (set-gua-of-price H top-price bottom-price)
                              top-volume bottom-price)))
        data)
    )
