(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;; 2.29a
(define (left-branch m)
  (car m))

(define (right-branch m)
  (car (cdr m)))

(define (branch-length b)
  (car b))

(define (branch-structure b)
  (car (cdr b)))

;; 2.29b
(define (branch-weight b)
  (let ((structure (branch-structure b)))
    (if (number? structure)
	structure
	(total-weight structure))))

(define (total-weight m)
  (let ((left (left-branch m))
	(right (right-branch m)))
    (+ (branch-weight left)
       (branch-weight right))))

(define 

(define m2 (make-mobile (make-branch 6 2)
			(make-branch 1 (make-mobile (make-branch 2 4)
					(make-branch 1 8)))))
