(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define (last-pair list1)
  (list (list-ref list1 (- (length list1) 1))))

(define (last-pair list1)
  (if (null? (cdr list1))
      list1
      (last-pair (cdr list1))))

;;(print (last-pair (list 23 72 149 34)))
