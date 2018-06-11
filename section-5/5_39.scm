(load "./no-apply-eval")

(define (make-address fnum dnum) (list fnum dnum))
(define (frame-number address) (car address))
(define (displacement-number address) (cadr address))

(define (lexical-address-lookup address env)
  (let ((vals (frame-values
                (list-ref env (frame-number address)))))
    (let ((val (list-ref vals
                         (displacement-number address))))
      (if (eq? val '*unassigned*)
          (error "*unassigned* variable --LEXICAL_ADDRESS_LOOKUP")
          val))))

(define (lexical-address-set! address val env)
  (let ((vals (frame-values
               (list-ref env (frame-number address)))))
    (list-set! vals (displacement-number address) val)))

(define test
  (list (make-frame '(a b c d) '(1 2 3 4))
        (make-frame '(x y) '(5 6))))

(lexical-address-lookup (make-address 1 0) test)
(lexical-address-set! (make-address 1 0) 10 test)
(lexical-address-lookup (make-address 1 0) test)
