(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

;; 問題
(define (solve f y0 dt)
  (let ((y '*unassigned*)
	(dy '*unassigned*))
    (let ((a (integral (delay dy) y0 dt))
	  (b (stream-map f y)))
      (set! y a)
      (set! dy b)
      y)))

;; aを束縛する際にdyが必要となる
;; この時点でdyは'*unssignedだが(delay dy)ではこの時点で評価されないと考える
;; 一方bを束縛する際はf yが必要となるがyも'*unssigned -> エラー


;; 本文
(define (solve f y0 dt)
  (let ((y '*unassigned*)
	(dy '*unassigned*))
    (set! y (integral (delay dy) y0 dt))
    (set! dy (stream-map f y))
    y))

;; yにset!する際にdyが必要 しかし(delay dy)のためこの時点で評価はされないと考える
;; dyをset!する際にyが必要 delayがうまく動作すればエラーにならないはず
