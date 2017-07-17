(load "./stream")

(define (show x)
  (display-line x)
  x)

(define x (stream-map show (stream-enumerate-interval 0 10)))

(define main
  (begin
    (display "(stream-ref x 5)")
    (stream-ref x 5)
    (display "(stream-ref x 7)")
    (stream-ref x 7)))


;; 0(stream-ref x 5)
;; 1
;; 2
;; 3
;; 4
;; 5(stream-ref x 7)
;; 6
;; 7
