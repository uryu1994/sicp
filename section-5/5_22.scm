(load "./register")

(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

(define append-machine
  (make-machine
   '(continue x y x-tmp result)
   (list (list 'null? null?) (list 'cons cons) (list 'car car) (list 'cdr cdr))
   '(controller
     (assign continue (label done))
     append-loop
     (test (op null?) (reg x))
     (branch (label append-null))
     (save continue)
     (assign continue (label after-append))
     (save x)
     (assign x (op cdr) (reg x))
     (goto (label append-loop))
     append-null
     (assign result (reg y))
     (goto (reg continue))
     after-append
     (restore x)
     (restore continue)
     (assign x-tmp (op car) (reg x))
     (assign result (op cons) (reg x-tmp) (reg result))
     (goto (reg continue))
     done)))

(set-register-contents! append-machine 'x '(1 2))
(set-register-contents! append-machine 'y '(3 4))
(start append-machine)
(print (get-register-contents append-machine 'result))


(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define append!-machine
  (make-machine
   '(continue x y cdr-tmp)
   (list (list 'null? null?) (list 'set-cdr! set-cdr!) (list 'cdr cdr))
   '(controller
     (assign continue (label append!-done))
     (save x)
     last-pair
     (assign cdr-tmp (op cdr) (reg x))
     (test (op null?) (reg cdr-tmp))
     (branch (label pair-null))
     (assign x (op cdr) (reg x))
     (goto (label last-pair))
     pair-null
     (assign x (op set-cdr!) (reg x) (reg y))
     (goto (reg continue))
     append!-done
     (restore x)
     )))

(set-register-contents! append!-machine 'x '(1 2))
(set-register-contents! append!-machine 'y '(3 4))
(start append!-machine)
(print (get-register-contents append!-machine 'x))
