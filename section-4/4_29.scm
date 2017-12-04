(load "./normal-order-evaluation")

;; no-memorize
(define (force-it obj)
  (if (thunk? obj)
      (actual-value (thunk-exp obj) (thunk-env obj))
      obj))

;; measurement time
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output
	   (time (actual-value input the-global-environment))))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(driver-loop)

(define (fib n)
  (define (fib-iter a b count)
    (if (= count 0)
	b
	(fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))

(fib 30)

;; -- memorize --
;;; L-Eval input:
;(time (actual-value input the-global-environment))
; real   0.001
; user   0.000
; sys    0.000

;; -- no memorize --
;;; L-Eval input:
;(time (actual-value input the-global-environment))
; real   5.404
; user   5.510
; sys    0.020

(define count 0)

(define (id x)
  (set! count (+ count 1))
  x)

(define (square x)
  (* x x))


;; -- memorize --
;;; L-Eval input:
(square (id 10))

;;; L-Eval value:
100

;;; L-Eval input:
count

;;; L-Eval value:
1


;; -- no memorize --
;;; L-Eval input:
(square (id 10))

;;; L-Eval value:
100

;;; L-Eval input:
count

;;; L-Eval value:
2
