(load "./2_7")

;; (lx ux) (ly uy)
;; (+   +) (+   +) -> (lx*ly ux*uy)
;; (+   +) (-   +) -> (ux*ly ux*uy)
;; (+   +) (-   -) -> (ux*ly lx*uy)
;; (-   +) (+   +) -> (lx*uy ux*uy)
;; (-   +) (-   +) 
;; (-   +) (-   -) -> (ux*ly lx*ly)
;; (-   -) (+   +) -> (lx*uy ux*ly)
;; (-   -) (-   +) -> (lx*uy lx*ly)
;; (-   -) (-   -) -> (ux*uy lx*ly)

(define (mul-interval2 x y)
  (define (mul1 l1 l2 u1 u2)
    (let ((l (* l1 l2))
          (u (* u1 u2)))
      (make-interval l u)))
  (define (mul2 x y)
    (let ((p1 (* (lower-bound x) (lower-bound y)))
          (p2 (* (lower-bound x) (upper-bound y)))
          (p3 (* (upper-bound x) (lower-bound y)))
          (p4 (* (upper-bound x) (upper-bound y))))
      (make-interval (min p1 p2 p3 p4)
                     (max p1 p2 p3 p4))))
  (let ((lx (lower-bound x))
        (ux (upper-bound x))
        (ly (lower-bound y))
        (uy (upper-bound y)))
    (cond ((and (<= 0 lx) (<= 0 ux) (<= 0 ly) (<= 0 uy))
           (mul1 lx ly ux uy))
          ((and (<= 0 lx) (<= 0 ux) (>  0 ly) (<= 0 uy))
           (mul1 ux ly ux uy))
          ((and (<= 0 lx) (<= 0 ux) (>  0 ly) (>  0 uy))
           (mul1 ux ly lx uy))
          ((and (>  0 lx) (<= 0 ux) (<= 0 ly) (<= 0 uy))
           (mul1 lx uy ux uy))
          ((and (>  0 lx) (<= 0 ux) (>  0 ly) (>  0 uy))
           (mul1 ux ly lx ly))
          ((and (>  0 lx) (>  0 ux) (<= 0 ly) (<= 0 uy))
           (mul1 lx uy ux ly))
          ((and (>  0 lx) (>  0 ux) (>  0 ly) (<= 0 uy))
           (mul1 lx uy lx ly))
          ((and (>  0 lx) (>  0 ux) (>  0 ly) (>  0 uy))
           (mul1 ux uy lx ly))
          (else (mul2 x y)))))
