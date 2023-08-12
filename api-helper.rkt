#lang racket/base

(require racket/format
         ming ming/number
         "8gua.rkt"
         "64gua.rkt")
(provide 彐顶价
         彐底价
         彐顶量
         彐底量
         􏹈卦文
         xvalues
         yvalues
         tvalues)

(名 (彐顶价 文)
    (𡊤 􏺗 (佫 (入 (e) (句化米 (􏿰弔 e 'high))) 文)))
(名 (彐底价 文)
    (𡊤 􏺘 (佫 (入 (e) (句化米 (􏿰弔 e 'low))) 文)))

(名 (彐顶量 文)
    (𡊤 􏺗 (佫 (λ (e) (句化米 (􏿰弔 e 'volume))) 文)))
(名 (彐底量 文)
    (𡊤 􏺘 (佫 (入 (e) (句化米 (􏿰弔 e 'volume))) 文)))

(名 (􏹈卦文 文 卦)
    (􏹈 (λ (H) (勺=? (􏿰弔 H 'price-gua) 卦)) 文))

(名 (xvalues 文)
    (佫 (λ (e) (􏿰弔 e 'day)) 文))

(名 (yvalues 文)
    (佫 (λ (e)
          (令 ([N (- (弓 六十四卦 (􏿰弔 e 'gua)) 32)])
              (若 (􏺡? N) (􏽊 N) N))
          )
        文)
    )

(名 (tvalues 文)
    (佫 (λ (e) (~a (􏹔 (􏿰弔 e 'avg-price) 2)
                   "/"
                   (􏹓 (/ (句化米 (􏿰弔 e 'volume)) 10000)))
          )
        文)
    )