(use slib)
(require trace)

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (trace iter)
  (iter items '()))

;;(square-list (list 1 2 3 4))
;;(iter (list 1 2 3 4) nil)
;;(iter (list 2 3 4) (cons 1 nil))
;;(iter (list 3 4) (cons 4 (cons 1 nil)))
;;(iter (list 4) (cons 9 (cons 4 (cons 1 nil))))
;;(iter '() (cons 16 (cons 9 (cons 4 (cons 1 nil)))))
;;(cons 16 (cons 9 (cons 4 (cons 1 nil)))) = (16 9 4 1)

(define (square-list-2 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons answer
                    (square (car things))))))
  (iter items nil))

;; (square-list-2 (list 1 2 3 4))
;; (iter (list 2 3 4) (cons nil 1))
;; (iter (list 3 4) (cons (cons nil 1) 4))
;; (iter (list 4) (cons (cons (cons nil 1) 4) 9))
;; (iter () (cons (cons (cons (cons nil 1) 4) 9) 16))
;; (cons (cons (cons (cons nil 1) 4) 9) 16)
;;
;; これは以下の構造になるため，リストにならない
;; * -> 16
;; |
;; * -> 9
;; |
;; * -> 4
;; |
;; * -> 1
;; |
;; nil
