(load "./eceval")

(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))

;; a
;; maximum-depth: 10

;; b
;; n = 1 -> p =  69
;; n = 2 -> p = 104
;; n = 3 -> p = 139
;; n = 4 -> p = 174
;; n = 5 -> p = 209

;; p = (35 * n) + 34

;;; EC-Eval input:
(factorial 3)

(total-pushes = 139 maximum-depth = 10)
;;; EC-Eval value:
6

;;; EC-Eval input:
(factorial 4)

(total-pushes = 174 maximum-depth = 10)
;;; EC-Eval value:
24

;;; EC-Eval input:
(factorial 5)

(total-pushes = 209 maximum-depth = 10)
;;; EC-Eval value:
120

;;; EC-Eval input:
(factorial 6)

(total-pushes = 244 maximum-depth = 10)
;;; EC-Eval value:
720

;;; EC-Eval input:
(factorial 7)

(total-pushes = 279 maximum-depth = 10)
;;; EC-Eval value:
5040

;;; EC-Eval input:
(factorial 8)

(total-pushes = 314 maximum-depth = 10)
;;; EC-Eval value:
40320

;;; EC-Eval input:

