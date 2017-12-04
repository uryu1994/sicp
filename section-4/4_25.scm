(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))

(factorial 5)
;; (unless (= 5 1) (* 5 (factorial (- 5 1))) 1)
;; (unless (= 5 1) (* 5 (unless (= 5 1) (* 4 (factorial (- 4 1))) 1)))
;; ...
;; -> usual-value, exceptional-valueの評価が先になる
;; よって作用的順序では無限ループ
;; 正規順序であれば引数の値が必要になるまで手続き引数の評価は行わないので動く
