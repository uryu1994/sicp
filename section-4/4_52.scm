;; Include amb.scm
(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
	;; ...
	;; Question 4.52
	((if-fail? exp) (analyze-if-fail exp))
	;; ...
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

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

;; --------------------------------------

(load "./amb")

(driver-loop)

(if-fail (let ((x (an-element-of '(1 3 5))))
           (require (even? x))
           x)
         'all-odd)


(if-fail (let ((x (an-element-of '(1 3 5 8))))
           (require (even? x))
           x)
         'all-odd)
