(load "./microshaft")

(query-driver-loop)

(assert! (rule (same ?x ?x)))
(assert! (rule (replace ?person-1 ?person-2)
               (and
                (or (and (job ?person-1 ?job)
                         (job ?person-2 ?job))
                    (and (job ?person-1 ?job-1)
                         (job ?person-2 ?job-2)
                         (can-do-job ?job-1 ?job-2)))
                (not (same ?person-1 ?person-2)))))

;; a
(replace (Fect Cy D) ?who)

;; b
(and (salary ?person ?salary)
     (replace ?person ?somebody)
     (salary ?somebody ?somebody-salary)
     (lisp-value > ?somebody-salary ?salary))
