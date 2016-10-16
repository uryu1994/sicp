(load "./2_36")

(define m (list (list 2 -1) (list 3 4)))
(define n (list (list 1 2) (list 3 4)))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product v x)) m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(transpose m)

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))

(matrix-*-vector '((2 -1) (-3 4)) '(1 2))
(matrix-*-matrix m n)
