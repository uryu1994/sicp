(load "./query")

(query-driver-loop)

(assert! (rule (append-to-form () ?y ?y)))

(assert! (rule (append-to-form (?u . ?v) ?y (?u . ?z))
               (append-to-form ?v ?y ?z)))

(assert! (rule (reverse () ())))

(assert! (rule (reverse (?u . ?v) ?y)
               (and (reverse ?v ?t)
                    (append-to-form ?t (?u) ?y))))



(reverse (1 2 3) ?x)

;;; Query results:
(reverse (1 2 3) (3 2 1))


(reverse (1 2 3) ?x)
;; 無限ループ
