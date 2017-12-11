(load "./../section-3/stream")

(define ex1 (cons-stream x y))
;; xが未定義なのでエラー
(define ex2 (cons-stream 1 y))
;; gosh> ex2
;; (1 . #<closure ((memo-proc memo-proc))>)
;; -> carは遅延されないがcdrは遅延される

(load "./stream-lazy-list")

(driver-loop)

(define my-stream (cons x y))
;; ;;; L-Eval input;
;; my-stream

;; ;;; L-Eval value:
;; (compound-procedure (m) ((m x y)))

;; -> 遅延性の高いリストであればcarもcdrも遅延評価される
