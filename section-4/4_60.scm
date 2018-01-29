(load "./microshaft")

(query-driver-loop)

(assert! (rule (lives-near ?person-1 ?person-2)
               (and (address ?person-1 (?town . ?rest-1))
                    (address ?person-2 (?town . ?rest-2))
                    (not (same ?person-1 ?person-2)))))

(assert! (rule (same ?x ?x)))

(lives-near ?x (Bitdiddle Ben))
(lives-near ?person-1 ?person-2)

;;; Query results:
(lives-near (Aull DeWitt) (Reasoner Louis))
(lives-near (Aull DeWitt) (Bitdiddle Ben))
(lives-near (Reasoner Louis) (Aull DeWitt))
(lives-near (Reasoner Louis) (Bitdiddle Ben))
(lives-near (Hacker Alyssa P) (Fect Cy D))
(lives-near (Fect Cy D) (Hacker Alyssa P))
(lives-near (Bitdiddle Ben) (Aull DeWitt))
(lives-near (Bitdiddle Ben) (Reasoner Louis))

;; lives-nearは組み合わせを列挙しているので
;; A-A, B-B ..のように同じ人物のものはフィルタされるが，
;; a-b, b-a, のように前後入れ替えたパターンは防ぐことはできない
