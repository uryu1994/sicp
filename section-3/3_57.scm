(use slib)
(require 'trace)

(load "./stream")

(define (debug-add x y)
  (display "Add")
  (+ x y))

(define (add-streams s1 s2)
  (stream-map debug-add s1 s2))

(define fibs
  (cons-stream 0
               (cons-stream 1
                            (add-streams (stream-cdr fibs)
                                         fibs))))

(stream-ref fibs 0)
(stream-ref fibs 1)
(stream-ref fibs 2) ;; 1
(stream-ref fibs 3) ;; 1
(stream-ref fibs 4) ;; 1
(stream-ref fibs 5) ;; 1
(stream-ref fibs 6) ;; 1
(stream-ref fibs 7) ;; 1
(stream-ref fibs 8) ;; 1

