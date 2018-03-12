;; 本文と問題4.64で示したような単純なループが避けられるように,
;; 質問システムにループ検出器を組み込む方法を考案せよ.

;; 一般的な考え方は, システムは現在の推論の鎖のある種の歴史を保持し,
;; すでに作業した質問の処理を始めないようにするものである. 

;; (assert! (married Minnie Mickey))

;; (assert! (rule (married ?x ?y)
;;                (married ?y ?x)))

;; (married Mickey ?who)
;; (married ?who Mickey)
;; (married Mickey ?who)
;; ... (無限ループ)

;; 規則と質問の組を保持する
;; この組の問い合わせを再度行った場合からフレームを返す
;; １回の問い合わせごとにリセットする必要がある

(load "./query")

(define USED-RULE-CHAIN '())

(define (remove-application-ids query)
  (define (tree-walk exp)
    (cond ((and (var? exp) (number? (cadr exp)))
           (cons (car exp) (cddr query)))
        ((pair? exp)
         (cons (remove-application-ids (car exp))
               (remove-application-ids (cdr exp))))
        (else exp)))
  (tree-walk query))
         
(define (add-chain! rule query)
  (let ((key-pair (cons rule (remove-application-ids query))))
    (set! USED-RULE-CHAIN (cons (cons key-pair 'applied) USED-RULE-CHAIN))))

(define (reset-chain!) (set! USED-RULE-CHAIN '()))
(define (applied-chain? rule query)
  (let ((key (cons rule (remove-application-ids query))))
    (assoc key USED-RULE-CHAIN)))
    

(define (apply-a-rule rule query-pattern query-frame)
  (cond ((applied-chain? rule query-pattern) the-empty-stream)
        (else (add-chain! rule query-pattern)
              (let ((clean-rule (rename-variables-in rule)))
                (let ((unify-result
                       (unify-match query-pattern
                                    (conclusion clean-rule)
                                    query-frame)))
                  (if (eq? unify-result 'failed)
                      the-empty-stream
                      (qeval (rule-body clean-rule)
                             (singleton-stream unify-result))))))))

(define (query-driver-loop)
  (reset-chain!)
  (prompt-for-input input-prompt)
  (let ((q (query-syntax-process (read))))
    (cond ((assertion-to-be-added? q)
           (add-rule-or-assertion! (add-assertion-body q))
           (newline)
           (display "Assertion added to data base.")
           (query-driver-loop))
          (else
           (newline)
           (display output-prompt)
           (display-stream
            (stream-map
             (lambda (frame)
               (instantiate q
                            frame
                            (lambda (v f)
                              (contract-question-mark v))))
             (qeval q (singleton-stream '()))))
           (query-driver-loop)))))

(query-driver-loop)


(assert! (married Minnie Mickey))

(assert! (rule (married ?x ?y)
               (married ?y ?x)))

(married Mickey ?who)


