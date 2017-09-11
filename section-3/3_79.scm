(load "./stream")

;; (define (solve-2nd a b dt y0 dy0)
;;   (define y (integral (delay dy) y0 dt))
;;   (define dy (integral (delay ddy) dy0 dt))
;;   (define ddy (add-streams (scale-stream dy a)
;; 			   (scale-stream y b)))
;;   y)

(define (solve-2nd f dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y))
  y)

(define (integral delay-integrand initial-value dt)
  (cons-stream initial-value
	       (let ((integrand (force delay-integrand)))
		 (if (stream-null? integrand)
		     the-empty-stream
		     (integral (delay (stream-cdr integrand))
			       (+ (* dt (stream-car integrand))
				  initial-value)
			       dt)))))

(stream-ref (solve-2nd (lambda (x y) (+ (* x 4) (* y -4))) 0.001 1 2) 1000)

