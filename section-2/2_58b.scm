(load "./2_58a")

;;(x + 3 * (x + y + 2))
;;addend -> x, augend -> 3 * (x + y + z)

;;3 * (x + y + z)
;;multiplier -> 3 multiplicand -> (x + y + z)

;;x + y + z
;;addend -> x augend -> y + z

;;y + z
;;addend -> y augend -> z

(define (sum? x)
  (if (eq? #f (memq '+ x))
      #f
      #t))

(define (addend x)
  (define (iter head tail)
    (cond ((null? tail) (reverse head))
          ((eq? '+ (car tail)) (reverse head))
          (else (iter (cons (car tail) head)
                      (cdr tail)))))
  (let ((ans (iter '() x)))
    (if (eq? 1 (length ans))
        (car ans)
        ans)))

(define (augend x)
  (let ((ans (cdr (memq '+ x))))
    (if (eq? 1 (length ans))
        (car ans)
        ans)))

(define (product? x)
  (cond ((pair? (memq '+ x)) #f)
        ((pair? (memq '* x)) #t)
        (else #f)))

(define (multiplier p)
  (car p))

(define (multiplicand p)
  (let ((ans (cdr (memq '* p))))
    (if (eq? 1 (length ans))
        (car ans)
        ans)))

(deriv '(x + 3 * (x + y + 2)) 'x)
(deriv '(x + (3 * ((x * x) + (x * (y + 2))))) 'x)
