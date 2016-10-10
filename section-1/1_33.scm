(load "./1_22.scm")

(define (filtered-accumulate combiner null-value filter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a)
              (if (filter a)
                  (combiner result (term a))
                  result))))
  (iter a null-value))

(define (filtered-accumulate-2 combiner null-value filter term a next b)
  (if (> a b)
      null-value
      (combiner (term a) (if (filter a)
                             (filtered-accumulate-2 combiner null-value (next a) next b)
                             null-value
                             ))))
                             
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (sum-of-squared-prime a b)
  (define (term x)
    (* x x))
  (define (next x)
    (+ x 1))
  (filtered-accumulate-2 + 0 prime? term a next b))

(define (product-of-min-cop n)
  (define (term x)
    (if (= (gcd x n) 1)
        x
        1))
  (define (next x)
    (+ x 1))
  (define (filter i)
    (< i n))
  (filtered-accumulate-2 * 1 filter term 1 next n))

(print (sum-of-squared-prime 1 10))
(print (product-of-min-cop 20))
