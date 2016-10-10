(define (make-rat n d)
  (let* ((g (gcd n d))
        (n1 (/ n g))
        (d1 (/ d g)))
  (if (< d1 0)
      (cons (* -1 n1) (* -1 d1))
      (cons n1 d1))))

(define (make-rat2 n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))

