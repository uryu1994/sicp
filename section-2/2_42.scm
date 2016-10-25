(load "./2_40")

(define (queens board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(define empty-board '())

(define (adjoin-position new-row k rest-of-queens)
  (cons (list new-row k) rest-of-queens))

;; k=0 -> '()
;; k=1 -> (((1 2 3 4) 1) '())
;; k=2 -> 

(define (conflicts? a b)
  (let ((dx (abs (- (car a) (car b))))
        (dy (abs (- (cadr a) (cadr b)))))
    (cond ((= dx 0) #t)
          ((= dy 0) #t)
          ((= dx dy) #t)
          (else #f))))


(define (safe? k positions)
  (let ((kpos (car positions)))
    (define (iter rest)
      (cond ((null? rest) #t)
            ((conflicts? (car rest) kpos) #f)
            (else (iter (cdr rest)))))
    (iter (cdr positions))))

(queens 4)
