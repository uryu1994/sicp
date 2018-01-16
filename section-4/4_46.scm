(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

;; set! で *unparsed* に先頭を取り出す副作用を与えている．
;; そのため，ambの評価順序に依存している
