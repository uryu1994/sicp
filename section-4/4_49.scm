(load "./amb")

(for-each simple-ambeval
	  '((define nouns (list 'noun (amb 'student 'professor 'cat 'class)))
	    (define verbs (list 'verb (amb 'studies 'lectures 'eats 'sleeps)))
	    (define articles (list 'article (amb 'the 'a)))
	    (define prepositions (list 'prep (amb 'for 'to 'in 'by 'with)))

	    (define (parse-prepositional-phrase)
	      (list 'prep-phrase
		    (parse-word prepositions)
		    (parse-noun-phrase)))

	    (define (parse-sentence)
	      (list 'sentence
		    (parse-noun-phrase)
		    (parse-verb-phrase)))

	    (define (parse-verb-phrase)
	      (define (maybe-extend verb-phrase)
		(amb verb-phrase
		     (maybe-extend (list 'verb-phrase
					 verb-phrase
					 (parse-prepositional-phrase)))))
	      (maybe-extend (parse-word verbs)))

	    (define (parse-simple-noun-phrase)
	      (list 'simple-noun-phrase
		    (parse-word articles)
		    (parse-word nouns)))

	    (define (parse-noun-phrase)
	      (define (maybe-extend noun-phrase)
		(amb noun-phrase
		     (maybe-extend (list 'noun-phrase
					 noun-phrase
					 (parse-prepositional-phrase)))))
	      (maybe-extend (parse-simple-noun-phrase)))
	    
	    (define (parse-word word-list)
	      (require (not (null? (cdr word-list))))
	      (list (car word-list) (car (cdr word-list))))
	    (define *unparsed* '())
	    
	    (define (parse input)
	      (set! *unparsed* input)
	      (let ((sent (parse-sentence)))
		(require (null? *unparsed*))
		sent))
	    ))

(driver-loop)
(parse-sentence)

;;; Starting a new problem 
;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb studies))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))))

