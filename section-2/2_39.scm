(load "./2_38")
(load "./2_33")

(define (reverse-right sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(define (reverse-left sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))

(reverse-left (list 1 2 3))
(reverse-right (list 1 2 3))
