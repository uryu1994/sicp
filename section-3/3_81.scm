(load "./stream")

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define random-init 12345)

(define (rand-update x)
  (modulo (+ (* 214013 x) 253011) 32767))

(define (rand input-stream random-init)
  (define random-stream
    (if (stream-null? input-stream)
	the-empty-stream
	(let ((request (stream-car input-stream)))
	  (cons-stream
	   (cond ((eq? request 'generate) (rand-update random-init))
		 ((number? request) (rand-update request))
		 (else (error "Unknown request --- RAND" request)))
	   (rand (stream-cdr input-stream) (stream-car random-stream))))))
  random-stream)

(define request-stream
  (list->stream (list 100 'generate 'generate 100 'generate 100 'generate)))

(stream-head (rand request-stream random-init) 5)
