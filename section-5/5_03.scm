(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

;; good-enough?とimprove演算は基本演算として使えると仮定
(controller
 sqrt-loop
 (assign x (op read))
 (assign guess (const 1.0))
 test-good-enough
 (test (op good-enough?) (reg guess) (reg x))
 (branch (label sqrt-loop-done))
 (assign guess (op improve) (reg guess) (reg x))
 (goto (label test-good-enough))
 sqrt-loop-done
 (perform (op print) (reg guess))
 (goto (label sqrt-loop)))

;; これらを算術演算を使って展開
