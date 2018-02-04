(load "./microshaft")

(query-driver-loop)
;; Real outranked-by
(assert! (rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss)))))

;; Louis' outranked-by
(assert! (rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (outranked-by ?middle-manager ?boss)
               (supervisor ?staff-person ?middle-manager)))))

(outranked-by (Bitdiddle Ben) ?who)

;; outranked-byの?staff-personにBitdiddle Benが束縛される
;; (supervisor ?staff-person ?boss)でBitdiddleの上司が束縛される
;; そしてoutranked-byが?bossがAとして?middle-managerを探す
;;
;; (以降繰り返しとなる）
;; supervisorが?bossをAとして?staff-personを部下Bとして束縛
;; andのoutranked-byで?bossがAとして?middle-managerを探す
;;
;; 
;; 結果，outranked-byの?middle-managerが未束縛になったまま無限ループへ陥る
