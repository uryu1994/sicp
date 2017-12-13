(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	...
	((quoted? exp) (text-of-quotation exp env))
	...
	((application? exp)
	 (apply (actual-value (operator exp) env)
		(operands exp)
		env))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

(define (text-of-quotation exp env)
  (let ((text (cadr exp)))
    (if (pair? text)
	(eval (text->list text) env)
	text)))

(define (text->list seq)
  (if (not (pair? seq))
      (list 'quote seq)
      (list 'cons
	    (text->list (car seq))
	    (text->list (cdr seq)))))

(load "./stream-lazy-list")
(driver-loop)
(define x '(a b c))

(car '(a b c))
(car (cdr '(a b c)))
(car (cdr (cdr '(a b c))))
