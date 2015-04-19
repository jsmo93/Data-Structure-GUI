#lang racket

(require racket/gui)
(require "Data-Structure-GUI-Core.rkt")

(define ds (list (list (list 1 2 3 "Ford") (list 1 2 3 "Ford"))
                 (list (list 1 2 3 "Ford") (list 1 2 3 "Ford"))))
(define gui-core (data-structure-core ds))