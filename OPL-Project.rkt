#lang racket

(require racket/gui)
(require "Diagram-Components.rkt")
(require "Diagram-Drawing.rkt")
(require "Load-Save-Utils.rkt")
(require "Table-Core-Utils.rkt")
(require "Table-Optimization.rkt")
(require "Table-Sorting.rkt")

(define (paint-dc dc path target)
  (send dc draw-path path)
  (make-object image-snip% target))

(define (paint-dc-enclosed dc path target)
  (send dc draw-path enclosure)
  (send dc draw-path path)
  (make-object image-snip% target))


(define a (list (list 1 2) (list 3 4 5) (list 6 7)))
(define tab1 (list-loader a))
(define tab2 (list-loader-two tab1 a))
(define tab3 (compress-rows tab2))
(define tab4 (table-sort-flip tab3 null (table-row-count tab3) (table-col-count tab3)))
(define tabfinal (table-sort (compress-cols tab4) null (table-row-count tab4) (table-col-count tab4)))
(define test-target (make-target (table-row-count tab2) (table-col-count tab2)))
(define test-dc (make-dc test-target))