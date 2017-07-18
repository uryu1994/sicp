(define f
  (let ((x 1))
    (lambda (n)
      (set! x (* x n)) x)))
        
(+ (f 0) (f 1))
(f 1)
(f 0)
