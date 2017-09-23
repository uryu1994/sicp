(load "./stream")

(define (integral delay-integrand initial-value dt)
  (cons-stream initial-value
	       (let ((integrand (force delay-integrand)))
		 (if (stream-null? integrand)
		     the-empty-stream
		     (integral (delay (stream-cdr integrand))
			       (+ (* dt (stream-car integrand))
				  initial-value)
			       dt)))))

(define (RLC R L C dt)
  (define (rlc vC0 iL0)
    (define iL (integral (delay diL) iL0 dt))
    (define dvC (scale-stream iL (/ -1 C)))
    (define vC (integral (delay dvC) vC0 dt))
    (define diL (add-streams (scale-stream vC (/ 1 L))
			     (scale-stream iL (/ (* -1 R) L))))
    (stream-map cons vC iL))
  rlc)

(stream-ref ((RLC 1 1 0.2 0.1) 10 0) 10)
