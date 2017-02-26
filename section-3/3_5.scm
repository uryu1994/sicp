(use srfi-27)

(define random random-integer)

(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro-test))))


(define (random-gcd-test trials initial-x)
  (define (iter trials-remaining trials-passed x)
    (let ((x1 (rand-update x)))
      (let ((x2 (rand-update x1)))
        (cond ((= trials-remaining 0)   
               (/ trials-passed trials))
              ((= (gcd x1 x2) 1)
               (iter (- trials-remaining 1)
                     (+ trials-passed 1)
                     x2))
              (else
               (iter (- trials-remaining 1)
                     trials-passed
                     x2))))))
  (iter trials 0 initial-x))

(define (cesaro-test)
  (= (gcd (rand) (rand)) 1))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (estimate-integral P x1 x2 y1 y2 trails)
  (define (experiment)
    (P (random-in-range x1 x2)
       (random-in-range y1 y2)))
  (* (monte-carlo trails experiment) (* (- x2 x1) (- y2 y1))))

(define (pi-from-monte-carlo-simulation circle-area radius)
  (display circle-area)
  (newline)
  (/ circle-area radius))

(define (p-test x y)
  (<= (+ (square (- x 5)) (square (- y 7))) (square 3)))

(pi-from-monte-carlo-simulation (estimate-integral p-test 2 8 4 10 100000.0) (square 3))
(pi-from-monte-carlo-simulation (estimate-integral p-test 2 8 4 10 100000.0) (square 3))
