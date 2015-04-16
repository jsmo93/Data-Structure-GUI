#lang racket

(require "Diagram-Components.rkt")
(require "Diagram-Drawing.rkt")
(require "Load-Save-Utils.rkt")
(require "Table-Core-Utils.rkt")
(require "Table-Optimization.rkt")
(require "Table-Sorting.rkt")

(define master-ds null)
(define master-table null)
(define master-target null)
(define master-dc null)

(provide load)
(define (load data-structure)
  (define initial-table (load-list data-structure))
  (define table-compress-rows (compress-rows initial-table))
  (define table-col-sort (sort-table-cols
                          table-compress-rows
                          null
                          (table-row-count table-compress-rows)
                          (table-col-count table-compress-rows)))
  (define tabfinal (sort-table-rows
                    (compress-cols table-col-sort)
                    null
                    (table-row-count table-col-sort)
                    (table-col-count table-col-sort)))
  (set! master-table tabfinal)
  master-target)

(provide draw)
(define (draw)
  (set! master-target (make-target (table-row-count master-table) (table-col-count master-table)))
  (set! master-dc (make-dc master-target))
  (draw-table master-table master-dc))

(provide draw-enclosed)
(define (draw-enclosed)
  (set! master-target (make-target (table-row-count master-table) (table-col-count master-table)))
  (set! master-dc (make-dc master-target))
  (draw-enclosed-table master-table master-dc))

(provide save)
(define (save)
  (save-helper master-table (table-entry-rc 0 0 master-table)))