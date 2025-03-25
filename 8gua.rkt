#lang racket/base

(require racket/vector)
(require racket/hash)

(provide gua8 gua8-with-icons gua8-with-chars gua-name->icon gua-name->binary 
         gua-binary->name gua-index->name gua-index->icon gua-index->binary
         gua-get-all gua-exists?)

;; 八卦名称（从小到大排列）
(define gua8
  '("坤" "艮" "坎" "巽" "震" "离" "兑" "乾"))

;; 八卦符号
(define gua8-icons
  '("☷" "☶" "☵" "☴" "☳" "☲" "☱" "☰"))

;; 八卦对应的二进制数值
(define gua8-binary
  '(0 1 2 3 4 5 6 7))

;; 名称 -> 符号哈希表
(define gua8-with-icons
  (make-immutable-hash (map cons gua8 gua8-icons)))

;; 名称 -> 二进制哈希表
(define gua8-with-chars
  (make-immutable-hash (map cons gua8 gua8-binary)))

;; 位置索引 -> 名称
(define gua-index->name
  (for/vector ([i (in-range 8)]) (list-ref gua8 i)))

;; 位置索引 -> 符号
(define gua-index->icon
  (for/vector ([i (in-range 8)]) (list-ref gua8-icons i)))

;; 位置索引 -> 二进制
(define gua-index->binary
  (for/vector ([i (in-range 8)]) (list-ref gua8-binary i)))

;; 根据八卦名称获取符号
(define (gua-name->icon name)
  (hash-ref gua8-with-icons name "未知"))

;; 根据八卦名称获取二进制值
(define (gua-name->binary name)
  (hash-ref gua8-with-chars name #f))

;; 根据二进制值获取八卦名称
(define (gua-binary->name binary)
  (define index (index-of gua8-binary binary))
  (if index (list-ref gua8 index) "未知"))

;; 获取所有八卦信息
(define (gua-get-all)
  (for/list ([i (in-range 8)])
    (list (vector-ref gua-index->name i)
          (vector-ref gua-index->icon i)
          (vector-ref gua-index->binary i))))

;; 判断八卦是否存在
(define (gua-exists? name)
  (hash-has-key? gua8-with-icons name))

;; 测试函数
;; (displayln "所有八卦信息:")
;; (for-each displayln (gua-get-all))

;; (displayln "\n测试单个查询:")
;; (displayln (gua-name->icon "乾"))  ; => ☰
;; (displayln (gua-name->binary "坎")) ; => 2
;; (displayln (gua-binary->name 5))    ; => "离"
;; (displayln (gua-exists? "离"))      ; => #t
;; (displayln (gua-exists? "不存在"))  ; => #f