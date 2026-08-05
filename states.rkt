#lang racket/base

(require ming ming/list
         "rules.rkt")
(provide Ts VPs Es Ds BOs Cs Bs Ss
         BSs WCHs ;; RSKs
         )

;;;; ID 中文 English 具体判断条件
;; Trend States（趋势状态）
(名 Ts
    `((,T1 T1 粗粒度上涨 "Coarse Uptrend" "ΔP[t] > 0 AND ΔP[t-1] > 0")
      (,T2 T2 粗粒度下跌 "Coarse Downtrend" "ΔP[t] < 0 AND ΔP[t-1] < 0")
      (,T3 T3 细粒度上涨 "Fine Uptrend" "Δp[t] > 0 AND Δp[t-1] > 0")
      (,T4 T4 细粒度下跌 "Fine Downtrend" "Δp[t] < 0 AND Δp[t-1] < 0")
      (,T5 T5 横盘震荡 "Sideways Range" "max(P[t-4:t])-min(P[t-4:t]) ≤ 1 AND max(p[t-4:t])-min(p[t-4:t]) ≤ 8")
      (,T6 T6 向上突破 "Upward Breakout" "前5日满足T5，且 p[t] > max(p[t-5:t-1]) AND Δp[t] > 0")
      (,T7 T7 向下破位 "Downward Breakdown" "前5日满足T5，且 p[t] < min(p[t-5:t-1]) AND Δp[t] < 0")
      (,T8 T8 强势上涨 "Strong Uptrend" "最近3日 Δp > 0 至少2天，且 Δv > 0 至少2天")
      (,T9 T9 强势下跌 "Strong Downtrend" "最近3日 Δp < 0 至少2天，且 Δv > 0 至少2天")
      (,T10 T10 高位内部转弱 "High-Level Weakness" "P ≥ 6 AND ΔP = 0 AND Δp < 0")
      (,T11 T11 低位内部转强 "Low-Level Strength" "P ≤ 1 AND ΔP = 0 AND Δp > 0")))


;; 量价关系状态（Price-Volume States）
(名 VPs
    `((,VP1 VP1 粗粒度量价同步上涨 "Coarse Price–Volume Expansion" "ΔP > 0 AND ΔV > 0")
      (,VP2 VP2 细粒度量价同步上涨 "Fine Price–Volume Expansion" "Δp > 0 AND Δv > 0")
      (,VP3 VP3 缩量上涨 "Low-Volume Advance" "Δp > 0 AND Δv < 0")
      (,VP4 VP4 价涨量平 "Price Up, Volume Flat" "Δp > 0 AND Δv = 0")
      (,VP5 VP5 粗粒度量价同步下跌 "Coarse Price–Volume Decline" "ΔP < 0 AND ΔV < 0")
      (,VP6 VP6 放量下跌 "Volume-Supported Decline" "Δp < 0 AND Δv > 0")
      (,VP7 VP7 缩量回调 "Low-Volume Pullback" "Δp < 0 AND Δv < 0")
      (,VP8 VP8 低位放量下跌 "Low-Level Panic Selling" "P ≤ 1 AND Δp < 0 AND Δv > 0")
      (,VP9 VP9 价稳量增 "Stable Price, Increasing Volume" "Δp = 0 AND Δv > 0")
      (,VP10 VP10 价稳量缩 "Stable Price, Decreasing Volume" "Δp = 0 AND Δv < 0")
      (,VP11 VP11 价格上涨量能下降 "Price–Volume Divergence" "Δp > 0 AND Δv < 0")
      (,VP12 VP12 价格下跌量能增加 "Downward Price–Volume Divergence" "Δp < 0 AND Δv > 0")
      )
    )

;; Position and Extreme States
(名 Es
    `((,E1 E1 顶价区 "Highest Coarse Price Zone" "P = 7")
      (,E2 E2 底价区 "Lowest Coarse Price Zone" "P = 0")
      (,E3 E3 高价区 "High Price Zone" "P ≥ 6")
      (,E4 E4 低价区 "Low Price Zone" "P ≤ 1")
      (,E5 E5 顶价六十四卦区 "Maximum Fine Price State" "p = 63")
      (,E6 E6 底价六十四卦区 "Minimum Fine Price State" "p = 0")
      (,E7 E7 高量区 "High Volume Zone" "V ≥ 6")
      (,E8 E8 低量区 "Low Volume Zone" "V ≤ 1")
      (,E9 E9 天量区 "Volume Climax" "V = 7")
      (,E10 E10 地量区 "Volume Drought" "V = 0")
      ;; Local High / Low States
      (,E11 E11 20日细粒度创新高 "20-Day Fine New High" "p[t] > max(p[t-19:t-1])")
      (,E12 E12 20日细粒度创新低 "20-Day Fine New Low" "p[t] < min(p[t-19:t-1])")
      (,E13 E13 5日细粒度创新高 "5-Day Fine New High" "p[t] > max(p[t-4:t-1])")
      (,E14 E14 5日细粒度创新低 "5-Day Fine New Low" "p[t] < min(p[t-4:t-1])")
      )
    )

;; 背离状态（Divergence States）
(名 Ds
    `(;; Short-Term Divergence
      (,D1 D1 短期顶部背离 "Short-Term Bearish Divergence" "P ≥ 6 AND Δp > 0 AND Δv < 0")
      (,D2 D2 短期底部背离 "Short-Term Bullish Divergence" "P ≤ 1 AND Δp < 0 AND Δv > 0")
      ;; Structural Divergence
      (,D3 D3 顶部结构背离 "Structural Bearish Divergence" "p_peak2 > p_peak1 AND v_peak2 < v_peak1")
      (,D4 D4 底部结构背离 "Structural Bullish Divergence" "p_low2 < p_low1 AND v_low2 > v_low1")
      )
    )

;; 压缩状态（Compression States）
(名 Cs
    `((,C1 C1 低位缩量压缩 "Low-Level Volume Compression" "最近5日 max(P)-min(P) ≤ 1 AND max(p)-min(p) ≤ 8 AND max(V) ≤ 2")
      (,C2 C2 高位盘整 "High-Level Consolidation" "最近5日 P ≥ 6 至少4天，且 max(p)-min(p) ≤ 8")
      (,C3 C3 低位盘整 "Low-Level Consolidation" "最近5日 P ≤ 1 至少4天，且 max(p)-min(p) ≤ 8")
      (,C4 C4 量能积累 "Volume Accumulation" "最近3日 Δv > 0 至少2天，且 max(p)-min(p) ≤ 8")
      (,C5 C5 量能衰减 "Volume Exhaustion" "最近3日 Δv < 0 至少2天，且 max(p)-min(p) ≤ 8")
      (,C6 C6 高位量能衰竭 "High-Level Exhaustion" "P ≥ 6，最近3日 Δv < 0 至少2天，且 Δp ≤ 0")
      (,C7 C7 低位量能积累 "Low-Level Accumulation" "P ≤ 1，最近3日 Δv > 0 至少2天，且 max(p)-min(p) ≤ 8"))
    )

;; Breakout States
(名 BOs
    `((,BO1 BO1 初步向上突破 "Initial Upward Breakout" "p[t] > max(p[t-5:t-1]) AND Δp[t] > 0")
      (,BO2 BO2 成交量确认突破 "Volume-Confirmed Breakout" "BO1 AND Δv[t] > 0")
      (,BO3 BO3 强确认突破 "Strong Confirmed Breakout" "BO1 AND Δv[t] > 0 AND V[t] > average(V[t-5:t-1])")
      (,BO4 BO4 初步向下破位 "Initial Downward Breakdown" "p[t] < min(p[t-5:t-1]) AND Δp[t] < 0")
      (,BO5 BO5 成交量确认破位 "Volume-Confirmed Breakdown" "BO4 AND Δv[t] > 0")
      (,BO6 BO6 强确认破位 "Strong Confirmed Breakdown" "BO4 AND Δv[t] > 0 AND V[t] > average(V[t-5:t-1])"))
    )

;; 买入信号（Buy Signals）
(名 Bs
    `((,B1 B1 横盘突破买入 "Range Breakout Buy" "T5 AND BO2")
      (,B2 B2 强突破买入 "Strong Breakout Buy" "T5 AND BO3")
      (,B3 B3 趋势回调买入 "Trend Pullback Buy" "最近3日 Δp > 0 至少2天，今日 Δp < 0 AND Δv ≤ 0，且 p[t] > min(p[t-3:t-1])")
      (,B4 B4 底部背离买入 "Bullish Divergence Buy" "D4 AND Δp > 0")
      (,B5 B5 低位量能积累买入 "Low-Level Accumulation Buy" "C7 AND P ≤ 1 AND Δp > 0")
      (,B6 B6 低位反转买入 "Low-Level Reversal Buy" "P ≤ 1 AND Δp > 0 AND Δv > 0")
      (,B7 B7 新高延续买入 "New High Continuation Buy" "E11 AND Δp > 0 AND Δv ≥ 0")
      )
    )

;; 卖出信号（Sell Signals）
;; ID 信号名称 English 触发条件
(名 Ss
    `((,S1 S1 短期顶部背离卖出 "Short-Term Divergence Sell" "D1 连续2天")
      (,S2 S2 顶部结构背离卖出 "Structural Divergence Sell" "D3 AND Δp < 0")
      (,S3 S3 趋势破坏卖出 "Trend Failure Sell" "过去3日 Δp > 0 至少2天，今日 Δp < 0，且 p[t] < min(p[t-3:t-1])")
      (,S4 S4 放量破位卖出 "Volume-Supported Breakdown Sell" "BO5")
      (,S5 S5 强放量破位卖出 "Strong Breakdown Sell" "BO6")
      (,S6 S6 高位量能衰竭卖出 "High-Level Exhaustion Sell" "C6")
      (,S7 S7 高位放量滞涨 "High-Level Volume Stagnation" "P ≥ 6 AND V ≥ 6 AND Δp ≤ 0")
      (,S8 S8 假突破失败卖出 "Failed Breakout Sell" "突破后2日内 p ≤ breakout_level 且 Δp < 0")
      )
    )

;; ;; 风险等级（Risk Levels）
;; ;; Level 名称 English 条件
;; (名 RSKs
;;     (􏿴 (􏿴 R1 'R1 '正常 "Normal" "无特殊状态")
;;         (􏿴 R2 'R2 '关注 "Watch" "E1/E2/C1")
;;         (􏿴 R3 'R3 '警告 "Warning" "D1/D2/C2")
;;         (􏿴 R4 'R4 '危险 "Dangerous" "VP3/T5")
;;         (􏿴 R5 'R5 '极危 "Critical" "S1/S6")
;;         ))

(名 BSs ;; Buy and Sell
    (􏿝 Bs Ss))

(名 WCHs
    (􏿝 Ts VPs Es Ds BOs Cs Bs Ss))
