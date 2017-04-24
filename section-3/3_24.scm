(define false #f)

(define (make-table same-key?)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
            ((same-key? key (caar records)) (car records))
            (else (assoc key (cdr records)))))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define tbl (make-table =))
((tbl 'insert-proc!) 1 1 'a)
((tbl 'insert-proc!) 1 2 'b)
((tbl 'insert-proc!) 2 1 'c)
((tbl 'insert-proc!) 2 2 'd)
((tbl 'lookup-proc) 1 1)
((tbl 'lookup-proc) 1 2)
((tbl 'lookup-proc) 1 3)
((tbl 'lookup-proc) 2 1)
((tbl 'lookup-proc) 2 2)
((tbl 'lookup-proc) 2 3)
