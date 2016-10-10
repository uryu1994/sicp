(define (cube x) (* x x x))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (inc n) (+ n 1))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(define (simpson f a b n)
  (define h
    (/ (- b a) n))
  (define (y k)
    (f (+ a (* k h))))
  (define (term i)
    (if (even? i)
        (* 2.0 (y i))
        (* 4.0 (y i))))
  (* (/ h 3.0)
     (+ (y 0)
        (sum term (+ a 1) inc (- n 1))
        (y n))))

;;(print "(simpson cube 0 1 100): " (simpson cube 0 1 100))
;;(print "(integral cube 0 1 0.01): " (integral cube 0 1 0.01))
;;(print "(simpson cube 0 1 1000): " (simpson cube 0 1 1000))
;;(print "(integral cube 0 1 0.001): " (integral cube 0 1 0.001))
(print "(simpson cube 0 1      10): "(simpson cube 0 1 10))
(print "(simpson cube 0 1     100): "(simpson cube 0 1 100))
(print "(simpson cube 0 1    1000): "(simpson cube 0 1 1000))
(print "(simpson cube 0 1   10000): "(simpson cube 0 1 10000))
(print "(simpson cube 0 1  100000): "(simpson cube 0 1 100000))
(print "(simpson cube 0 1 1000000): "(simpson cube 0 1 1000000))
