(define (iterative-improve enough? improve)
  (lambda (y)
    (define (iter y)
      (if (enough? y)
          y
          (iter (improve y))))
    (iter y)))

(define (average x y)
  (/ (+ x y) 2.0))


(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  ((iterative-improve good-enough? improve) x))

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? guess)
    (< (abs (- guess (f guess))) tolerance))
  (f ((iterative-improve close-enough? f) first-guess)))


(print (sqrt 9))
(print (fixed-point (lambda (y) (+ (sin y) (cos y)))
             1.0))
