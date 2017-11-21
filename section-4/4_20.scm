(define (letrec? exp) (tagged-list? exp 'letrec))
(define (letrec-clauses exp) (cadr exp))
(define (letrec-variables exp) (map car (letrec-clauses exp)))
(define (letrec-expressions exp) (map cdr (letrec-clauses exp)))
(define (letrec-body exp) (cddr exp))

(define (letrec->let exp)
  (cons 'let
	(cons (map (lambda (x) (list x ''*unssigned*))
		   (letrec-variables exp))
	      (append (map (lambda (x y) (cons 'set! (cons x y)))
			   (letrec-variables exp)
			   (letrec-expressions exp))
		      (letrec-body exp)))))

