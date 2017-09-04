(load "./stream")

(define (triples s t u)
  (cons-stream
   (list (stream-car s) (stream-car t) (stream-car u))
   (interleave
    (stream-map (lambda (x) (cons (stream-car s) x))
		(pairs (stream-cdr t) (stream-cdr u)))
    (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define triples-of-integers (triples integers integers integers))

(stream-head triples-of-integers 10)

(define pythagoras
  (stream-filter (lambda (x)
		   (= (+ (square (car x)) (square (cadr x))) (square (caddr x))))
		 triples-of-integers))

(stream-head pythagoras 5)
