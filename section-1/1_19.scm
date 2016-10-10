(define (fib n)
  (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   (+ (* p p) (* q q))   ; p'を計算
                   (+ (* 2 p q) (* q q)) ; q'を計算
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

;; a' <- bq + a(q + p)
;; b' <- bp + aq

;; a'' <- b'q + a'(q + p)
;; b'' <- b'p + a'q

;; a'' <- (bp + aq)q + (bq + a(q + p))(q + p)
;; b'' <- (bp + aq)p + (bq + a(q + p)q = bpp + apq + bqq + aqq + apq

;; b'' <- a(qq + 2pq) + b(qq + pp)
;; a'' <- 

;;(fib 5)
;;(fib-iter 1 0 0 1 5)
;;(fib-iter 1 1 0 1 4)
;;(fib-iter 1 1     2)
;;(fib-iter 1 1     1)
;;(fib-iter   5     0)

;;(fib 2)
;;(fib-iter 1 0 0 1 2)
;;(fib-iter 1 0     1)
;;(fib-iter   1     0)

;; 0 1 1 2 3 5
