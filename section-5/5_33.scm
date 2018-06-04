(load "./compile")

(parse-compiled-code
 (compile
  '(define (factorial-alt n)
     (if (= n 1)
         1
         (* n (factorial-alt (- n 1)))))
  'val
  'next))

;; 違い
;; factorial-branch4
;; factorialはprocを退避->arglに部分引数リストを入れて退避->procに*のもう一つの引数(factorial (- n 1))の計算を入れて退避
;; factorial-altはenvを退避->procにfactorial-alt入れて退避
;;
;; 効率
;; arglに部分引数リストを入れて退避しているかの差はあるが命令の実行回数は同じなので両者の違いはない
