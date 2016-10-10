(define (iterative-improve enough? improve)
  (lambda (y)
    (define (iter y)
      (if (enough? y)
          y
          (iter (improve y))))
    (iter y)))

(define (iterative-improve2 enough? improve)
  (define (iter y)
    (if (enough? y)
        (iter (improve y))))
  iter)

(define (average x y)
  (/ (+ x y) 2.0))


(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  ((iterative-improve2 good-enough? improve) x))

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? guess)
    (< (abs (- guess (f guess))) tolerance))
  ((iterative-improve2 close-enough? f) first-guess))


(print (sqrt 100))
(print (fixed-point cos 1.0))
