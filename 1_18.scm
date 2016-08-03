(load ./1_17.scm)

(define (mul2 a b)
  (mul-iter a b 1))

(define (mul-iter a b c)
  (cond ((= b 0) c)
        ((even? b) (mul-iter (double a) (halve b) c))
        (else (mul-iter (double a) (- b 1) (+ a c)))))
