(load "./register-analyze")

(define true #t)
(define false #f)

(define (make-register name)
  (let ((contents '*unassigned*)
        (reg-trace false))
    (define (trace-on)
      (set! reg-trace true))
    (define (trace-off)
      (set! reg-trace false))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value)
               (if reg-trace (print "register:" name " old:" contents " new:" value)) 
               (set! contents value)))
            ((eq? message 'trace-on) (trace-on))
            ((eq? message 'trace-off) (trace-off))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (reg-trace-on machine reg-name)
  ((get-register machine reg-name) 'trace-on))

(define (reg-trace-off machine reg-name)
  ((get-register machine reg-name) 'trace-off))

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
  (reg-trace-on fact-machine 'val)
  (set-register-contents! fact-machine 'n n)
  (start fact-machine)
  (print (get-register-contents fact-machine 'val))
  'done)

(fact 5)
