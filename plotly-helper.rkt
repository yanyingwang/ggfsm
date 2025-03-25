#lang at-exp racket/base


(require ming
         ming/number
         gregor json
         racket/format
         "64gua.rkt"
         )

(provide current-ploty-colorway
         gen-trace gen-plotly-jscode)

(define current-ploty-colorway
    (make-parameter
     (list "#ECCEF5" "#CEECF5" "#0101DF")
     ))


(define (gen-yrect N M C)
    (hash 'fillcolor C 'line (hash 'width 0) 'opacity 0.2 'layer"below" 'type "rect" 'y0 N 'y1 M 'yref "x" 'x0 0 'x1 1 'xref "paper"))

(define roads-of-gua-graphs
    (list (gen-yrect 24 32 "aqua") (gen-yrect 16 24 "Chartreuse") (gen-yrect 8 16 "darkOrange") (gen-yrect 0 8 "mediumBlue") (gen-yrect -8 0 "red") (gen-yrect -16 -8 "grey") (gen-yrect -24 -16 "DarkOrchid") (gen-yrect -32 -24 "darkGray")
        ))

(define (gen-ylines N C)
    (hash 'fillcolor C 'line (hash 'color C 'dash "dot" 'width 1) 'opacity 0.6 'type "line" 'y0 N 'y1 N 'yref "x" 'x0 0 'x1 1 'xref "paper"))

(define middle-line-of-gua-graphs
    (list (gen-ylines 32 "aqua") (gen-ylines 24 "Chartreuse") (gen-ylines 16 "darkOrange") (gen-ylines 8 "mediumBlue") (gen-ylines -8 "red") (gen-ylines -16 "grey") (gen-ylines -24 "DarkOrchid") (gen-ylines -32 "darkGray")))

(define lines-of-gua-graphs
    (list (gen-ylines 32 "aqua") (gen-ylines 24 "Chartreuse") (gen-ylines 16 "darkOrange") (gen-ylines 8 "mediumBlue") (gen-ylines -8 "red") (gen-ylines -16 "grey") (gen-ylines -24 "DarkOrchid") (gen-ylines -32 "darkGray")
        ))


(define (gen-trace name x y t [opacity 1] (customdata #f))
    (define hovertemplate
        (if customdata
            "%{x}, %{y} <br> <b>%{text}元</b> <br> 顶底：%{customdata[2]}~%{customdata[3]}元  <br> 开收: %{customdata[0]}~%{customdata[1]}元 "
            ""))
    (hash
     'name name 'opacity opacity 'mode "markers+lines" 'type "scatter" 'x x 'y y 'text t 'hovertemplate hovertemplate 'customdata customdata 'hoverinfo "all" 'textposition "top center"))

(define (gen-plotly-jscode div data)
    @~a{Plotly.newPlot("@|div|",@(jsexpr->string data),@(jsexpr->string (layout)),@(jsexpr->string config))})


;; coordinates
(define ys-of-coordinate
  (map (λ (N) (let-values  ([(a b) (quotient/remainder N 8)]) (~a "-" (add1 a) (add1 b) (list-ref (reverse 32gua-of-the-second-half) N)))) (build-list 32 value)))
 
(define tick-vals (range  -32 33))
(define tick-text (append (reverse ys-of-coordinate) '("〇") ys-of-coordiante))

(define config
    (hash 'responsive #t))

(define (layout)
    (hash
     'xaxis (hash 'title "时" 'hoverformat "%Y-%m-%d(%a)" 'tickformat "%Y-%m-%d" 'gridwidth 1 'type "date")
     'yaxis (hash 'title "卦" 'range: '(-32 32) 'ticksuffix "$" 'tickmode "array" 'tickvals tick-vals 'ticktext tick-text)
     'shapes lines-of-gua-graphs 'title "卦势图" 'showlegend #t 'height 1200 'colorway (current-ploty-colorway)
     'modebar (hash 'add (list "hovercompare" "hoverclosest") )))


;; usage::
;; (define data
;;     (gen-data (gen-trace x1 y1 t1)
;;               (gen-trace x2 y2 t2)))

;; (gen-plotly-code data)
