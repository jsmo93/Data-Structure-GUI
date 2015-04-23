#lang racket

(require "Table-Core-Utils.rkt")

(provide replace-data-entry)
(define (replace-data-entry table value entry)
  (replace-entry table (element-row entry) (element-col entry) 
                 (new-entry (element-row entry)
                             (element-col entry)
                             (element-type entry)
                             (car (element-parent entry))
                             (cadr (element-parent entry))
                             value
                             -1
                             -1
                             -1
                             -1)))

(provide replace-node-entry)
(define (replace-node-entry table value entry)
  (null))