(load "./2_33")

(define (count-leaves t)
  (accumulate + 0 (map (lambda (x) (cond ((null? x) 0)
                                         ((not (pair? x)) 1)
                                         (else (count-leaves x)))) t)))


(count-leaves (list 1 (list 2 (list 3 4))))
