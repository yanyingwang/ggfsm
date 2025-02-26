#lang at-exp racket/base

(require racket/runtime-path racket/format
         ming ming/number ming/string ming/list
         csv-reading
         "paths.rkt"
         )

(provide 沪股文 沪股文头
         深股文 深股文头
         彐沪股 彐深股
         彐股 彐股以名
         )

;; http://www.szse.cn/market/product/stock/list/index.html
;; http://www.szse.cn/certificate/individual/index.html?code=000001
;;--
;; http://www.sse.com.cn/assortment/stock/list/share/
;; http://www.sse.com.cn/assortment/stock/list/info/company/index.shtml?COMPANY_CODE=600000
;; http://www.sse.com.cn/market/stockdata/activity/main/
;; -- wiki
;; https://zh.wikipedia.org/zh-hans/Category:%E4%B8%8A%E5%B8%82%E5%85%AC%E5%8F%B8%E5%88%97%E8%A1%A8
;; https://zh.wikipedia.org/zh-hans/%E4%B8%8A%E6%B5%B7%E8%AF%81%E5%88%B8%E4%BA%A4%E6%98%93%E6%89%80%E4%B8%BB%E6%9D%BF%E4%B8%8A%E5%B8%82%E5%85%AC%E5%8F%B8%E5%88%97%E8%A1%A8
;; https://zh.wikipedia.org/zh-hans/%E6%B7%B1%E5%9C%B3%E8%AF%81%E5%88%B8%E4%BA%A4%E6%98%93%E6%89%80%E4%B8%BB%E6%9D%BF%E4%B8%8A%E5%B8%82%E5%85%AC%E5%8F%B8%E5%88%97%E8%A1%A8
;; https://zh.wikipedia.org/zh-hans/Category:%E4%B8%AD%E5%8D%8E%E4%BA%BA%E6%B0%91%E5%85%B1%E5%92%8C%E5%9B%BD%E4%BC%81%E4%B8%9A%E5%88%97%E8%A1%A8

(define shse-reader
    (make-csv-reader
     (open-input-file (csv/ "shse.csv"))
     '((separator-chars            #\,)
       (strip-leading-whitespace?  . #t)
       (strip-trailing-whitespace? . #t))))

(define szse-reader
    (make-csv-reader
     (open-input-file (csv/ "szse.csv"))
     '((separator-chars            #\,)
       (strip-leading-whitespace?  . #t)
       (strip-trailing-whitespace? . #t))))


(define 沪股文头
    '(A股代码 B股代码 证券简称 扩位证券简称 公司英文全称 上市日期) ;; (shse-reader)
    )
(define 深股文头
    '(
      板块 公司全称 英文名称 注册地址 A股代码
      A股简称 A股上市日期 A股总股本 A股流通股本 B股代码
      B股简称 B股上市日期 B股总股本 B股流通股本 地区
      省份 城市 所属行业 公司网址 未盈利
      具有表决权差异安排 具有协议控制架构
      ) ;; (szse-reader)
    )

(define 头
    '(所 代码 简称 英文全称 上市日期))


(define 沪股文
    (csv->list shse-reader))
(define 深股文
    (csv->list szse-reader))

(define (彐沪股 S [N 0]) ;; 0: A股代码，见文头
    (define 文 (􏹌 (λ (L) (􏸶? (弔 L N) S))
               沪股文))
    (并 文
        (􏿰^ (佫 双 头 (双 'SH (伄 文 0 2 4 5)))))
    )

(define (彐深股 S [N 4]) ;; 4: A股代码，见文头
    (define 文 (􏹌 (λ (L) (􏸶? (􏸵 (弔 L N)) S))
               深股文))
    (并 文
        (􏿰^ (佫 双 头 (双 'SZ (伄 文 4 5 2 6)))))
    )

(define (彐股 S)
    (戈 (彐沪股 S) (彐深股 S)))

(define (彐股以名 S)
    (戈 (彐沪股 S 2) (彐深股 S 5)))  ;; 2,5：简称，见文头
