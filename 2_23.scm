(define (for-each proc items)
  (cond ((null? items) #f)
        (else
         (proc (car items))
         (for-each proc (cdr items)))))
