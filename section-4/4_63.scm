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

(grandson-of Cain ?s)

(son-of Cain ?s)

(son-of Lamech ?s)

(son-of Ada ?s)
