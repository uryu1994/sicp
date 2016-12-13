(load "./table")
(load "./tag")

;; 従業員レコード(TIM)
;; (name address salary)
;; 事業所レコード(TIM)
;; (type-tag (record1) (record2) ...)
(define tim-data
  '((hoge1 sinjuku 250000)
    (hoge2 yotsuya 270000)
    (hoge3 shibuya 220000)))

(define (install-tim-db-package)
  (define (make-db db)
    (attach-tag 'tim db))
  (define (get-name record) (car record))
  (define (get-address record) (cadr record))
  (define (get-salary record) (caddr record))
  (define (get-record db name)
    (let ((records (cdr db)))
      (define (iter records)
        (if (null? records)
            #f
            (let ((record (car records)))
              (if (equal? name (get-name record))
                  record
                  (iter (cdr records))))))
      (iter records)))
  (put 'make-db 'tim make-db)
  (put 'get-record 'tim get-record)
  (put 'get-salary 'tim get-salary)
  'done)

(install-tim-db-package)

(define tim-db ((get 'make-db 'tim) tim-data))

;; SICP事業所データ
(define sicp-data '((1 (npg sapporo 200000))
                    (2 (poi otaru 180000))
                    (3 (opi kushiro 2400000))))

(define (install-sicp-db-package)
  (define (make-db db)
    (attach-tag 'sicp db))
  (define (get-contents record) (cadr record))
  (define (get-name record) (car (get-contents record)))
  (define (get-address record) (cadr (get-contents record)))
  (define (get-salary record) (caddr (get-contents record)))
  (define (get-record db name)
    (let ((records (cdr db)))
      (define (iter records)
        (if (null? records)
            #f
            (let ((record (car records)))
              (if (equal? name (get-name record))
                  record
                  (iter (cdr records))))))
      (iter records)))
  (put 'make-db 'sicp make-db)
  (put 'get-record 'sicp get-record)
  (put 'get-salary 'sicp get-salary)
  'done)

(install-sicp-db-package)

(define sicp-db ((get 'make-db 'sicp) sicp-data))

(define all-db-list (list tim-db sicp-db))

;; 2.74a
(define (get-record db name)
  ((get 'get-record (type-tag db)) db name))

;; 2.74b
(define (get-salary db name)
  (let ((target (get-record db name))
        (proc (get 'get-salary (type-tag db))))
    (if (eq? #f target)
        #f
        (proc target))))

;; 2.74c
(define (find-employee-record db-list name)
  (define (iter db-list)
    (let ((record (get-record (car db-list) name)))
      (if (eq? record #f)
          (iter (cdr db-list))
          record)))
  (iter db-list))
  

(get-record tim-db 'hoge1)
(get-salary tim-db 'hoge1)
(get-record sicp-db 'poi)
(get-salary sicp-db 'opi)
(find-employee-record all-db-list 'hoge2)

;; 2.74d
;; (install-***-package)のように
;; 合併した企業のデータ構造向けにpackageを用意すれば，
;; 既存のデータ構造とかそれを操作するロジックをいじる必要はない
