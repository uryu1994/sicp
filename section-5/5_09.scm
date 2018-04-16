(load "./register")

(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
        (aprocs
         (map (lambda (e)
                (if (label-exp? e)
                    (error "can't operate on label -- MAKE-OPERATION_EXP" e)
                    (make-primitive-exp e machine labels)))
              (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))

(define label-op-test
  (make-machine
   '(a)
   (list (list '= =) (list '> >))
   '(test-l
     main
     (test (op >) (reg a) (label main))
     (branch (label done))
     (assign b (op +) (reg a) (label main))
     done)))
