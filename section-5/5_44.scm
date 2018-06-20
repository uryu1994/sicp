(load "./5_43")

(define (spread-arguments operands ct-env)
  (let ((op1 (compile (car operands) 'arg1 'next ct-env))
        (op2 (compile (cadr operands) 'arg2 'next ct-env)))
    (list op1 op2)))

(define (open-code? exp)
  (memq (car exp) '(= + - *)))

(define (compile-open-code exp target linkage ct-env)
  (if (= (length exp) 3)
      (let ((proc (operator exp))
            (args (spread-arguments (operands exp) ct-env)))
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


(define (compile exp target linkage cenv)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp target linkage))
        ((quoted? exp) (compile-quoted exp target linkage))
        ((variable? exp)
         (compile-variable exp target linkage cenv))
        ((assignment? exp)
         (compile-assignment exp target linkage cenv))
        ((definition? exp)
         (compile-definition exp target linkage cenv))
        ((if? exp) (compile-if exp target linkage cenv))
        ((lambda? exp) (compile-lambda exp target linkage cenv))
        ((begin? exp)
         (compile-sequence (begin-actions exp)
                           target
                           linkage
                           cenv))
        ((cond? exp) (compile (cond->if exp) target linkage cenv))
        ((open-code-operator? exp) (compile-open-code exp target linkage cenv))
        ((application? exp)
         (compile-application exp target linkage cenv))
        (else
         (error "Unknown expression type -- COMPILE" exp))))

(define (overwrite? operator ct-env)
  (let ((addr (find-variable operator ct-env)))
    (eq? addr 'not-found)))

(define (open-code-operator? exp ct-env)
  (and (open-code? exp)
       (overwrite? (operator exp) ct-env)))

(parse-compiled-code
 (compile
  '(lambda (+ * a b x y)
     (+ (* a x) (* b y)))
  'val
  'next
  '()))
