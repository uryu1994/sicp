;; (let ((⟨var1⟩ ⟨exp1) ...  (⟨varn⟩ ⟨expn⟩))
;;       ⟨body⟩)
;;
;; ((lambda (⟨var1⟩ ... ⟨varn⟩)
;;    ⟨body⟩)
;;  ⟨exp1⟩
;;  ...
;;  ⟨expn⟩)

(define (let? exp) (tagged-list? exp 'let))
(define (let-clauses exp) (cadr exp))
(define (let-clause-var clause) (car clause))
(define (let-clause-value-exp clause) (cadr clause))
(define (let-body exp) (cddr exp))

(define (let->combination exp)
  (define vars (map let-clause-var (let-clauses exp)))
  (define value-exps (map let-clause-value-exp (let-clauses exp)))
  (cons
   (make-lambda vars (let-body exp))
   value-exps))

(define (eval exp env)
  (cond ...
	((let? exp) (eval (let->combination exp) env))
	((application? exp)
	 (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
	(else
	 (error "Unknown expression type -- EVAL" exp))))
