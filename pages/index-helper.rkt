#lang racket/base

(require racket/format
         ming)
(provide h1 table table1 table2)

(define th1
    '(tr
      (th ((scope "col")) "代码")
      (th ((scope "col")) "名称")
      (th ((scope "col")) "交易所")
      (th ((scope "col")) "权重(%)")
      ))

(define th2
    '(tr
      (th ((scope "col")) "代码")
      (th ((scope "col")) "名称")
      (th ((scope "col")) "行业")
      (th ((scope "col")) "权重(%)")
      ))

(define (h1 t [h #f])
    `(div
     (h1 ([class "pt-3"]) ,t
         ,(丫 h
              `(sup ([class "ms-1"])
                    (a ([class "fs-6 text-reset"] [href ,h] [target "_blank"]) "官网"))
             ""))
     (hr))
    )

(define (table t c th)
    `(div
      (h2 ,t)
      (table ([class "table table-striped table-hover text-center"]) ;; table-borderless table-bordered table-striped table-hover
             (thead ,th)
             (tbody ([class "table-group-divider"])
                    ,@(佫 (λ (L)
                            `(tr #;(th ((scope "row")) "1")
                                 (td ,(~a (甲 L)))
                                 (td (a ([href ,(~a (乙 L) ".html")])
                                        ,(~a (乙 L))))
                                 (td ,(~a (丙 L)))
                                 (td ,(~a (丁 L)))))
                          c))
             ))
    )

(define (table1 t c)
    (table t c th1))

(define (table2 t c)
    (table t c th2))
