(define (make-frame1 origin edge1 edge2)
  (list origin edge1 edge2))

(define origin-frame1 car)
(define edge1-frame1 cadr)
(define edge2-frame1 caddr)

(define (make-frame2 origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define origin-edge2 car)
(define edge1-frame2 cadr)
(define edge2-frame2 cddr)
