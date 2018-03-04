(load "./microshaft")

;; a
(define (simple-stream-flatmap proc s)
  (simple-flatten (stream-map proc s)))

(define (simple-flatten stream)
  (stream-map stream-car
              (stream-filter (lambda (s) (not (stream-null? s))) stream)))

;; b

;; 変わらない
;; simple-stream-flatmapの結果は変更が加えられる前と同じ順序の単一の要素からなるストリームとなるため
(define (negate operands frame-stream)
  (simple-stream-flatmap
   (lambda (frame)
     (if (stream-null? (qeval (negated-query operands)
                              (singleton-stream frame)))
         (singleton-stream frame)
         the-empty-stream))
   frame-stream))

(put 'not 'qeval negate)

(define (lisp-value call frame-stream)
  (simple-stream-flatmap
   (lambda (frame)
     (if (execute
          (instantiate
           call
           frame
           (lambda (v f)
             (error "Unknown pat var -- LISP-VALUE" v))))
         (singleton-stream frame)
         the-empty-stream))
   frame-stream))

(put 'lisp-value 'qeval lisp-value)

(define (find-assertions pattern frame)
  (simple-stream-flatmap (lambda (datum)
                           (check-an-assertion datum pattern frame))
                         (fetch-assertions pattern frame)))

(query-driver-loop)

(and (salary (Bitdiddle Ben) ?ben-salary)
     (salary ?name ?salary)
     (lisp-value < ?salary ?ben-salary))
