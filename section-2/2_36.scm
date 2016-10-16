(load "./2_33")

(define nil '())
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(define s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

(accumulate-n + 0 s)
(accumulate-n cons nil s)

;; s =>(list (list 1 2 3) (list 4 5 6) (list 7 8 9))
;; (cons (cons 1 (cons 2 (cons 3 nil))) (cons 4 (cons 5 (cons 6 nil))))
