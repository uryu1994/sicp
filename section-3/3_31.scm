(load "./circuit")

(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
          (begin (set! signal-value new-value)
                 (call-each action-procedures))
          'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures)))
;;    (define (accept-action-procedure! proc)
;;      (set! action-procedures (cons proc action-procedures))
;;      (proc))

    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-my-signal!)
            ((eq? m 'add-action!) accept-action-procedure!)
            (else (error "Unknown operation -- WIRE" m))))
    dispatch))
 
(define input-1 (make-wire))
(define input-2 (make-wire))
(define sum (make-wire))
(define carry (make-wire))
(probe 'sum sum)
(probe 'carry carry)
(half-adder input-1 input-2 sum carry)
(set-signal! input-1 1)
(propagate)
(set-signal! input-2 1)
(propagate)

;; もし(accept-action-procedure!)手続きの最後で(proc)が呼ばれていない場合
;; half-adderの場合，内部のinverterと繋いでいる回路eは1にする必要がある
;; (proc)が呼ばれないことによりこの初期化がされなくなるため誤った初期値のまま
;; 次第書きの順序で実行されることになる
