;; 手続きを構成し手続き本体のコードを飛び越す
(assign val
        (op make-compiled-procedure) (label entry2) (reg env))
(goto (label after-lambda1))

entry2     ; factorialの呼出しはここから始る
(assign env (op compiled-procedure-env) (reg proc))
(assign env
        (op extend-environment) (const (n)) (reg argl) (reg env))
;; 手続き本体の開始
(save continue)
(save env)

;; (= n 1)の計算
(assign proc (op lookup-variable-value) (const =) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch17))
compiled-branch16
(assign continue (label after-call15))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch17
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call15   ; valには(= n 1)の結果がある
(restore env)
(restore continue)
(test (op false?) (reg val))
(branch (label false-branch4))
true-branch5   ; 1を返す
(assign val (const 1))
(goto (reg continue))

false-branch4
;; (* (factorial (- n 1)) n)を計算し返す
(assign proc (op lookup-variable-value) (const *) (reg env))
(save continue)
(save proc)   ; *手続きを退避
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op list) (reg val))
(save argl)   ; *の部分引数リストを退避

;; *のもう一つの引数(factorial (- n 1))の計算
(assign proc
        (op lookup-variable-value) (const factorial) (reg env))
(save proc)  ; factorial手続きを退避
;; factorialの引数(- n 1)の計算
(assign proc (op lookup-variable-value) (const -) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch8))
compiled-branch7
(assign continue (label after-call6))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch8
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call6   ; valには(- n 1)の結果がある
(assign argl (op list) (reg val))
(restore proc) ; factorialを回復
;; factorialを作用させる
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch11))
compiled-branch10
(assign continue (label after-call9))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch11
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call9      ; valには(factorial (- n 1))の結果がある
(restore argl) ; *の部分引数リストを回復
(assign argl (op cons) (reg val) (reg argl))
(restore proc) ; *を回復
(restore continue)
;; *を作用させ値を返す
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch14))
compiled-branch13
;; 合成手続きは末尾再帰的に呼び出されることに注意
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch14
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))
after-call12
after-if3
after-lambda1
;; 手続きを変数factorialに代入
(perform
 (op define-variable!) (const factorial) (reg val) (reg env))
(assign val (const ok))
