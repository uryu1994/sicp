(load "./eceval")

(define eceval-operations               
  (list (list 'self-evaluating? self-evaluating?)
        ...
        ;; Question 5.23
        (list 'cond? cond?)
        (list 'cond->if cond->if)
        (list 'let? let?)
        (list 'let->combination let->combination)
        (list 'application? application?)
        ...
        (list 'user-print user-print)
        ))


(define eceval
  (make-machine
   '(exp env val proc argl continue unev)
   eceval-operations
   '(
     ...
     (branch (label ev-cond))
     (test (op let?) (reg let))
     (branch (label ev-let))
     (test (op application?) (reg exp))
     ...
     ev-cond
     (assign exp (op cond->if) (reg exp))
     (goto (label eval-dispatch))
     ev-let
     (assign exp (op let->combination) (reg exp))
     (goto (label eval-dispatch))
     ...
     )))
