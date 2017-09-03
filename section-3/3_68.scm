(load "./stream")

(define (pairs s t)
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               t)
   (pairs (stream-cdr s) (stream-cdr t))))

(stream-head (pairs integers integers) 10) ;WARNING

;; cons-streamを使ってないため遅延評価が行われない(無限ループ)
