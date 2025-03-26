#lang at-exp racket/base

(require ming racket/list
         racket/format
         racket/match
         racket/set
         "8gua.rkt"
         "64gua.rkt")

(provide overlapped-gua
         single-gua
         single-up-gua
         single-down-gua
         gua-index
         gua-binary-representation
         gua-description)

;; 计算八卦在 gua8 列表中的索引
(define (gua-index gua-symbol)
  (define idx (index-of gua8 gua-symbol))
  (if idx
      idx
      (error "Invalid Gua Symbol" gua-symbol)))

;; 将卦转换为二进制表示（阳爻 1，阴爻 0）
(define (gua-binary-representation gua-symbol)
  (match (gua-index gua-symbol)
    [0  '(1 1 1)]  ; 乾
    [1  '(0 0 0)]  ; 坤
    [2  '(1 0 0)]  ; 震
    [3  '(0 1 1)]  ; 巽
    [4  '(0 1 0)]  ; 坎
    [5  '(1 0 1)]  ; 离
    [6  '(0 0 1)]  ; 艮
    [7  '(1 1 0)]  ; 兑
    [_  (error "Invalid gua symbol")]))

;; 获取六十四卦的编号
(define (overlapped-gua up-gua down-gua)
  (define N (gua-index up-gua))
  (define M (gua-index down-gua))
  (define X (+ (* M 8) N)) ; gua64 由下卦变化，每个下卦对应 8 个上卦
  (list-ref gua64 X))

;; 从六十四卦获取上下卦
(define (single-gua overlapped-gua)
  (define X (index-of gua64 overlapped-gua))
  (define-values (M N) (quotient/remainder X 8))
  (values (list-ref gua8 N) (list-ref gua8 M)))

;; 获取上卦
(define (single-up-gua overlapped-gua)
  (define X (index-of gua64 overlapped-gua))
  (define-values (_ N) (quotient/remainder X 8))
  (list-ref gua8 N))

;; 获取下卦
(define (single-down-gua overlapped-gua)
  (define X (index-of gua64 overlapped-gua))
  (define-values (M _) (quotient/remainder X 8))
  (list-ref gua8 M))

;; 获取六十四卦的详细描述
(define (gua-description gua-symbol)
  (match gua-symbol
    ['乾 ]
    ['坤 ]
    ['震 ]
    ['巽 ]
    ['坎 ]
    ['离 ]
    ['艮 ]
    ['兑 ]
    [_ "未知卦象"]))

;; 测试用例
(module+ test
  (require rackunit)
  (check-equal? (overlapped-gua '乾 '坤) '泰)  ; 乾上坤下 -> 泰卦
  (check-equal? (single-up-gua '泰) '乾)      ; 泰卦的上卦 -> 乾
  (check-equal? (single-down-gua '泰) '坤)    ; 泰卦的下卦 -> 坤
  (check-equal? (gua-binary-representation '坎) '(0 1 0)) ; 坎卦二进制
  (check-equal? (gua-description '震) "震惊百里，雷动九天。"))  ; 震卦描述