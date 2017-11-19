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

(lambda <vars>
  (define u <e1>)
  (define v <e2>)
  <e3>)

(lambda <vars>
  (let ((u '*unassigned*)
	(v '*unassigned*))
    (set! u <e1>)
    (set! v <e2>)
    <e3>))

(define (lambda-defines exps)
  (filter definition? exps))

(define (lambda-expressions exps)
  (filter (lambda (exp) (not (definition? exp))) exps))

(define (make-assignment name new-value)
  (list 'set! name new-value))

(define (scan-out-defines body)
  (let ((internal-defines (lambda-defines body)))
    (let ((vars (map definition-variable internal-defines))
	  (vals (map definition-value internal-defines)))
      (if (null? vars)
	  body
	  (list
	   (make-let (map (lambda (var) (list var '*unassigned*))
			  vars)
		     (append
		      (map (lambda (var val) (make-assignment var val))
			   vars vals)
		      (lambda-expressions body))))))))
				  
