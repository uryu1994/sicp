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

;; (lambda <vars>
;;   (define u <e1>)
;;   (define v <e2>)
;;   <e3>)

;; (lambda <vars>
;;   (let ((u '*unassigned*)
;; 	(v '*unassigned*))
;;     (set! u <e1>)
;;     (set! v <e2>)
;;     <e3>))

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

;; make-procedure
(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-defines body) env))
;; evalの前に呼び出される

;; procedure-body
(define (procedure-body p) (scan-out-defines (cadddr p)))
;; user-printとapplyで呼び出される
;; 特にapplyは実行頻度が高いため効率がよくない


(driver-loop)
