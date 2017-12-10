(load "./normal-order-evaluation")

;; (define (f x (y lazy))
;;   (+ x y))

;;('procedure (x y) ((+ x y)) the-global-environment)
;;
;;('procedure (x y) (() lazy) ((+ x y)) the-global-environment)

(define (make-procedure parameters body env)
  (define (unmodify x)
    (if (symbol? x) x (car x)))
  (define (modifier x)
    (if (symbol? x) '() (cadr x)))
  (let ((p (map unmodify parameters))
	(m (map modifier parameters)))
    (list 'procedure p m body env)))

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (cadddr p))
(define (procedure-environment p) (car (cddddr p)))
(define (procedure-modifier p) (caddr p))

(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure
	  procedure
	  (list-of-arg-values arguments env)))
	((compound-procedure? procedure)
	 (eval-sequence
	  (procedure-body procedure)
	  (extend-environment
	   (procedure-parameters procedure)
	   (list-of-delayed-args arguments
				 (procedure-modifier procedure)
				 env)
	   (procedure-environment procedure))))
	(else
	 (error
	  "Unknown procedure type -- APPLY" procedure))))

(define (delay-memo-it exp env)
  (list 'thunk-memo exp env))

(define (list-of-delayed-args exps modifier env)
  (if (no-operands? exps)
      '()
      (let ((m (first-operand modifier))
	    (o (first-operand exps)))
	(cons (cond ((eq? m 'lazy) (delay-it o env))
		    ((eq? m 'lazy-memo) (delay-memo-it o env))
		    ((null? m) (actual-value o env))
		    (else
		     (error "Unknown modifier -- LIST-OF-DELAYED-ARGS" m)))
	      (list-of-delayed-args (rest-operands exps)
				    (rest-operands modifier)
                                  env)))))

(define (thunk-memo? obj)
  (tagged-list? obj 'thunk-memo))

(define (force-it obj)
  (cond ((thunk-memo? obj)
         (let ((result (actual-value
                        (thunk-exp obj)
                        (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj) result)  ; expをその値で置き換える
           (set-cdr! (cdr obj) '())     ; 不要なenvを忘れる
           result))
        ((evaluated-thunk? obj)
         (thunk-value obj))
	((thunk? obj)
	 (actual-value (thunk-exp obj) (thunk-env obj)))
        (else obj)))
