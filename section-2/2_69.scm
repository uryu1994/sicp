(load "./2_68")

(define (successive-merge pairs)
  (if (null? (cdr pairs))
      (car pairs)
      (successive-merge
       (adjoin-set (make-code-tree (car pairs) (cadr pairs))
                   (cddr pairs)))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(generate-huffman-tree '((A 4) (B 2) (C 1) (D 1)))
