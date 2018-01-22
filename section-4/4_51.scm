
;; Include amb.scm
(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
	;; ...
	;; Question 4.51
	((passingment? exp) (analyze-permanent-assignment exp))
	;; ...
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

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

;; --------------------

(load "./amb")

(driver-loop)

(define count 0)

(let ((x (an-element-of '(a b c)))
      (y (an-element-of '(a b c))))
  (permanent-set! count (+ count 1))
  (require (not (eq? x y)))
  (list x y count))
