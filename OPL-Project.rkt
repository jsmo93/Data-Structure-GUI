#lang racket

(require racket/gui)
(require "Data-Structure-GUI-Core.rkt")
(require "Diagram-Components.rkt")
(require "Diagram-Drawing.rkt")
(require "Load-Save-Utils.rkt")
(require "Table-Core-Utils.rkt")
(require "Table-Optimization.rkt")
(require "Table-Sorting.rkt")

(define ds (list (list 1 2) (list 3 4 5) 6))
(define gui-core (data-structure-core ds))