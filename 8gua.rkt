#lang racket/base

(require ming)
(provide gua8 gua8-with-icons gua8-with-chars)


;; 乾☰   兑☱   离☲  震☳     巽☴    坎☵    艮☶   坤☷
;; 111   011   101  001     110    010    100   000
;; 7     3     5    1       6      2      4     0


(define gua8
    (list '坤 '艮 '坎 '巽 '震 '离 '兑 '乾))

(define gua8-with-icons ;汉字和符号对应表
  (hash '乾 '☰
        '兑 '☱
        '离 '☲
        '震 '☳
        '巽 '☴
        '坎 '☵
        '艮 '☶
        '坤 '☷
        ))

(define gua8-with-chars ;汉字和二进制对应表
  (hash '乾 111 ;7
        '兑 110 ;6
        '离 101 ;5
        '震 100 ;4
        '巽 011 ;3
        '坎 010 ;2
        '艮 001 ;1
        '坤 000 ;0
        ))
