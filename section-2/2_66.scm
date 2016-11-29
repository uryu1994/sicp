(load "./2_65")

(define (key record)
  (car record))

(define (value record)
  (cadr record))

(define (make-record key value)
  (list key value))

(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) #f)
        ((equal? given-key (key (car set-of-records)))
         (car set-of-records))
        (else (lookup given-key (cdr set-of-records)))))

(define (lookup given-key set-of-records)
  (if (null? set-of-records)
      #f
      (let* ((entry-of-record (entry set-of-records))
             (key-of-record (key entry-of-record)))
        (cond ((= given-key key-of-record) (value entry-of-record))
              ((< given-key key-of-record) (lookup given-key (left-branch set-of-records)))
              (else (lookup given-key (right-branch set-of-records)))))))

(define record1 (list->tree (list (make-record 1 'hoge)
                                  (make-record 3 'huga)
                                  (make-record 6 'fuji)
                                  (make-record 8 'nagoshi))))

(lookup 8 record1)
