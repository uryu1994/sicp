(load "./circuit")

(define the-agenda (make-agenda))
(define a1 (make-wire))
(define a2 (make-wire))
(define output (make-wire))

(probe 'output output)
(and-gate a1 a2 output)
(set-signal! a2 1) ;; ...(1)
(current-time the-agenda)
(segments the-agenda)

(propagate)
(current-time the-agenda)
(segments the-agenda)

(set-signal! a1 1);; ...(2)
(set-signal! a2 0);; ...(3)
(current-time the-agenda)
(segments the-agenda)

(propagate)
(current-time the-agenda)
(segments the-agenda)

;; 次第書きのアクションはadd-action!が呼ばれた順にキューに入る(FIFO)
;; そのため，上記例だとa1に登録されたアクション -> a2に登録されたアクション
;; の順に格納されて、その順番で実行される
;; (propagate)が呼ばれると，
;; (1)... a1 = 0, a2 = 1 -> output = 0(変化なし)
;; (2)... a1 = 1, a2 = 1 -> output = 1
;; (3)... a1 = 1, a2 = 0 -> output = 0
;; と，1回目の(propagate)ではoutputに変化がないため出力されないが，
;; 2回目の(propagate)で1, 0と変化するため共に出力される

;; 次第書きのアクションがLIFOになると格納順は同じだが，
;; 最後に入れたものから順に実行されるので
;; a2に登録されたアクション -> a1に登録されたアクション
;; の順に実行される
;; したがって，
;; (1)... a1 = 0, a2 = 1 -> output = 0(変化なし)
;; (2)... a1 = 0, a2 = 0 -> output = 0(変化なし)
;; (3)... a1 = 1, a2 = 0 -> output = 0(変化なし)
;; と，本来の実行順と異なる動きになる
