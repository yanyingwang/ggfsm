
#lang at-exp racket/base

(require ming ming/list
         racket/format
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt")
(provide 天价地量? 天量地价? 高价缩量? 低价起量? 低价低量? 超量超价?
         get-days 卦象解析 量价解析)

(define (超量超价? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (> (hash-ref d 'lgua-n) 5)))

(define (天价地量? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (< (hash-ref d 'lgua-n) 2)))

(define (天量地价? d)
  (or (< (hash-ref d 'jgua-n) 2)
      (> (hash-ref d 'lgua-n) 5)))

(define (高价缩量? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (or (> (hash-ref d 'lgua-n) 2)
          (< (hash-ref d 'lgua-n) 5))))

(define (低价起量? d)
  (or (> (hash-ref d 'jgua-n) 5)
      (or (> (hash-ref d 'lgua-n) 2)
          (< (hash-ref d 'lgua-n) 5))))

(define (低价低量? d)
  (or (< (hash-ref d 'jgua-n) 2)
      (< (hash-ref d 'lgua-n) 2)))

(define (买入信号? dn) ; 连续三日低价起量
  (andmap 低价起量? dn))

(define (卖出信号? dn) ; 连续三日高价缩量
  (andmap 高价缩量? dn))

(define (超买信号? d)
    (天量地价? d))

(define (风险信号? d)
    (天价地量? d))

(define (get-days proced dn)
  (map  (lambda (d) (hash-ref d 'day))
        (filter proced dn)))

(define (卦象解析 复卦)
  @~a{最近一个交易日卦象（复卦）为: @|复卦|，序号为：@(list-ref 六十四卦 复卦)。拆解后，其上单卦（量卦）为： @(上单卦 复卦)，序号是：@(list-ref 八卦 (上单卦 复卦))；其下单卦（价卦）为： @(下单卦 复卦)，序号是：@(list-ref 八卦 (下单卦 复卦))。})

(define (量价解析 d)
    (define (置 data key)
      (肖 (hash-ref data key)
            [(5 6 7) "高"]
            [(3 4) "中"]
            [(0 1 2) "低"]
            [夬 #f]))
    (define (风险 d)
        (cond
         [(超量超价? d) "风险提示：超量超价(多方买入)。"]
         [(天量地价? d) "买入信号：天量地价(超强买入)，可以入场。"]
         [(天价地量? d) "风险提示：天价地量，需密切关注，如已购入，建议减仓。"]
         [(高价缩量? d) "卖出信号：高价缩量(卖出信号)。"]
         [(低价起量? d) "买入信号：低价起量(一般买入)。"]
         [(低价低量? d) "观望市场：低价低量(市场低靡), 不建议操作。"]

         [else "无异常，观望市场。"])
        )
    @~a{@(hash-ref d 'day)当日，本股交易量位于@(置 d 'lgua-n)位，价格位于@(置 d 'jgua-n)位。@(风险 d)})