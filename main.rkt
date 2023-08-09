#lang at-exp racket/base

(module+ test
  (require rackunit))

;; Notice
;; To install (from within the package directory):
;;   $ raco pkg install
;; To install (once uploaded to pkgs.racket-lang.org):
;;   $ raco pkg install <<name>>
;; To uninstall:
;;   $ raco pkg remove <<name>>
;; To view documentation:
;;   $ raco docs <<name>>
;;
;; For your convenience, we have included LICENSE-MIT and LICENSE-APACHE files.
;; If you would prefer to use a different license, replace those files with the
;; desired license.
;;
;; Some users like to add a `private/` directory, place auxiliary files there,
;; and require them in `main.rkt`.
;;
;; See the current version of the racket style guide here:
;; http://docs.racket-lang.org/style/index.html

(require ming
         ming/number
         gregor
         xml
         racket/format
         "api.rkt"
         "api-helper.rkt"
         "add-8gua.rkt"
         "add-64gua.rkt"
         )

;; (股号 "sh603259") ; 药明康德
;; sh601006 五粮液

;; (名 H (甲 文))
;; (攸以量卦 H 顶量 底量)

;; 令令今

(名 (abc)
    (名 文 (取天文/半年))
    "sfsf"
    )

(股号 "sh603259")
(名 文 (取天文/半年))
(名 顶价 (彐顶价 文))
(名 底价 (彐底价 文))
(名 顶量 (彐顶量 文))
(名 底量 (彐底量 文))

(名 八卦文
    (佫 (λ (H) (攸以卦 (攸以量卦 (攸以价卦 H 顶价 底价)
                                 顶量 底量)))
        文))



(名 沪市A股 '("600" "601" "603"))
(名 沪市B股 '("900"))

(名 深市A股 '("000"))
(名 深市B股 '("200"))

(名 科创板 '("688"))
(名 创业板 '("300"))
(名 中小板 '("002"))

(名 早期上市股 '("6006"))


(define xpage
  `(html
    (head
     (title @,~a{八卦走势图 - @(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")})
     (meta ([name "viewport"]
            [content "width=device-width, initial-scale=0.9"]))
     (meta ([http-equiv "content-type"]
            [content "text/html; charset=utf-8"]))
     (link ([rel "stylesheet"]
            [type "text/css"]
            [title "default"]
            [href "public/main.css"]))
     (style "body { background-color: linen; }")
     (script ([type "text/javascript"]
              [src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"]))
     (script ([type "text/javascript"]
              [src "https://cdn.plot.ly/plotly-latest.min.js"]))
     )
    (body
     (div ((class "main"))
          (div
           (h1 "ggfsm")
               (p ((class "subtext"))
                  "数据来源：Sina"
                  (br)
                  @,~a{更新日期：@(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")}
                  #;(br)
                  #;(a ((href "https://www.yanying.wang/daily-report")) "原连接")
                  #;(entity 'nbsp)
                  #;(a ((href "https://github.com/yanyingwang/daily-report")) "源代码")
))
          (div ((class "text"))
               (div ((class "sub"))
                    (h2 ((style "margin-bottom: 6px;")) "h2222222")
                    (p ((style "margin-top: 6px;")) "Chart.js")
                    (canvas ([id "a1234a"]
                             [style "width:100%;max-width:700px"]))
                    (br)
                    (canvas ([id "a1234z"]
                             [style "width:100%;max-width:700px"]))
                    (br)
                    (canvas ([id "a1234b"]
                             [style "width:100%;max-width:700px"]))
                    (br)
                    (canvas ([id "a1234c"]
                             [style "width:100%;max-width:700px"]))
                    (br)
                    (canvas ([id "a1234d"]
                             [style "width:100%;max-width:700px"]))

                    (p ((style "margin-top: 6px;")) "Ploty.js")
                    (div ([id "b1234b"]
                          [style "width:100%;max-width:700px"]))
                    )
               )
          ))
    (script ([type "text/javascript"]
             [src "public/mychart.js"]))
    (script ([type "text/javascript"]
             [src "public/myplot.js"]))
    )
  )


(with-output-to-file "ggsm.html" #:exists 'replace
  (lambda () (display (xexpr->string xpage))))


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
