(define (make-count-pairs pair)
  (let ((counted-list '()))
    (define (count-pairs x)
      (cond ((not (pair? x)) 0)
            ((memq x counted-list) 0)
            (else
             (set! counted-list (cons x counted-list))
             (display counted-list)
             (+ (count-pairs (car x))
                (count-pairs (cdr x))
                1))))
    (count-pairs pair)))

(define x (list 'a 'b 'c))

(define y (list (list 'a 'b) 'c))

(define z (list 'a 'b 'c))
(set-car! (cdr z) (cdr (cdr z)))
(set-car! z (cdr z))

(make-count-pairs x);; 3

(make-count-pairs y);; 4
(make-count-pairs z);; 3
