(load "./stream")

;; Included in stream.scm
;; (define (div-streams s1 s2)
;;   (stream-map / s1 s2))



;; 3.59a
(define (integrate-series s)
  (cons-stream (stream-car s)
               (div-streams (stream-cdr s)
                            (add-streams ones integers))))

;; 3.59b
(define minus-ones (cons-stream -1 minus-ones))
(define (inverse-stream s)
  (stream-map * minus-ones s))

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define cosine-series
  (cons-stream 1 (inverse-stream (integrate-series sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

