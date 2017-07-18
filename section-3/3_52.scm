(use slib)
(require 'trace)

(load "./stream")

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(trace accum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
;; CALL accum 1
;; RETN accum 1

(define y (stream-filter even? seq))
;; CALL accum 2 RETN accum 3
;; CALL accum 3 RETN accum 6

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
;; CALL accum 4 RETN accum 10

(stream-ref y 7)
;; CALL accum 5  RETN accum 15
;; CALL accum 6  RETN accum 21
;; CALL accum 7  RETN accum 28
;; CALL accum 8  RETN accum 36
;; CALL accum 9  RETN accum 45
;; CALL accum 10 RETN accum 55
;; CALL accum 11 RETN accum 66
;; CALL accum 12 RETN accum 78
;; CALL accum 13 RETN accum 91
;; CALL accum 14 RETN accum 105
;; CALL accum 15 RETN accum 120
;; CALL accum 16 RETN accum 136

;; 136

(display-stream z)
;; 10
;; 15
;; 45
;; 55
;; 105
;; 120
;; CALL accum 17 RETN accum 153
;; CALL accum 18 RETN accum 171
;; CALL accum 19 RETN accum 190

;; 190
;; CALL accum 20 RETN accum 210

;; 210done

(display sum)
;; sum: 210
