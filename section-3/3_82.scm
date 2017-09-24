(use srfi-27)
(load "./stream")

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ passed (+ passed failed))
     (monte-carlo
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (* range (random-real)))))

(define (estimate-integral P x1 x2 y1 y2)
  (stream-map (lambda (m) (* m (- x2 x1) (- y2 y1))) 
	      (monte-carlo (stream-map P
				       (stream-map (lambda (x) (random-in-range x1 x2)) ones)
				       (stream-map (lambda (x) (random-in-range y1 y2)) ones))
			   0.0 0.0)))

(define (pi-from-monte-carlo-simulation circle-area radius)
  (display circle-area)
  (newline)
  (/ circle-area radius))

(define (p-test x y)
  (<= (+ (square (- x 5)) (square (- y 7))) (square 3)))

(pi-from-monte-carlo-simulation (stream-ref (estimate-integral p-test 0 10 0 10) 100000) (square 5))
