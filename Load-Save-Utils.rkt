#lang racket

(require "Table-Core-Utils.rkt")
(require "Table-Sorting.rkt")

;Merge this and 
(provide list-loader)
(define (list-loader lst)
  (define table (load-list-helper lst 0 0 0 0 1 1))
  (table-sort table '() (table-row-count table) (table-col-count table)))

;Separate for debugging, will combine into master list loader
(provide list-loader-two)
(define (list-loader-two table lst)
  (define table2 (load-list-helper lst 0 0 0 0 (table-row-count table) (table-col-count table)))
  (table-sort table2 '() (table-row-count table2) (table-col-count table2)))

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