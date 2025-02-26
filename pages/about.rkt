#lang racket/base

(require racket/format
         ming ming/list
         "../paths.rkt"
         "../page-helper.rkt"
         )
(provide about.html)


(define page
    (wrapped
     "关于"
     `(div ([class "container my-5"])
           (div ([class "text-center"])
                (h1 "关于")
                (p "本项目源码可见于："
                   (a ((target "_blank") (href "https://github.com/yanyingwang/ggfsm/")) "github.com/yanyingwang/ggfsm"))
                (img ([class "border rounded mb-3 col-6"] [src ,(styles/ "64gua1.jpg")] [alt "64卦图"])))

           (p "我写本项目的初衷，一方面是为了锻炼"
              (a ((target "_blank") (href "https://github.com/yanyingwang/ming")) "名语言")
              "，我需要在实际的使用中明确主体、收集问题，确认方向；另一方面是觉得当今的股票趋势图都是一种绝对描述，因而无法将两张表融合，我想要做出一种多种指标融合在一块的趋势图；还有就是想要研习一下易经八卦，看它到底能否对股价的走向形成一种预判。")
           (p "上段提到的初衷中，关于易经八卦，我后来发现八卦的倒序其实就是二进制的由小到大排序，这样以来，八卦的神秘性一下就荡然无存了，因为大小渐进是数学里面最基础的事情，这样说来，其实也算是没有弄清易经八卦，因为易经八卦的神秘在于其的象形上，就像是围棋的“气”，气是一种抽象，不是一种简单的逻辑推理。同理，我只是弄清八卦的形，并没有弄清它的气。")
           (p "因为上段所述，本项目某一股票趋势图的X轴是时间，而Y轴虽然名曰卦，其实跟用纯数字表示是一样的，因为它仅仅是一种大小的抽象，没有探及更深的维度。")

           )
     )
    )

(define (about.html)
    (gen-html "about" page))
