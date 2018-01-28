(load "./amb")

(for-each simple-ambeval
	  '((define (prime-sum-pair list1 list2)
	      (let ((a (an-element-of list1))
		    (b (an-element-of list2)))
		;; (print "(" a " " b ")")
		(require (prime? (+ a b)))
		(list a b)))

	    (define (square n)
	      (* n n))

	    (define (smallest-divisor n)
	      (find-divisor n 2))

	    (define (find-divisor n test-divisor)
	      (cond ((> (square test-divisor) n) n)
		    ((divides? test-divisor n) test-divisor)
		    (else (find-divisor n (+ test-divisor 1)))))

	    (define (divides? a b)
	      (= (remainder b a) 0))

	    (define (prime? n)
	      (= n (smallest-divisor n)))))

(driver-loop)

(let ((pairs '()))
  (if-fail (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110))))
             (permanent-set! pairs (cons p pairs))
             (amb))
           pairs))

;;; Starting a new problem (1 20)
(1 35)
(1 110)
(3 20)
(3 35)
(3 110)
(5 20)
(5 35)
(5 110)
(8 20)
(8 35)
(8 110)

;;; Amb-Eval value:
((8 35) (3 110) (3 20))

