(load "./query")

(instantiate 'a '() (lambda (exp frame) ()))

(expand-question-mark '?)
(map-over-symbols expand-question-mark '?x)
(query-syntax-process '(job ?x ?y))

(pattern-match '(job (? x) (? y))
               '(job (Hacker Alyssa P) (computer programmer))
               '())

(pattern-match '(job (? x) (computer programmer))
               '(job (Hacker Alyssa P) (computer programmer))
               '())

(unify-match '(Hacker) '(? x) '())
(unify-match '(? x) '(Hacker) '())
(unify-match '(? x) '(? y) '())
(unify-match '((? y) (? x)) '((? x) (? y)) '())
(unify-match '(? x) 1
             (extend '(? y) 2
                     '()))
(unify-match '((? x) (? y)) '((? y) 1)
             (extend '(? x) 1
                     '()))

(unify-match '((? x) (? x)) '((? y) (? y)) '())
