#lang racket/base

(require racket/format
         ming ming/list
         "../paths.rkt"
         "../suo.rkt"
         "../page-helper.rkt"
         "../zixuan.rkt"
         "index-helper.rkt"
         )
(provide index.html)


(名 (gen-zixuan-divs t)
    `(div ((class "mt-5 border"))
      (h2 ((class "py-2 border-bottom")) ,t)
          (div ([class "row justify-content-center"])
               ,@(􏷑 (λ (P) `(div ([class "col-2 my-2"])
                                  (a ([class "link-underline-light"] [href ,(~a (阳 P) ".html")]) ,(~a (阴 P)))
                                  ))
                     自选)
               ))
    )

(名 page
    (wrapped
     "Indexes"
     `(div ([class "container my-5 text-center"])
           (h1 ((class "pt-3 pb-1 border-bottom")) "Indexes")
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
                (h2 ([class "py-2 border-bottom"]) "Watching List 1")
                (div ([class "row justify-content-center"]
                      [onload "popDataToZixuan()"]
                      [id "zixuan"])
                     (div ([class "col-2 my-2"])
                          (a ([class "link-underline-light"] [href "#"]) "请添加自选"))
                     )
                )
           ,(gen-zixuan-divs "Watching List 2")
           )
     `(script ([type "text/javascript"] [src ,(js/ "zixuan.js")]))
     `(script "zixuanIndex()")
     )
    )

(名 (index.html)
    (gen-html "index" page))
