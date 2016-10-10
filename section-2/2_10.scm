(load "./2_7")

(define (div-interval-error x y)
  (if (< (* (lower-bound y) (upper-bound y)) 0)
      (print "error")
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))
