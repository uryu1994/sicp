(load "./microshaft")

(sum ?amount
     (and (job ?x (computer programmer))
          (salary ?x ?amount)))

(query-driver-loop)

(assert! (rule (wheel ?person)
               (and (supervisor ?middle-manager ?person)
                    (supervisor ?x ?middle-manager))))

(and (wheel ?who)
     (salary ?who ?amount))

(and (wheel (Warbucks Oliver)) (salary (Warbucks Oliver) 150000))
(and (wheel (Warbucks Oliver)) (salary (Warbucks Oliver) 150000))
(and (wheel (Bitdiddle Ben)) (salary (Bitdiddle Ben) 60000))
(and (wheel (Warbucks Oliver)) (salary (Warbucks Oliver) 150000))
(and (wheel (Warbucks Oliver)) (salary (Warbucks Oliver) 150000))

;; Benの方法では重複するため正しい合計値を出すことができない

;; 打開する方法として，フレームのストリームを作り出した後，
;; マップ関数に渡す前に重複するものを除去するフィルタ関数に通す必要がある
