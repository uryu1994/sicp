(load "./amb")

(for-each simple-ambeval
	  '((define (a-pythagorean-triples)
	      (let ((i (an-integer-starting-from 1)))
		(let ((j (an-integer-starting-from i)))
		  (let ((k (an-integer-starting-from j)))
		    (require (= (+ (* i i) (* j j)) (* k k)))
		    (list i j k)))))))

(for-each simple-ambeval
	  '((define (a-pythagorean-triples)
	      (let ((k (an-integer-starting-from 1)))
		(let ((i (an-integer-between 1 k)))
		  (let ((j (an-integer-between i k)))
		    (require (= (+ (* i i) (* j j)) (* k k)))
		    (list i j k)))))
	    
	    (define (an-integer-between low high)
	      (require (< low high))
	      (amb low (an-integer-between (+ low 1) high)))))

(driver-loop)

