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
;; 	;; Question 4.06
;; 	((let? exp) (eval (let->combination exp) env))
;; 	;; Question 4.07
;; 	((let*? exp) (eval (let*->nested-lets exp) env))
;; 	;; Question 4.20
;; 	((letrec? exp) (eval (letrec->let exp) env))
;; 	;; Question 4.09
;; 	((while? exp) (eval (while->let exp) env))
;; 	;; Question 4.13
;; 	((unbind? exp) (eval-unbinding exp env))
;; 	((application? exp)
;; 	 (apply (eval (operator exp) env)
;;                 (list-of-values (operands exp) env)))
;; 	(else
;; 	 (error "Unknown expression type -- EVAL" exp))))

(define (analyze-application exp)
  (let ((pproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
    (lambda (env)
      (execute-application (pproc env)
                           (map (lambda (aproc) (aproc env))
                                aprocs)))))

(define (execute-application proc args)
  (cond ((primitive-procedure? proc)
         (apply-primitive-procedure proc args))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment (procedure-parameters proc)
                              args
                              (procedure-environment proc))))
        (else
         (error
          "Unknown procedure type -- EXECUTE-APPLICATION"
          proc))))


(define (eval exp env)
  ((analyze exp) env))

(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
	;; Question 4.52
	((if-fail? exp) (analyze-if-fail exp))
	((and? exp) (analyze (and->if exp)))
	((or? exp) (analyze (or->if exp)))
        ((lambda? exp) (analyze-lambda exp))
	((amb? exp) (analyze-amb exp))
	;; Question 4.50
	((ramb? exp) (analyze-ramb exp))
	;; Question 4.51
	((passingment? exp) (analyze-permanent-assignment exp))
	;; Question 4.53
	((require? exp) (analyze-require exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
	((let? exp) (analyze (let->combination exp)))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

;; 4.3.3
(define (amb? exp) (tagged-list? exp 'amb))
(define (amb-choices exp) (cdr exp))

(define (ambeval exp env succeed fail)
  ((analyze exp) env succeed fail))

(use srfi-27)
;; Question 4.50
(define (ramb? exp) (tagged-list? exp 'ramb))
(define (ramb-choices exp) (cdr exp))
(define (analyze-ramb exp)
  (let ((cprocs (map analyze (ramb-choices exp))))
    (define (delete x seq)
      (cond ((null? seq) '())
	    ((equal? x (car seq)) (cdr seq))
	    (else (cons (car seq) (delete x (cdr seq))))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    (let ((choice (list-ref choices (random-integer (length choices)))))
	      (choice env succeed (lambda ()
				    (try-next (delete choice choices)))))))
      (try-next cprocs))))

;; Question 4.51
(define (passingment? exp) (tagged-list? exp 'permanent-set!))
(define (analyze-permanent-assignment exp)
  (let ((var (assignment-variable exp))
	(vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (set-variable-value! var val env)
	       (succeed 'ok fail2))
	     fail))))

;; Question 4.52
(define (if-fail? exp) (tagged-list? exp 'if-fail))
(define (if-succeed exp) (cadr exp))
(define (if-failed exp) (caddr exp))
(define (analyze-if-fail exp)
  (let ((sproc (analyze (if-succeed exp)))
	(fproc (analyze (if-failed exp))))
    (lambda (env succeed fail)
      (sproc env
	     succeed
	     (lambda ()
	       (fproc env succeed fail))))))

;; Question 4.53
(define (require? exp) (tagged-list? exp 'require))
(define (require-predicate exp) (cadr exp))

(define (analyze-require exp)
  (let ((pproc (analyze (require-predicate exp))))
    (lambda (env succeed fail)
      (pproc env
             (lambda (pred-value fail2)
               (if (false? pred-value)
                   (fail2)
                   (succeed 'ok fail2)))
             fail))))

(define (analyze-self-evaluating exp)
  (lambda (env succeed fail)
    (succeed exp fail)))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env succeed fail)
      (succeed qval fail))))

(define (analyze-variable exp)
  (lambda (env succeed fail)
    (succeed (lookup-variable-value exp env)
             fail)))

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
        (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env succeed fail)
      (succeed (make-procedure vars bproc env)
               fail))))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)        ; *1*
               (let ((old-value
                      (lookup-variable-value var env))) 
                 (set-variable-value! var val env)
                 (succeed 'ok
                          (lambda ()    ; *2*
                            (set-variable-value! var
                                                 old-value
                                                 env)
                            (fail2)))))
             fail))))

(define (analyze-definition exp)
  (let ((var (definition-variable exp))
        (vproc (analyze (definition-value exp))))
    (lambda (env succeed fail)
      (vproc env                        
             (lambda (val fail2)
               (define-variable! var val env)
               (succeed 'ok fail2))
             fail))))

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
    (lambda (env succeed fail)
      (pproc env
             ;; pred-valueを得るための
             ;; 述語の評価の成功継続
             (lambda (pred-value fail2)
               (if (true? pred-value)
                   (cproc env succeed fail2)
                   (aproc env succeed fail2)))
             ;; 述語の評価の失敗継続
             fail))))

(define (analyze-sequence exps)
  (define (sequentially a b)
    (lambda (env succeed fail)
      (a env
         ;; aを呼び出す時の成功継続
         (lambda (a-value fail2)
           (b env succeed fail2))
         ;; aを呼び出す時の失敗継続
         fail)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

(define (analyze-application exp)
  (let ((pproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
    (lambda (env succeed fail)
      (pproc env
             (lambda (proc fail2)
               (get-args aprocs
                         env
                         (lambda (args fail3)
                           (execute-application
                            proc args succeed fail3))
                         fail2))
             fail))))

(define (get-args aprocs env succeed fail)
  (if (null? aprocs)
      (succeed '() fail)
      ((car aprocs) env
       ;; このaprocの成功継続
       (lambda (arg fail2)
	 (get-args (cdr aprocs)
		   env
		   ;; get-argsの再帰呼出しの
		   ;; 成功継続
		   (lambda (args fail3)
		     (succeed (cons arg args)
			      fail3))
		   fail2))
       fail)))

(define (execute-application proc args succeed fail)
  (cond ((primitive-procedure? proc)
         (succeed (apply-primitive-procedure proc args)
                  fail))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment (procedure-parameters proc)
                              args
                              (procedure-environment proc))
          succeed
          fail))
        (else
         (error
          "Unknown procedure type -- EXECUTE-APPLICATION"
          proc))))


(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
            (fail)
            ((car choices) env
	     succeed
	     (lambda ()
	       (try-next (cdr choices))))))
      (try-next cprocs))))

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
(define (and->if exp)
  (expand-and-clauses (and-clauses exp)))

(define (expand-and-clauses clauses)
  (define (expand-and-iter clauses result)
    (if (null? clauses)
        result
        (let ((first (and-first-exp clauses))
              (rest (and-rest-exps clauses)))
	  (make-if first
		   (expand-and-iter rest first)
		   'false))))
  (if (null? clauses)
      'true
      (expand-and-iter clauses '())))

(define (or? exp) (tagged-list? exp 'or))
(define (or-clauses exp) (cdr exp))
(define (or-first-exp exp) (car exp))
(define (or-rest-exps exp) (cdr exp))
(define (or->if exp)
  (expand-or-clauses (or-clauses exp)))

(define (expand-or-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (or-first-exp clauses))
            (rest (or-rest-exps clauses)))
	(make-if first
		 first
		 (expand-or-clauses rest)))))

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
  (list 'procedure parameters body env))

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
	(list 'caddr caddr)
	(list 'cadddr cadddr)
	(list 'cddddr cddddr)
        (list 'cons cons)
        (list 'null? null?)
	(list 'list list)
	(list 'eq? eq?)
	(list 'not not)
	(list 'member member)
	(list 'memq memq)
	(list '+ +)
	(list '- -)
	(list '* *)
	(list '/ /)
	(list '= =)
	(list 'abs abs)
	(list 'assoc assoc)
	(list 'even? even?)
	(list 'remainder remainder)
	(list '< <)
	(list '> >)
	(list '<= <=)
	(list '>= >=)
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

(define input-prompt ";;; Amb-Eval input:")
(define output-prompt ";;; Amb-Eval value:")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
          (try-again)
          (begin
            (newline)
            (display ";;; Starting a new problem ")
            (ambeval input
                     the-global-environment
                     ;; ambeval 成功
                     (lambda (val next-alternative)
                       (announce-output output-prompt)
                       (user-print val)
                       (internal-loop next-alternative))
                     ;; ambeval 失敗
                     (lambda ()
                       (announce-output
                        ";;; There are no more values of")
                       (user-print input)
                       (driver-loop)))))))
  (internal-loop
   (lambda ()
     (newline)
     (display ";;; There is no current problem")
     (driver-loop))))


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

(define (simple-ambeval exp)
  (ambeval exp
	   the-global-environment
	   (lambda (val next-alternative))
	   (lambda ())))

(for-each simple-ambeval
	  '(
	    ;;(define (require p)
	    ;;   (if (not p) (amb)))
	    (define (xor a b)
	      (or (and a (not b)) (and (not a) b)))
	    (define (an-element-of items)
	      (require (not (null? items)))
	      (amb (car items) (an-element-of (cdr items))))
	    (define (an-integer-starting-from n)
	      (amb n (an-integer-starting-from (+ n 1))))
	    (define (distinct? items)
	      (cond ((null? items) true)
		    ((null? (cdr items)) true)
		    ((member (car items) (cdr items)) false)
		    (else (distinct? (cdr items)))))
	    ))
;; (driver-loop)
