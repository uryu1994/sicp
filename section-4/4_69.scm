(load "./query")

(for-each add-rule-or-assertion!
          '((son Adam Cain)
            (son Cain Enoch)
            (son Enoch Irad)
            (son Irad Mehujael)
            (son Mehujael Methushael)
            (son Methushael Lamech)
            (wife Lamech Ada)
            (son Ada Jabal)
            (son Ada Jubal)))

(query-driver-loop)

(assert! (rule (grandson-of ?g ?s)
               (and (son-of ?f ?s)
                    (son-of ?g ?f))))

(assert! (rule (son-of ?m ?s)
               (or (son ?m ?s)
                   (and (wife ?m ?w)
                        (son ?w ?s)))))

(assert! (rule ((great . ?rel) ?x ?y)
               (and (son-of ?x ?w)
                    (?rel ?w ?y))))

(assert! (rule ((grandson) ?x ?y)
               (grandson-of ?x ?y)))

((great grandson) ?g ?ggs)

(?relationship Adam Irad)
