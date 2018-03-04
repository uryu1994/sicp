(load "./query")

(define (simple-query query-pattern frame-stream)
  (stream-flatmap
   (lambda (frame)
     (stream-append-delayed
      (find-assertions query-pattern frame)
      (delay (apply-rules query-pattern frame))))
   frame-stream))

;; Louis' simple-query
(define (simple-query query-pattern frame-stream)
  (stream-flatmap
   (lambda (frame)
     (stream-append (find-assertions query-pattern frame)
                    (apply-rules query-pattern frame)));; delayしてない
   frame-stream))

(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave-delayed
       (qeval (first-disjunct disjuncts) frame-stream)
       (delay (disjoin (rest-disjuncts disjuncts)
                       frame-stream)))))

;; Louis' disjoin
(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave
       (qeval (first-disjunct disjuncts) frame-stream)
       (disjoin (rest-disjuncts disjuncts) frame-stream)))) ;; delayしてない

;; Louisの定義の場合遅延評価されないため，評価が全て完了するまで何も表示されない
;; 通常の場合，無限ループになる質問は評価結果が印字されながら次の質問処理をするが，
;; Louisの手続きの場合は何も印字されないまま無限ループに陥る

(query-driver-loop)
(assert! (loop 1 2))
(assert! (rule (loop ?x ?y)
               (loop ?y ?x)))

(loop 1 ?y)
