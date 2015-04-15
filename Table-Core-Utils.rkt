#lang racket

;Returns a new table entry with the suplied data
(provide new-entry)
(define (new-entry row col type parent-row parent-col value car-row car-col cdr-row cdr-col)
  (list row col type (list parent-row parent-col) value
        (if (or (= car-row -1) (= car-col -1))
            null
            (list car-row car-col))
        (if (or (= cdr-row -1) (= cdr-col -1))
            null
            (list cdr-row cdr-col))))

(provide replace-entry)
(define (replace-entry table row col new-ent)
  (define (replace-entry-helper table new-table row col new-ent)
    (cond ((null? table) null)
          ((and (pair? table) (= (element-row (car table)) row) (= (element-column (car table)) col))
           (append
            new-table
            (append
             (list new-ent)
             (cdr table))))
          (else
           (append
            new-table
            (append
             (list (car table))
             (replace-entry-helper (cdr table) new-table row col new-ent))))))
  (replace-entry-helper table null row col new-ent))

;Return a table entry at entry-number
(provide table-entry)
(define (table-entry entry-num table)
  (if (= 0 entry-num)
      (if (pair? table)
          (car table)
          null)
      (table-entry (- entry-num 1) (cdr table))))

;Return the row cell for a table entry
(provide element-row)
(define (element-row table-element)
  (car table-element))

;Return a column cell for a table entry
(provide element-column)
(define (element-column table-element)
  (cadr table-element))

;Return an element type for a table entry
;data, node, bypass-node, etc
(provide element-type)
(define (element-type table-element)
  (caddr table-element))

;Provide parent row and column as a list
;for a table entry
(provide element-parent)
(define (element-parent table-element)
  (cadddr table-element))

;Provide element value for table entries
;of type data
(provide element-value)
(define (element-value table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr table-element))))))

;Provide the car information for table
;entries of any type of node. List of
;child row and column
(provide element-car)
(define (element-car table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr
       (cdr table-element)))))))

;Provide the cdr information for table
;entries of any type of node. List of
;child row and column
(provide element-cdr)
(define (element-cdr table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr
       (cdr
        (cdr table-element))))))))

;Provides the number of cols in the table
(provide table-col-count)
(define (table-col-count table)
  (+ 1 (table-col-count-helper table 0)))

(define (table-col-count-helper table max-found)
  (if (pair? table)
      (if (> (element-column (car table)) max-found)
          (table-col-count-helper (cdr table) (element-column (car table)))
          (table-col-count-helper (cdr table) max-found))
      max-found))

;Provides the number of rows in the table
(provide table-row-count)
(define (table-row-count table)
  (+ 1 (table-row-count-helper table 0)))

(define (table-row-count-helper table max-found)
  (if (pair? table)
      (if (> (element-row (car table)) max-found)
          (table-row-count-helper (cdr table) (element-row (car table)))
          (table-row-count-helper (cdr table) max-found))
      max-found))