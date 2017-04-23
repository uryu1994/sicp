(load "./queue")

(define (print-queue queue)
  (front-ptr queue))

(define q1 (make-queue))

(insert-queue! q1 'a)
(print-queue q1)

(insert-queue! q1 'b)
(print-queue q1)

(delete-queue! q1)
(print-queue q1)

(delete-queue! q1)
(print-queue q1)

;; delete-queue!はキューの先頭のポインタを動かしているだけ
;; LISPの解釈系応答だとfront-ptrだけでなくrear-ptrも含めて印字される
;; なので最後の項目がキューに２度挿入されているわけではない
