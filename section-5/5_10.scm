(load "./register")

(define (make-execution-procedure inst labels machine
                                  pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'inc)
         (make-inc inst machine pc))
        ((eq? (car inst) 'dec)
         (make-dec inst machine pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))))

(define (make-inc inst machine pc)
  (let ((target
         (get-register machine (inc-reg-name inst))))
    (lambda ()
      (let ((value (get-contents target)))
        (cond ((number? value)
               (set-contents! target (+ value 1))
               (advance-pc pc))
              (else
               (error "INCREMENT require number, but" value)))))))

(define (inc-reg-name exp) (cadr exp))

(define (make-dec inst machine pc)
  (let ((target
         (get-register machine (dec-reg-name inst))))
    (lambda ()
      (let ((value (get-contents target)))
        (cond ((number? value)
               (set-contents! target (- value 1))
               (advance-pc pc))
              (else               
               (error "DECREMENT require number, but" value)))))))

(define (dec-reg-name exp) (cadr exp))

(define add-two
  (make-machine
   '(a)
   (list '())
   '(main
     (inc a)
     (inc a)
     (inc a)
     (dec a)
     done)))

(set-register-contents! add-two 'a 10)
(start add-two)
(get-register-contents add-two 'a)
