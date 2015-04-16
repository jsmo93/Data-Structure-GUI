#lang racket

(require racket/gui)
(require "Diagram-Components.rkt")
(require "Diagram-Drawing.rkt")
(require "Load-Save-Utils.rkt")
(require "Table-Core-Utils.rkt")
(require "Table-Optimization.rkt")
(require "Table-Sorting.rkt")

(define ds (list (list 1 2) (list 3 4 5) 6))
(define uncompressed-table (load-list ds))
(define compressed-table
  (sort-table-rows
   (compress-cols
    (sort-table-cols
     (compress-rows
      (load-list ds))))))

(define uc-target (make-target uncompressed-table))
(define c-target (make-target compressed-table))
(define uc-dc (make-dc uc-target))
(define c-dc (make-dc c-target))

(draw-enclosed-table uncompressed-table uc-dc)
(draw-enclosed-table compressed-table c-dc)