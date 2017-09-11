(load "./stream")

(define sense-data
  (stream-map (lambda (x) (sin x)) integers))

(define (sign-change-detector s2 s1)
  (cond ((and (<= 0 s2) (> 0 s1)) 1)
	((and (> 0 s2) (<= 0 s1)) -1)
	(else 0)))

(define (average x y)
  (/ (+ x y) 2))

(define (smooth s)
  (stream-map average s (stream-cdr s)))

(define (make-zero-crossings input-stream last-value)
  (cons-stream
   (sign-change-detector (stream-car input-stream) last-value)
   (make-zero-crossings (stream-cdr input-stream)
                        (stream-car input-stream))))

(define zero-crossings (make-zero-crossings (smooth sense-data) 0))

(stream-head sense-data 20)
(stream-head zero-crossings 20)
