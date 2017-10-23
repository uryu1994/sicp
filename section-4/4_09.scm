(load "./evaluation")

;; (while <pred> <body>)

(define (while? exp) (tagged-list? exp 'while))
(define (while-predicate exp) (cadr exp))
(define (while-body exp) (cddr exp))

(define (while->let exp)
  (let ((predicate (while-predicate exp))
	(body (while-body exp)))
    (list 'let 'while-loop '()
	  (make-if predicate
		   (append (cons 'begin body)
			   (list (cons 'while-loop '())))
		    'true))))

