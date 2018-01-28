(load "./microshaft")

(query-driver-loop)
;; a
(and (supervisor ?x (Bitdiddle Ben))
     (address ?x ?y))

;;; Query results:
(and (supervisor (Tweakit Lem E) (Bitdiddle Ben)) (address (Tweakit Lem E) (Boston (Bay State Road) 22)))
(and (supervisor (Fect Cy D) (Bitdiddle Ben)) (address (Fect Cy D) (Cambridge (Ames Street) 3)))
(and (supervisor (Hacker Alyssa P) (Bitdiddle Ben)) (address (Hacker Alyssa P) (Cambridge (Mass Ave) 78)))


;; b
(and (salary (Bitdiddle Ben) ?Ben-amount)
     (salary ?person ?amount)
     (lisp-value > ?Ben-amount ?amount))

;;; Query results:
(and (salary (Bitdiddle Ben) 60000) (salary (Aull DeWitt) 25000) (lisp-value > 60000 25000))
(and (salary (Bitdiddle Ben) 60000) (salary (Cratchet Robert) 18000) (lisp-value > 60000 18000))
(and (salary (Bitdiddle Ben) 60000) (salary (Reasoner Louis) 30000) (lisp-value > 60000 30000))
(and (salary (Bitdiddle Ben) 60000) (salary (Tweakit Lem E) 25000) (lisp-value > 60000 25000))
(and (salary (Bitdiddle Ben) 60000) (salary (Fect Cy D) 35000) (lisp-value > 60000 35000))
(and (salary (Bitdiddle Ben) 60000) (salary (Hacker Alyssa P) 40000) (lisp-value > 60000 40000))


;; c
(and (job ?person ?section)
     (and (not (job ?person (computer . ?type)))
          (supervisor ?person ?supervisor)))

;;; Query results:
(and (job (Aull DeWitt) (administration secretary)) (and (not (job (Aull DeWitt) (computer . ?type))) (supervisor (Aull DeWitt) (Warbucks Oliver))))
(and (job (Cratchet Robert) (accounting scrivener)) (and (not (job (Cratchet Robert) (computer . ?type))) (supervisor (Cratchet Robert) (Scrooge Eben))))
(and (job (Scrooge Eben) (accounting chief accountant)) (and (not (job (Scrooge Eben) (computer . ?type))) (supervisor (Scrooge Eben) (Warbucks Oliver))))
