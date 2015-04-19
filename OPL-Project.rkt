#lang racket

(require racket/gui)
(require "Data-Structure-GUI-Core.rkt")
(require "Diagram-Components.rkt")
(require "Diagram-Drawing.rkt")
(require "Load-Save-Utils.rkt")
(require "Table-Core-Utils.rkt")
(require "Table-Optimization.rkt")
(require "Table-Sorting.rkt")
(require "Scratchpad.rkt")

(define ds (list (list "Ford" "F150" "$20k") (list "Chevy" "Silverado" "$22k") (list "Dodge" "Ram" "$15k")))
(define tab (sort-table-rows (build-table ds null 0 0 0 0 'right)))
(define test-target (make-target tab))
(define test-dc (make-dc test-target))
(draw-table tab test-dc)

(define gui-core (data-structure-core ds))