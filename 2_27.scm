
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(define x (list (list 1 2) (list 3 4)))

(define (reverse items)
  (define (reverse-iter i r)
    (if (null? i)
        r
        (reverse-iter (cdr i) (cons (car i) r))))
  (reverse-iter items ()))

(define (deep-reverse items)
  (cond ((null? items) '())
        ((not (pair? items)) items)
         (else (append (deep-reverse (cdr items))
		       (list (deep-reverse (car items)))))))
