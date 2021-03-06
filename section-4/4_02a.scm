(load "./evaluation")

;; 4.1.1 eval
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (text-of-quotation exp))
	((application? exp)
	 (apply (eval (operator exp) env)
                (list-of-values (operands exp) env))) ; Louis Answer.
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp env))
	((lambda? exp)
	 (make-procedure (lambda-parameters exp)
			 (lambda-body exp)
			 env))
	((begin? exp) 
	 (eval-sequence (begin-actions exp) env))
	((cond? exp) (eval (cond->if exp) env))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

;; application?がtrueになるのでdefineが手続き作用として扱われてしまう
