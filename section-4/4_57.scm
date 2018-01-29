(load "./microshaft")

(query-driver-loop)

(assert! (rule (same ?x ?x)))
(assert! (rule (replace ?person1 ?person2)
               (and
                (or (and (job ?person1 ?job)
                         (job ?person2 ?job))
                    (and (job ?person1 ?job1)
                         (job ?person2 ?job2)
                         (can-do-job ?job2 ?job1)))
                (not (same ?person1 ?person2)))))

;; a
(replace (Fect Cy D) ?who)

;; b
(and (salary ?person ?salary)
     (replace ?person ?somebody)
     (salary ?somebody ?somebody-salary)
     (lisp-value > ?somebody-salary ?salary))
