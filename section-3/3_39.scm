(define x 10)

(define s (make-serializer))

(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
                  (s (lambda () (set! x (+ x 1)))))

;; 101: P1がxを100に設定し, 次にP2がxを101に増加する.
;; 121: P2がxを11に増加し, 次にP1がxをx掛けるxに設定する.
;; 100:	P1がxに(二回)アクセスし, P2がxを11に設定し, P1がxを設定する. 
