(load "./2_63")
(load "./2_64")

(define tree->list tree->list-2)

(define (intersection-order set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-order (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-order (cdr set1) set2))
              ((< x2 x1)
               (intersection-order set1 (cdr set2)))))))

(define (union-order set1 set2)
  (cond ((and (null? set1) (null? set2)) '())
        ((null? set1) set2)
        ((null? set2) set1)
        (else
         (let ((x (car set1))
               (y (car set2)))
           (cond
            ((= x y) (cons x (cons y (union-order (cdr set1) (cdr set2)))))
            ((< x y) (cons x (union-order (cdr set1) set2)))
            (else
             (cons y (union-order set1 (cdr set2)))))))))

(define (union-set set1 set2)
  (let ((s1 (tree->list set1))
        (s2 (tree->list set2)))
    (list->tree (union-order s1 s2))))

(define (intersection-set set1 set2)
  (let ((s1 (tree->list set1))
        (s2 (tree->list set2)))
    (list->tree (intersection-order s1 s2))))

(union-set (list->tree '(1 3 5)) (list->tree '(2 4 6)))
(intersection-set (list->tree '(1 3 4 5 6)) (list->tree '(2 3 5 6)))
