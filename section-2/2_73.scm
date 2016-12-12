(load "./table")

(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))

;; 2.73a) ((get 'deriv (operator exp)) (operands exp) var) -> わざわざsum?とかproduct?とかをderiv内で呼び出す必要がなくなり，derivを変更する必要がなくなった
;; 一方，number?やvariable?は型タグを持てない(expが数値なのか文字か不明)ため，定義できない

;; 2.73b)
(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-op op exp1 exp2)
  ((get 'make-op op) exp1 exp2))

(define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (install-sum-deriv-package)
  (define (addend s) (car s))
  (define (augend s)
    (if (null? (cddr s))
        (cadr s)
        (cons '+ (cdr s))))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2)) (+ a1 a2))
          (else (list '+ a1 a2))))
  (define (deriv-sum exp var)
    (make-sum (deriv (addend exp) var)
              (deriv (augend exp) var)))
  (put 'make-op '+ make-sum)
  (put 'deriv '+ deriv-sum)
  'done)

(define (install-product-deriv-package)
  (define (multiplier p) (car p))
  (define (multiplicand p)
    (if (null? (cddr p))
        (cadr p)
        (cons '* (cdr p))))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))
  (define (deriv-product exp var)
    (make-op '+
             (make-product (multiplier exp)
                           (deriv (multiplicand exp) var))
             (make-product (deriv (multiplier exp) var)
                           (multiplicand exp))))
  (put 'make-op '* make-product)
  (put 'deriv '* deriv-product)
  'done)

;; 2.73c

(define (install-exponent-deriv-package)
  (define (base exp) (car exp))
  (define (exponent exp) (cadr exp))
  (define (make-exponentation b e)
    (cond ((=number? e 0) 1)
          ((=number? e 1) b)
          (else (list '** b e))))
  (define (deriv-exp exp var)
    (make-op '*
             (exponent exp)
             (make-exponentation (base exp)
                                 (- (exponent exp) 1))))
  (put 'make-op '** make-exponentation)
  (put 'deriv '** deriv-exp)
  'done)
             

(install-sum-deriv-package)
(install-product-deriv-package)
(install-exponent-deriv-package)

;; 2.73d
;; (put <op> <type> <item>) -> (put <type> <op> <item>)
;; (get <op> <type>)        -> (get <type> <op>)
;;
;;単に<op>と<type>を入れ替えればよさそう
