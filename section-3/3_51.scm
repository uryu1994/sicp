(load "./stream")

(define (show x)
  (display-line x)
  x)

(define x (stream-map show (stream-enumerate-interval 0 10)))
;; 0x

(stream-ref x 5)
;; 1
;; 2
;; 3
;; 4
;; 55

(stream-ref x 7)
;; 6
;; 77
