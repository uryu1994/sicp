;; ./sicp_4_17a.png
(lambda ⟨vars⟩
  (define u ⟨e1⟩)
  (define v ⟨e2⟩)
  ⟨e3⟩)

;; ./sicp_4_17b.png
(lambda ⟨vars⟩
  (let ((u '*unassigned*)
        (v '*unassigned*))
    (set! u ⟨e1⟩)
    (set! v ⟨e2⟩)
    ⟨e3⟩))

;; lambdaが評価されると環境が作られる
;; letはlambdaの構文シュガーなので後者の方が環境が多く作られる


;; 余計なフレームを構成せずに解釈系が内部定義の「同時」有効範囲規則を実装する方法
(lambda ⟨vars⟩
  (define u '*unassigned*)
  (define v '*unassigned*)
  (set! u ⟨e1⟩)
  (set! v ⟨e2⟩)
  ⟨e3⟩)
