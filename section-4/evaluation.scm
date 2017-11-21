(define true #t)
(define false #f)

(define apply-in-underlying-scheme apply)

;; 4.1.1 apply
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure procedure arguments))
	((compound-procedure? procedure)
	 (eval-sequence
	  (procedure-body procedure)
	  (extend-environment
	   (procedure-parameters procedure)
	   arguments
	   (procedure-environment procedure))))
	(else
	 (error
	  "Unknown procedure type -- APPLY" procedure))))

;; 4.1.1 eval
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
	((application? exp)
	 (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
	(else
	 (error "Unknown expression type -- EVAL" exp))))


;; 4.1.1 Procedure arguments
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
	    (list-of-values (rest-operands exps) env))))

;; 4.1.1 Contidionals
(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

;; 4.1.1 Sequences
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
	(else (eval (first-exp exps) env)
	      (eval-sequence (rest-exps exps) env))))

;; 4.1.1 Assignments and definitions
(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
		       (eval (assignment-value exp) env)
		       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
    (eval (definition-value exp) env)
    env)
  'ok)


;; 4.1.2 The only self-evaluating
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

;; 4.1.2 Variables
(define (variable? exp) (symbol? exp))

;; 4.1.2 Quotations
(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

;; 4.1.2 Assignments
(define (assignment? exp)
  (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

;; 4.1.2 Definitions
(define (definition? exp)
  (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)   ; 仮パラメタ
                   (cddr exp)))) ; 本体

;; 4.1.2 lambda expressions
(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

;; 4.1.2 Contidionals
(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

;; 4.1.2 Begin packages
(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

;; 4.1.2 Procedure application
(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

;; 4.1.2 Derived expressions
(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false                          ; else節なし
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

;; Question 4.03
(define (and? exp) (tagged-list? exp 'and))
(define (and-clauses exp) (cdr exp))
(define (and-first-exp exp) (car exp))
(define (and-rest-exps exp) (cdr exp))
(define (eval-and exp env)
  (if (null? exp)
      true
      (let ((first (eval (and-first-exp exp) env))
	    (rest (and-rest-exps exp)))
	(if (true? first)
	    (eval-and rest env)
	    false))))

(define (or? exp) (tagged-list? exp 'or))
(define (or-clauses exp) (cdr exp))
(define (or-first-exp exp) (car exp))
(define (or-rest-exps exp) (cdr exp))
(define (eval-or exp env)
  (if (null? exp)
      false
      (let ((first (eval (or-first-exp exp) env))
	    (rest (or-rest-exps exp)))
	(if (true? first)
	    first
	    (eval-or rest env)))))

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

(define (normal-let->combination exp)
  (define vars (map let-clause-var (let-clauses exp)))
  (define value-exps (map let-clause-value-exp (let-clauses exp)))
  (cons
   (make-lambda vars (let-body exp))
   value-exps))

;; Question 4.09
(define (while? exp) (tagged-list? exp 'while))
(define (while-predicate exp) (cadr exp))
(define (while-body exp) (cddr exp))

(define (while->let exp)
  (let ((predicate (while-predicate exp))
	(body (while-body exp)))
    (list 'let 'while-loop '()
	  (make-if predicate
		   (append (cons 'begin body)
			   (list (cons 'while-loop '())))
		    'true))))


;; 4.1.3 Testing of predicates
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

;; 4.1.3 Representing procedures
(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-defines body) env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

;; 4.1.3 Operations on Environments
(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
	     (if (eq? (car vals) '*unassigned*)
		 (error "variable is unassigned" var)
		 (car vals)))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
           ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

;; Question 4.13
(define (unbind? exp) (tagged-list? exp 'unbind!))

(define (eval-unbinding exp env)
  (unbind-variable! (unbinding-variable exp) env))

(define (unbinding-variable exp) (cadr exp))
   
(define (unbind-variable! var env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
	     (error "Unbound Variable" var))
	    ((eq? var (car vars))
	     (set-car! vars (cadr vars))
	     (set-cdr! vars (cddr vars))
	     (set-car! vals (cadr vals))
	     (set-cdr! vals (cddr vals)))
	    (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
	  (frame-values frame))))

;; 4.16
(define (scan-out-defines body)
  (define (unassigned-variables definitions)
    (map (lambda (x) (list (definition-variable x) ''*unassigned*)) definitions))
  (define (set-values definitions)
    (map (lambda (x) (list 'set! (definition-variable x) (definition-value x))) definitions))
  (let ((definitions (filter definition? body))
	(rest-body (filter (lambda (x) (not (definition? x))) body)))
    (if (null? definitions)
	body
	(list (append (list 'let (unassigned-variables definitions))
		      (set-values definitions)
		      rest-body)))))

;; Question 4.20
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

;; 4.1.4 Running the Evaluator as a Program
(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
	(list 'cadr cadr)
        (list 'cons cons)
        (list 'null? null?)
	(list '+ +)
	(list '- -)
	(list '* *)
	(list '= =)
	(list 'assoc assoc)
	(list '< <)
	(list 'print print)
	;;⟨基本手続きが続く⟩
        ))
(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     ))
      (display object)))

(define the-global-environment (setup-environment))
;; (driver-loop)
