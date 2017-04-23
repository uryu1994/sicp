(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (make-item value)
  (cons value (cons '() '())))

(define (next-item item) (cddr item))
(define (prev-item item) (cadr item))
(define (value-of-item item) (car item))

(define (set-next-item! item next)
  (set-cdr! (cdr item) next))

(define (set-prev-item! item prev)
  (set-car! (cdr item) prev))

(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (value-of-item (front-ptr queue))))

(define (rear-queue queue)
  (if (empty-queue? queue)
      (error "REAR called with an empty queue" queue)
      (value-of-item (rear-ptr queue))))

(define (front-insert-queue! queue value)
  (let ((new-item (make-item value)))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-item)
           (set-rear-ptr! queue new-item)
           queue)
          (else
           (set-next-item! new-item (front-ptr queue))
           (set-front-ptr! queue new-item)
           queue))))

(define (rear-insert-queue! queue value)
  (let ((new-item (make-item value)))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-item)
           (set-rear-ptr! queue new-item)
           queue)
          (else
           (set-prev-item! new-item (rear-ptr queue))
           (set-next-item! (rear-ptr queue) new-item)
           (set-rear-ptr! queue new-item)
           queue))))

(define (front-delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-prev-item! (next-item (front-ptr queue)) '())
         (set-front-ptr! queue (next-item (front-ptr queue)))
         queue)))

(define (rear-delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-next-item! (prev-item (rear-ptr queue)) '())
         (set-rear-ptr! queue (prev-item (rear-ptr queue)))
         queue)))

(define (print-queue queue)
  (define (recur item)
    (if (null? item)
        '()
        (cons (value-of-item item) (recur (next-item item)))))
  (recur (front-ptr queue)))

(define q (make-queue))
(front-insert-queue! q 'a)
(print-queue q)
(rear-insert-queue! q 'c)
(rear-delete-queue! q)
(front-delete-queue! q)
