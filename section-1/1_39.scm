(load "./1_37.scm")

(define (tan-cf x k)
  (define (n i)
    (if (= i 1)
        x
        (* x x -1)))
  (define (d j)
    (- (* 2 j) 1))
  (cont-frac n d k))

(print (tan-cf (/ 3.141592 2) 1000))
