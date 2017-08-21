(load "./stream")
(load "./3_59")

;; (define (mul-series s1 s2)
;;   (cons-stream (* (stream-car s1) (stream-car s2))
;;   	       (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
;;   			    (mul-series (stream-cdr s1) s2))))

(stream-ref (add-streams (mul-series sine-series sine-series)
			 (mul-series cosine-series cosine-series)) 0)

(stream-ref (add-streams (mul-series sine-series sine-series)
			 (mul-series cosine-series cosine-series)) 1)

(stream-ref (add-streams (mul-series sine-series sine-series)
			 (mul-series cosine-series cosine-series)) 2)

(stream-ref (add-streams (mul-series sine-series sine-series)
			 (mul-series cosine-series cosine-series)) 3)

(stream-ref (add-streams (mul-series sine-series sine-series)
			 (mul-series cosine-series cosine-series)) 4)
