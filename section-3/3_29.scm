
;; a ---|>o--{c1}--\
;;                  ===|)--{s}--|>o--{output}
;; b ---|>o--{c2}--/

(define (or-gate a b output)
  (let ((c1 (make-wire))
        (c2 (make-wire))
        (s (make-wire)))
    (inverter a c1)
    (inverter b c2)
    (and-gate c1 c2 s)
    (inverter s output)
    'ok))
