(load "./stream")

(define (ln2-summands n)
  (cons-stream (/ 1.0 n)
	       (stream-map - (ln2-summands (+ n 1)))))

(define ln2-stream
  (partial-sums (ln2-summands 1)))

(stream-head ln2-stream 10)
(stream-head (euler-transform ln2-stream) 10)
(stream-head (accelerated-sequence euler-transform ln2-stream) 10)
