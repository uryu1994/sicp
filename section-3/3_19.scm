(define (safe-cycle? x)
  (define (check x1 x2)
    (cond ((eq? x1 x2) #t)
          ((null? (cdr x1)) #f)
          ((null? (cddr x2)) #f)
          (else
           (check (cdr x1) (cddr x2)))))
  (cond ((not (pair? x)) #f)
        ((not (pair? (cdr x))) #f)
        (else
         (check (cdr x) (cddr x)))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define x (make-cycle (list 'a 'b 'c)))
(define y (make-cycle (list 'a 'b 'c 'd 'e 'f 'g 'h)))

(safe-cycle? x)
(safe-cycle? y)
(safe-cycle? (list (list 'a 'b) 'c))
