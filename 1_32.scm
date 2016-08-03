;;a)
(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner (term a) result))))
  (iter a null-value))

(define (acm combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a) (acm combiner null-value term (next a) next b))))
