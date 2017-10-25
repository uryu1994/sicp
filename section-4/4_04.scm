(load "./evaluation")

;; (define (and? exp) (tagged-list? exp 'and))
;; (define (and-clauses exp) (cdr exp))
;; (define (and-first-exp exp) (car exp))
;; (define (and-rest-exps exp) (cdr exp))
;; (define (eval-and exp env)
;;   (if (null? exp)
;;       true
;;       (let ((first-eval (eval (car exp) env))
;; 	    (rest (cdr exp)))
;; 	(if (true? first-eval)
;; 	    (eval-and rest env)
;; 	    false))))

;; (define (or? exp) (tagged-list? exp 'or))
;; (define (or-clauses exp) (cdr exp))
;; (define (or-first-exp exp) (car exp))
;; (define (or-rest-exps exp) (cdr exp))
;; (define (eval-or exp env)
;;   (if (null? exp)
;;       false
;;       (let ((first-eval (eval (car exp) env))
;; 	    (rest (cdr exp)))
;; 	(if (true? first-eval)
;; 	    first-eval
;; 	    (eval-or rest env)))))

;; (define (eval exp env)
;;   (cond ((self-evaluating? exp) exp)
;;         ((variable? exp) (lookup-variable-value exp env))
;; 	((quoted? exp) (text-of-quotation exp))
;; 	((assignment? exp) (eval-assignment exp env))
;; 	((definition? exp) (eval-definition exp env))
;; 	((if? exp) (eval-if exp env))
;; 	((and? exp) (eval-and (and-clauses exp) env))
;; 	((or? exp) (eval-or (or-clauses exp) env))
;; 	((lambda? exp)
;; 	 (make-procedure (lambda-parameters exp)
;; 			 (lambda-body exp)
;; 			 env))
;; 	((begin? exp) 
;; 	 (eval-sequence (begin-actions exp) env))
;; 	((cond? exp) (eval (cond->if exp) env))
;; 	((application? exp)
;; 	 (apply (eval (operator exp) env)
;;                 (list-of-values (operands exp) env)))
;; 	(else
;; 	 (error "Unknown expression type -- EVAL" exp))))

;; TODO: 導出された式

(driver-loop)
