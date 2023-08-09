#lang racket/base

(require ming
         ming/number)
(provide 彐顶价
         彐底价
         彐顶量
         彐底量)

(名 (彐顶价 文)
    (𡊤 􏺗 (佫 (入 (e) (句化米 (􏿰弔 e 'high))) 文)))
(名 (彐底价 文)
    (𡊤 􏺘 (佫 (入 (e) (句化米 (􏿰弔 e 'low))) 文)))

(名 (彐顶量 文)
    (𡊤 􏺗 (佫 (λ (e) (句化米 (􏿰弔 e 'volume))) 文)))
(名 (彐底量 文)
    (𡊤 􏺘 (佫 (入 (e) (句化米 (􏿰弔 e 'volume))) 文)))
