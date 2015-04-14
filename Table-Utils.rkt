#lang racket

(define sorted-table '())
(define sub-sorted-table '())
(provide table-sort)
(define (table-sort table sorted-table row-count col-count current-row)
  (define (row-filter-helper entry)
    (if (= (element-row entry) current-row)
        #t
        #f))
  (if (= row-count current-row)
      sorted-table
      (table-sort table
                  (append sorted-table
                          (sub-sort
                           (filter row-filter-helper table)
                           sub-sorted-table col-count 0))
                  row-count
                  col-count
                  (+ current-row 1))))

(define (sub-sort table sorted-table col-count current-col)
  (define (col-filter-helper entry)
    (if (= (element-column entry) current-col)
        #t
        #f))
  (if (= col-count current-col)
      sorted-table
      (sub-sort table (append sorted-table (filter col-filter-helper table)) col-count (+ current-col 1))))

(provide resolve-collisions)
(define (resolve-collisions table)
 (define repaired-table (fix-collision table table '()))
 (if (equal? repaired-table table) ;Keep running repairs until the table isn't changed
     repaired-table
     (resolve-collisions repaired-table)))

(define (fix-collision table initial-table resolved-table)
  (if (pair? table)
      (if (and
           (= (element-row (car table))
              (element-row (cadr table)))
           (= (element-column (car table))
              (element-column (cadr table))))
          (resolve initial-table (to-space (car table) (cadr table)))
          (fix-collision (cdr table) initial-table (append resolved-table (car table))))
      resolved-table)

(define (to-space first-element second-element)
    (cond ((= (car (element-parent first-element)) (car (element-parent second-element)))
           (if (< (cdr (element-parent first-element)) (cdr (element-parent second-element)))
               (element-parent first-element)
               (element-parent second-element)))
          ((< (car (element-parent first-element)) (car (element-parent second-element)))
           (element-parent first-element))
          (else (element-parent second-element))))

(define (resolve table parent)
;find parent space it 

(provide table-entry)
(define (table-entry entry-num table)
  (if (= 0 entry-num)
      (if (pair? table)
          (car table)
          null)
      (table-entry (- entry-num 1) (cdr table))))

(provide element-row)
(define (element-row table-element)
  (car table-element))

(provide element-column)
(define (element-column table-element)
  (cadr table-element))

(provide element-type)
(define (element-type table-element)
  (caddr table-element))

(provide element-parent)
(define (element-parent table-element)
  (cadddr table-element))

(provide element-value)
(define (element-value table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr table-element))))))

(provide element-car)
(define (element-car table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr
       (cdr table-element)))))))

(provide element-cdr)
(define (element-cdr table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr
       (cdr
        (cdr table-element))))))))

(provide table-col-count)
(define (table-col-count table max-found)
  (if (pair? table)
      (if (> (element-column (car table)) max-found)
          (table-col-count (cdr table) (element-column (car table)))
          (table-col-count (cdr table) max-found))
      max-found))
      
(provide table-row-count)
(define (table-row-count table max-found)
  (if (pair? table)
      (if (> (element-row (car table)) max-found)
          (table-row-count (cdr table) (element-row (car table)))
          (table-row-count (cdr table) max-found))
      max-found))