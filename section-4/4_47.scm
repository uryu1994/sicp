(load "./natural-language-parser")

(for-each simple-ambeval
	  '((define (parse-verb-phrase)
	      (amb (parse-word verbs)
		   (list 'verb-phrase
			 (parse-verb-phrase)
			 (parse-prepositional-phrase))))
	    ))

(driver-loop)
(parse '(the professor lectures to the student with the cat))
;;; Starting a new problem 
;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun professor)) (verb-phrase (verb lectures) (prep-phrase (prep to) (noun-phrase (simple-noun-phrase (article the) (noun student)) (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun professor)) (verb-phrase (verb-phrase (verb lectures) (prep-phrase (prep to) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))

;;; Amb-Eval input:
try-again

;; -> 返ってこない(無限ループ)

;; ambの中の式の順を交換すると, プログラムの振舞いは変るか
;; -> 変わる
