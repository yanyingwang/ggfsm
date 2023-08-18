#lang at-exp racket/base

(require racket/format
         gregor
         ming ming/number
         "paths.rkt")
(provide header
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
             [href ,(styles/css/ "bootstrap.min.css")]))
      (link ([rel "stylesheet"]
             [type "text/css"]
             [title "default"]
             [href ,(styles/css/ "main.css")]))
      ;; (style "body { background-color: linen; }")
      ;; (script ([type "text/javascript"]
      ;;          [src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"]))
      ;; (script ([type "text/javascript"]
      ;; [src "styles/js/plotly-latest.min.js"]))
      (script ([type "text/javascript"]
               [src ,(styles/js/ "plotly-2.25.2.min.js")]))
      (script ([type "text/javascript"]
               [src ,(styles/js/ "plotly-locale-zh-cn-latest.js")]))
      (script "Plotly.setPlotConfig({locale: 'zh-CN'})")
      (script ([type "text/javascript"]
               [src ,(styles/js/ "d3.v3.min.js")]))

      ))


