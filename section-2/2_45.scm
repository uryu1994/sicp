(define (split first-div second-div)
  (define (spliter painter n)
    (if (= n 0)
        painter
        (let ((smaller (spliter painter (- n 1))))
          (first-div painter (second-div smaller smaller)))))
  spliter)

