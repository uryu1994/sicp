(load "./2_69")

(define rock-code '((A 2) (BOOM 1) (GET 2) (JOB 2) (NA 16) (SHA 3) (YIP 9) (WAH 1)))
(define rock-huffman-tree (generate-huffman-tree rock-code))
(define rock-song '(GET A JOB
                        SHA NA NA NA NA NA NA NA NA
                        GET A JOB
                        SHA NA NA NA NA NA NA NA NA
                        WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP
                        SHA BOOM))

(define rock-encode (encode rock-song rock-huffman-tree))
;;(1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 1 0 1 1)

(length rock-encode)
;; -> 84bit

(length rock-song)
;; -> 36
;; 8記号アルファベットの固定長符号化は3bit必要
;; よって 36 * 3bit = 108bit となる
