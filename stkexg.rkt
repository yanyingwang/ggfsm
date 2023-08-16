#lang at-exp racket/base

(require ming
         ming/number
         racket/format
         csv-reading
         )

(provide 沪股文 沪股文头
         深股文 深股文头
         彐沪股 彐深股 彐股
)


;; http://www.szse.cn/market/product/stock/list/index.html
;; http://www.szse.cn/certificate/individual/index.html?code=000001
;;--
;; http://www.sse.com.cn/assortment/stock/list/share/
;; http://www.sse.com.cn/assortment/stock/list/info/company/index.shtml?COMPANY_CODE=600000
;; http://www.sse.com.cn/market/stockdata/activity/main/


(名 shse-reader
    (make-csv-reader
     (open-input-file "csv/shse.csv")
     '((separator-chars            #\,)
       (strip-leading-whitespace?  . #t)
       (strip-trailing-whitespace? . #t))))

(名 szse-reader
    (make-csv-reader
     (open-input-file "csv/szse.csv")
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
      具有表决权差异安排 具有协议控制架构) ;; (szse-reader)
  )

(名 沪股文
    (csv->list shse-reader))
(名 深股文
    (csv->list szse-reader))

(名 (彐沪股 号)  ; 号：A股代码
    (名 文 (􏹌 (λ (L) (句=? (弔 L 0) 号))
               沪股文))
    (若 文
        (佫 双 沪股文头 文)
        #f)
    )

(名 (彐深股 号)  ; 号：A股代码
    (名 文 (􏹌 (λ (L) (句=? (弔 L 4) 号))
               深股文))
    (若 文
        (佫 双 深股文头 文)
        #f)
    )

(名 (彐股 号)
    (尚 (句􏾝 (􏺔 号) 0 2)
        [("SH")
         (彐沪股 (句􏾝 号 2))]
        [("SZ")
         (彐深股 (句􏾝 号 2))]
        [否则 #f]))
