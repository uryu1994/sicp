(define (sqrt-stream x)
  (cons-stream 1.0
               (stream-map (lambda (guess)
                             (sqrt-improve guess x))
                           (sqrt-stream x)))) ;; ここで環境が作られる

;; Louis版だと毎回ストリームを最初から生成することになる
;; そのため，再度計算が走ることになるためmemo化されてないことと同じになる

;; delay実装がmemo-procの最適化を使わなかったとしたらそもそもstream自体がmemo化されていないので，
;; 効率は変わらない
