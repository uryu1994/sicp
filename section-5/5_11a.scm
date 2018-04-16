(load "./register")

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
     afterfib-n-2
     (restore n)                                   ; 戻った時Fib(n-2)の値はvalにある
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
