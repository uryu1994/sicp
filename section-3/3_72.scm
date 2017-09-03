(load "./stream")

(define (add-square-pairs-weight pair)
  (let ((i (car pair))
	(j (cadr pair)))
    (+ (square i) (square j))))

(define (trible-way-sum-square s)
  (let ((s1 (stream-car s))
	(s2 (stream-car (stream-cdr s)))
	(s3 (stream-car (stream-cdr (stream-cdr s)))))
    (let ((weight-s1 (add-square-pairs-weight s1))
	  (weight-s2 (add-square-pairs-weight s2))
	  (weight-s3 (add-square-pairs-weight s3)))
      (if (= weight-s1 weight-s2 weight-s3)
	  (cons-stream weight-s1
		       (trible-way-sum-square (stream-cdr s)))
	  (trible-way-sum-square (stream-cdr s))))))

(define trible-way-sum-square-num
  (trible-way-sum-square
   (weighted-pairs integers integers add-square-pairs-weight)))

(stream-head trible-way-sum-square-num 10)
