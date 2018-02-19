;; 元のadd-assertion!
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
          (cons-stream assertion old-assertions))
    'ok))

;; letによる束縛を行わないadd-assertion!
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS
        (cons-stream assertion THE-ASSERTIONS))
  'ok)


;; 元のadd-assertion!はletでTHE-ASSERTIONSの古い値を保存しているが
;; 後者はletによる束縛を行わず直接set! している
;; cons-streamはcarは評価するがcdrはdelayするため評価されない
;; これにより後者は元のTHE-ASSERTIONSの値にアクセスできず，
;; 無限ストリームとなってしまう
