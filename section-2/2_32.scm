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

;;(subsets (1 2 3))
;;(append rest (map (lambda (x) (cons 1 x)) rest)) rest <= (subsets (2 3))
;;
;;(subsets (2 3))
;;(append rest (map (lambda (x) (cons 2 x)) rest)) rest <= (subsets (3))
;;
;;(subsets (3))
;;(append rest (map (lambda (x) (cons 3 x)) rest)) rest <= (subsets '())
;;=> ( '() (3))
;;
;;(subsets (2 3))
;;=> ( '() (3) )
