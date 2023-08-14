#lang at-exp racket/base

(require ming
         ming/number
         gregor json
         racket/format
         "64gua.rkt"
         )

(provide layout config gen-trace gen-plotly-jscode)


(名 (gen-yrect N M C)
    (􏿰 'fillcolor C
        'line (􏿰 'width 0)
        'opacity 0.2
        'layer"below"
        'type "rect"
        'y0 N
        'y1 M
        'yref "x"
        'x0 0
        'x1 1
        'xref "paper"))

(名 八卦条
    (􏿴 (gen-yrect 24 32 "aqua")
        (gen-yrect 16 24 "Chartreuse")
        (gen-yrect 8 16 "darkOrange")
        (gen-yrect 0 8 "mediumBlue")
        (gen-yrect -8 0 "red")
        (gen-yrect -16 -8 "grey")
        (gen-yrect -24 -16 "DarkOrchid")
        (gen-yrect -32 -24 "darkGray")
        ))

(名 (gen-ylines N C)
    (􏿰 'fillcolor C
        'line (􏿰 'color C
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
(名 中卦线
    (􏿴 (gen-ylines 32 "aqua")
        (gen-ylines 24 "Chartreuse")
        (gen-ylines 16 "darkOrange")
        (gen-ylines 8 "mediumBlue")
        (gen-ylines -8 "red")
        (gen-ylines -16 "grey")
        (gen-ylines -24 "DarkOrchid")
        (gen-ylines -32 "darkGray")
        ))
(名 八卦线
    (􏿴 (gen-ylines 32 "aqua")
        (gen-ylines 24 "Chartreuse")
        (gen-ylines 16 "darkOrange")
        (gen-ylines 8 "mediumBlue")
        (gen-ylines -8 "red")
        (gen-ylines -16 "grey")
        (gen-ylines -24 "DarkOrchid")
        (gen-ylines -32 "darkGray")
        ))


(名 (gen-trace x y t)
    (􏿰
     'name "卦"
     'mode "markers+lines+text"
     ;; 'mode "markers+lines"
     'type "scatter"
     'x x
     'y y
     'text t
     ;; 'ids textArray
     'hoverinfo "all"
     'textposition "top center"
     )
    )

(名 (gen-plotly-jscode div data)
    @~a{
        const data = @(jsexpr->string data);
        const layout = @(jsexpr->string layout);
        const config = @(jsexpr->string config);
        Plotly.newPlot(@(~v div), data, layout, config);
        }
    )

(名 tick-vals
    (􏼏  -32 33))
(名 tick-text
    (佫 (λ (S) (勺化句 S))
        (􏿝 三十二阳卦 '(〇) (􏾛 三十二阴卦))))

(名 config
    (􏿰 ;; 'scrollZoom #t
        'responsive #t
        ;;locale "zh-CN"
        ;; 'editable #t
        ))

(名 layout
    (􏿰
     'xaxis (􏿰
             'title "时"
             'hoverformat "%Y-%m-%d(%a)"
             'tickformat "%Y-%m-%d"
             ;; 'gridcolor "lightGray"
             'gridwidth 1
             )
     'yaxis (􏿰
             'title "卦"
             'range: '(-32 32)
             'labelalias (􏿰 '|27革| "27革::::::")
             ;; 'tickmode "linear"
             ;; 'tick0: 0
             ;; 'dtick: 8
             'tickmode "array"
             'tickvals tick-vals
             'ticktext tick-text
             ;; 'gridcolor "lightGray"
             ;; 'showgrid #t
             ;; 'gridwidth 1
             )
     'shapes 八卦线
     'title "量价卦势图（日均半年）"
     ;; 'font (􏿰 'size 12)
     'showlegend #t
     'height 1200
     ;; 'width 600
     ; calendar "chinese"
     )
    )


        ;; usage::
        ;; (名 data
        ;;     (gen-data (gen-trace x1 y1 t1)
        ;;               (gen-trace x2 y2 t2)))

        ;; (gen-plotly-code data)
