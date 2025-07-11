#lang racket/base

(require racket/format
         ming ming/list
         "../paths.rkt"
         "../page-helper.rkt"
         )
(provide about.html)


(名 page
    (wrapped
     "About"
     `(div ([class "container my-5"])
           (div ([class "text-center"])
                (h1 "About")
                (p "Source code of this project："
                   (a ((target "_blank") (href "https://github.com/yanyingwang/ggfsm/")) "github.com/yanyingwang/ggfsm"))
                (img ([class "border rounded mb-3 col-6"] [src ,(styles/ "64gua1.jpg")] [alt "64 gua graph"])))
           (p "The reason that I implement this project is that I need to imporve"
              (a ((target "_blank") (href "https://github.com/yanyingwang/ming")) " my Ming. ")
              "By implement this project in Racket with Ming lang style, I can have a practical feel about how does this lang do with programming and where should I improve my Ming lang. Another reason is that I found all the graphes about stocks's price and volume are in two different graph, while I noticed they have a strong connection in some cases of the stocks. I want to merge price and volume to show them in a single graph. By doing this, perhaps we can see the connection more eaily. I'm also curious about the I Ching for a very long time, then there cames I created this project and draw/merge the prices and volumes in a way of what described by the I Ching graphes, which graph is especially called Gua Graph by me.")
           (p "")

           )
     )
    )

(名 (about.html)
    (gen-html "about" page))
