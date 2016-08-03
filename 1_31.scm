(define (product term a next b)
  (if (> a b)
      1
      (* (term a) (product term (next a) next b))))

(define (product2 term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (factorial n)
  (define (next i) (+ i 1))
  (define (term i) i)
  (product term 1 next n))

(define (pi1 n)
  (define (next i) (+ i 1))
  (define (f k)
    (if (even? k)
        (/ (+ k 2.0) (+ k 1.0))
        (/ (+ k 1.0) (+ k 2.0))))
  (* 4.0 (product f 1 next n)))

(define (pi2 n)
  (define (next i) (+ i 1))
  (define (f k)
    (if (even? k)
        (/ (+ k 2.0) (+ k 1.0))
        (/ (+ k 1.0) (+ k 2.0))))
  (* 4.0 (product2 f 1.0 next n)))

(print "pi1 n=   100: " (pi1 100))
(print "pi1 n=  1000: " (pi1 1000))
(print "pi1 n= 10000: " (pi1 1000))
(print "pi1 n=100000: " (pi1 100000))
(print "pi2: " (pi2 100))
