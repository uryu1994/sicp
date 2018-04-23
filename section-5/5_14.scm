(load "./register-analyze")


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
    (start fact-machine)
    (format #t "fact:~2d => ~8d" n (get-register-contents fact-machine 'val))
    ((fact-machine 'stack) 'print-statistics)
    (newline))
  (define (fact-iter x)
    (if (< x 10)
        (begin (fact x)
               (fact-iter (+ x 1)))))
  (fact-iter 1))

(fact-loop)

;; fact: 1 =>        1
;; (total-pushes = 0 maximum-depth = 0)

;; fact: 2 =>        2
;; (total-pushes = 2 maximum-depth = 2)

;; fact: 3 =>        6
;; (total-pushes = 4 maximum-depth = 4)

;; fact: 4 =>       24
;; (total-pushes = 6 maximum-depth = 6)

;; fact: 5 =>      120
;; (total-pushes = 8 maximum-depth = 8)

;; fact: 6 =>      720
;; (total-pushes = 10 maximum-depth = 10)

;; fact: 7 =>     5040
;; (total-pushes = 12 maximum-depth = 12)

;; fact: 8 =>    40320
;; (total-pushes = 14 maximum-depth = 14)

;; fact: 9 =>   362880
;; (total-pushes = 16 maximum-depth = 16)
;; #<undef>

;; 待避回数・スタックの最大深さともに2 * (n - 1)
