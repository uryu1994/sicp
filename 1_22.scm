(load "./1_21.scm")

(define (prime? n)
  (= n (smallest-divisor n)))

(define (runtime)
  (round->exact (* (expt 10 6)
                   (time->seconds (current-time)))))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes n count)
  (search-iter (if (even? n)
                   (+ 1 n)
                   n
                   )
               count))

(define (search-iter x count)
  (cond ((= count 0) #t)
        ((timed-prime-test x) (search-iter (+ x 2) (- count 1)))
        (else (search-iter (+ x 2) count))))
                   
;;1000 ->       1009    1013    1019
;;10000 ->     10007   10009   10037
;;100000 ->   100003  100019  100043
;;1000000 -> 1000003 1000033 1000037
