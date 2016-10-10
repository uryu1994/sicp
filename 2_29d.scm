(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))

(define (left-branch m)
  (car m))

(define (branch-length b)
  (car b))

;; 変更箇所
(define (right-branch m)
  (cdr m))

;; 変更箇所
(define (branch-structure b)
  (cdr b))
