#lang at-exp racket/base

(require racket/cmdline
         racket/format
         racket/match
         racket/list
         racket/string
         racket/hash
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt")

(provide top-price-bottom-volume? top-volume-bottom-price? high-price-shrinked-volume?
         low-price-voting-volume? low-price-low-volume? top-price-top-volume?
         get-days analysis-gua analysis-relationship-of-volume-price
         load-stock-data analyze-stock-data)

;; ======================
;;  交易量与价格分析，当日预测规则
;; ======================

;; 判断是否为 “天价天量”（市场过热，可能有回调风险）
(define (top-price-top-volume? d)
  (define jgua (hash-ref d 'jgua-n 0))
  (define lgua (hash-ref d 'lgua-n 0))
  (or (> jgua 5) (> lgua 5)))

;; 判断是否为 “天价地量”（股价高但成交量低，市场冷却的可能性）
(define (top-price-bottom-volume? d)
  (define jgua (hash-ref d 'jgua-n 0))
  (define lgua (hash-ref d 'lgua-n 0))
  (or (> jgua 5) (< lgua 2)))

;; 判断是否为 “天量地价”（成交量暴增但价格未升，潜在买入信号）
(define (top-volume-bottom-price? d)
  (define jgua (hash-ref d 'jgua-n 0))
  (define lgua (hash-ref d 'lgua-n 0))
  (or (< jgua 2) (> lgua 5)))

;; 判断是否为 “高价缩量”（股价高但成交量缩小，可能的卖出信号）
(define (high-price-shrinked-volume? d)
  (define jgua (hash-ref d 'jgua-n 0))
  (define lgua (hash-ref d 'lgua-n 0))
  (or (> jgua 5) (<= 2 lgua 5)))

;; 判断是否为 “低价放量”（低价但成交量增加，可能的买入信号）
(define (low-price-voting-volume? d)
  (define jgua (hash-ref d 'jgua-n 0))
  (define lgua (hash-ref d 'lgua-n 0))
  (or (> jgua 5) (<= 2 lgua 5)))

;; 判断是否为 “低价低量”（市场低迷，观望）
(define (low-price-low-volume? d)
  (define jgua (hash-ref d 'jgua-n 0))
  (define lgua (hash-ref d 'lgua-n 0))
  (or (< jgua 2) (< lgua 2)))


(define (single-of-buy-in? dn)
  (andmap low-price-voting-volume? dn))

(define (single-of-sell-out? dn)
  (andmap high-price-shrinked-volume? dn))

(define (single-of-great-buy-in? d)
  (top-volume-bottom-price? d))

(define (single-of-risking? d)
  (top-price-bottom-volume? d))

;; ======================
;;  数据获取与分析
;; ======================
(define (get-days proc data)
  (map (lambda (d) (hash-ref d 'day)) (filter proc data)))

(define (analysis-gua overlapped-gua)
  (define up-gua (single-up-gua overlapped-gua))
  (define down-gua (single-down-gua overlapped-gua))
  @~a{
      最近交易日卦象为: @|overlapped-gua|
      卦象序号：@(list-ref gua64 overlapped-gua)
      量卦（上卦）：@(up-gua)，序号：@(list-ref gua8 up-gua)
      价卦（下卦）：@(down-gua)，序号：@(list-ref gua8 down-gua)
      })

;; ======================
;;  量价关系分析
;; ======================
;; 交易量或价格等级转换
(define (converting data key)
  (match (hash-ref data key 0)
    [(or 5 6 7) "高"]
    [(or 3 4) "中"]
    [(or 0 1 2) "低"]
    [_ "未知"]))

;; 风险与信号分析
(define (risk d)
  (cond
    [(top-price-top-volume? d) "⚠️ 风险提示：超量超价，可能为市场过热。"]
    [(top-volume-bottom-price? d) "✅ 买入信号：天量地价，可能是入场机会。"]
    [(top-price-bottom-volume? d) "⚠️ 风险提示：天价地量，建议密切关注，如已购入可考虑减仓。"]
    [(high-price-shrinked-volume? d) "🔻 卖出信号：高价缩量，可能有调整风险。"]
    [(low-price-voting-volume? d) "✅ 买入信号：低价起量，可能有资金进入。"]
    [(low-price-low-volume? d) "🔍 观望市场：低价低量，市场低迷，不建议操作。"]
    [else ""]))

;; 量价关系分析主函数
(define (analyze-relationship-of-volume-price d)
  @~a{
      @(hash-ref d 'day) 交易日：
      成交量等级：@(converting d 'lgua-n)
      价格等级：@(converting d 'jgua-n)
      交易信号：@(risk d)
      })




;; ======================
;;  读取数据 & 解析 JSON
;; ======================

(define (read-json-file filename)
  (with-input-from-file filename read-json))

;; 处理交易数据并转换为 JSON 结果
(define (analyze-data json-data)
  (let ([results (map analyze-relationship json-data)])
    (jsexpr->string results)))

;; ======================
;;  命令行调用逻辑
;; ======================

(define (main)
  (define input-file
    (command-line
     #:program "analysis.rkt"
     #:args (code day)
     filename))

  (with-handlers ([exn:fail?
                   (lambda (e)
                     (eprintf "错误: 无法读取或解析 JSON 文件: ~a\n" (exn-message e))
                     (exit 1))])
    (define json-data (read-json-file input-file))
    (define output (analyze-data json-data))
    (displayln output)))

(main)
