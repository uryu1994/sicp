(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (let* ((quotient (/ x guess))
         (average (average guess (/ x guess))))
    (print #"~guess  ~|x|/~|guess|=~quotient  (~|guess|+~|quotient|)/2=~average")
    average))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (better-good-enough? guess1 guess2)
  (< (abs (- guess1 guess2)) 0.0000000001))

(define (better-sqrt-iter guess1 x)
  (if (better-good-enough? guess1 (improve guess1 x))
      guess1
      (better-sqrt-iter (improve guess1 x) x)))

(define (better-sqrt x)
  (better-sqrt-iter 1.0 x))
