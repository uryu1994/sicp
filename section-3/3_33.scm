(load "./connector")

;;     c = (a + b) / 2
;; 2 * c = a + b

(define (averager a b c)
  (let ((u (make-connector))
        (v (make-connector)))
    (adder a b u)
    (multiplier c v u)
    (constant 2 v)
    'ok))

(define A (make-connector))
(define B (make-connector))
(define C (make-connector))

(averager A B C)
(probe "A" A)
(probe "B" B)
(probe "C" C)

(set-value! A 10 'user)
(set-value! B 20 'user)
(set-value! C 50 'user)
(forget-value! A 'user)
(set-value! C 50 'user)
