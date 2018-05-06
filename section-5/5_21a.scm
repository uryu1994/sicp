(load "./register")

(define count-leaves
  (make-machine
   '(continue tree val tmp val-tmp)
   (list (list '+ +)
         (list 'null? null?)
         (list 'not not)
         (list 'pair? pair?)
         (list 'car car)
         (list 'cdr cdr))
   '(controller
     (assign continue (label done))
     (assign val (const 0))
     count-leaves-loop
     (test (op null?) (reg tree))
     (branch (label tree-null))
     (assign tmp (op pair?) (reg tree))
     (test (op not) (reg tmp))
     (branch (label tree-not-pair))
     (save continue)
     (assign continue (label after-count-car))
     (save tree)
     (assign tree (op car) (reg tree))
     (goto (label count-leaves-loop))
     tree-null
     (assign val (const 0))
     (goto (reg continue))
     tree-not-pair
     (assign val (const 1))
     (goto (reg continue))
     after-count-car
     (restore tree)
     (restore continue)
     (assign tree (op cdr) (reg tree))
     (save continue)
     (assign continue (label after-count-cdr))
     (save val)
     (goto (label count-leaves-loop))
     after-count-cdr
     (assign val-tmp (reg val))
     (restore val)
     (restore continue)
     (assign val (op +) (reg val) (reg val-tmp))
     (goto (reg continue))
     done)))

(define x (cons (list 1 2) (list 3 4)))
(set-register-contents! count-leaves 'tree (list x x))
(start count-leaves)
(get-register-contents count-leaves 'val)
