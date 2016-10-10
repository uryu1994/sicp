(load "./newton")

(define (cube x)
  (* x x x))

(define (cubic a b c)
  (lambda (x) (+ (cube x)
                 (* a (square x))
                 (* b x)
                 c)))

(print (newtons-method (cubic 1 1 0) 1))
