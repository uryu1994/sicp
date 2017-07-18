(define (make-monitored f)
  (let ((count 0))
    (define (mf m)
      (cond ((eq? m 'how-many-calls?) count)
            ((eq? m 'reset-count)
             (begin (set! count 0) count))
            (else
             (begin (set! count (+ count 1)) (f m)))))
    mf))

(define s (make-monitored sqrt))

(s 100)

(s 'how-many-calls?)
(s 'reset-count)
(s 10)
