;; Text
(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

;; Alyssa
(define (analyze-sequence exps)
  (define (execute-sequence procs env)
    (cond ((null? (cdr procs)) ((car procs) env))
          (else ((car procs) env)
                (execute-sequence (cdr procs) env))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (lambda (env) (execute-sequence procs env))))

;; 並びが１つの式を持つ場合
(begin 1)

;; Text版
'(lambda (env)
   ((lambda (env) 1) env))

;; Alyssa版
'(lambda (env)
   (execute-sequence '((lambda (env) 1))
		     env))

;; 並びが２つの式を持つ場合
(begin 1 2)

;; Text版
'(lambda (env)
   ((lambda (env) 1) env)
   ((lambda (env) 2) env))

;; Alyssa版
'(lambda (env)
   (execute-sequence '((lambda (env) 1)
		       (lambda (env) 2))
		     env))

;; 本文版は実行時に式を順番に評価していく
;; 並びをネストした式に変換しているので解析の手間を無くしている

;; Alyssa版は個々に式を評価するが，null?などの解析をする
;; 
