(use srfi-27)

(define (random-init 12345))
(define (rand-update x)
  (remainder (+ 31526 x) 41678))

(define rand
  (let ((x random-init))
    (define (reset new-value)
      (set! x new-value) x)
    (define (generate)
      (set! x (rand-update x)) x)
    (define (dispatch m)
      (cond ((eq? m 'reset) reset)
            ((eq? m 'generate) (generate))
            (else
             (error "Unknown request -- rand" m))))
    dispatch))

((rand 'reset) 10000)
(rand 'generate)
