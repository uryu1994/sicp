(load "./amb")

(for-each simple-ambeval
	  '((define *unparsed* '())
	    (define nouns '(noun student professor cat class bed))
	    (define verbs '(verb studies lectures eats sleeps runs))
	    (define articles '(article the a))
	    (define prepositions '(prep for to in by with))
	    (define adverbs '(adverb fast early well very))
	    (define adjectives '(adjective big little good easy beautiful new old long short))
	    
	    (define (parse-prepositional-phrase)
	      (list 'prep-phrase
		    (parse-word prepositions)
		    (parse-noun-phrase)))

	    (define (parse-sentence)
	      (list 'sentence
		    (parse-noun-phrase)
		    (parse-verb-phrase)))

	    (define (parse-adverb-phrase)
	      (define (maybe-extend adverb-phrase)
		(amb adverb-phrase
		     (maybe-extend (list 'adverb-phrase
					 adverb-phrase
					 (parse-prepositional-phrase)))))
	      (maybe-extend (parse-word adverbs)))
	    
	    (define (parse-verb-phrase)
	      (define (maybe-extend verb-phrase)
		(amb verb-phrase
		     (maybe-extend (list 'verb-phrase
					 verb-phrase
					 (parse-adverb-phrase)))
		     (maybe-extend (list 'verb-phrase
					 verb-phrase
					 (parse-prepositional-phrase)))))
	      (maybe-extend (parse-word verbs)))

	    (define (parse-simple-noun-phrase)
	      (list 'simple-noun-phrase
		    (parse-article-phrase)
		    (parse-word nouns)))

	    (define (parse-simple-article-phrase)
	      (list 'simple-article-phrase
		    (parse-word articles)
		    (parse-word adjectives)))

	    (define (parse-article-phrase)
	      (define (maybe-extend article-phrase)
		(amb article-phrase
		     (maybe-extend (list 'article-phrase
					 article-phrase
					 (parse-word adjectives)))))
	      (maybe-extend (parse-word articles)))

	    (define (parse-noun-phrase)
	      (define (maybe-extend noun-phrase)
		(amb noun-phrase
		     (maybe-extend (list 'noun-phrase
					 noun-phrase
					 (parse-prepositional-phrase)))))
	      (maybe-extend (parse-simple-noun-phrase)))

	    (define (parse-word word-list)
	      (require (not (null? *unparsed*)))
	      (require (memq (car *unparsed*) (cdr word-list)))
	      (let ((found-word (car *unparsed*)))
		(set! *unparsed* (cdr *unparsed*))
		(list (car word-list) found-word)))
	    
	    (define (parse input)
	      (set! *unparsed* input)
	      (let ((sent (parse-sentence)))
		(require (null? *unparsed*))
		sent))	    
	    ))


(driver-loop)

(parse '(the little cat runs very fast))
