#lang at-exp racket/base

(require ming ming/list ming/string ming/number net/uri-codec
         racket/format
         "gua-helper.rkt"
         "8gua.rkt"
         "64gua.rkt"
         "senders.rkt"
         "zixuan.rkt")
(provide )

(名 (价米 H)
    (􏿰弔 H 'p8gua-n))
(名 (量米 H)
    (􏿰弔 H 'v8gua-n))
(名 (价精米 H)
    (􏿰弔 H 'pgua-n))
(名 (量精米 H)
    (􏿰弔 H 'vgua-n))
(名 (价跃 H)
    (􏿰弔 H 'p8gua-tn))
(名 (量跃 H)
    (􏿰弔 H 'v8gua-tn))
(名 (价精跃 H)
    (􏿰弔 H 'pgua-tn))
(名 (量精跃 H)
    (􏿰弔 H 'vgua-tn))


;; 􏵞: 0707，0706，0705，0704，0703。通常需要逆序，亦即(􏾛 􏵞)

;; Trend States（趋势状态）
;; ID	状态名称	English	判断条件
;; T1	连续上涨	Continuous Uptrend	连续3天 ΔP ≥ 1
;; T2	连续下跌	Continuous Downtrend	连续3天 ΔP ≤ -1
;; T3	横盘震荡	Sideways Range	连续5天 abs(ΔP) ≤ 1
;; T4	向上突破	Upward Breakout	T3后 ΔP ≥ 2
;; T5	向下破位	Downward Breakdown	T3后 ΔP ≤ -2
;; T6	强势上涨	Strong Uptrend	连续3天 P递增且平均V≥4
;; T7	强势下跌	Strong Downtrend	连续3天 P递减且平均V≥4
(名 (连续上涨 L)
    (并 (>= (价跃 (􏷜 L)) 1)
        (>= (价跃 (􏷛 L)) 1)
        (>= (价跃 (􏷚 L)) 1)))
(名 (连续下跌 L)
    (并 (<= (价跃 (􏷜 L)) -1)
        (<= (价跃 (􏷛 L)) -1)
        (<= (价跃 (􏷚 L)) -1)))
(名 (横盘震荡 L)
    (并 (<= (􏹚 (价跃 (􏷜 L))) 1)
        (<= (􏹚 (价跃 (􏷛 L))) 1)
        (<= (􏹚 (价跃 (􏷚 L))) 1)
        (<= (􏹚 (价跃 (􏷙 L))) 1)
        (<= (􏹚 (价跃 (􏷘 L))) 1)))
(名 (向上突破 L)
    (并 (横盘震荡 (阴 L))
        (>= (价跃 (􏷜 L)) 2)))
(名 (向下破位 L)
    (并 (横盘震荡 (阴 L))
        (<= (价跃 (􏷜 L)) -2)))
(名 (强势上涨 L)
    (并 (> (价米 (􏷜 L)) (价米 (􏷛 L)) (价米 (􏷚 L)))
        (>= (/ (+ (量米 (􏷜 L))
                  (量米 (􏷛 L))
                  (量米 (􏷚 L))) 3)
            4)))
(名 (强势下跌 L)
    (并 (< (价米 (􏷜 L)) (价米 (􏷛 L)) (价米 (􏷚 L)))
        (>= (/ (+ (量米 (􏷜 L))
                  (量米 (􏷛 L))
                  (量米 (􏷚 L))) 3)
            4)))

;; 量价关系状态（Price-Volume States）
;; ID	状态名称	English	判断条件
;; VP1	放量上涨	Volume Supported Advance	ΔP ≥ 1 且 ΔV ≥ 2
;; VP2	缩量上涨	Low Volume Advance	        ΔP ≥ 1 且 ΔV ≤ 0
;; VP3	放量下跌	Volume Supported Decline	ΔP ≤ -1 且 ΔV ≥ 2
;; VP4	缩量下跌	Low Volume Pullback	        ΔP ≤ -1 且 ΔV ≤ 0
;; VP5	放量滞涨	Volume Stagnation		ΔP=0 且 V≥6
;; VP6	放量滞跌	Volume Stabilization		ΔP=0 且 V≥6
;; VP7	缩量横盘	Low Volume Consolidation	ΔP=0 且 V≤2
;; VP8	放量突破	Volume Breakout		ΔP≥2 且 ΔV≥3
(名 (放量上涨 H)
    (并 (>= (价跃 H) 1)
        (>= (量跃 H) 2)))
(名 (缩量上涨 H)
    (并 (>= (价跃 H) 1)
        (<= (量跃 H) 0)))
(名 (放量下跌 H)
    (并 (<= (价跃 H) -1)
        (>= (量跃 H) 2)))
(名 (缩量下跌 H)
    (并 (<= (价跃 H) -1)
        (<= (量跃 H) 0)))
(名 (放量滞涨 H)
    (并 (= (价跃 H) 0)
        (>= (量米 H) 6)))
(名 (放量滞跌 H)
    (并 (= (价跃 H) 0)
        (>= (量米 H) 6)))
(名 (缩量横盘 H)
    (并 (= (价跃 H) 0)
        (<= (量米 H) 2)))
(名 (放量突破 H)
    (并 (>= (价跃 H) 2)
        (>= (量跃 H) 3)))

;; 极值状态（Extreme States）
;; ID	状态名称	English	判断条件
;; E1	历史新高	Historical High	P=8
;; E2	历史新低	Historical Low	P=1
;; E3	天量	  Volume Climax	V=8
;; E4	地量	  Volume Drought	V=1
;; E5	高位区	  High Price Zone	P≥7
;; E6	低位区	  Low Price Zone	P≤2
;; E7	高量区	  High Volume Zone	V≥7
;; E8	低量区	  Low Volume Zone	V≤2
(名 (历史新高 H)
    (= (价米 H) 7))
(名 (历史新低 H)
    (= (价米 H) 0))
(名 (天量 H)
    (= (量米 H) 7))
(名 (地量 H)
    (= (量米 H) 0))
(名 (高位区 H)
    (>= (价米 H) 6))
(名 (低位区 H)
    (<= (价米 H) 1))
(名 (高量区 H)
    (>= (量米 H) 6))
(名 (低量区 H)
    (<= (量米 H) 1))


;; 背离状态（Divergence States）
;; ID	状态名称	English	判断条件
;; D1	顶背离	Bearish Divergence	ΔP>0 且 ΔV<0 且 P≥5
;; D2	底背离	Bullish Divergence	ΔP<0 且 ΔV>0 且 P≤2
;; D3	顶部弱背离	Weak Bearish Divergence	P创新高但V不创新高
;; D4	底部弱背离	Weak Bullish Divergence	P创新低但V不创新低
(名 (顶背离 H)
    (并 (> (价跃 H) 0)
        (> (量跃 H) 0)
        (>= (价米 H) 5)))
(名 (底背离 H)
    (并 (< (价跃 H) 0)
        (> (量跃 H) 0)
        (<= (价米 H) 2)))

;; 压缩状态（Compression States）
;; ID	状态名称	English	判断条件
;; C1	缩量盘整	Low Volume Compression	连续5天 V≤3 且 abs(ΔP)≤1
;; C2	高位盘整	High Level Consolidation	P≥6 持续3天
;; C3	低位盘整	Low Level Consolidation	P≤3 持续3天
;; C4	能量积累	Energy Accumulation	V逐步上升而P不变
;; C5	能量衰减	Energy Exhaustion	V逐步下降而P不变
(名 (缩量盘整 L)
    (并 (并 (<= (价米 (􏷜 L)) 2) (<= (􏹚 (价跃 (􏷜 L))) 1))
        (并 (<= (价米 (􏷛 L)) 2) (<= (􏹚 (价跃 (􏷛 L))) 1))
        (并 (<= (价米 (􏷚 L)) 2) (<= (􏹚 (价跃 (􏷚 L))) 1))
        (并 (<= (价米 (􏷙 L)) 2) (<= (􏹚 (价跃 (􏷙 L))) 1))
        (并 (<= (价米 (􏷘 L)) 2) (<= (􏹚 (价跃 (􏷘 L))) 1))))
(名 (高位盘整 L)
    (并 (<= (价米 (􏷜 L)) 5)
        (<= (价米 (􏷛 L)) 5)
        (<= (价米 (􏷚 L)) 5)))
(名 (低位盘整 L)
    (并 (<= (价米 (􏷜 L)) 2)
        (<= (价米 (􏷛 L)) 2)
        (<= (价米 (􏷚 L)) 2)))
(名 (低位盘整 L)
    (并 (<= (价米 (􏷜 L)) 2)
        (<= (价米 (􏷛 L)) 2)
        (<= (价米 (􏷚 L)) 2)))

(名 (能量积累 L)
    (并 (> (量米 (􏷜 L)) (量米 (􏷛 L)) (量米 (􏷚 L)))
        (= (价米 (􏷜 L)) (价米 (􏷛 L)) (价米 (􏷚 L)))))
(名 (能量衰减 L)
    (并 (< (量米 (􏷜 L)) (量米 (􏷛 L)) (量米 (􏷚 L)))
        (= (价米 (􏷜 L)) (价米 (􏷛 L)) (价米 (􏷚 L)))))

;; 买入信号（Buy Signals）
;; ID	信号名称	English	触发条件
;; B1	底部反转	Bottom Reversal	E2 + VP1
;; B2	突破买入	Breakout Buy	T3 + T4 + VP1
;; B3	底背离买入	Bullish Divergence Buy	D2 + VP1
;; B4	缩量回调买入	Pullback Buy	T1 + VP4
;; B5	低位放量买入	Accumulation Buy	E6 + VP1
;; B6	压缩突破买入	Compression Breakout Buy	C1 + VP8
;; B7	新高突破买入	New High Breakout Buy	E1 + VP8
(名 (底部反转 L)
    (并 (历史新高 L)
        (放量上涨 L)))
(名 (突破买入 L)
    (并 (放量上涨 L)
        (向上突破 L)))
(名 (底背离买入 L)
    (并 (底背离 L)
        (放量上涨 L)))





;; 卖出信号（Sell Signals）
;; ID	信号名称	English	触发条件
;; S1	顶部卖出	Climax Top Sell	P≥7 且 V≥7
;; S2	顶背离卖出	Bearish Divergence Sell	D1
;; S3	破位卖出	Breakdown Sell	T5 + VP3
;; S4	放量滞涨卖出	Volume Stagnation Sell	VP5
;; S5	高位盘整卖出	Distribution Sell	C2 + VP5
;; S6	天量卖出	Volume Climax Sell	E3 + P≥7
;; S7	跌破趋势卖出	Trend Failure Sell	T1后出现T5

;; 风险等级（Risk Levels）
;; Level	名称	English	条件
;; 1	正常	Normal	无特殊状态
;; 2	关注	Watch	E1/E2/C1
;; 3	警告	Warning	D1/D2/C2
;; 4	危险	Dangerous	VP3/T5
;; 5	极危	Critical	S1/S6
