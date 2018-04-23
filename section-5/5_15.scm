(load "./register-analyze")

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (instruction-count 0))
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
                (set! instruction-count (+ instruction-count 1))
                (execute)))))
      (define (get-instruction-count)
        instruction-count)
      (define (initialize-instruction-count)
        (set! instruction-count 0))
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
              ((eq? message 'get-instruction-count) (get-instruction-count))
              ((eq? message 'initialize-instruction-count) (initialize-instruction-count))
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (get-instruction-count machine)
  (machine 'get-instruction-count))

(define (initialize-instruction-count machine)
  (machine 'initialize-instruction-count))


;; test

(define fact-machine
  (make-machine   
   '(continue val n)
   (list (list '= =) (list '- -) (list '* *))
   '(test-f
     (assign continue (label fact-done))     ; 最終帰り番地設定
     fact-loop
     (test (op =) (reg n) (const 1))
     (branch (label base-case))
     ;;nとcontinueを退避し再帰呼出しを設定する.
     ;; 再帰呼出しから戻る時after-fact}から
     ;; 計算が続行するようにcontinueを設定
     (save continue)
     (save n)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label after-fact))
     (goto (label fact-loop))
     after-fact
     (restore n)
     (restore continue)
     (assign val (op *) (reg n) (reg val))   ; valに n(n-1)!がある
     (goto (reg continue))                   ; 呼出し側に戻る
     base-case
     (assign val (const 1))                  ; 基底の場合: 1!=1
     (goto (reg continue))                   ; 呼出し側に戻る
     fact-done)))

(define (fact-loop)
  (define (fact n)
    (newline)
    ((fact-machine 'stack) 'initialize)
    (set-register-contents! fact-machine 'n n)
    (initialize-instruction-count fact-machine)
    (start fact-machine)
    (format #t "fact:~2d => ~8d" n (get-register-contents fact-machine 'val))
    (format #t "instruction-count: ~4d" (get-instruction-count fact-machine))
    (newline))
  (define (fact-iter x)
    (if (< x 5)
        (begin (fact x)
               (fact-iter (+ x 1)))))
  (fact-iter 1))

(fact-loop)
