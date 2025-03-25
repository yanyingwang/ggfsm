#lang at-exp racket/base

(require ming racket/list
         racket/format
         "8gua.rkt"
         "64gua.rkt")
(provide overlapped-gua single-gua single-up-gua single-down-gua)

;; overlapped-gua overlapped gua
;; single-gua single gua
;; single-up-gua single up gua
;; single-down-gua signle down gua

(define (overlapped-gua up-gua down-gua)
  (define N (index-of gua8 up-gua))
  (define M (index-of gua8 down-gua))
  (define X (+ (* M 8) N)) ; gua64是下gua8的每一序卦都依次排布上gua8
  (list-ref gua64 X)
  )

(define (single-gua overlapped-gua)
  (define X (index-of gua64 overlapped-gua))
  (define-values (M N) (quotient/remainder X 8))
  (value (list-ref gua8 N)
         (list-ref gua8 M)))

(define (single-up-gua overlapped-gua)
  (define X (index-of gua64 overlapped-gua))
  (define-values (M N) (quotient/remainder X 8))
  (list-ref gua8 N))

(define (single-down-gua overlapped-gua)
  (define X (index-of gua64 overlapped-gua))
  (define-values (M N) (quotient/remainder X 8))
  (list-ref gua8 M)
  )
