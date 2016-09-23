(load "./2_17")

(define (reverse items)
  (define (reverse-iter i r)
    (if (null? i)
        r
        (reverse-iter (cdr i) (cons (car i) r))))
  (reverse-iter items ()))
