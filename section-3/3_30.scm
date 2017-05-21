(define (ripple-carry-adder ak bk sk c)
  (if (not (null? ak))
      (let ((c-out (make-wire)))
        (full-adder (car ak) (car bk) c (car sk) c-out)
        (ripple-carry-adder (cdr ak) (cdr bk) (cdr-sk) c-out))
      'ok))

;; Da = and-gate-delay
;; Do = or-gate-delay
;; Di = inverter-delay
;; Dh = half-adder-delay
;; Df = full-adder-delay
;; Dr = ripple-carry-adder-delay
;;
;; Dr = Df * n
;; Df = 2Dh + Do
;; Dh = (Da + Do)||(2Da + Di)
;; Do = Di + Da + Di = 2Di + Da とすると(3.29)
;; Da + Do = 2Di + 2Da > 2Da + Di より
;; Dh = 2Da + 2Diとなる
;; Df = 2 * (2Da + 2Di) + 2Di + Da
;;    = 5Da + 6Di
;; Dr = (5Da + 6Di) * n
