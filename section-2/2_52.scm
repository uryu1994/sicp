(define wave2
  (segments->painter (list (make-segment (make-vect 0 0.6) (make-vect 0.2 0.4))
                           (make-segment (make-vect 0.2 0.4) (make-vect 0.3 0.55))
                           (make-segment (make-vect 0.3 0.55) (make-vect 0.35 0.45))
                           (make-segment (make-vect 0.35 0.45) (make-vect 0.25 0))
                           (make-segment (make-vect 0.4 0) (make-vect 0.5 0.3))
                           (make-segment (make-vect 0.5 0.3) (make-vect 0.6 0))
                           (make-segment (make-vect 0.75 0) (make-vect 0.6 0.45))
                           (make-segment (make-vect 0.6 0.45) (make-vect 0.99 0.15))
                           (make-segment (make-vect 0 0.8) (make-vect 0.2 0.55))
                           (make-segment (make-vect 0.2 0.55) (make-vect 0.3 0.6))
                           (make-segment (make-vect 0.3 0.6) (make-vect 0.4 0.6))
                           (make-segment (make-vect 0.4 0.6) (make-vect 0.35 0.8))
                           (make-segment (make-vect 0.35 0.8) (make-vect 0.4 0.99))
                           (make-segment (make-vect 0.6 0.99) (make-vect 0.65 0.8))
                           (make-segment (make-vect 0.65 0.8) (make-vect 0.6 0.6))
                           (make-segment (make-vect 0.6 0.6) (make-vect 0.8 0.6))
                           (make-segment (make-vect 0.8 0.6) (make-vect 0.99 0.35))
                           (make-segment (make-vect 0.45 0.65) (make-vect 0.5 0.7))
                           (make-segment (make-vect 0.5 0.7) (make-vect 0.55 0.65))
                           )))

(define (corner-split2 painter n)
  (if (= n 0)
      painter
      (let ((up (up-split2 painter (- n 1)))
            (right (right-split2 painter (- n 1))))
        (let ((top-left (up-split up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

(define (right-split2 painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split2 painter (- n 1))))
        (beside painter (below smaller smaller)))))

(define (up-split2 painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split2 painter (- n 1))))
        (below painter (beside smaller smaller)))))