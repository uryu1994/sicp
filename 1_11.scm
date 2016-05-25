(define (f n)
  (cond ((< n 3) n)
        (else (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3)))))))
;;(f 5)
;;(+ (f 4) (* 2 (f 3)) (* 3 (f 2)))
;;(+ (+ (f 3) (* 2 (f 2)) (* 3 (f 1))) (* 2 (f 3)) (* 3 (f 2)))
;;(+ (+ 3 4 3) 6 6)
;;(+ 10 6 6)
;;22

(define (f2 n)
  (f2-iter 2 1 0 n))

(define (f2-iter a b c count)
  (cond ((= count 2) a)
        ((= count 1) b)
        ((= count 0) c)
        (else (f2-iter (+ a (* 2 b) (* 3 c))
                       a
                       b
                       (- count 1)))))

;;(f2-iter 2 1 0 3)
;;(f2-iter 4 2 1 2)
;; 4

;;(f2-iter 2 1 0 5)
;;(f2-iter 4 2 1 4)
;;(f2-iter 11 4 2 3)
;;(f2-iter 25 11 4 2)
;; 25
