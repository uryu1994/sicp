(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (f 10))

;; Eva > Alyssa > Ben の順で支持

;; Evaが好むように振る舞う内部定義の実装
;; -> delayを使う？
