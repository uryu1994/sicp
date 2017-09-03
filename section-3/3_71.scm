(load "./stream")

(define (cube x)
  (* x x x))

(define (add-cube-pairs-weight pair)
  (let ((i (car pair))
	(j (cadr pair)))
    (+ (cube i) (cube j))))

(define (ramanujan s)
  (let ((s1 (stream-car s))
	(s2 (stream-car (stream-cdr s))))
    (let ((weight-s1 (add-cube-pairs-weight s1))
	  (weight-s2 (add-cube-pairs-weight s2)))
      (if (= weight-s1 weight-s2)
	  (cons-stream weight-s1
		       (ramanujan (stream-cdr s)))
	  (ramanujan (stream-cdr s))))))

(define ramanujan-num (ramanujan (weighted-pairs integers integers add-cube-pairs-weight)))

(stream-head ramanujan-num 6)
;; gosh> 1729
;; 4104
;; 13832
;; 20683
;; 32832
;; 39312
;; done
