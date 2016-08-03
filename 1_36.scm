(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (display next)
      (newline)
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (f x)
  (/ (log 1000) (log x)))
(define (g x)
  (/ (+ (log x) (/ (log 1000) (log x))) 2))

;;(fixed-point f 100)
(fixed-point g 100)
