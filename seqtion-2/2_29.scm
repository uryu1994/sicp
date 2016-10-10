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

(define mobile-balanced
  (make-mobile (make-branch 2 3)
               (make-branch 1
                            (make-mobile (make-branch 1 3)
                                         (make-branch 1 3)))))

;; 2.29b
(define (branch-weight b)
  (let ((structure (branch-structure b)))
    (if (weight? structure)
	structure
	(total-weight structure))))

(define weight? number?)

(define (total-weight m)
  (let ((left (left-branch m))
        (right (right-branch m)))
    (+ (branch-weight left)
       (branch-weight right))))

;; 2.29c
(define (balanced? m)
  (let ((l (left-branch m))
        (r (right-branch m)))
    (and (= (moment l) (moment r))
         (bweight? l)
         (bweight? r))))

(define (bweight? b)
  (if (weight? (branch-structure b))
      #t
      (balanced? (branch-structure b))))
        
(define (moment b)
  (* (branch-weight b) (branch-length b)))
     

(balanced? mobile-balanced)

(define m2 (make-mobile (make-branch 6 2)
			(make-branch 1 (make-mobile (make-branch 2 4)
                                        (make-branch 1 8)))))

(balanced? m2)
