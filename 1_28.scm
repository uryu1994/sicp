(load "./fermat")

(define (miller-rabin-test x n)
  (and (not (= x 1))
       (not (= x (- n 1)))
       (= (remainder (* x x) n) 1)))
