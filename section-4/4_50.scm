(load "./amb")

(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
	;; 省略
	((amb? exp) (analyze-amb exp))
	;; Question 4.50
	((ramb? exp) (analyze-ramb exp))
	;; 省略
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))


(use srfi-27)
(define (ramb? exp) (tagged-list? exp 'ramb))
(define (ramb-choices exp) (cdr exp))
(define (analyze-ramb exp)
  (let ((cprocs (map analyze (ramb-choices exp))))
    (define (delete x seq)
      (cond ((null? seq) '())
	    ((equal? x (car seq)) (cdr seq))
	    (else (cons (car seq) (delete x (cdr seq))))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    (let ((choice (list-ref choices (random-integer (length choices)))))
	      (choice env succeed (lambda ()
				    (try-next (delete choice choices)))))))
      (try-next cprocs))))

(for-each simple-ambeval
	  '((define nouns (list 'noun (ramb 'student 'professor 'cat 'class)))
	    (define verbs (list 'verb (ramb 'studies 'lectures 'eats 'sleeps)))
	    (define articles (list 'article (ramb 'the 'a)))
	    (define prepositions (list 'prep (ramb 'for 'to 'in 'by 'with)))

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
(sentence (simple-noun-phrase (article a) (noun class)) (verb studies))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article a) (noun class)) (verb-phrase (verb studies) (prep-phrase (prep with) (simple-noun-phrase (article a) (noun class)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(sentence (simple-noun-phrase (article a) (noun class)) (verb-phrase (verb-phrase (verb studies) (prep-phrase (prep with) (simple-noun-phrase (article a) (noun class)))) (prep-phrase (prep with) (simple-noun-phrase (article a) (noun class)))))

