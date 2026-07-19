#lang racket/base

(require ming ming/list
         "rules.rkt")
(provide Ts VPs Es Ds Bs Cs Ss
         BSs WCHs RSKs)


;; Trend States（趋势状态）
;; ID	状态名称	English	判断条件
(名 Ts
    (􏿴 (􏿴 T1 'T1 '连续上涨 "Continuous Uptrend" "连续3天 ΔP ≥ 1")
        (􏿴 T2 'T2 '连续下跌 "Continuous Downtrend" "连续3天 ΔP ≤ -1")
        (􏿴 T3 'T3 '横盘震荡 "Sideways Range" "连续5天 abs(ΔP) ≤ 1")
        (􏿴 T4 'T4 '向上突破 "Upward Breakout" "T3后 ΔP ≥ 2")
        (􏿴 T5 'T5 '向下破位 "Downward Breakdown" "T3后 ΔP ≤ -2")
        (􏿴 T6 'T6 '强势上涨 "Strong Uptrend" "连续3天 P递增且平均 V ≥ 4")
        (􏿴 T7 'T7 '强势下跌 "Strong Downtrend" "连续3天 P递减且平均 V ≥ 4")))

;; 量价关系状态（Price-Volume States）
;; ID 状态名称 English 判断条件
(名 VPs
    (􏿴 (􏿴 VP1 'VP1 '放量上涨 "Volume Supported Advance" "ΔP≥1 且 ΔV≥2")
        (􏿴 VP2 'VP2 '缩量上涨 "Low Volume Advance" "ΔP≥1 且 ΔV≤0")
        (􏿴 VP3 'VP3 '放量下跌 "Volume Supported Decline" "ΔP≤-1 且 ΔV≥2")
        (􏿴 VP4 'VP4 '缩量下跌 "Low Volume Pullback" "ΔP≤-1 且 ΔV≤0")
        (􏿴 VP5 'VP5 '放量滞涨 "Volume Stagnation" "ΔP=0 且 V≥6")
        (􏿴 VP6 'VP6 '放量滞跌 "Volume Stabilization" "ΔP=0 且 V≥6")
        (􏿴 VP7 'VP7 '缩量横盘 "Low Volume Consolidation" "ΔP=0 且 V≤2")
        (􏿴 VP8 'VP8 '放量突破 "Volume Breakout" "ΔP≥2 且 ΔV≥3")
        ))

;; 极值状态（Extreme States）
;; ID 状态名称 English 判断条件
(名 Es
    (􏿴 (􏿴 E1 'E1 '天价 "Historical High" "P=7")
        (􏿴 E2 'E2 '地价 "Historical Low" "P=0")
        (􏿴 E3 'E3 '天量 "Volume Climax" "V=7")
        (􏿴 E4 'E4 '地量 "Volume Drought" "V=0")
        (􏿴 E5 'E5 '高价 "High Price Zone" "P≥6")
        (􏿴 E6 'E6 '低价 "Low Price Zone" "P≤1")
        (􏿴 E7 'E7 '高量 "High Volume Zone" "V≥6")
        (􏿴 E8 'E8 '低量 "Low Volume Zone" "V≤1")
        ))

;; 背离状态（Divergence States）
;; ID 状态名称 English 判断条件
(名 Ds
    (􏿴 (􏿴 D1 'D1 '顶背离 "Bearish Divergence" "ΔP>0 且 ΔV<0 且 P≥5")
        (􏿴 D2 'D2 '底背离 "Bullish Divergence" "ΔP<0 且 ΔV>0 且 P≤2")
        ))
;; D3 顶部弱背离 Weak Bearish Divergence P创新高但V不创新高
;; D4 底部弱背离 Weak Bullish Divergence P创新低但V不创新低

;; 压缩状态（Compression States）
;; ID 状态名称 English 判断条件
(名 Cs
    (􏿴 (􏿴 C1 'C1 '缩量盘整 "Low Volume Compression" "连续5天 V≤3 且 abs(ΔP)≤1")
        (􏿴 C2 'C2 '高位盘整 "High Level Consolidation" "P≥6 持续3天")
        (􏿴 C3 'C3 '低位盘整 "Low Level Consolidation" "P≤3 持续3天")
        (􏿴 C4 'C4 '能量积累 "Energy Accumulation" "V逐步上升而P不变")
        (􏿴 C5 'C5 '能量衰减 "Energy Exhaustion" "V逐步下降而P不变")
        ))

;; 买入信号（Buy Signals）
;; ID 信号名称 English 触发条件
(名 Bs
    (􏿴 (􏿴 B1 'B1 '底部反转买入 "Bottom Reversal" "E2 + VP1")
        (􏿴 B2 'B2 '突破买入 "Breakout Buy" "(T3 +) T4 + VP1")
        (􏿴 B3 'B3 '底背离买入 "Bullish Divergence Buy" "D2 + VP1")
        (􏿴 B4 'B4 '缩量回调买入 "Pullback Buy" "T1 + VP4")
        (􏿴 B5 'B5 '低位放量买入 "Accumulation Buy" "E6 + VP1")
        (􏿴 B6 'B6 '压缩突破买入 "Compression Breakout Buy" "C1 + VP8")
        (􏿴 B7 'B7 '新高突破买入 "New High Breakout Buy" "E1 + VP8")
        ))

;; 卖出信号（Sell Signals）
;; ID 信号名称 English 触发条件
(名 Ss
    (􏿴 (􏿴 S1 'S1 '顶部卖出 "Climax Top Sell" "P≥7 且 V≥7")
        (􏿴 S2 'S2 '顶背离卖出 "Bearish Divergence Sell" "D1")
        (􏿴 S3 'S3 '破位卖出 "Breakdown Sell" "T5 + VP3")
        (􏿴 S4 'S4 '放量滞涨卖出 "Volume Stagnation Sell" "VP5")
        (􏿴 S5 'S5 '高位盘整卖出 "Distribution Sell" "C2 + VP5")
        (􏿴 S6 'S6 '天量卖出 "Volume Climax Sell" "E3 + E5")
        (􏿴 S7 'S7 '跌破趋势卖出 "Trend Failure Sell" "T1 + T5")
        ))

;; 风险等级（Risk Levels）
;; Level 名称 English 条件
(名 RSKs
    (􏿴 (􏿴 R1 'R1 '正常 "Normal" "无特殊状态")
        (􏿴 R2 'R2 '关注 "Watch" "E1/E2/C1")
        (􏿴 R3 'R3 '警告 "Warning" "D1/D2/C2")
        (􏿴 R4 'R4 '危险 "Dangerous" "VP3/T5")
        (􏿴 R5 'R5 '极危 "Critical" "S1/S6")
        ))

(名 BSs
    (􏿝 Bs Ss))

(名 WCHs
    (􏿝 Ts VPs Es Ds Cs))
