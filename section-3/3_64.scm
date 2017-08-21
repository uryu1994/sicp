(load "./stream")

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(define (stream-limit s tolerance)
  (let ((s1 (stream-car s))
	(s2 (stream-car (stream-cdr s))))
    (if (< (abs (- s1 s2)) tolerance)
	s2
	(stream-limit (stream-cdr s) tolerance))))

(sqrt 2 0.001)
(sqrt 3 0.001)
(sqrt 5 0.001)
