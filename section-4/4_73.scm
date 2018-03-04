(define (flatten-stream stream)
  (if (stream-null? stream)
      the-empty-stream
      (interleave
       (stream-car stream)
       (flatten-stream (stream-cdr stream)))));; not-delayed

;; 4.71と同様，遅延されないため，無限ループが起こるような場合などは結果が印字されない
