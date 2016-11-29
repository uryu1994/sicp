(load "./2_67")

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (define (iter tree bits)
    (cond ((leaf? tree)
           (reverse bits))
          ((memq symbol (symbols (left-branch tree)))
           (iter (left-branch tree) (cons 0 bits)))
          ((memq symbol (symbols (right-branch tree)))
           (iter (right-branch tree) (cons 1 bits)))
          (else
           (error "ENCODE Symbol Not Found"))))
  (iter tree '()))

(encode '(A D A B B C A) sample-tree)
