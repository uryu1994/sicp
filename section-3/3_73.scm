(load "./stream")

(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                              int)))
  int)

(define (RC R C dt)
  (define (rc i v-zero)
    (add-streams (scale-stream i R)
		 (integral (scale-stream i (/ 1 C)) v-zero dt)))
  rc)

(define RC1 (RC 5 1 0.5))
(stream-head (RC1 ones 0) 10)
