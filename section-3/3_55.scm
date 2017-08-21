(load "./stream")

;; Include stream.scm

;; (define (partial-sums S)
;;   (cons-stream (stream-car S)
;;                (add-streams
;;                 (stream-cdr S)
;;                 (partial-sums S))))


(stream-ref (partial-sums integers) 0)
(stream-ref (partial-sums integers) 1)
(stream-ref (partial-sums integers) 2)
(stream-ref (partial-sums integers) 3)
(stream-ref (partial-sums integers) 4)
(stream-ref (partial-sums integers) 5)

