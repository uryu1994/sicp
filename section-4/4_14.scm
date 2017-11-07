;; ;;; M-Eval input:
;; (map car '((a b) (c d) (e f)))
;; *** ERROR: invalid application: ((primitive #<subr (car obj)>) (a b))

;; primitiveタグが剥がれないままapply-in-underlying-schemeに適用されるため
