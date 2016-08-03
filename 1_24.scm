(load "./fermat.scm")

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
  (if (fast-prime? n 10)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes min max)
  (if (even? min)
      (search-iter (+ min 1) max)
      (search-iter min max)))

(define (search-iter x last)
  (if (<= x last)
      (timed-prime-test x))
  (if (<= x last)
      (search-iter (+ x 2) last)))

(print (search-for-primes 1000 1020))
(print (search-for-primes 1000000 1000038))
