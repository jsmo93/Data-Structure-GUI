#lang racket

(require "Table-Core-Utils.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; List building procedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide build-list)
(define (build-list table)
  (build-list-helper table (table-entry-rc 0 0 table)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Deconstruct a table into the corresponding list
 (define (build-list-helper table current-entry)
  (if (null? table)
     table
    (cond ((null? current-entry) null)
          ((eqv? (element-type current-entry) 'data)
           (element-value current-entry))
          ((eqv? (element-type current-entry) 'null-node)
           (cons null null))
          ((eqv? (element-type current-entry) 'terminal-node)
           (cons
            (build-list-helper table (table-entry-rc
                                (car (element-car current-entry))
                                (cadr (element-car current-entry))
                                table))
            null))
          ((eqv? (element-type current-entry) 'bypass-node)
           (cons
            null
            (build-list-helper table (table-entry-rc
                                (car (element-cdr current-entry))
                                (cadr (element-cdr current-entry))
                                table))))
          ((eqv? (element-type current-entry) 'node)
           (cons
            (build-list-helper table (table-entry-rc
                                (car (element-car current-entry))
                                (cadr (element-car current-entry))
                                table))
            (build-list-helper table (table-entry-rc
                                (car (element-cdr current-entry))
                                (cadr (element-cdr current-entry))
                                table))))
          (else null))))