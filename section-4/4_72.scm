(load "./query")

(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (stream-append-delayed
       (qeval (first-disjunct disjuncts) frame-stream)
       (delay (disjoin (rest-disjuncts disjuncts)
                       frame-stream)))))

(put 'or 'qeval disjoin)

(define (flatten-stream stream)
  (if (stream-null? stream)
      the-empty-stream
      (stream-append-delayed
       (stream-car stream)
       (delay (flatten-stream (stream-cdr stream))))))

(query-driver-loop)

(assert! (loop1 1))
(assert! (loop2 2))

(assert! (rule (loop1 ?x)
               (loop1 ?x)))
(assert! (rule (loop2 ?x)
               (loop2 ?x)))
(assert! (rule (loop ?x)
               (or (loop1 ?x)
                   (loop2 ?x))))
(loop ?x)
;; (loop 1)
;; (loop 1)
;; (loop 1)
;; ...

;; interleaveを使うと
;; (loop 1)
;; (loop 2)
;; (loop 1)
;; (loop 2)
;; ...
;; のように交互に印字

;; このように1つ目のストリームが無限ストリームである場合，最初の結果しか表示されない
;; interleaveを使うことで交互に先頭の要素を評価するので，片方どちらかが無限ストリームに陥っても両方評価が可能になる
