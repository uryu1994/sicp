(load "./eceval-not-recusive")

;; 5.26
(define (factorial-a n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))

;; n = 1 -> p = 77  m = 20
;; n = 2 -> p = 114 m = 23
;; n = 3 -> p = 151 m = 26
;; n = 4 -> p = 188 m = 29


;; 5.27
(define (factorial-b n)
  (if (= n 1)
      1
      (* (factorial-b (- n 1)) n)))

;; n = 1 -> p = 18  m = 11
;; n = 2 -> p = 52  m = 19
;; n = 3 -> p = 86  m = 27
;; n = 4 -> p = 120 m = 35
