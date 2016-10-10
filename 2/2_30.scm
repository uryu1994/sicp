(define nil '())

(define (square-tree tree)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (square-tree sub-tree)
	     (square sub-tree)))
       tree))

(define (square-tree-2 tree)
  (cond ((null? tree) nil)
	((not (pair? tree)) (square tree))
	(else (cons (square-tree-2 (car tree))
		    (square-tree-2 (cdr tree))))))

(square-tree-2
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))