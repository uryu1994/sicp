(load "./stream")

;; 3.59a
(define (integrate-series s)
  (stream-map / s integers))

;; 3.59b
(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define cosine-series
  (cons-stream 1 (stream-map - (integrate-series sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))
