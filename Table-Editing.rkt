#lang racket

(require "Table-Core-Utils.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table editing procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Replace data in a given element with what the user specified
(provide replace-data-entry)
(define (replace-data-entry table value entry)
  (replace-entry table (element-row entry) (element-col entry) 
                 (new-entry (element-row entry)
                             (element-col entry)
                             (element-type entry)
                             (car (element-parent entry))
                             (cadr (element-parent entry))
                             (if (not(string->number value))
                                 value
                                 (string->number value))
                             -1
                             -1
                             -1
                             -1)))