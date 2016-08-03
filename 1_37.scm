;;a
(define (cont-frac n d k)
  (define (loop i)
    (if (= i k)
        (/ (n i) (d i))
        (/ (n i) (+ (d i) (loop (+ i 1))))))
  (loop 1))

(print (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 10))

;;b
(define (cont-frac2 n d k)
  (define (loop i result)
    (if (= i 0)
        result
        (loop (- i 1) (/ (n i) (+ (d i) result)))))
  (loop k 1))

(print (cont-frac2 (lambda (i) 1.0) (lambda (i) 1.0) 10))
