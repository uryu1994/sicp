
(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
	...
	((let? exp) (analyze (let->combination exp)))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

;; 問題4.6-4.8がそのまま使える
;; Question 4.06
(define (let? exp) (tagged-list? exp 'let))
(define (let-clauses exp) (cadr exp))
(define (let-clause-var clause) (car clause))
(define (let-clause-value-exp clause) (cadr clause))
(define (let-body exp) (cddr exp))

;; (define (let->combination exp)
;;   (define vars (map let-clause-var (let-clauses exp)))
;;   (define value-exps (map let-clause-value-exp (let-clauses exp)))
;;   (cons
;;    (make-lambda vars (let-body exp))
;;    value-exps))

;; Question 4.07
(define (let*? exp) (tagged-list? exp 'let*))
(define (let*-clauses exp) (cadr exp))
(define (let*-body exp) (caddr exp))

(define (let*->nested-lets exp)
  (define (make-lets clauses)
    (if (null? clauses)
	(let*-body exp)
	(list 'let (list (car clauses))
	      (make-lets (cdr clauses)))))
  (make-lets (let*-clauses exp)))

;; Question 4.08
(define (named-let? exp) (symbol? (cadr exp)))
(define (named-let-var exp) (cadr exp))
(define (named-let-clauses clauses) (caddr clauses))
(define (named-let-body exp) (cadddr exp))

(define (let->combination exp)
  (if (named-let? exp)
      (named-let->combination exp)
      (normal-let->combination exp)))

(define (named-let->combination exp)
  (define vars (map let-clause-var (named-let-clauses exp)))
  (define value-exps (map let-clause-value-exp (named-let-clauses exp)))
  (make-begin
   (list
    (list 'define (cons (named-let-var exp) vars)
	  (named-let-body exp))
    (cons (named-let-var exp) value-exps))))
