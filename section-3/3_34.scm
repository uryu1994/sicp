(load "./connector")

(define (squarer a b)
  (multiplier a a b))

(define A (make-connector))
(define B (make-connector))
(squarer A B)
(probe "A" A)
(probe "B" B)

(set-value! A 10 'user)
;; Probe: A = 10
;; Probe: B = 100done -> 正しい

(forget-value! A 'user)
(set-value! B 400 'user)
;; Probe: B = 400done -> Aが表示されない

;; Aのみ値がセットされる場合3つ中2つ値が設定される
;; Bのみ値がセットされる場合3つ中1つしか値が設定されないので process-new-value 手続きのいずれにもヒットしない
