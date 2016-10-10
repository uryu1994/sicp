(load "./fixed_point.scm")

(define phi (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.6))

(print phi)
