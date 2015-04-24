#lang racket

(require racket/gui)
(require "Data-Structure-GUI.rkt")
(require "Templates.rkt")

(define ds beer-template)

(define gui (ds-gui ds))
(gui 'help)
(write "Ex: (gui 'start)")
(newline)