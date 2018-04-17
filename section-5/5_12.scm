(load "./register")

(define (assemble controller-text machine)
  (extract-labels controller-text
                  (lambda (insts labels)
                    (update-deta-path! insts machine)
                    (update-insts! insts labels machine)
                    insts)))

(define (add-data-path! data-path exp)
  (if (not (member exp (cdr data-path)))
      (set-cdr! data-path
                (cons exp (cdr data-path)))))

(define (update-deta-path! insts machine)
  (let ((data-path (machine 'data-path)))
    (for-each
     (lambda (inst)
       (let ((type (car inst)))
         (add-data-path! (assoc 'instruction-type data-path)
                         type)
         (cond ((eq? type 'goto)
                (add-data-path! (assoc 'entry-point data-path)
                                (goto-dest inst)))
               ((or (eq? type 'save) (eq? type 'restore))
                (add-data-path! (assoc 'save-restore data-path)
                                (stack-inst-reg-name inst)))
               ((eq? type 'assign)
                (add-data-path! (assoc 'assign-source data-path)
                                (assign-value-exp inst))))))
     (map instruction-text insts))))


(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (data-path (list (list 'instruction-type)
                         (list 'entry-point)
                         (list 'save-restore)
                         (list 'assign-source)))
        (the-instruction-sequence '()))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
              ((eq? message 'data-path) data-path)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))


;; test
(define fib
  (make-machine
   '(n val continue)
   (list (list '< <) (list '- -) (list '+ +))
   '(test-fib
     (assign continue (label fib-done))
     fib-loop
     (test (op <) (reg n) (const 2))
     (branch (label immediate-answer))
     ;; Fib(n-1)を計算するよう設定
     (save continue)
     (assign continue (label afterfib-n-1))
     (save n)                           ; nの昔の値を退避
     (assign n (op -) (reg n) (const 1)); nを n-1 に変える
     (goto (label fib-loop))            ; 再帰呼出しを実行
     afterfib-n-1                         ; 戻った時 Fib(n-1)はvalにある
     (restore n)
     (restore continue)
     ;; Fib(n-2)を計算するよう設定
     (assign n (op -) (reg n) (const 2))
     (save continue)
     (assign continue (label afterfib-n-2))
     (save val)                         ; Fib(n-1)を退避
     (goto (label fib-loop))
     afterfib-n-2                         ; 戻った時Fib(n-2)の値はvalにある
     (assign n (reg val))               ; nにはFib(n-2)がある
     (restore val)                      ; valにはFib(n-1)がある
     (restore continue)
     (assign val                        ; Fib(n-1)+Fib(n-2)
             (op +) (reg val) (reg n))
     (goto (reg continue))              ; 呼出し側に戻る. 答えはvalにある
     immediate-answer
     (assign val (reg n))               ; 基底の場合: Fib(n)=n
     (goto (reg continue))
     fib-done)))

(set-register-contents! fib 'n 4)
(start fib)
(get-register-contents fib 'val)
(print (fib 'data-path))
