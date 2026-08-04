#lang racket/base

(require ming ming/list ming/string ming/number
         racket/format
         gregor/period)
(provide P V p v
         dP dV dp dp
         Pt pt Pt1 pt1
         dPt dpt dPt1 dpt1
         Vt vt Vt1 vt1
         dVt dvt dVt1 dvt1
         day day差
         p峰? p谷? v峰? v谷?
         p峰L3L p谷L3L v峰L3L v谷L3L
         p峰LL p谷LL v峰LL v谷LL
         p峰s p谷s v峰s v谷s
         maxp minp maxP minP
         maxv minv maxV minV avgV
         Ps dps dvs dps+ dvs+ dps- dvs-
         )

;; 􏵞: 0707，0706，0705，0704，0703。通常需要逆序，亦即(􏾛 􏵞)
;; P(大写): p8gua。粗粒度的卦，即是八卦粒度
;; p(小写): pgua。细粒度的卦，即是六十四卦粒度
;; dp: Δp
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
(名 (day H)
    (􏿰弔 H 'day))
(名 (day差 day1 day2)
    (period-ref (date-period-between day1 day2) 'days))

;; t: today
;; dpt: ΔP[t]
;; dpt1: 因为是逆序，所以t1是昨日。即是：Δp[t-1]
(名 (Pt L)
    (P (􏷜 L)))
(名 (pt L)
    (p (􏷜 L)))
(名 (Pt1 L)
    (P (􏷛 L)))
(名 (pt1 L)
    (p (􏷛 L)))
(名 (dPt L)
    (dP (􏷜 L)))
(名 (dPt1 L)
    (dP (􏷛 L)))
(名 (dpt L)
    (dp (􏷜 L)))
(名 (dpt1 L)
    (dp (􏷛 L)))

(名 (Vt L)
    (V (􏷜 L)))
(名 (vt L)
    (v (􏷜 L)))
(名 (Vt1 L)
    (V (􏷛 L)))
(名 (vt1 L)
    (v (􏷛 L)))
(名 (dVt L)
    (dV (􏷜 L)))
(名 (dVt1 L)
    (dP (􏷛 L)))
(名 (dvt L)
    (dv (􏷜 L)))
(名 (dvt1 L)
    (dv (􏷛 L)))


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

;; prd: predicate
(名 (波L3L L prd)
    (令 演 ([L L])
        (丫 (> (巨 L) 2)
            (丫 (prd L)
                (双 (􏾺 L 3) (演 (阴 L)))
                (演 (阴 L)))
            㐅)))
(名 (波LL L prd)
    (令 演 ([L L])
        (丫 (> (巨 L) 2)
            (丫 (prd L)
                (双 (􏷛 L) (演 (阴 L)))
                (演 (阴 L)))
            㐅)))

;; L3L, lists like: '((1 1 1) ...)
(名 (p峰L3L L)
    (波L3L L p峰?))
(名 (p谷L3L L)
    (波L3L L p谷?))
(名 (v峰L3L L)
    (波L3L L v峰?))
(名 (v谷L3L L)
    (波L3L L v谷?))

;; LL, list like: '((1) ...)
(名 (p峰LL L)
    (波LL L p峰?))
(名 (p谷LL L)
    (波LL L p谷?))
(名 (v峰LL L)
    (波LL L v峰?))
(名 (v谷LL L)
    (波LL L v谷?))

;; p峰s: p峰的复数形式
(名 (p峰s L)
    (􏷑 p (p峰LL L)))
(名 (p谷s L)
    (􏷑 p (p谷LL L)))
(名 (v峰s L)
    (􏷑 v (v峰LL L)))
(名 (v谷s L)
    (􏷑 v (v谷LL L)))


;; a-b: 包含a不包含b
(名 (maxP L [b +inf.0] [a 0])
    (用 􏺗 (􏷑 P (􏾝 L a b))))
(名 (maxp L [b +inf.0] [a 0])
    (用 􏺗 (􏷑 p (􏾝 L a b))))
(名 (minP L [b +inf.0] [a 0])
    (用 􏺘 (􏷑 p (􏾝 L a b))))
(名 (minp L [b +inf.0] [a 0])
    (用 􏺘 (􏷑 P (􏾝 L a b))))

(名 (maxV L [b +inf.0] [a 0])
    (用 􏺗 (􏷑 V (􏾝 L a b))))
(名 (maxv L [b +inf.0] [a 0])
    (用 􏺗 (􏷑 v (􏾝 L a b))))
(名 (minV L [b +inf.0] [a 0])
    (用 􏺘 (􏷑 V (􏾝 L a b))))
(名 (minv L [b +inf.0] [a 0])
    (用 􏺘 (􏷑 v (􏾝 L a b))))

(名 (avgV L [b +inf.0] [a 0])
    (/ (􏷎 + 0 (􏷑 V (􏾝 L a b))) (- b a)))
;; (􏹈dp (L prd)
;;       (􏹈 (λ (H)
;;             (prd (dp H)))
;;           L))
;; (􏹈dv (L prd)
;;       (􏹈 (λ (H)
;;             (prd (dv H)))
;;           L))
;; dPs: ΔP的复数形式
;; dPs+: ΔP的复数形式（且是正数）
;; Ps: P的复数形式
(名 (Ps prd L)
      (􏹈 prd (􏷑 dp L)))
(名 (dps prd L)
      (􏹈 prd (􏷑 dp L)))
(名 (dvs prd L)
    (􏹈 prd (􏷑 dv L)))
(名 (dps+ L [b +inf.0] [a 0])
      (dps 􏻛? (􏾝 L a b)))
(名 (dps- L [b +inf.0] [a 0])
      (dps 􏻚? (􏾝 L a b)))
(名 (dvs+ L [b +inf.0] [a 0])
      (dvs 􏻛? (􏾝 L a b)))
(名 (dvs- L [b +inf.0] [a 0])
      (dvs 􏻚? (􏾝 L a b)))
