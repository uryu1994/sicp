(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define x (list 'a 'b 'c))

(define y (list (list 'a 'b) 'c))

(define z (list 'a 'b 'c))
(set-car! (cdr z) (cdr (cdr z)))
(set-car! z (cdr z))

(define w (make-cycle (list 'a 'b 'c)))

(count-pairs x);; 3

(count-pairs y);; 4
(count-pairs z);; 7

(count-pairs w);; no return(!!WARNING!!)
