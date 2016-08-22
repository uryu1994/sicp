(define (make-segment p0 p1)
  (cons p0 p1))

(define (start-segment s)
  (car s))

(define (end-segment s)
  (cdr s))

(define (make-point x y)
  (cons x y))

(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (midpoint-segment s)
  (define (average a b)
    (/ (+ a b) 2))
  (let ((p0 (start-segment s))
        (p1 (end-segment s)))
    (make-point (average (x-point p0) (x-point p1))
                (average (y-point p0) (y-point p1)))))

