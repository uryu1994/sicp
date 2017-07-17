(define x 10)

(define s (make-serializer))

(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))));;P1
                  (s (lambda () (set! x (+ x 1)))));;P2

;; P1)
;; P11: P1の1番目と2番目のxへのアクセス
;; P12: P1のxへの設定

;; P2: P2のxへのアクセスとP2のxへの設定

;; P11(10) -> P12(100) -> P2(101)
;; P11(10) -> P2(11)   -> P12(100)
;; P2(11)  -> P11(11)  -> P12(121)
;;※P11(10) -> P2(10) ->  P12(100) -> P211)

;; 101: P1がxを100に設定し, 次にP2がxを101に増加する.
;; 121: P2がxを11に増加し, 次にP1がxをx掛けるxに設定する.
;;  11: P2がxにアクセスし，P1がxを100に設定，P2がxを設定する.
;; 100:	P1がxに(二回)アクセスし, P2がxを11に設定し, P1がxを設定する. 