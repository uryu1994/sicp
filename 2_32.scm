(use slib)
(require 'trace)

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (cons (car s) x)) rest)))))
(trace subsets)

(define nil '())
(define x (list 1 2 3))
(subsets x)
