(define x (list 'a 'b))
(define y (list 'c 'd))
(define z (append x y))

(print z)

(cdr x)
;; (b)

(define w (append! x y))
(print w)

(cdr x)
;; (b c d)
