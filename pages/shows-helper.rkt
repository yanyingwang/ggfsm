#lang racket/base

(require racket/format
         ming ming/number ming/list racket/list
         gregor
         "../64gua.rkt"
         "../plotly-helper.rkt"
         "../gu-helper.rkt")
(provide xs
         ys/价卦 ys/并卦 ys/量卦
         ts/量 ts/并卦
         ts/其他价 ts/average-price
         plotly-data plotly-script
         sselink szselink suolink
         thslink gstlink
         compinfo nav-tabs
         )

(define (xs 文)
    (map (λ (e) (hash-ref e 'day)) 文))

(define (xs 文)
    (map (λ (e) (hash-ref e 'day)) 文))

(define (n-to-y n)
    (define n1 (- n 32))
    (if (exact-nonnegative-integer? n1)
        (add1 n1)
        n1))

(define (ys/并卦 文)
    (map (λ (H)
          (n-to-y (index-of gua64 (hash-ref H 'bgua))))
        文))

(define (ys/价卦 文)
    (map (λ (H)
          (n-to-y (index-of gua64 (hash-ref H 'jgua))))
        文))

(define (ys/量卦 文)
    (map (λ (H)
          (n-to-y (index-of gua64 (hash-ref H 'lgua))))
        文))

(define (ts/其他价 文)
    (map (λ (H)
          (list
           (round (string->number (hash-ref H 'open)))
           (round (string->number (hash-ref H 'close)))
           (round (string->number (hash-ref H 'high)))
           (round (string->number (hash-ref H 'low)))
           ))
        文))

(define (ts/average-price 文)
    (map (λ (H)
          (round (hash-ref H 'avg-price)))
        文))

(define (ts/量 文)
    (map (λ (H) (~a (round (/ (string->number (hash-ref H 'volume)) 10000)) "万手"))
        文))

(define (ts/并卦 文)
    (map (λ (H)
          (~a (round (hash-ref H 'avg-price)) "元"

(define (ys/并卦 文)
    (map (λ (H)
          (n-to-y (list-index gua64 (hash-ref H 'bgua))))
        文))

(define (ys/价卦 文)
    (map (λ (H)
          (n-to-y (list-index gua64 (hash-ref H 'jgua))))
        文))

(define (ys/量卦 文)
    (map (λ (H)
          (n-to-y (list-index gua64 (hash-ref H 'lgua))))
        文))

(define (ts/其他价 文)
    (map (λ (H)
          (􏿴
           (round (string->number (hash-ref H 'open)))
           (round (string->number (hash-ref H 'close)))
           (round (string->number (hash-ref H 'high)))
           (round (string->number (hash-ref H 'low)))
           ))
        文))

(define (ts/average-price 文)
    (map (λ (H)
          (round (hash-ref H 'avg-price)))
        文))

(define (ts/量 文)
    (map (λ (H) (~a (􏹓 (/ (string->number (hash-ref H 'volume)) 10000)) "万手"))
        文))

(define (ts/并卦 文)
    (map (λ (H)
          (~a (round (hash-ref H 'avg-price)) "元"
              "/"
              (round (/ (string->number (hash-ref H 'volume)) 10000)) "万手"
              ))
        文))


(define (plotly-data 文)
    (list (gen-trace "量" (xs 文) (ys/量卦 文) (ts/量 文) 1)
        (gen-trace "价" (xs 文) (ys/价卦 文) (ts/average-price 文) 1 (ts/其他价 文))
        (gen-trace "并" (xs 文) (ys/并卦 文) (ts/并卦 文) #;(ts/overlapped-gua数 文))
        ))

(define (plotly-script div 文)
    `(script ,(gen-plotly-jscode (~a div) (plotly-data 文)))
    )


(define (sselink 代码)
    (string-append "http://www.sse.com.cn/assortment/stock/list/info/company/index.shtml?COMPANY_CODE=" 代码))
(define (szselink 代码)
    (string-append "http://www.szse.cn/certificate/individual/index.html?code=" 代码))
(define (suolink code 所)
    (case 所
        [(SH) (sselink 代码)]
        [(SZ) (szselink 代码)]
        [else ""]
        ))

(define (gstlink stock-code)
    (string-append "https://gushitong.baidu.com/stock/ab-" stock-code))
(define (thslink stock-code)
    (string-append "http://basic.10jqka.com.cn/" stock-code))

(define (compinfo exchange stock-code 中文简称 英文全称 上市日期)
    `(div ([class "row text-center justify-content-center"])
          (h1 ([id "stock-name-code"])
              ,(~a 中文简称 "（" stock-code "）")
              (button ([type "button"]
                       [id "zixuan-add-item-button"]
                       [class "btn btn-success"]
                       [onclick "zixuanAddItem()"])
                      "加自选")
              )
          (div ([class "col-12 mb-0"]) ,英文全称 )
          (div ([class "col-12 mb-0"]) ,(~a "数据更新日期：" (~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")))
          (div ([class "col-12 mb-0"])
               (a ([class "me-3"] [href ,(suolink stock-code 所)] [target "_blank"]) "在交易所")
               (a ([class "me-3"] [href ,(gstlink stock-code)] [target "_blank"]) "股市通")
               (a ([class "me-3"] [href ,(thslink stock-code)] [target "_blank"]) "同花顺F10"))
          (div ([class "col-md-6"])
               (table ([class "table text-center"])
                      (tbody
                       (tr (td ,(~a "交易所：" 所))
                           (td ,(~a "上市日期：" 上市日期)))
                       (tr (td ,(~a "板块：" (industry stock-code)))
                           (td ,(~a "股指：" (string-join (stock-index stock-code) "/")))
                           (td ,(~a "股指：" (list->string (stock-index stock-code) "/")))
                           ))))
          )
    )

(define (nav-tabs stock-code active)
    (define AL (association-list
            '3md "three-months/in-day"
            '6md "six-months/in-day"
            '1yd "one-year/in-day"
            '2yw "two-years/in-week"
            '3yw "three-years/in-week"
            '5yw "five-years/in-week"))
    `(ul ([class "nav nav-pills justify-content-center"])
         ,@(map (λ (AP)
                 `(li ([class "nav-item"])
                      (a ([class ,(if (symbol=?? (car AP) active) "nav-link active" "nav-link")]
                          ;; [aria-current ,(if (symbol=?? (car P) active) "true" "false")]
                          [href ,(~a stock-code "-" (car AP) ".html")]) ,(cdr AP)))
                  ,@(map (λ (AP)
                 `(li ([class "nav-item"])
                      (a ([class ,(丫 (symbol=? (car AP) active) "nav-link active" "nav-link")]
                          ;; [aria-current ,(丫 (symbol=? (car P) active) "true" "false")]
                          [href ,(~a stock-code "-" (car AP) ".html")]) ,(cdr AP)))
                         )
               AL)
         )
    )
