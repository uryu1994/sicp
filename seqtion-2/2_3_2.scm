(load "./2_2.scm")

;; p1 -------- 
;;   |        |
;;   |        |
;;    -------- p2

(define (perimeter r)
  (let ((w (width r))
        (h (height r)))
    (* (+ w h) 2)))

(define (area r)
  (let ((w (width r))
        (h (height r)))
    (* w h)))

(define (make-rectangle p1 p2)
  (cons p1 p2))

(define (width r)
  (let ((x1 (x-point (car r)))
        (x2 (x-point (cdr r))))
    (if (> x1 x2)
        (- x1 x2)
        (- x2 x1))))

(define (height r)
  (let ((y1 (y-point (car r)))
        (y2 (y-point (cdr r))))
    (if (> y1 y2)
        (- y1 y2)
        (- y2 y1))))
