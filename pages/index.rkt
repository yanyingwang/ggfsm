#lang racket/base

(require racket/format
         ming ming/list
         "../paths.rkt"
         "../suo.rkt"
         "../page-helper.rkt"
         "index-helper.rkt"
         )
(provide index.html)


(名 AL1
    (􏿳 "603259" '药明康德 "300015" '艾尔眼科 "600750" '江中药业 "600559" '老白干 "000858" '五粮液 "000568" '泸州老窖))

(名 AL2
    (􏿳 "600519" '贵州茅台 "002049" '紫光国微 "300750" '宁德时代 "002594" '比亚迪 "002709" '天赐材料 "002460" '赣锋锂业))


(名 (tda L)
    `(td (a ([href ,(~a (阳 L) ".html")]) ,(~a (阴 L)))))

(名 page
    (wrapped
     "索引"
     `(div ([class "container my-5 text-center"])
           ,(h1 "索引")
           (div ([class "row justify-content-center"])
                (div ([class "col-4"])
                     (table ([class "table text-center"])
                            (tbody
                             (tr
                              (td (a ([href "hs300.html"]) "沪深300"))
                              (td (a ([href "zz500.html"]) "中证500"))
                              (td (a ([href "sz50.html"]) "上证50"))
                              (td (a ([href "sc500.html"]) "深成500"))
                              )
                             )))
                (div ([class "width-100"]))
                (div ([class "col-8"])
                     (table ([class "table text-center"])
                            (tbody
                             (tr ,@(佫 tda AL1))
                             (tr ,@(佫 tda AL2))
                             )))
                )
           ))
    )

(名 (index.html)
    (gen-html "index" page))
