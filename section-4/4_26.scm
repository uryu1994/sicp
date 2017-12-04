(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	...
	;; Question 4.26
	((unless? exp) (eval (unless->if exp) env))
	((application? exp)
	 (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

(define (unless? exp) (tagged-list? exp 'unless))
(define (unless-condition exp) (cadr exp))
(define (unless-usual-value exp) (caddr exp))
(define (unless-exceptional-value exp) (cadddr exp))

(define (unless->if exp)
  (make-if (unless-condition exp)
	   (unless-exceptional-value exp)
	   (unless-usual-value exp)))

;;unlessが特殊形式としてではなく, 手続きとして使えると有用である状況の例
;; mapなどの高階関数に渡せたりできるので有用なこともある
