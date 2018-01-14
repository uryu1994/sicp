;; 制限の順序

;; 解に影響するか? -> しない

;; 界を見出す時間に影響するか? -> する
;; 失敗しやすい制限ほど先に配置することでrequireの実行回数を減らすことができる


(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
     (distinct? (list baker cooper fletcher miller smith)))
    (require (> miller cooper))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= fletcher 1)))    
    (require (not (= fletcher 5)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))
