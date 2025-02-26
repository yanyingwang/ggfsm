#lang racket/base

(require racket/format
         ming ming/list
         "../paths.rkt"
         "../suo.rkt"
         "../page-helper.rkt"
         "index-helper.rkt"
         )
(provide index.html)


(名 AL
    (􏿳 "603259" '药明康德 "300015" '艾尔眼科 "600750" '江中药业 "600559" '老白干 "000858" '五粮液 "000568" '泸州老窖
        "600519" '贵州茅台 "002049" '紫光国微 "300750" '宁德时代 "002594" '比亚迪 "002709" '天赐材料 "002460" '赣锋锂业
        ))


(名 (自选 t)
    `(div ((class "mt-5 border"))
      (h2 ((class "py-2 border-bottom")) ,t)
          (div ([class "row justify-content-center"])
               ,@(􏷑 (λ (P) `(div ([class "col-2 my-2"])
                                  (a ([class "link-underline-light"] [href ,(~a (阳 P) ".html")]) ,(~a (阴 P)))
                                  ))
                     AL)
               ))
    )

(名 page
    (wrapped
     "索引"
     `(div ([class "container my-5 text-center"])
           (h1 ((class "pt-3 pb-1 border-bottom")) "索引")
           (div ([class "row justify-content-center"])
                (div ([class "col-2 py-2 border-bottom"])
                     (a ([class " link-underline-light"] [href "hs300.html"]) "沪深300"))
                (div ([class "col-2 py-2 border-bottom"])
                     (a ([class " link-underline-light"] [href "zz500.html"]) "中证500"))
                (div ([class "col-2 py-2 border-bottom"])
                     (a ([class " link-underline-light"] [href "sz50.html"]) "上证50"))
                (div ([class "col-2 py-2 border-bottom"])
                     (a ([class " link-underline-light"] [href "sc500.html"]) "深成500")))
           (div ((class "mt-5 border"))
                (h2 ([class "py-2 border-bottom"]) "自选1")
                (div ([class "row justify-content-center"]
                      [onload "popDataToZixuan()"]
                      [id "zixuan"])
                     (div ([class "col-2 my-2"])
                          (a ([class "link-underline-light"] [href "#"]) "请添加自选"))
                     )
                )
           ,(自选 "自选2")
           )
     `(script ([type "text/javascript"] [src ,(js/ "zixuan.js")]))
     `(script "zixuanIndex()")
     )
    )

(名 (index.html)
    (gen-html "index" page))
