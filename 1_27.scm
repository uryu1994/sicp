(load "./fermat")

(define (carmichael n)
  (carmichael-iter 1 n))

(define (carmichael-iter a n)
  (cond ((= a n) #t)
        ((= (expmod a n n) a)
         (carmichael-iter (+ a 1) n))
        (else #f)))
(print (carmichael 561))
(print (carmichael 1105))
(print (carmichael 1729))
(print (carmichael 2465))
(print (carmichael 2821))
(print (carmichael 6601))
