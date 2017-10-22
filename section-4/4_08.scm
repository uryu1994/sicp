;; (define (fib n)
;;   (let fib-iter ((a 1)
;;                  (b 0)
;;                  (count n))
;;     (if (= count 0)
;;         b
;;         (fib-iter (+ a b) a (- count 1)))))
;; ====
;; (define (fib n)
;;   (define (fib-iter a b count)
;;     (if (= count 0)
;; 	b
;; 	(fib-iter (+ a b) a (- count 1))))
;;   (fib-iter 1 0 n))


(define (let? exp) (tagged-list? exp 'let))
(define (let-clauses exp) (cadr exp))
(define (let-clause-var clause) (car clause))
(define (let-clause-value-exp clause) (cadr clause))
(define (let-body exp) (cddr exp))

(define (named-let? exp) (symbol? (cadr exp)))
(define (named-let-var exp) (cadr exp))
(define (named-let-clauses clauses) (caddr clauses))
(define (named-let-body exp) (cadddr exp))

(define (let->combination exp)
  (if (named-let? exp)
      (named-let->combination exp)
      (normal-let->combination exp)))

(define (named-let->combination exp)
  (define vars (map let-clause-var (named-let-clauses exp)))
  (define value-exps (map let-clause-value-exp (named-let-clauses exp)))
  (make-begin
   (list
    (list 'define (cons (named-let-var exp) vars)
	  (named-let-body exp))
    (cons (named-let-var exp) value-exps))))

(define (normal-let->combination exp)
  (define vars (map let-clause-var (let-clauses exp)))
  (define value-exps (map let-clause-value-exp (let-clauses exp)))
  (cons
   (make-lambda vars (let-body exp))
   value-exps))
