(load "./3_60")

(define (invert-unit-series s)
  (cons-stream 1
	       (mul-series (scale-stream (stream-cdr s) -1)
			   (invert-unit-series s))))
