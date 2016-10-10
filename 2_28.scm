(define x (list (list 1 2) (list 3 4)))
(define y (list (list 1 2) (list 3 4)))


(define (fringe x)
  (cond ((null? x) x)
        ((not (pair? x)) (list x))
        (else (append (fringe (car x)) (fringe (cdr x))))))

(define (fringe x)
  (define (iter i r)
    (cond ((null? i) r)
          ((not (pair? i)) (cons i r))
          (else (iter (car i) (iter (cdr i) r)))))
  (iter x '()))

(fringe (list x x))
