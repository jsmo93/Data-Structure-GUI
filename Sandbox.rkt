#lang racket

(require racket/gui)
(require "Data-Structure-GUI.rkt")

(define ds (list (list (list 1 2 3 "Ford") (list 1 2 3 "Ford"))
                 (list (list 1 2 3 "Ford") (list 1 2 3 "Ford"))))

(define gui (ds-gui ds))
(gui 'help)
(write "Ex: (gui 'start)")
(newline)