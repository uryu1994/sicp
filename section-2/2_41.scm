(load "./2_40")

(define (unique-triples n)
  (flatmap (lambda (i)
             (map (lambda (j) (append i (list j)))
                  (enumerate-interval 1 (- (cadr i) 1))))
           (unique-pairs n)))

(unique-triples 6)
