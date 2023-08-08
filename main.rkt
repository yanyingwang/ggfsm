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
         "api.rkt"
         "api-helper.rkt"
         "add-8gua.rkt"
         "add-64gua.rkt"
         )

;; (股号 "sh603259") ; 药明康德
;; sh601006 五粮液

;; (名 H (甲 文))
;; (攸以量卦 H 顶量 底量)

(名 八卦文
    (股号 "sh603259")
    (名 文 (取天文/半年))
    (名 顶价 (顶价 文))
    (名 低价 (低价 文))
    (名 顶量 (顶量 文))
    (名 底量 (底量 文))
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
     (title @,~a{YJStock - @(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")})
     (meta ((name "viewport") (content "width=device-width, initial-scale=0.9")))
     ;; (style
     ;;     "body { background-color: linen; } .main { width: auto; padding-left: 10px; padding-right: 10px; } .row { padding-top: 10px; } .text { padding-left: 30px; } .subtext { padding-left: 30px; font-size: 90%; } h2 { margin-bottom: 6px; } p { margin-top: 6px; } .responsive { width: 100%; height: auto; }")
          )
    (body
     (div ((class "main"))
          (div
               (h1 "新冠肺炎报告")
               (p ((class "subtext"))
                  #;"作者：Yanying"
                  #;(br)
                  "数据来源：QQ/Sina"
                  (br)
                  @,~a{更新日期：@(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")}
                  #;(br)
                  #;(a ((href "https://www.yanying.wang/daily-report")) "原连接")
                  #;(entity 'nbsp)
                  #;(a ((href "https://github.com/yanyingwang/daily-report")) "源代码")
))
          (div ((class "text"))
               ,(div-wrap processed/domestic/overall)
               #;,(div-wrap processed/domestic/overall1))
          ,(div-wrap/+img processed/domestic/top10 domestic.jpeg)
          ,(div-wrap/+img processed/foreign/conadd/top10 foreign-conadd.jpeg)
          ,(div-wrap/+img processed/foreign/deathadd/top10 foreign-deathadd.jpeg)
          ,(div-wrap/+img processed/foreign/connum/top10 foreign-connum.jpeg)
          ,(div-wrap/+img processed/foreign/deathnum/top10 foreign-deathnum.jpeg)
               ))))
(define xpage/string (xexpr->string xpage))


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
