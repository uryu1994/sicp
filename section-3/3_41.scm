(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposit) (protected deposit))
            ((eq? m 'balance)
             ((protected (lambda () balance)))) ; 直列化した.
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

;; 変更点
;; ((eq? m 'balance) balance)
;; ↓
;; ((eq? m 'balance) ((protected (lambda () balance))))
;;
;; 並列性に問題は無い
;; 処理系によっては賛成
