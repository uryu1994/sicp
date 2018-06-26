(load "./compile-eceval")


(define eceval
  (make-machine
   '(exp env val proc argl continue unev compapp)
   eceval-operations
   '(
     ;; Question 5.47
     (assign compapp (label compound-apply))
     (branch (label external-entry))      ; flagが設定してあれば分岐する
     read-eval-print-loop
     (perform (op initialize-stack))
     ...
     )))

;; Question 5.47
(define (compile-procedure-call target linkage)
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
        (compound-branch (make-label 'compound-branch))
        (after-call (make-label 'after-call)))
    (let ((compiled-linkage
           (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
       (make-instruction-sequence '(proc) '()
                                  `((test (op primitive-procedure?) (reg proc))
                                    (branch (label ,primitive-branch))))
       (make-instruction-sequence '(proc) '()
                                  `((test (op compiled-procedure?) (reg proc))
                                    (branch (label ,compiled-branch))))
       (parallel-instruction-sequences
        (append-instruction-sequences
         compound-branch
         (compound-proc-appl target compiled-linkage))
        (parallel-instruction-sequences
         (append-instruction-sequences
          compiled-branch
          (compile-proc-appl target compiled-linkage))
         (append-instruction-sequences
          primitive-branch
          (end-with-linkage linkage
                            (make-instruction-sequence '(proc argl)
                                                       (list target)
                                                       `((assign ,target
                                                                 (op apply-primitive-procedure)
                                                                (reg proc)
                                                                (reg argl))))))))
       after-call))))


(define (compound-proc-appl target linkage)
  (cond ((and (eq? target 'val) (not (eq? linkage 'return)))
         (make-instruction-sequence
          '() all-regs
          `((assign continue (label ,linkage))
            (save continue)
            (goto (reg compapp)))))
        ((and (not (eq? target 'val))
              (not (eq? linkage 'return)))
         (let ((proc-return (make-label 'proc-return)))
           (make-instruction-sequence '(proc) all-regs
                                      `((assign continue (label ,proc-return))
                                        (save continue)
                                        (goto (reg compapp))
                                        ,proc-return
                                        (assign ,target (reg val))
                                        (goto (label ,linkage))))))
        ((and (eq? target 'val) (eq? linkage 'return))
         (make-instruction-sequence '(proc continue) all-regs
                                    `((save continue)
                                      (goto (reg compapp)))))
        ((and (not (eq? target 'val)) (eq? linkage 'return))
         (error "return linkage, target not val -- COMPILE"
                target))))
