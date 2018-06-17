(load "./5_42")

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


(define (compile-lambda-body exp proc-entry cenv)
  (let ((formals (lambda-parameters exp)))
    (append-instruction-sequences
     (make-instruction-sequence '(env proc argl) '(env)
                                `(,proc-entry
                                  (assign env (op compiled-procedure-env) (reg proc))
                                  (assign env
                                          (op extend-environment)
                                          (const ,formals)
                                          (reg argl)
                                          (reg env))))
     (compile-sequence (scan-out-defines (lambda-body exp)) 'val 'return (cons formals cenv)))))

(parse-compiled-code
  (compile
   '(lambda (x y)
      (define u (+ u x))
      (define v (- v y))
      (* u v))
   'val
   'next
   '()))
