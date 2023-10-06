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

(名 current-ploty-colorway
    (make-parameter
     (􏿴 "#ECCEF5" "#CEECF5" "#0101DF")
     ))


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


(名 (gen-trace name x y t [opacity 1] (customdata #f))
    (名 hovertemplate
        (丫 customdata
            "%{x}, %{y} <br> <b>%{text}元</b> <br> 顶底：%{customdata[2]}~%{customdata[3]}元  <br> 开收: %{customdata[0]}~%{customdata[1]}元 "
            ""))
    (􏿰
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

(名 (gen-plotly-jscode div data)
    @~a{
        Plotly.newPlot("@|div|",
                       @(jsexpr->string data),
                       @(jsexpr->string (layout)),
                       @(jsexpr->string config))
        }
    )


;;「坐标」用单字表示称之为「􏸷」
;;坐标值比如(1,2)中的1称为􏸺，2称之为􏸻，因为X是纬线轴，Y是经线轴
(名 负􏸻
    (佫 (λ (N)
          (􏸽  ([(a b) (􏻓和𥺌 N 8)])
              (~a "-" (􏽊 a) (􏽊 b) (弔 (􏾛 三十二阳卦) N))))
        (􏼎 32 並)))
(名 正􏸻
    (佫 (λ (N)
          (􏸽  ([(a b) (􏻓和𥺌 N 8)])
              (~a  (􏽊 a) (􏽊 b) (弔 (􏾛 三十二阴卦) N))))
        (􏼎 32 並)))

(名 tick-vals
    (􏼏  -32 33))
(名 tick-text
    (􏿝 (􏾛 负􏸻) '("〇") 正􏸻))

(名 config
    (􏿰
     ;; 'scrollZoom #t
     'responsive #t
     ;;locale "zh-CN"
     ;; 'editable #t
     ))

(名 (layout)
    (􏿰
     ;; 'hovermode "closest"
     'xaxis (􏿰
             'title "时"
             'hoverformat "%Y-%m-%d(%a)"
             'tickformat "%Y-%m-%d"
             ;; 'gridcolor "lightGray"
             ;; 'ticksuffix "$"
             ;; 'labelalias (􏿰 '|2023-08-01| "...革::::::")
             'gridwidth 1
             ;; 'autorange #t
             ;; 'range (􏿴 (date->iso8601 (-months (today) 6)) (date->iso8601 (today)))
             ;; 'rangeselector (􏿰
             ;;                 'buttons (􏿴 (􏿰
             ;;                               'count 3
             ;;                               'label "3月"
             ;;                               'step "month"
             ;;                               'stepmode "backward")
             ;;                              (􏿰
             ;;                               'count 6
             ;;                               'label "6月"
             ;;                               'step "month"
             ;;                               'stepmode "backward"
             ;;                               )
             ;;                              (􏿰 'step "all")
             ;;                              ))
             ;; 'rangeslider (􏿴 (date->iso8601 (-years (today) 3)) (date->iso8601 (today)))
             'type "date"
             )
     'yaxis (􏿰
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
     ;; 'font (􏿰 'size 12)
     'showlegend #t
     'height 1200
     'colorway (current-ploty-colorway)
     'modebar (􏿰 'add (􏿴 "hovercompare" "hoverclosest") )
     ;; 'width 900
     ; calendar "chinese"
     )
    )


;; usage::
;; (名 data
;;     (gen-data (gen-trace x1 y1 t1)
;;               (gen-trace x2 y2 t2)))

;; (gen-plotly-code data)
