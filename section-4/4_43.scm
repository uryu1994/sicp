(load "./amb")

;;
;;    Moore: Mary     Lorna
;;  Downing:          Melissa
;;     Hall:          Rosalind
;; Barnacle: Melissa  Gabrielle
;;   Packer:          Mary

(for-each simple-ambeval
	  '((define (filter pred lst)
	      (if (null? lst)
		  '()
		  (if (pred (car lst))
		      (cons (car lst) (filter pred (cdr lst)))
		      (filter pred (cdr lst)))))

	    (define (map proc items)
	      (if (null? items)
		  '()
		  (cons (proc (car items))
			(map proc (cdr items)))))
	    
	    (define (yacht-owner)
	      (let ((moore (cons 'mary 'lorna))
		    (downing (cons (amb 'lorna 'rosalind 'gabrielle) 'mellisa))
		    (hall (cons (amb 'lorna 'gabrielle) 'rosalind))
		    (barnacle (cons 'mellisa 'gabrielle))
		    (packer (cons (amb 'lorna 'rosalind 'gabrielle) 'mary)))
		(let ((father-list (list moore downing hall barnacle packer)))
		  (require (distinct? (map car father-list)))
		  (require (eq? (cdr (car (filter (lambda (n) (eq? (car n) 'gabrielle)) father-list)))
				(car packer)))
		  (list (list 'moore moore)
			(list 'downing downing)
			(list 'hall hall)
			(list 'barnacle barnacle)
			(list 'packer packer)))))	    
	    ))

(driver-loop)
(yacht-owner)

;;; Starting a new problem 
;;; Amb-Eval value:
((moore (mary . lorna)) (downing (lorna . mellisa)) (hall (gabrielle . rosalind)) (barnacle (mellisa . gabrielle)) (packer (rosalind . mary)))

;;; Amb-Eval input:
try-again

;;; There are no more values of
(yacht-owner)

;; -> lornaの父はdowning
