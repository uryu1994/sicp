(load "./microshaft")

(define (unique-query exp) (car exp))

(define (uniquely-asserted operands frame-stream)
  (stream-flatmap
   (lambda (frame)
     (let ((result (qeval (unique-query operands) (singleton-stream frame))))
       (if (and (not (stream-null? result))
                (stream-null? (stream-cdr result)))
           result
           the-empty-stream)))
   frame-stream))

(put 'unique 'qeval uniquely-asserted)

(query-driver-loop)

(unique (job ?x (computer wizard)))

(unique (job ?x (computer programmer)))

(and (job ?x ?j) (unique (job ?anyone ?j)))
