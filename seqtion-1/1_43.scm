
(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f k)
  (define (iter i)
    (if (= i k)
        f
        (compose f (iter (+ i 1)))))
  (iter 1))

(print ((repeated square 2) 5))
(print ((repeated square 3) 5))
(print ((repeated square 4) 5))
