(define (sum x y z)
	(cond ((and (> x z) (> y z)) (+ (* x x) (* y y)))
          ((and (> y x) (> z x)) (+ (* y y) (* z z)))
          ((and (> z y) (> x y)) (+ (* z z) (* x x)))))
