(load "./register")

;; (1 2 3)
;; (('a 1) ('b 2) ('c 3))

(define (make-save inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name)))
      (lambda ()
        (push stack (cons reg-name (get-contents reg)))
        (advance-pc pc)))))

(define (make-restore inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name)))
      (lambda ()
        (let ((head (pop stack)))
          (if (eq? (car head) reg-name)
              (set-contents! reg (cdr head))
              (error "Wrong register name -RESTORE" reg-name)))
        (advance-pc pc)))))

(define test-stack
  (make-machine
   '(a b)
   '()
   '(test-s
     (assign a (const 1))
     (assign b (const 2))
     (save a)
     (save b)
     (restore a)
     done)))

(start test-stack)
