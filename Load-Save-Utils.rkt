#lang racket

(require "Table-Core-Utils.rkt")
(require "Table-Sorting.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load procedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Load a list into a table
(provide load-list)
(define (load-list lst)
  (define tab (list-loader-one lst))
  (list-loader-two tab lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calls the helper procedure with a spacing of 1
;Final spacing done in 
(define (list-loader-one lst)
  (define table (load-list-helper lst 0 0 0 0 1 1))
  (sort-table-rows table))

;Calls the helper procedure with the spacing required
;Uses the table from list-loader-one to determine this requirement
(define (list-loader-two table lst)
  (define table2 (load-list-helper lst 0 0 0 0 (count-rows table) (count-cols table)))
  (sort-table-rows table2))

;Helper procedure, create table with appropriate spacing
(define (load-list-helper lst current-row current-col parent-row parent-col max-row max-col)
  (if (pair? lst)
      (cond ((and (null? (car lst)) (null? (cdr lst)))
             (list 
             (list 
               current-row
               current-col
               'null-node
               (list parent-row parent-col)
               null
               null
               null)))
            ((null? (car lst))
              (append (list
                       (list
                       current-row
                       current-col
                       'bypass-node
                       (list parent-row parent-col)
                       null
                       null
                       (list current-row 
                             (if (= 0 current-row)
                                 (+ max-col current-col)
                                 (+ 1 current-col)))))
                      (load-list-helper (cdr lst) current-row 
                                 (if (= 0 current-row)
                                     (+ max-col current-col)
                                     (+ 1 current-col))
                                 current-row
                                 current-col
                                 max-row
                                 max-col)))
            ((null? (cdr lst))
              (append (list
                       (list
                       current-row
                       current-col
                       'terminal-node
                       (list parent-row parent-col)
                       null
                       (list (if (= 0 current-col)
                                 (+ 1 max-row)
                                 (+ 1 current-row))
                             current-col)
                       null))
                      (load-list-helper (car lst)
                                 (if (= 0 current-col)
                                     (+ max-row current-row)
                                     (+ 1 current-row))
                                 current-col
                                 current-row
                                 current-col
                                 max-row
                                 max-col)))
            (else 
             (append (list
                      (list
                       current-row
                       current-col
                       'node
                       (list parent-row parent-col)
                       null
                       (list (if (= 0 current-col)
                                 (+ max-row current-row)
                                 (+ 1 current-row))
                             current-col)
                       (list current-row 
                             (if (= 0 current-row)
                                 (+ max-col current-col)
                                 (+ 1 current-col)))))
                     (append
                      (load-list-helper (car lst)
                                 (if (= 0 current-col)
                                     (+ max-row current-row)
                                     (+ 1 current-row))
                                 current-col
                                 current-row
                                 current-col
                                 max-row
                                 max-col)
                      (load-list-helper (cdr lst)
                                 current-row
                                 (if (= 0 current-row)
                                     (+ max-col current-col)
                                     (+ 1 current-col))
                                 current-row
                                 current-col
                                 max-row
                                 max-col)))))
      (list (list current-row current-col 'data (list parent-row parent-col) lst null null))))

(provide save-helper)
 (define (save-helper table current-entry)
  (if (null? table)
     table
    (cond ((null? current-entry) null)
          ((eqv? (element-type current-entry) 'data)
           (element-value current-entry))
          ((eqv? (element-type current-entry) 'null-node)
           (cons null null))
          ((eqv? (element-type current-entry) 'terminal-node)
           (cons
            (save-helper table (table-entry-rc
                                (car (element-car current-entry))
                                (cadr (element-car current-entry))
                                table))
            null))
          ((eqv? (element-type current-entry) 'bypass-node)
           (cons
            null
            (save-helper table (table-entry-rc
                                (car (element-cdr current-entry))
                                (cadr (element-cdr current-entry))
                                table))))
          ((eqv? (element-type current-entry) 'node)
           (cons
            (save-helper table (table-entry-rc
                                (car (element-car current-entry))
                                (cadr (element-car current-entry))
                                table))
            (save-helper table (table-entry-rc
                                (car (element-cdr current-entry))
                                (cadr (element-cdr current-entry))
                                table))))
          (else null))))