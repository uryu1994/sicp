(define (cycle? x)
  (let ((walk-list '()))
    (define (cycle-iter p)
      (cond ((not (pair? p)) #f)
            ((memq p walk-list) #t)
            (else
             (set! walk-list (cons p walk-list))
             (cycle-iter (cdr p)))))
    (cycle-iter x)))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define x (list 'a 'b 'c))

(define y (list (list 'a 'b) 'c))

(define z (list 'a 'b 'c))
(set-car! (cdr z) (cdr (cdr z)))
(set-car! z (cdr z))

(define w (make-cycle (list 'a 'b 'c)))

(cycle? x)
(cycle? y)
(cycle? z)
(cycle? w)
