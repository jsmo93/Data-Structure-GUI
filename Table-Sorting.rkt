#lang racket

(require "Table-Core-Utils.rkt")

(define sorted-table '())
(define sub-sorted-table '())

;Main sorting function
(provide table-sort)
(define (table-sort table sorted-table row-count col-count)
  (table-sort-helper table sorted-table row-count col-count 0))

;Helper function, sort by row
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

;Helper function, sort by column
(define (sub-sort table sorted-table col-count current-col)
  (define (col-filter-helper entry)
    (if (= (element-column entry) current-col)
        #t
        #f))
  (if (= col-count current-col)
      sorted-table
      (sub-sort table (append sorted-table (filter col-filter-helper table)) col-count (+ current-col 1))))

;Internal sorting function for compression
(provide table-sort-flip)
(define (table-sort-flip table sorted-table row-count col-count)
  (define sub-sorted-table null)
  (table-sort-helper-flip table sorted-table row-count col-count 0))

;Helper function, sort by column
(define (table-sort-helper-flip table sorted-table row-count col-count current-col)
  (define (col-filter-helper-flip entry)
    (if (= (element-column entry) current-col)
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

;Helper function, sort by row
(define (sub-sort-flip table sorted-table row-count current-row)
  (define (row-filter-helper-flip entry)
    (if (= (element-row entry) current-row)
        #t
        #f))
  (if (= row-count current-row)
      sorted-table
      (sub-sort-flip table (append sorted-table (filter row-filter-helper-flip table)) row-count (+ current-row 1))))