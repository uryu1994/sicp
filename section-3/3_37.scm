(load "./connector")

(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))

;; x - y = z -> z + y = x
(define (c- x y)
  (let ((z (make-connector)))
    (adder z y x)
    z))

(define (c* x y)
  (let ((z (make-connector)))
    (multiplier x y z)
    z))

;; x / y = z -> z * y = x
(define (c/ x y)
  (let ((z (make-connector)))
    (multiplier z y x)
    z))

(define (cv x)
  (let ((z (make-connector)))
    (constant x z)
    z))

(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
          x)
      (cv 32)))

(define C (make-connector))
(define F (celsius-fahrenheit-converter C))

(probe "Celsius temp" C)
(probe "Fahrenheit temp" F)
(set-value! C 25 'user)
(set-value! F 212 'user)
(forget-value! C 'user)
(set-value! F 212 'user)
