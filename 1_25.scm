(use srfi-27)

(define (expmod base exp m)
  (remainder (fast-expt base exp) m))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random-integer (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else #f)))

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
(print (search-for-primes 10000 10038))
