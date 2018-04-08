(load "./register")

(define expt-machine
  (make-machine
   '(b n counter product)
   (list (list '= =) (list '- -) (list '* *))
   '((assign counter (reg n))
     (assign product (const 1))
     expt-loop
     (test (op =) (reg counter) (const 0))
     (branch (label expt-done))
     (assign counter (op -) (reg counter) (const 1))
     (assign product (op *) (reg b) (reg product))
     (goto (label expt-loop))
     expt-done)))

(set-register-contents! expt-machine 'b 2)
(set-register-contents! expt-machine 'n 8)
(start expt-machine)
(get-register-contents expt-machine 'product)
