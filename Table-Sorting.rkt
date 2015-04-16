#lang racket

(require "Table-Core-Utils.rkt")

(define sorted-table '())
(define sub-sorted-table '())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table sorting functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Sort table by rows
(provide sort-table-rows)
(define (sort-table-rows table)
  (table-sort-helper table sorted-table (count-rows table) (count-cols table) 0))

;Sort table by columns
(provide sort-table-cols)
(define (sort-table-cols table)
  (define sub-sorted-table null)
  (table-sort-helper-flip table sorted-table (count-rows table) (count-cols table) 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Sort table by row helper
(define (table-sort-helper table sorted-table row-count col-count current-row)
  (define (row-filter-helper entry)
    (if (= (element-row entry) current-row)
        #t
        #f))
  (if (= row-count current-row)
      sorted-table
      (table-sort-helper table
                  (append sorted-table
                          (sub-sort
                           (filter row-filter-helper table)
                           sub-sorted-table col-count 0))
                  row-count
                  col-count
                  (+ current-row 1))))

;Sort table by row helper
(define (sub-sort table sorted-table col-count current-col)
  (define (col-filter-helper entry)
    (if (= (element-col entry) current-col)
        #t
        #f))
  (if (= col-count current-col)
      sorted-table
      (sub-sort table (append sorted-table (filter col-filter-helper table)) col-count (+ current-col 1))))

;Sort table by column helper
(define (table-sort-helper-flip table sorted-table row-count col-count current-col)
  (define (col-filter-helper-flip entry)
    (if (= (element-col entry) current-col)
        #t
        #f))
  (if (= col-count current-col)
      sorted-table
      (table-sort-helper-flip table
                              (append sorted-table
                                      (sub-sort-flip
                                       (filter col-filter-helper-flip table)
                                       sub-sorted-table row-count 0))
                              row-count
                              col-count
                              (+ current-col 1))))

;Sort table by column helper
(define (sub-sort-flip table sorted-table row-count current-row)
  (define (row-filter-helper-flip entry)
    (if (= (element-row entry) current-row)
        #t
        #f))
  (if (= row-count current-row)
      sorted-table
      (sub-sort-flip table (append sorted-table (filter row-filter-helper-flip table)) row-count (+ current-row 1))))