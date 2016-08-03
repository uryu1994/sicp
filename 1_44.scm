(define dx 0.00001)

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f k)
  (define (iter i)
    (if (= i k)
        f
        (compose f (iter (+ i 1)))))
  (iter 1))

(define (smooth f)
  (lambda (x)
    (/ (+ (f (- x dx)) (f x) (f (+ x dx)))
       3)))

(define (n-fold-smooth f n)
    ((repeated smooth n) f))

(define pi (* 4 (atan 1.0)))

(print pi)

;;(print ((smooth square) 10))
(print ((n-fold-smooth cos 1)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 2)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 3)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 4)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 5)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 6)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 7)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 8)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 9)  (* (/ 1.0 2) pi)))
(print ((n-fold-smooth cos 10) (* (/ 1.0 2) pi)))
