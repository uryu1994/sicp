(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (* (expmod base (/ exp 2) m)
                       (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

;; (expmod base 12 m)
;; 12 -- 6 -- 3 -- 2 -- 1 -- 0
;;
;; 12 -- 6 -- 3 --
;;       |
;;       ---- 
