(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

;; (expand 1 7 10)
;; (cons-stream
;;  (quotient (* 1 10) 7)
;;  (expand (remainder (* 1 10) 7) 7 10))

;; (expand 3 7 10)
;; (cons-stream
;;  (quotient (* 3 10) 7)
;;  (expand (remainder (* 3 10) 7) 7 10))

;; (expand 2 7 10)
;; (cons-stream
;;  (quotient (* 2 10) 7)
;;  (expand (remainder (* 2 10) 7) 7 10))

;; (expand 6 7 10)
;; (cons-stream
;;  (quotient (* 6 10) 7)
;;  (expand (remainder (* 6 10) 7) 7 10))

;; (expand 4 7 10)
;; (cons-stream
;;  (quotient (* 4 10) 7)
;;  (expand (remainder (* 4 10) 7) 7 10))

;; (expand 5 7 10)
;; (cons-stream
;;  (quotient (* 5 10) 7)
;;  (expand (remainder (* 5 10) 7) 7 10))

;; (expand 1 7 10)
;; ...

;; (1, 4, 2, 8, 5, 7, 1, ...)
;; 1 / 7 = 0.142851...

;; (expand 3 8 10)
;; (cons-stream
;;  (quotient (* 3 10) 8)
;;  (expand (remainder (* 3 10) 8) 8 10))

;; (expand 6 8 10)
;; (cons-stream
;;  (quotient (* 6 10) 8)
;;  (expand (remainder (* 6 10) 8) 8 10))

;; (expand 4 8 10)
;; (cons-stream
;;  (quotient (* 4 10) 8)
;;  (expand (remainder (* 4 10) 8) 8 10))

;; (expand 0 8 10)
;; (cons-stream
;;  (quotient (* 0 10) 8)
;;  (expand (remainder (* 0 10) 8) 8 10))
;;
;; (expand 0 8 10)
;; ...
;;
;; (3, 7, 5, 0, ...)
;; 3 / 8 = 0.375
