(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))

(print (last-pair z))
;; make-cycle内のset-cdr!でlistの末尾を同じlistの先頭にセットする
;; つまり循環構造になるため無限ループに陥って何も出てこなくなる
