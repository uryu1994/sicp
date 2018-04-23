(load "./register-analyze")

(define true #t)
(define false #f)

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (instruction-count 0)
        (trace-flag false))
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
                (let ((inst (car insts)))
                  (set! instruction-count (+ instruction-count 1))
                  (if trace-flag
                      (begin
                        (print (instruction-label inst))
                        (print (instruction-text inst))
                        ))
                  ((instruction-execution-proc inst))
                  (execute))))))
      (define (get-instruction-count)
        instruction-count)
      (define (initialize-instruction-count)
        (set! instruction-count 0))
      (define (trace-on) (set! trace-flag true))
      (define (trace-off) (set! trace-flag false))
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
              ((eq? message 'trace-on) (trace-on))
              ((eq? message 'trace-off) (trace-off))
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
                      (lambda (insts labels)
                        (let ((next-inst (car text)))
                          (if (symbol? next-inst)
                              (let ((new-insts (adjoin-label next-inst insts))) 
                                  (receive new-insts
                                           (cons (make-label-entry next-inst new-insts)
                                                 labels)))
                              (receive (cons (make-instruction next-inst)
                                             insts)
                                       labels)))))))

(define (adjoin-label label insts)
  (cond ((null? insts) insts)
        ((not (null? (cdr (car insts)))) insts)
        (else (cons (append (car insts)
                            (list label))
                    (adjoin-label label (cdr insts))))))
                          
                        
(define (make-instruction text)
  (cons text '()))

(define (instruction-text inst)
  (car inst))

(define (instruction-label inst)
  (cadr inst))

(define (instruction-execution-proc inst)
  (cddr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-cdr! (cdr inst) proc))

(define (get-instruction-count machine)
  (machine 'get-instruction-count))

(define (initialize-instruction-count machine)
  (machine 'initialize-instruction-count))

(define (trace-on machine)
  (machine 'trace-on))

(define (trace-off machine)
  (machine 'trace-off))

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

(define (fact n)
  (trace-on fact-machine)
  ((fact-machine 'stack) 'initialize)
  (set-register-contents! fact-machine 'n n)
  (initialize-instruction-count fact-machine)
  (start fact-machine)
  (print (get-register-contents fact-machine 'val))
  (newline)
  (trace-off fact-machine)
  ((fact-machine 'stack) 'initialize)
  (set-register-contents! fact-machine 'n n)
  (initialize-instruction-count fact-machine)
  (start fact-machine)
  (print (get-register-contents fact-machine 'val))
  'done)

(fact 5)
