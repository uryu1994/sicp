(define (sqrt-stream x)
  (cons-stream 1.0
               (stream-map (lambda (guess)
                             (sqrt-improve guess x))
                           (sqrt-stream x))))

;; Louis版だと毎回ストリームを最初から生成することになる
;; そのため，再度計算が走ることになるためmemo化されてないことと同じになる

;; delay実装がmemo-procの最適化を使わない場合も同様に，再計算されまくるため効率が悪い
