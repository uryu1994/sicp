(load "./5_40")
(load "./5_41")

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
        ((application? exp)
         (compile-application exp target linkage cenv))
        (else
         (error "Unknown expression type -- COMPILE" exp))))

(define (compile-variable exp target linkage cenv)
  (let ((addr (find-variable exp cenv)))
    (end-with-linkage
     linkage
     (make-instruction-sequence
      '(env)
      (list target)
      (if (eq? addr 'not-found)
          `((assign ,target
                    (op lookup-variable-value)
                    (const ,exp)
                    (reg env)))
          `((assign ,target
                    (op lexical-address-set!)
                    (const ,exp)
                    (reg env)))
          )))))


(define (compile-assignment exp target linkage cenv)
  (let ((var (assignment-variable exp))
        (get-value-code
         (compile (assignment-value exp) 'val 'next cenv)))
    (let ((addr (find-variable var cenv)))
      (end-with-linkage
       linkage
       (preserving
        '(env)
        get-value-code
        (make-instruction-sequence
         '(env val)
         (list target)
         (if (eq? addr 'not-found)
             `((perform (op set-variable-value!)
                        (const ,var)
                        (reg val)
                        (reg env))
               (assign ,target (const ok)))
             `((perform (op lexical-address-set!)
                        (const ,var)
                        (reg val)
                        (reg env))
               (assign ,target (const ok)))
             )))))))

;; (parse-compiled-code
;;   (compile
;;    '(lambda (x y)
;;       (lambda (a b)
;;         (+
;;          (+ x a)
;;          (* y b)
;;          (set! x a)
;;          (set! z b))))
;;    'val
;;    'next
;;    '()))
