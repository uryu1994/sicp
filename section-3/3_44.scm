(define (transfer from-account to-account amount)
  ((from-account 'withdraw) amount)
  ((to-account 'deposit) amount))

;; 正しくない
;; 移動(transfer): 預け入れ・引き出しの順番は前後しても結果は同じ
;; 交換(exchange): 「残高取得」->「預け入れ・引き出し」この順番は前後することはできない(serializeする必要あり)
