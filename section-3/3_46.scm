(define (test-and-set! cell)
  (if (car cell)
      true
      (begin (set-car! cell true)
             false)))

;; 2つのプロセスが同時にmutexを獲得すると破綻する
