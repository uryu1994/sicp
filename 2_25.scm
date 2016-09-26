(define list1 (list 1 3 (list 5 7) 9))
(define list2 (list (list 7))) 
(define list3 (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

(define (pop1 list)
  (car (cdr (car (cdr (cdr list))))))

(print (pop1 list1))

(define (pop2 list)
  (car (car list)))

(print (pop2 list2))

(define (pop3 list)
  (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr list)))))))))))))

(print (pop3 list3))
