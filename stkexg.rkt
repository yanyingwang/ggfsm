#lang at-exp racket/base

(require racket/runtime-path racket/format
         ming ming/number ming/string ming/list
         csv-reading
         "paths.rkt"
         )

(provide 沪股文 沪股文头
         深股文 深股文头
         彐沪股 彐深股 彐股)

;; http://www.szse.cn/market/product/stock/list/index.html
;; http://www.szse.cn/certificate/individual/index.html?code=000001
;;--
;; http://www.sse.com.cn/assortment/stock/list/share/
;; http://www.sse.com.cn/assortment/stock/list/info/company/index.shtml?COMPANY_CODE=600000
;; http://www.sse.com.cn/market/stockdata/activity/main/

(名 shse-reader
    (make-csv-reader
     (open-input-file (~a csv/ "shse.csv"))
     '((separator-chars            #\,)
       (strip-leading-whitespace?  . #t)
       (strip-trailing-whitespace? . #t))))

(名 szse-reader
    (make-csv-reader
     (open-input-file (~a csv/ "szse.csv"))
     '((separator-chars            #\,)
       (strip-leading-whitespace?  . #t)
       (strip-trailing-whitespace? . #t))))


(名 沪股文头
    '(A股代码 B股代码 证券简称 扩位证券简称 公司英文全称 上市日期) ;; (shse-reader)
    )
(名 深股文头
    '(
      板块 公司全称 英文名称 注册地址 A股代码
      A股简称 A股上市日期 A股总股本 A股流通股本 B股代码
      B股简称 B股上市日期 B股总股本 B股流通股本 地区
      省份 城市 所属行业 公司网址 未盈利
      具有表决权差异安排 具有协议控制架构
      ) ;; (szse-reader)
    )

(名 头
    '(所 代码 简称 英文全称 上市日期))


(名 沪股文
    (csv->list shse-reader))
(名 深股文
    (csv->list szse-reader))

(名 (彐沪股 S [N 0]) ;; 0: A股代码，见文头
    (名 文 (􏹌 (λ (L) (􏸶? (弔 L N) S))
               沪股文))
    (且 文
        (佫 双 头 (双 'SH (伄 文 0 2 4 5))))
    )

(名 (彐深股 S [N 4]) ;; 4: A股代码，见文头
    (名 文 (􏹌 (λ (L) (􏸶? (􏸵 (弔 L N)) S))
               深股文))
    (且 文
        (佫 双 头 (双 'SZ (伄 文 4 5 2 6))))
    )

(名 (彐股 S)
    (尚 (句􏾝 (􏺔 S) 0 2)
        [("SH")
         (彐沪股 (句􏾝 S 2))]
        [("SZ")
         (彐深股 (句􏾝 S 2))]
        [否则
         (或 (彐沪股 S 2) ;; 2: 简称
             (彐深股 S 5) ;; 5: 简称
             )]))
