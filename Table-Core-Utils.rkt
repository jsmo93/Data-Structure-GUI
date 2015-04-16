#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table manipulation procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Provides the number of cols in the table
(provide count-cols)
(define (count-cols table)
  (+ 1 (table-col-count-helper table 0)))

;Provides the number of rows in the table
(provide count-rows)
(define (count-rows table)
  (+ 1 (table-row-count-helper table 0)))

;Replace a table entry with a new entry
(provide replace-entry)
(define (replace-entry table row col new-ent)
  (define (replace-entry-helper table new-table row col new-ent)
    (cond ((null? table) null)
          ((and (pair? table) (= (element-row (car table)) row) (= (element-col (car table)) col))
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table helper procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (table-col-count-helper table max-found)
  (if (pair? table)
      (if (> (element-col (car table)) max-found)
          (table-col-count-helper (cdr table) (element-col (car table)))
          (table-col-count-helper (cdr table) max-found))
      max-found))

(define (table-row-count-helper table max-found)
  (if (pair? table)
      (if (> (element-row (car table)) max-found)
          (table-row-count-helper (cdr table) (element-row (car table)))
          (table-row-count-helper (cdr table) max-found))
      max-found))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table accessors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Return a table entry at entry-number
(provide table-entry)
(define (table-entry entry-num table)
  (if (= 0 entry-num)
      (if (pair? table)
          (car table)
          null)
      (table-entry (- entry-num 1) (cdr table))))

;Return a table entry with a given row and column number
(provide table-entry-rc)
(define (table-entry-rc row col table)
  (cond ((null? table) null)
        ((not (pair? table)) null)
        ((and (= (element-row (car table)) row) (= (element-col (car table)) col)) (car table))
        (else (table-entry-rc row col (cdr table)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Constructor for table entry
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table entry accessors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Return the row cell for a table entry
(provide element-row)
(define (element-row table-element)
  (car table-element))

;Return a column cell for a table entry
(provide element-col)
(define (element-col table-element)
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