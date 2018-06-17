(load "./5_39")

(define (find-variable var ct-env)
  (define (frame-iter frames frame-num)
    (if (null? frames)
        'not-found
        (let ((addr (scan-iter (car frames) frame-num 0)))
          (if (null? addr)
              (frame-iter (cdr frames) (+ frame-num 1))
              addr))))
  (define (scan-iter frame frame-num disp-num)
    (if (null? frame)
        '()
        (if (eq? var (car frame))
            (make-address frame-num disp-num)
            (scan-iter (cdr frame) frame-num (+ disp-num 1)))))
  (frame-iter ct-env 0))

;; (find-variable 'c '((y z) (a b c d e) (x y)))

;; (find-variable 'x '((y z) (a b c d e) (x y)))

;; (find-variable 'w '((y z) (a b c d e) (x y)))
