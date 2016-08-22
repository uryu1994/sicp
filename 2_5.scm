(define (m_cons a b)
  (* (expt 2 a) (expt 3 b)))

(define (expt_index x divisor)
  (define (iter a n)
    (if (= 1 (gcd a divisor))
        n
        (iter (/ a divisor) (+ n 1))))
  (iter x 0))

(define (m_car z)
  (expt_index z 2))

(define (m_cdr z)
  (expt_index z 3))

