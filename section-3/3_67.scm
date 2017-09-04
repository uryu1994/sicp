(load "./stream")

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (interleave
     (stream-map (lambda (x) (list (stream-car t) x))
		 (stream-cdr s))
     (stream-map (lambda (x) (list x (stream-car s)))
		 (stream-cdr t)))
    (pairs (stream-cdr s) (stream-cdr t)))))

(stream-head (pairs integers integers) 20)
