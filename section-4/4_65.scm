(load "./microshaft")

(query-driver-loop)

(assert! (rule (wheel ?person)
               (and (supervisor ?middle-manager ?person)
                    (supervisor ?x ?middle-manager))))

(wheel ?person)

(supervisor ?middle-manager ?person)

;;; Query results:
(supervisor (Aull DeWitt) (Warbucks Oliver))
(supervisor (Cratchet Robert) (Scrooge Eben))
(supervisor (Scrooge Eben) (Warbucks Oliver)); 1
(supervisor (Bitdiddle Ben) (Warbucks Oliver)); 2
(supervisor (Reasoner Louis) (Hacker Alyssa P))
(supervisor (Tweakit Lem E) (Bitdiddle Ben))
(supervisor (Fect Cy D) (Bitdiddle Ben))
(supervisor (Hacker Alyssa P) (Bitdiddle Ben)); 3

;; (supervisor ?x ?middle-manager)
;; 上記フレームに対し上の質問を投げる
(supervisor ?x (Aull DeWitt))

(supervisor ?x (Cratchet Robert))

(supervisor ?x (Scrooge Eben)) ; 1
;; -> (supervisor (Cratchet Robert) (Scrooge Eben))

(supervisor ?x (Bitdiddle Ben)); 2
;;
;; (supervisor (Tweakit Lem E) (Bitdiddle Ben))
;; (supervisor (Fect Cy D) (Bitdiddle Ben))
;; (supervisor (Hacker Alyssa P) (Bitdiddle Ben))


(supervisor ?x (Reasoner Louis))

(supervisor ?x (Tweakit Lem E))

(supervisor ?x (Fect Cy D))

(supervisor ?x (Hacker Alyssa P)) ;; 3
;; (supervisor (Reasoner Louis) (Hacker Alyssa P))

;; 2つ目の質問で，1と2の出力される合計が4となるため
;; Warbucks Oliverは４回分出力されることになる
