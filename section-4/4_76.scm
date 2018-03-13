(load "./query")

(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
      frame-stream
      (merge-frame-stream
       (qeval (first-conjunct conjuncts) frame-stream) 
       (conjoin (rest-conjuncts conjuncts)frame-stream))))

(define (merge-frame-stream s1 s2)
  (stream-flatmap (lambda (f1)
                    (stream-filter
                     (lambda (frame) (not (equal? frame 'failed)))
                     (stream-map
                      (lambda (f2)
                        (merge-frame f1 f2))
                      s2)))
                  s1))

(define (merge-frame f1 f2)
  (if (null? f1)
      f2
      (let ((var (caar f1))
            (val (cdar f1)))
        (let ((extension (extend-if-possible var val f2)))
          (if (equal? extension 'failed)
              'failed
              (merge-frame (cdr f1) extension))))))

(put 'and 'qeval conjoin)
