(load "./normal-order-evaluation")

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (text-of-quotation exp))
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp env))
	((and? exp) (eval-and (and-clauses exp) env))
	((or? exp) (eval-or (or-clauses exp) env))
	((lambda? exp)
	 (make-procedure (lambda-parameters exp)
			 (lambda-body exp)
			 env))
	((begin? exp) 
	 (eval-sequence (begin-actions exp) env))
	((cond? exp) (eval (cond->if exp) env))
	;; Question 4.06
	((let? exp) (eval (let->combination exp) env))
	;; Question 4.07
	((let*? exp) (eval (let*->nested-lets exp) env))
	;; Question 4.20
	((letrec? exp) (eval (letrec->let exp) env))
	;; Question 4.09
	((while? exp) (eval (while->let exp) env))
	;; Question 4.13
	((unbind? exp) (eval-unbinding exp env))
	;; Question 4.26
	((unless? exp) (eval (unless->if exp) env))
	;; 4.2.2 Fixed
	;; ((application? exp)
	;;  (apply (actual-value (operator exp) env)
	;; 	(operands exp)
	;; 	env))
	((application? exp)
	 (apply (eval (operator exp) env)
		(operands exp)
		env))	
	(else
	 (error "Unknown expression type -- EVAL" exp))))

;; ;;; L-Eval input:
;; (define (foo x)
;;   (+ x 1))

;; ;;; L-Eval value:
;; ok

;; ;;; L-Eval input:
;; (foo 2)

;; ;;; L-Eval value:
;; 3

;; ;;; L-Eval input:
;; (define (hoge proc)
;;   (proc 10))

;; ;;; L-Eval value:
;; ok

;; ;;; L-Eval input:
;; (hoge foo)
;; *** ERROR: Unknown procedure type -- APPLY (thunk foo #0=(((hoge foo false true car cdr cadr cons null? + - * / = assoc < print) (procedure (proc) ((proc 10)) #0#) (procedure (x) ((+ x 1)) #0#) #f #t (primitive #<subr (car obj)>) (primitive #<subr (cdr obj)>) (primitive #<subr (cadr obj)>) (primitive #<subr (cons obj1 obj2)>) (primitive #<subr (null? obj)>) (primitive #<subr (+ :rest args)>) (primitive #<subr (- arg1 :rest args)>) (primitive #<subr (* :rest args)>) (primitive #<subr (/ arg1 :rest args)>) (primitive #<subr (= arg0 arg1 :rest args :optarray oarg)>) (primitive #<closure (assoc x lis . args)>) (primitive #<subr (< arg0 arg1 :rest args :optarray oarg)>) (primitive #<closure (print . args)>))))
