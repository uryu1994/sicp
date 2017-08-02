(load "./stream")

;; -- Include stream.scm
;; (define (mul-streams s1 s2)
;;   (stream-map * s1 s2))

(define factorials (cons-stream 1
                                (mul-streams factorials (stream-cdr integers))))

(stream-ref factorials 0)
(stream-ref factorials 1)
(stream-ref factorials 2)
(stream-ref factorials 3)
(stream-ref factorials 4)
(stream-ref factorials 5)
