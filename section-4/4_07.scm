(load "./4_06")

;; (let* ((<var1> <exp1>)
;;        (<var2> <exp2>)
;;        ...)
;;   <body>)

;; (let ((<var1> <exp1>))
;;   (let ((<var2> <exp2>))
;;     ...
;;     <body>))

(define (let*? exp) (tagged-list? exp 'let*))
(define (let*-clauses exp) (cadr exp))
(define (let*-body exp) (caddr exp))

(define (let*->nested-lets exp)
  (define (make-lets clauses)
    (if (null? clauses)
	(let*-body exp)
	(list 'let (list (car clauses))
	      (make-lets (cdr clauses)))))
  (make-lets (let-clauses exp)))
