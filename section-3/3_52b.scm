(use slib)
(require 'trace)

(load "./stream-nomemo")

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(trace accum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
;; CALL accum 1 RETN accum 1

(define y (stream-filter even? seq))
;; CALL accum 2 RETN accum 3
;; CALL accum 3 RETN accum 6

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
;; CALL accum 2 RETN accum 8
;; CALL accum 3 RETN accum 11
;; CALL accum 4 RETN accum 15

(stream-ref y 7)
;; CALL accum 4  RETN accum 19
;; CALL accum 5  RETN accum 24
;; CALL accum 6  RETN accum 30
;; CALL accum 7  RETN accum 37
;; CALL accum 8  RETN accum 45
;; CALL accum 9  RETN accum 54
;; CALL accum 10 RETN accum 64
;; CALL accum 11 RETN accum 75
;; CALL accum 12 RETN accum 87
;; CALL accum 13 RETN accum 100
;; CALL accum 14 RETN accum 114
;; CALL accum 15 RETN accum 129
;; CALL accum 16 RETN accum 145
;; CALL accum 17 RETN accum 162

;; 162

(display-stream z)
;; 15
;; CALL accum 5 RETN accum 167
;; CALL accum 6 RETN accum 173
;; CALL accum 7 RETN accum 180

;; 180
;; CALL accum 8  RETN accum 188
;; CALL accum 9  RETN accum 197
;; CALL accum 10 RETN accum 207
;; CALL accum 11 RETN accum 218
;; CALL accum 12 RETN accum 230

;; 230
;; CALL accum 13 RETN accum 243
;; CALL accum 14 RETN accum 257
;; CALL accum 15 RETN accum 272
;; CALL accum 16 RETN accum 288
;; CALL accum 17 RETN accum 305

;; 305
;; CALL accum 18 RETN accum 323
;; CALL accum 19 RETN accum 342
;; CALL accum 20 RETN accum 362
;; done

(display sum)
;; 362

;; memo-proc(メモライズ)しないことにより呼ぶ必要のないaccumが再実行される
;; それによりsumに値が余分に加算することになるため計算結果がおかしくなる
