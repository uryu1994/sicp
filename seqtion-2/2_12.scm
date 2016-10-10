(load "./2_7")


(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))


(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))


(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (percent x)
  (* (/ (width x) (center x)) 100.0))

(define (make-center-percent c p)
  (let ((w (/ (* (abs c) p) 100.0)))
    (make-interval (- c w) (+ c w))))
