#lang at-exp racket/base


(require racket/format
         ming ming/number
         gregor xml
         "api.rkt"
         "api-helper.rkt"
         "add-8gua.rkt"
         "add-64gua.rkt"
         "64gua.rkt"
         "8gua.rkt"
         "xpage.rkt"
         "jscode-helper.rkt"
         )


;; (股号 "sh603259") ;药明康德
(股号 "sz000858") ;五粮液
(名 文 (取天文/半年))
(名 顶价 (彐顶价 文))
(名 底价 (彐底价 文))
(名 顶量 (彐顶量 文))
(名 底量 (彐底量 文))

(名 卦文
    (佫 (λ (H) (攸以卦 (攸以量卦 (攸以价卦 H 顶价 底价)
                                 顶量 底量)))
        文))

;; (名 卦文1
;;     (􏹈卦文 卦文 '坤))
;; (名 卦文2
;;     (􏹈卦文 卦文 '艮))
;; (名 卦文3
;;     (􏹈卦文 卦文 '坎))
;; (名 卦文4
;;     (􏹈卦文 卦文 '巽))
;; (名 卦文5
;;     (􏹈卦文 卦文 '震))
;; (名 卦文6
;;     (􏹈卦文 卦文 '离))
;; (名 卦文7
;;     (􏹈卦文 卦文 '兑))
;; (名 卦文8
;;     (􏹈卦文 卦文 '乾))

;; ;; (pretty-print-depth 2)
;; (名 trace1
;;     (gen-trace (xvalues 卦文1) (yvalues 卦文1) (tvalues 卦文1)))
;; (名 trace2
;;     (gen-trace (xvalues 卦文2) (yvalues 卦文2) (tvalues 卦文2)))
;; (名 trace3
;;     (gen-trace (xvalues 卦文3) (yvalues 卦文3) (tvalues 卦文3)))
;; (名 trace4
;;     (gen-trace (xvalues 卦文4) (yvalues 卦文4) (tvalues 卦文4)))
;; (名 trace5
;;     (gen-trace (xvalues 卦文5) (yvalues 卦文5) (tvalues 卦文5)))
;; (名 trace6
;;     (gen-trace (xvalues 卦文6) (yvalues 卦文6) (tvalues 卦文6)))
;; (名 trace7
;;     (gen-trace (xvalues 卦文7) (yvalues 卦文7) (tvalues 卦文7)))
;; (名 trace8
;;     (gen-trace (xvalues 卦文8) (yvalues 卦文8) (tvalues 卦文8)))

;; (名 data
    ;; (list trace1 trace2 trace3 trace4 trace5 trace6 trace7 trace8))

(名 data
    (list (gen-trace (xvalues 卦文) (yvalues 卦文) (tvalues 卦文))))

(名 jscode
    (gen-plotly-jscode "myPlot" data))


(with-output-to-file "ggsm.html" #:exists 'replace
  (lambda () (display (xexpr->string (xpage jscode)))))


;; (佫 (λ (e) (􏿰弔 e 'gua)) 八卦文)
(佫 (λ (e) (- (弓 六十四卦 (􏿰弔 e 'gua)) 32)) 八卦文)


(佫 (λ (e) (~a (􏿰弔 e 'day) "-"
               (􏿰弔 e 'gua) "/"
               (􏹔 (􏿰弔 e 'avg-price) 2) "/"
               (􏿰弔 e 'volume))
      )
    八卦文)



(佫 (λ (e) (~a (􏹔 (􏿰弔 e 'avg-price) 2) "/"
               (􏿰弔 e 'volume))
      )
    八卦文)

(佫 (λ (e) (~a (􏿰弔 e 'day) "-"
               (􏿰弔 e 'gua) "/"
               )
      )
    八卦文)



(名 沪市A股 '("600" "601" "603"))
(名 沪市B股 '("900"))

(名 深市A股 '("000"))
(名 深市B股 '("200"))

(名 科创板 '("688"))
(名 创业板 '("300"))
(名 中小板 '("002"))

(名 早期上市股 '("6006"))





(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  (check-equal? (+ 2 2) 4))

(module+ main
  ;; (Optional) main submodule. Put code here if you need it to be executed when
  ;; this file is run using DrRacket or the `racket` executable.  The code here
  ;; does not run when this file is required by another module. Documentation:
  ;; http://docs.racket-lang.org/guide/Module_Syntax.html#%28part._main-and-test%29

  (require racket/cmdline)
  (define who (box "world"))
  (command-line
    #:program "my-program"
    #:once-each
    [("-n" "--name") name "Who to say hello to" (set-box! who name)]
    #:args ()
    (printf "hello ~a~n" (unbox who))))
