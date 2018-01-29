(load "./microshaft")

(for-each add-rule-or-assertion!
          '((meeting accounting (Monday 9am))
            (meeting administration (Monday 10am))
            (meeting computer (Wednesday 3pm))
            (meeting administration (Friday 1pm))
            (meeting whole-company (Wednesday 4pm))
            ))

(query-driver-loop)

;; a
(meeting ?section (Friday ?time))

;; b
(assert! (rule (meeting-time ?person ?day-and-time)
               (or (meeting whole-company ?day-and-time)
                   (and (job ?person (?section . ?type))
                        (meeting ?person ?day-and-time)))))

;; c
(meeting-time (Hacker Alyssa P) (Wednesday ?time))
