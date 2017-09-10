(load "./stream")

(define sense-data
  (stream-map (lambda (x) (sin x)) integers))

(define (sign-change-detector s2 s1)
  (cond ((and (<= 0 s2) (> 0 s1)) 1)
	((and (> 0 s2) (<= 0 s1)) -1)
	(else 0)))

;; Louis make-zero-crossings
;; (define (make-zero-crossings input-stream last-value)
;;   (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
;;     (cons-stream (sign-change-detector avpt last-value)
;;                  (make-zero-crossings (stream-cdr input-stream)
;;                                       avpt))))
;;
;; 平滑化された値をlast-valueに渡している．
;; また，境界値のチェックは平均値同士でやる必要がある

;; Answer
(define (make-zero-crossings input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream (sign-change-detector avpt last-avpt)
                 (make-zero-crossings (stream-cdr input-stream)
				      (stream-car input-stream)
				      avpt))))

(define zero-crossings (make-zero-crossings sense-data 0 0))

(stream-head sense-data 20)
(stream-head zero-crossings 20)
