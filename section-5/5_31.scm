     
     ev-application
     (save continue)
     (save env); 演算子でのenv退避
     (assign unev (op operands) (reg exp))
     (save unev)
     (assign exp (op operator) (reg exp))
     (assign continue (label ev-appl-did-operator))
     (goto (label eval-dispatch))
     ev-appl-did-operator
     (restore unev)
     (restore env); 演算子でのenv回復
     (assign argl (op empty-arglist))
     (assign proc (reg val))
     (test (op no-operands?) (reg unev))
     (branch (label apply-dispatch))
     (save proc); 被演算子列でのproc退避
     ev-appl-operand-loop
     (save argl); 各被演算子でのargl退避
     (assign exp (op first-operand) (reg unev))
     (test (op last-operand?) (reg unev))
     (branch (label ev-appl-last-arg))
     (save env); 各被演算子でのenv退避
     (save unev)
     (assign continue (label ev-appl-accumulate-arg))
     (goto (label eval-dispatch))
     ev-appl-accumulate-arg
     (restore unev)
     (restore env); 各被演算子でのenv回復
     (restore argl); 各被演算子でのargl回復
     (assign argl (op adjoin-arg) (reg val) (reg argl))
     (assign unev (op rest-operands) (reg unev))
     (goto (label ev-appl-operand-loop))
     ev-appl-last-arg
     (assign continue (label ev-appl-accum-last-arg))
     (goto (label eval-dispatch))
     ev-appl-accum-last-arg
     (restore argl)
     (assign argl (op adjoin-arg) (reg val) (reg argl))
     (restore proc); 被演算子列でのproc回復
     (goto (label apply-dispatch))
     ;; 手続き作用
     apply-dispatch
     (test (op primitive-procedure?) (reg proc))
     (branch (label primitive-apply))
     (test (op compound-procedure?) (reg proc))
     (branch (label compound-apply))
     (goto (label unknown-procedure-type))


(f 'x 'y)
;; 演算子の評価の前後でenvレジスタを退避回復　不要
;;  fには値が束縛されているため
;; 各被演算子の前後でenvを退避回復 不要
;;  引数がクォート式なので評価の必要なし
;; 各被演算子の前後でarglを退避回復 不要
;;  引数がクォート式なのでarglを使わなくていい
;; 被演算子列の評価の前後でprocを退避回復 不要
;;  引数列はクォート式のみなのでprocを使わなくていい

((f) 'x 'y)
;; 演算子の評価の前後でenvレジスタを退避回復　不要
;;  非演算子が変数だったら退避しなければならないが、クォートなので
;; 各被演算子の前後でenvを退避回復 不要
;;  上と同様
;; 各被演算子の前後でarglを退避回復 不要
;;  上と同様
;; 被演算子列の評価の前後でprocを退避回復 不要
;;  上と同様

(f (g 'x) y)
;; 演算子の評価の前後でenvレジスタを退避回復　不要
;;  fには値が束縛されているため
;; 各被演算子の前後でenvを退避回復
;;  （g　'x) => 不要
;;        y => 不要
;; 各被演算子の前後でarglを退避回復
;;  （g　'x) => 必要
;;      gの評価にarglを使うため
;;        y => 不要
;; 被演算子列の評価の前後でprocを退避回復 必要
;;  gの作用でprocを使う


(f (g 'x) 'y)
;; 演算子の評価の前後でenvレジスタを退避回復　不要
;;  fには値が束縛されているため
;; 各被演算子の前後でenvを退避回復
;;  （g　'x) => 不要
;;        'y => 不要
;;      クォート式なので
;; 各被演算子の前後でarglを退避回復 不要
;;  （g　'x) => 必要
;;      gの評価にarglを使うため
;;        'y => 不要
;;      クォート式なので
;; 被演算子列の評価の前後でprocを退避回復 必要
;;  gの作用でprocを使う
