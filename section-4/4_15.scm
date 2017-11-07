(define (run-forever) (run-forever))

(define (try p)
  (if (halts? p p)
      (run-forever)
      'halted))

(try try)

;; (halts? try try): true (stop)     => no-stop
;; (halts? try try): false (no-stop) => stop
