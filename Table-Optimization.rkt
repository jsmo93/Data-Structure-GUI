#lang racket

(require "Table-Core-Utils.rkt")
(require "Table-Sorting.rkt")
(require "Load-Save-Utils.rkt")

;Removes emptry rows
(provide compress-rows)
(define (compress-rows table)
  (define compressed (row-compression table null 0 #f 0 0))
  (if (null? compressed)
      null
      (if (equal? compressed table)
          table
          (compress-rows (fix-row-child compressed null (last compressed))))))

(define (fix-row-child table new-table to-match)
  (cond ((null? (cdr table)) null)
        ((equal? (element-car (car table)) to-match)
         (append
          new-table
          (append
           (list (list
                  (element-row (car table))
                  (element-column (car table))
                  (element-type (car table))
                  (element-parent (car table))
                  (element-value (car table))
                  (list (- (car (element-car (car table))) 1) (cadr (element-car (car table))))
                  (element-cdr (car table))))
                  (fix-row-child (cdr table) new-table to-match))))
        ((equal? (element-cdr (car table)) to-match)
         (append
          new-table
          (append
           (list (list
                  (element-row (car table))
                  (element-column (car table))
                  (element-type (car table))
                  (element-parent (car table))
                  (element-value (car table))
                  (element-car (car table))
                  (list (- (car (element-cdr (car table))) 1) (cadr (element-cdr (car table))))))
                  (fix-row-child (cdr table) new-table to-match))))
        (else
         (append
          new-table
          (append
           (list (car table))
           (fix-row-child (cdr table) new-table to-match))))))
         
(provide row-compression)
(define (row-compression table new-table last-row found-gap found-at-row found-at-col)
  (cond ((null? table) (if found-gap
                           (list (list found-at-row found-at-col))
                           null))
        ((not (pair? table)) (if found-gap
                           (list (list found-at-row found-at-col))
                           null))
        ((null? (car table)) (if found-gap
                           (list (list found-at-row found-at-col))
                           null))
        (else 
         (if found-gap
             (append
              new-table
              (append
               (list (list
                (- (element-row (car table)) 1)
                (element-column (car table))
                (element-type (car table))
                (if (> (car (element-parent (car table))) last-row)
                    (list (- (car (element-parent (car table))) 1) (cadr (element-parent (car table))))
                    (element-parent (car table)))
                (element-value (car table))
                (if (null? (element-car (car table)))
                    null
                    (list (- (car (element-car (car table))) 1) (cadr (element-car (car table)))))
                (if (null? (element-cdr (car table)))
                    null
                    (list (- (car (element-cdr (car table))) 1) (cadr (element-cdr (car table)))))))
               (row-compression (cdr table) new-table last-row #t found-at-row found-at-col)))
             (if (> (- (element-row (car table)) last-row) 1)
                 (append
                  new-table
                  (append
                   (list (list
                    (- (element-row (car table)) 1)
                    (element-column (car table))
                    (element-type (car table))
                    (element-parent (car table))
                    (element-value (car table))
                    (if (null? (element-car (car table)))
                        null
                        (list (- (car (element-car (car table))) 1) (cadr (element-car (car table)))))
                    (if (null? (element-cdr (car table)))
                        null
                        (list (- (car (element-cdr (car table))) 1) (cadr (element-cdr (car table)))))))
                   (row-compression (cdr table) new-table last-row #t (element-row (car table)) (element-column (car table)))))
                 (append
                  new-table
                  (append
                   (list (car table))
                   (row-compression (cdr table) new-table (element-row (car table)) #f found-at-row found-at-col))))))))

;Removes empty columns, must pass in col-sorted table
(provide compress-cols)
(define (compress-cols table)
  (define compressed (col-compression table null 0 #f 0 0))
  (if (null? compressed)
      null
      (if (equal? compressed table)
          table
          (compress-cols (fix-col-child compressed null (last compressed))))))

(define (fix-col-child table new-table to-match)
  (cond ((null? (cdr table)) null)
        ((equal? (element-car (car table)) to-match)
         (append
          new-table
          (append
           (list (list
                  (element-row (car table))
                  (element-column (car table))
                  (element-type (car table))
                  (element-parent (car table))
                  (element-value (car table))
                  (list (car (element-car (car table))) (- (cadr (element-car (car table))) 1))
                  (element-cdr (car table))))
                  (fix-col-child (cdr table) new-table to-match))))
        ((equal? (element-cdr (car table)) to-match)
         (append
          new-table
          (append
           (list (list
                  (element-row (car table))
                  (element-column (car table))
                  (element-type (car table))
                  (element-parent (car table))
                  (element-value (car table))
                  (element-car (car table))
                  (list (car (element-cdr (car table))) (- (cadr (element-cdr (car table))) 1))))
                  (fix-col-child (cdr table) new-table to-match))))
        (else
         (append
          new-table
          (append
           (list (car table))
           (fix-col-child (cdr table) new-table to-match))))))
         
(provide col-compression)
(define (col-compression table new-table last-col found-gap found-at-row found-at-col)
  (cond ((null? table) (if found-gap
                           (list (list found-at-row found-at-col))
                           null))
        ((not (pair? table)) (if found-gap
                           (list (list found-at-row found-at-col))
                           null))
        ((null? (car table)) (if found-gap
                           (list (list found-at-row found-at-col))
                           null))
        (else 
         (if found-gap
             (append
              new-table
              (append
               (list (list
                (element-row (car table))
                (- (element-column (car table)) 1)
                (element-type (car table))
                (if (> (cadr (element-parent (car table))) last-col)
                    (list (car (element-parent (car table))) (- (cadr (element-parent (car table))) 1))
                    (element-parent (car table)))
                (element-value (car table))
                (if (null? (element-car (car table)))
                    null
                    (list (car (element-car (car table))) (- (cadr (element-car (car table))) 1)))
                (if (null? (element-cdr (car table)))
                    null
                    (list (car (element-cdr (car table))) (- (cadr (element-cdr (car table))) 1)))))
               (col-compression (cdr table) new-table last-col #t found-at-row found-at-col)))
             (if (> (- (element-column (car table)) last-col) 1)
                 (append
                  new-table
                  (append
                   (list (list
                    (element-row (car table))
                    (- (element-column (car table)) 1)
                    (element-type (car table))
                    (element-parent (car table))
                    (element-value (car table))
                    (if (null? (element-car (car table)))
                        null
                        (list (car (element-car (car table))) (- (cadr (element-car (car table))) 1)))
                    (if (null? (element-cdr (car table)))
                        null
                        (list (car (element-cdr (car table))) (- (cadr (element-cdr (car table))) 1)))))
                   (col-compression (cdr table) new-table last-col #t (element-row (car table)) (element-column (car table)))))
                 (append
                  new-table
                  (append
                   (list (car table))
                   (col-compression (cdr table) new-table (element-column (car table)) #f found-at-row found-at-col))))))))