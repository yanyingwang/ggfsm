#lang racket/base

(require ming ming/list ming/string ming/number
         racket/format)
(provide P V dP dV
         p v dp dp
         p峰? p谷? v峰? v谷?
         p峰L p谷L v峰L v谷L
         p峰L3L p谷L3L v峰L3L v谷L3L
         )

;; 􏵞: 0707，0706，0705，0704，0703。通常需要逆序，亦即(􏾛 􏵞)
(名 (P H)
    (􏿰弔 H 'p8gua-n))
(名 (V H)
    (􏿰弔 H 'v8gua-n))
(名 (p H)
    (􏿰弔 H 'pgua-n))
(名 (v H)
    (􏿰弔 H 'vgua-n))
(名 (dP H)
    (􏿰弔 H 'p8gua-tn))
(名 (dV H)
    (􏿰弔 H 'v8gua-tn))
(名 (dp H)
    (􏿰弔 H 'pgua-tn))
(名 (dv H)
    (􏿰弔 H 'vgua-tn))


(名 (p峰? L)
    (并 (> (p (􏷛 L))
           (p (􏷜 L)))
        (> (p (􏷛 L))
           (p (􏷚 L)))))
(名 (p谷? L)
    (并 (> (p (􏷛 L))
           (p (􏷜 L)))
        (> (p (􏷛 L))
           (p (􏷚 L)))))
(名 (v峰? L)
    (并 (> (p (􏷛 L))
           (p (􏷜 L)))
        (> (p (􏷛 L))
           (p (􏷚 L)))))
(名 (v谷? L)
    (并 (> (p (􏷛 L))
           (p (􏷜 L)))
        (> (p (􏷛 L))
           (p (􏷚 L)))))


(名 (波L3L L prd)  ; prd: predicate
    (令 演 ([L L])
        (丫 (> (巨 L) 2)
            (丫 (prd L)
                (双 (􏾺 L 3) (演 (阴 L)))
                (演 (阴 L)))
            㐅)))
(名 (波L L prd)  ; prd: predicate
    (令 演 ([L L])
        (丫 (> (巨 L) 2)
            (丫 (prd L)
                (双 (􏷛 L) (演 (阴 L)))
                (演 (阴 L)))
            㐅)))

(名 (p峰L3L L) ; L3L, lists like: '((1 1 1) ...)
    (波L3L L p峰?))
(名 (p谷L3L L)
    (波L3L L p谷?))
(名 (v峰L3L L)
    (波L3L L v峰?))
(名 (v谷L3L L)
    (波L3L L v谷?))

(名 (p峰L L)
    (波L L p峰?))
(名 (p谷L L)
    (波L L p谷?))
(名 (v峰L L)
    (波L L v峰?))
(名 (v谷L L)
    (波L L v谷?))
