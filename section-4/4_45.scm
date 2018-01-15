(load "./natural-language-parser")

(driver-loop)
(parse '(the professor lectures to the student in the class with the cat))

;; 教授は生徒に講義する，教室で，猫とともに．
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase
  (verb-phrase
   (verb-phrase (verb lectures)
		(prep-phrase (prep to)
			     (simple-noun-phrase (article the) (noun student))))
   (prep-phrase (prep in)
		(simple-noun-phrase (article the) (noun class))))
  (prep-phrase (prep with)
	       (simple-noun-phrase
		(article the) (noun cat)))))

;; 教授は生徒に講義する，猫のいる教室で．
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase
  (verb-phrase (verb lectures)
	       (prep-phrase (prep to)
			    (simple-noun-phrase
			     (article the) (noun student))))
  (prep-phrase (prep in)
	       (noun-phrase
		(simple-noun-phrase (article the) (noun class))
		(prep-phrase (prep with)
			     (simple-noun-phrase
			      (article the) (noun cat)))))))

;; 教授は教室にいる生徒に講義する，猫とともに．
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase
  (verb-phrase (verb lectures)
	       (prep-phrase (prep to)
			    (noun-phrase
			     (simple-noun-phrase
			      (article the) (noun student))
			     (prep-phrase (prep in)
					  (simple-noun-phrase
					   (article the) (noun class))))))
  (prep-phrase (prep with)
	       (simple-noun-phrase
		(article the) (noun cat)))))

;; 教授は，教室に猫とともにいる生徒に講義する．
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase (verb lectures)
	      (prep-phrase (prep to)
			   (noun-phrase
			    (noun-phrase
			     (simple-noun-phrase
			      (article the) (noun student))
			     (prep-phrase (prep in)
					  (simple-noun-phrase
					   (article the) (noun class))))
			    (prep-phrase (prep with)
					 (simple-noun-phrase
					  (article the) (noun cat)))))))

;; 教授は猫のいる教室の中の生徒に講義する．
(sentence
 (simple-noun-phrase (article the) (noun professor))
 (verb-phrase (verb lectures)
	      (prep-phrase (prep to)
			   (noun-phrase
			    (simple-noun-phrase
			     (article the) (noun student))
			    (prep-phrase (prep in)
					 (noun-phrase
					  (simple-noun-phrase
					   (article the) (noun class))
					  (prep-phrase (prep with)
						       (simple-noun-phrase
							(article the) (noun cat)))))))))
