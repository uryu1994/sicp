(load "./fixed_point.scm")

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f k)
  (define (iter i)
    (if (= i k)
        f
        (compose f (iter (+ i 1)))))
  (iter 1))

(define (average-damp f)
  (lambda (y)
    (/ (+ y (f y)) 2)))

(define (n-root n x)
  (fixed-point ((repeated average-damp (round (log n 2)))
                (lambda (y) (/ x (expt y (- n 1)))))
               1.0))

(define (n-root-test n x k)
  (fixed-point ((repeated average-damp k)
                (lambda (y) (/ x (expt y (- n 1)))))
               1.0))
                
(define n-x (expt 3 100))
(define n-n 100)

(print (n-root 3 8))
(print (n-root 10 (expt 2 10)))

;;(print (n-root-test n-n n-x 1)) 
;;(print (n-root-test n-n n-x 2)) 
;;(print (n-root-test n-n n-x 3))
;;(print (n-root-test n-n n-x 4))
;;(print (n-root-test n-n n-x 5))
;;(print (n-root-test n-n n-x 6))
;;(print (n-root-test n-n n-x 7))
;;(print (n-root-test n-n n-x 8))
;;(print (n-root-test n-n n-x 9))
;;(print (n-root-test n-n n-x 10))
