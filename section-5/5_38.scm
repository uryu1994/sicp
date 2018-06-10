(load "./compile")

(define (spread-arguments operands)
  (let ((op1 (compile (car operands) 'arg1 'next))
        (op2 (compile (cadr operands) 'arg2 'next)))
    (list op1 op2)))

(define (open-code? exp)
  (memq (car exp) '(+ - * /)))

(define (compile-open-code exp target linkage)
  (if (= (length exp) 3)
      (let ((proc (operator exp))
            (args (spread-arguments (operands exp))))
        (end-with-linkage linkage
                          (append-instruction-sequences
                           (car args)
                           (preserving
                            '(arg1)
                            (cadr args)
                            (make-instruction-sequence
                             '(arg1 arg2)
                             (list target)
                             `((assign ,target (op ,proc) (reg arg1) (reg arg2))))))))
      (error "Require 2 operands -- COMPILE-OPEN-CODE" exp)))

(define (compile exp target linkage)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp target linkage))
        ((quoted? exp) (compile-quoted exp target linkage))
        ((variable? exp)
         (compile-variable exp target linkage))
        ((assignment? exp)
         (compile-assignment exp target linkage))
        ((definition? exp)
         (compile-definition exp target linkage))
        ((if? exp) (compile-if exp target linkage))
        ((lambda? exp) (compile-lambda exp target linkage))
        ((begin? exp)
         (compile-sequence (begin-actions exp)
                           target
                           linkage))
        ((cond? exp) (compile (cond->if exp) target linkage))
        ((open-code? exp) (compile-open-code exp target linkage))
        ((application? exp)
         (compile-application exp target linkage))
        (else
         (error "Unknown expression type -- COMPILE" exp))))

(parse-compiled-code
 (compile
  '(define (factorial n)
     (if (= n 1)
         1
         (* (factorial (- n 1)) n)))
  'val
  'next))
