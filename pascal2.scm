(define (pascal n k)
  (p-iter 1 n k))

(define (p-iter a b c)
  (cond ((= b 1)
