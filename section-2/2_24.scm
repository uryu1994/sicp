(define nil '())

;;(list 1 (list 2 (list 3 4)))
;;(list 1 (list 2 (cons 3 (cons 4 nil))))
;;(list 1 (cons 2 (cons (cons 3 (cons 4 nil)) nil)))
;;(cons 1 (cons (cons 2 (cons (cons 3 (cons 4 nil)) nil)) nil))
(cons 1 (cons (list 2 (list 3 4)) nil))
(cons 1 (cons (cons 2 (cons (list 3 4) nil)) nil))
(cons 1 (cons (cons 2 (cons (cons 3 (cons 4 nil)) nil)) nil))
;;
;;
;; * -> * 
;; |    |    
;; 1    * -> *
;;      |    |
;;      2    * -> *
;;           |    |
;;           3    4

(print (list 1 (list 2 (list 3 4))))