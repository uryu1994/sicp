(define (scan var vars vals proc)
  (cond ((null? vars) false)
	((eq? var (car vars))
	 (proc var vars vals))
	(else (scan var (cdr vars) (cdr vals) proc))))

(define (env-loop var env proc)
  (if (eq? env the-empty-environment)
      false
      (let ((frame (first-frame env)))
	(scan var
	      (frame-variables frame)
	      (frame-values frame)
	      proc))))

(define (lookup-variable-value var env)
  (let ((target (env-loop var env (lambda (var vars vals)
				    (car vals)))))
    (if target
	target
	(error "Unbound variable" var))))

(define (set-variable-value! var val env)
  (let ((target (env-loop var env (lambda (var vars vals)
				    (set-car! vals val)))))
    (if target
	target
	(error "Unbound variable -- SET!" var))))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (let ((target (scan var
			(frame-variables frame)
			(frame-values frame)
			(lambda (var vars vals)
			  (set-car! vals val)))))
      (if target
	  target
	  (add-binding-to-frame! var val frame)))))

