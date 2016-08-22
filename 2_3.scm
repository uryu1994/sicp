(load "./2_2")

;; p1 -------- 
;;   |        |
;;   |        |
;;    -------- p2

;; 高さと幅で表現
(define (make-rectangle w h)
  (cons w h))

(define (width r) (car r))
(define (height r) (cdr r))

(define (perimeter r)
  (let ((w (width r))
        (h (height r)))
    (* (+ w h) 2)))

(define (area r)
  (let ((w (width r))
        (h (height r)))
    (* w h)))
