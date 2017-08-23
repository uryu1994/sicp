(load "./3_59")
(load "./3_61")


(define (div-series s1 s2)
  (if (= (stream-car s2) 0)
      (error "-- DIV-SERIES divide zero")
      (scale-stream (mul-series s1
				(invert-unit-series (scale-stream s2 (/ 1 (stream-car s2)))))
		    (/ 1 (stream-car s2)))))

(define tan-series (div-series sine-series cosine-series))

(stream-ref tan-series 0)
(stream-ref tan-series 1)
(stream-ref tan-series 2)
(stream-ref tan-series 3)
(stream-ref tan-series 4)
(stream-ref tan-series 5)
