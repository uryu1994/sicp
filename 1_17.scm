;;(* 2 5)
;;(+ 2 (* 2 4))
;;(+ 2 (+ 2 (* 2 3)))
;;(+ 2 (+ 2 (+ 2 (* 2 2))))
;;(+ 2 (+ 2 (+ 2 (+ 2 (* 2 1)))))

(define (even? n)
  (= (remainder n 2) 0))

(define (double n)
  (+ n n))
(define (halve n)
  (/ n 2))

(define (mul a b)
  (cond ((= b 0) 0)
        ((even? b) (double (mul a (halve b))))
        (else (+ a (mul a (- b 1))))))

;; 2 * 4 = 2 + 2 + 2 + 2 = (2 * 2) * 1
;; 3 * 5 = 3 + 3 + 3 + 3 + 3 = 3 + (3 * 2) * 1

;;(mul 2 5)
;;(+ 2 (mul 2 4))
;;(+ 2 (double (mul 2 2)))
;;(+ 2 (double (double (mul 2 1))))
;;(+ 2 (double (double (+ 2 (mul 2 0)))))
;;(+ 2 (double (double (+ 2 0))))

;;(* 2 5)
;;(+ 2 (* 2 4))
;;(+ 2 (+ 2 (* 2 3)))
;;(+ 2 (+ 2 (+ 2 (* 2 2))))
;;(+ 2 (+ 2 (+ 2 (+ 2 (* 2 1)))))
;;(+ 2 (+ 2 (+ 2 (+ 2 (+ 2 (* 2 0))))))
;;(+ 2 (+ 2 (+ 2 (+ 2 (+ 2 0)))))
;;(+ 2 (+ 2 (+ 2 (+ 2 2))))
;; -> 10
