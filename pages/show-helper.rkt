#lang racket/base

(require racket/format
         ming ming/number
         "../64gua.rkt"
         "../plotly-helper.rkt")
(provide xs
         ys/价卦 ys/并卦 ys/量卦
         ts/量 ts/并卦
         ts/其他价 ts/均价
         plotly-data plotly-script
         )

(名 (xs 文)
    (佫 (λ (e) (􏿰弔 e 'day)) 文))

(名 (n-to-y n)
    (名 n1 (- n 32))
    (若 (􏺡? n1)
        (􏽊 n1)
        n1))

(名 (ys/并卦 文)
    (佫 (λ (H)
          (n-to-y (弓 六十四卦 (􏿰弔 H 'bgua))))
        文))

(名 (ys/价卦 文)
    (佫 (λ (H)
          (n-to-y (弓 六十四卦 (􏿰弔 H 'jgua))))
        文))

(名 (ys/量卦 文)
    (佫 (λ (H)
          (n-to-y (弓 六十四卦 (􏿰弔 H 'lgua))))
        文))

(名 (ts/其他价 文)
    (佫 (λ (H)
          (􏿴
           (􏹔 (句化米 (􏿰弔 H 'open)))
           (􏹔 (句化米 (􏿰弔 H 'close)))
           (􏹔 (句化米 (􏿰弔 H 'high)))
           (􏹔 (句化米 (􏿰弔 H 'low)))
           ))
        文))

(名 (ts/均价 文)
    (佫 (λ (H)
          (􏹔 (􏿰弔 H 'avg-price)))
        文))

(名 (ts/量 文)
    (佫 (λ (H) (~a (􏹓 (/ (句化米 (􏿰弔 H 'volume)) 10000)) "万手"))
        文))

(名 (ts/并卦 文)
    (佫 (λ (H)
          (~a (􏹔 (􏿰弔 H 'avg-price)) "元"
              "/"
              (􏹓 (/ (句化米 (􏿰弔 H 'volume)) 10000)) "万手"
              ))
        文))


(名 (plotly-data 文)
    (􏿴 (gen-trace "量" (xs 文) (ys/量卦 文) (ts/量 文) 1)
        (gen-trace "价" (xs 文) (ys/价卦 文) (ts/均价 文) 1 (ts/其他价 文))
        (gen-trace "并" (xs 文) (ys/并卦 文) (ts/并卦 文) #;(ts/复卦数 文))
        ))

(名 (plotly-script div 文)
    `(script ,(gen-plotly-jscode div (plotly-data 文)))
    )