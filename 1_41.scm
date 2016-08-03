(load "./newton")

(define (double f)
  (lambda (x) (f (f x))))

(define (inc x)
  (+ x 1))

(print (((double (double double)) inc) 5))

;;(define D2 (D D))

;;(((D (D D)) inc) 5)
