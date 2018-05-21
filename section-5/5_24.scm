;; Question 5.24
ev-cond
(assign unev (op cond-clauses) (reg exp))
(save continue)
(goto (label ev-cond-loop))
ev-cond-loop
(test (op null?) (reg unev))
(branch (label ev-cond-null))
(assign exp (op car) (reg unev))
(test (op cond-else-clause?) (reg exp))
(branch (label ev-cond-else))
(save exp)
(assign exp (op cond-predicate) (reg exp))
(save unev)
(save env)
(assign continue (label ev-cond-decide))
(goto (label eval-dispatch))
ev-cond-decide
(restore env)
(restore unev)
(restore exp)
(test (op true?) (reg val))
(branch (label ev-cond-consequent))
(assign unev (op cdr) (reg unev))
(goto (label ev-cond-loop))
ev-cond-consequent
(assign unev (op cond-actions) (reg exp))
(goto (label ev-sequence))
ev-cond-else
(assign unev (op cond-actions) (reg exp))
(goto (label ev-sequence)) 
ev-cond-null
(restore continue)
(assign val (const #f))
(goto (reg continue))

(load "./eceval")
