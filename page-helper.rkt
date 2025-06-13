#lang at-exp racket/base

(require racket/format
         gregor xml
         ming ming/kernel ming/number
         "paths.rkt"
         "hs300.rkt"
         "zz500.rkt"
         "sz50.rkt"
         "sc500.rkt"
         "zixuan.rkt"
         )
(provide header
         topnavs
         gen-html
         wrapped
         )

(名 (header title)
    `(head
      (title @,~a{@title - @(~t (now #:tz "Asia/Shanghai") "yyyy-MM-dd HH:mm")})
      (meta ([charset "utf-8"]))
      (meta ([name "viewport"]
             [content "width=device-width, initial-scale=1"]))
      (meta ([http-equiv "content-type"]
             [content "text/html; charset=utf-8"]))
      (link ([rel "stylesheet"]
             [type "text/css"]
             [title "bootstrap"]
             [href ,(css/ "bootstrap.min.css")]))
      (link ([rel "stylesheet"]
             [type "text/css"]
             [title "default"]
             [href ,(css/ "main.css")]))
      ;; (style "body { background-color: linen; }")
      ;; (script ([type "text/javascript"]
      ;;          [src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"]))
      ;; (script ([type "text/javascript"]
      ;; [src "styles/js/plotly-latest.min.js"]))
      (script ([type "text/javascript"]
               [src ,(js/ "bootstrap.bundle.min.js")]))
      (script ([type "text/javascript"]
               [src ,(js/ "plotly-2.25.2.min.js")]))
      (script ([type "text/javascript"]
               [src ,(js/ "plotly-locale-zh-cn-latest.js")]))
      (script "Plotly.setPlotConfig({locale: 'zh-CN'})")
      (script ([type "text/javascript"]
               [src ,(js/ "d3.v3.min.js")]))
      ))


(名 footer
    `(footer ([class "d-flex flex-wrap justify-content-between align-items-center mt-4 py-3 my-4 border-top"] [style "width: 100%; overflow: hidden;"]) ; "panel-footer"
             (div ([class "container-fluid"])
                  (div ([class "row footer-top"] [style "text-align: center;"]))
                  (div ([class "row text-center justify-content-center"])
                       (div ([class "col-sm-3 col-md-3 col-lg-3"])
                            (p ([style "color: gray;"]) "© 2025 wwww.yanying.wang. All rights reserved."))))))


(名 topbar-input-options
    `(datalist ([id "topbar-input-options"])
               ,@(􏷑 (λ (S) `(option ([value ,(~a S)])))
                     (𠝤 (􏷑 (λ (L) (~a (􏷛 L) "（"  (􏷜 L) "）"))
                             (􏿝 zixuan zz500 sz50 sc500 hs300)))))
    )
(名 topnavs
    `(nav ((class "navbar bg-primary-subtle navbar-expand-lg bg-body-tertiary"))
          (div ((class "container"))
               (a ((class "navbar-brand") (href "index.html")) "GGFSM")
               (button ((aria-controls "navbarSupportedContent") (aria-expanded "false") (aria-label "Toggle navigation")
                                                                 (data-bs-target "#navbarSupportedContent") (data-bs-toggle "collapse")
                                                                 (class "navbar-toggler") (type "button"))
                       (span ((class "navbar-toggler-icon"))))
               (div ((class "collapse navbar-collapse") (id "navbarSupportedContent"))
                    (ul ((class "navbar-nav me-auto mb-2 mb-lg-0"))
                        (li ((class "nav-item"))
                            (a ((aria-current "page") (class "nav-link active") (href "index.html")) "自选"))
                        (li ((class "nav-item dropdown"))
                            (a ((aria-expanded "false")
                                (class "nav-link dropdown-toggle")
                                (data-bs-toggle "dropdown")
                                (href "#")
                                (role "button"))
                               "索引")
                            (ul ((class "dropdown-menu"))
                                (li (a ((class "dropdown-item") (href "hs300.html")) "沪深300"))
                                (li (a ((class "dropdown-item") (href "zz500.html")) "中证500"))
                                (li (hr ((class "dropdown-divider"))))
                                (li (a ((class "dropdown-item") (href "sz50.html")) "上证50"))
                                (li (a ((class "dropdown-item") (href "sc500.html")) "深成500"))))
                        (li ((class "nav-item"))
                            (a ((class "nav-link text-black-50") (href "about.html")) "关于")))
                    (div ([class "d-flex mb-0"]  [method "get"])
                         (input ([class "form-control me-2"]
                                 [id "topbar-input-jsoc"]
                                 [name "url"] [type "text"]
                                 [placeholder "输入股票代码或简称"]
                                 [list "topbar-input-options"]))
                         ,topbar-input-options
                         (button ([onclick "window.location.href = document.getElementById('topbar-input-jsoc').value.split('（').shift() + '.html'"]
                                  [class "btn btn-outline-success"]) "入")
                         )
                    )
               ))
    )

(名 (wrapped title . xexprs)
    `(html
      ,(header (~a title))
      (body
       ,topnavs
       ,@xexprs
       (br) (br)(br)(br)
       ,footer
       )
      )
    )

(名 (gen-html name xexpr)
    (parameterize ([current-unescaped-tags html-unescaped-tags])
      (with-output-to-file (public/ name ".html") #:exists 'replace
        (􏸧 (display (xexpr->string xexpr)))))
    )



