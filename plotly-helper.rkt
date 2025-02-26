#lang at-exp racket/base


(require ming
         ming/number
         gregor json
         racket/format
         "64gua.rkt"
         )

(provide current-ploty-colorway
         ;; layout config
         gen-trace gen-plotly-jscode)

(define current-ploty-colorway
    (make-parameter
     (list "#ECCEF5" "#CEECF5" "#0101DF")
     ))


(define (gen-yrect N M C)
    (hash 'fillcolor C
        'line (hash 'width 0)
        'opacity 0.2
        'layer"below"
        'type "rect"
        'y0 N
        'y1 M
        'yref "x"
        'x0 0
        'x1 1
        'xref "paper"))

(define 八卦条
    (list (gen-yrect 24 32 "aqua")
        (gen-yrect 16 24 "Chartreuse")
        (gen-yrect 8 16 "darkOrange")
        (gen-yrect 0 8 "mediumBlue")
        (gen-yrect -8 0 "red")
        (gen-yrect -16 -8 "grey")
        (gen-yrect -24 -16 "DarkOrchid")
        (gen-yrect -32 -24 "darkGray")
        ))

(define (gen-ylines N C)
    (hash 'fillcolor C
        'line (hash 'color C
                  'dash "dot"
                  'width 1)
        'opacity 0.6
        'type "line"
        'y0 N
        'y1 N
        'yref "x"
        'x0 0
        'x1 1
        'xref "paper"))

(define 中卦线
    (list (gen-ylines 32 "aqua")
        (gen-ylines 24 "Chartreuse")
        (gen-ylines 16 "darkOrange")
        (gen-ylines 8 "mediumBlue")
        (gen-ylines -8 "red")
        (gen-ylines -16 "grey")
        (gen-ylines -24 "DarkOrchid")
        (gen-ylines -32 "darkGray")
        ))

(define 八卦线
    (list (gen-ylines 32 "aqua")
        (gen-ylines 24 "Chartreuse")
        (gen-ylines 16 "darkOrange")
        (gen-ylines 8 "mediumBlue")
        (gen-ylines -8 "red")
        (gen-ylines -16 "grey")
        (gen-ylines -24 "DarkOrchid")
        (gen-ylines -32 "darkGray")
        ))


(define (gen-trace name x y t [opacity 1] (customdata #f))
    (define hovertemplate
        (if customdata
            "%{x}, %{y} <br> <b>%{text}元</b> <br> 顶底：%{customdata[2]}~%{customdata[3]}元  <br> 开收: %{customdata[0]}~%{customdata[1]}元 "
            ""))
    (hash
     'name name
     'opacity opacity
     ;; 'mode "markers+lines+text"
     'mode "markers+lines"
     'type "scatter"
     'x x
     'y y
     'text t
     'hovertemplate hovertemplate
     'customdata customdata
     ;; 'ids textArray
     'hoverinfo "all"
     'textposition "top center"
     )
    )

(define (gen-plotly-jscode div data)
    @~a{
        Plotly.newPlot("@|div|",
                       @(jsexpr->string data),
                       @(jsexpr->string (layout)),
                       @(jsexpr->string config))
        }
    )


;;「坐标」用单字表示称之为「􏸷」
;;坐标值比如(1,2)中的1称为􏸺，2称之为􏸻，因为X是纬线轴，Y是经线轴
(define 负􏸻
    (map (λ (N)
          (􏸽  ([(a b) (􏻓和𥺌 N 8)])
              (~a "-" (add1 a) (add1 b) (list-ref (reverse 三十二阳卦) N))))
        (build-list 32 並)))
(define 正􏸻
    (map (λ (N)
          (􏸽  ([(a b) (􏻓和𥺌 N 8)])
              (~a  (add1 a) (add1 b) (list-ref (reverse 三十二阴卦) N))))
        (build-list 32 並)))

(define tick-vals
    (􏼏  -32 33))
(define tick-text
    (􏿝 (reverse 负􏸻) '("〇") 正􏸻))

(define config
    (hash
     ;; 'scrollZoom #t
     'responsive #t
     ;;locale "zh-CN"
     ;; 'editable #t
     ))

(define (layout)
    (hash
     ;; 'hovermode "closest"
     'xaxis (hash
             'title "时"
             'hoverformat "%Y-%m-%d(%a)"
             'tickformat "%Y-%m-%d"
             ;; 'gridcolor "lightGray"
             ;; 'ticksuffix "$"
             ;; 'labelalias (hash '|2023-08-01| "...革::::::")
             'gridwidth 1
             ;; 'autorange #t
             ;; 'range (list (date->iso8601 (-months (today) 6)) (date->iso8601 (today)))
             ;; 'rangeselector (hash
             ;;                 'buttons (list (hash
             ;;                               'count 3
             ;;                               'label "3月"
             ;;                               'step "month"
             ;;                               'stepmode "backward")
             ;;                              (hash
             ;;                               'count 6
             ;;                               'label "6月"
             ;;                               'step "month"
             ;;                               'stepmode "backward"
             ;;                               )
             ;;                              (hash 'step "all")
             ;;                              ))
             ;; 'rangeslider (list (date->iso8601 (-years (today) 3)) (date->iso8601 (today)))
             'type "date"
             )
     'yaxis (hash
             'title "卦"
             'range: '(-32 32)
             ;; 'tickmode "linear"
             ;; 'tick0: 0
             ;; 'dtick: 8
             'ticksuffix "$"
             'tickmode "array"
             'tickvals tick-vals
             'ticktext tick-text
             ;; 'gridcolor "lightGray"
             ;; 'showgrid #t
             ;; 'gridwidth 1
             )
     'shapes 八卦线
     'title "卦势图"
     ;; 'font (hash 'size 12)
     'showlegend #t
     'height 1200
     'colorway (current-ploty-colorway)
     'modebar (hash 'add (list "hovercompare" "hoverclosest") )
     ;; 'width 900
     ; calendar "chinese"
     )
    )


;; usage::
;; (define data
;;     (gen-data (gen-trace x1 y1 t1)
;;               (gen-trace x2 y2 t2)))

;; (gen-plotly-code data)
