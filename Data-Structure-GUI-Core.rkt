#lang racket

(require "Diagram-Drawing.rkt")
(require "Table-Deconstruction.rkt")
(require "Table-Construction.rkt")
(require "Table-Editing.rkt")

(provide data-structure-core)
(define (data-structure-core data-structure)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; GUI data structures
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;These structures hold the state of the whole program
  (define master-ds null)
  (define master-table null)
  (define master-target null)
  (define master-dc null)
  (define editing-ds null)
  (define editing-table null)
  (define editing-target null)
  (define editing-dc null)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; GUI core procedures
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Take the master data structure and build everything from it
  (define (load-data-structure)
    (set! master-table (build-table master-ds))
    (set! master-target (make-target master-table))
    (set! master-dc (make-dc master-target))
    (set! editing-ds (copy-struct master-ds))
    (set! editing-table (copy-struct master-table))
    (set! editing-target (make-target editing-table))
    (set! editing-dc (make-dc editing-target))
    (draw-table master-table master-dc))  
  
  ;Draw the master data structure onto the target bitmap
  (define (draw-data-structure)
    (set! master-target (make-target master-table))
    (set! master-dc (make-dc master-target))
    (draw-table master-table master-dc))
  
  ;Draw the master data structure with row, col gridlines
  (define (draw-enclosed-data-structure)
    (set! master-target (make-target master-table))
    (set! master-dc (make-dc master-target))
    (draw-enclosed-table master-table master-dc))
  
  ;Replace the data in a given cell with a given value
  (define (replace-data-data-structure value entry)
    (set! editing-table (replace-data-entry editing-table value entry))
    (set! editing-target (make-target editing-table))
    (set! editing-dc (make-dc editing-target))
    (draw-enclosed-table editing-table editing-dc)
    editing-target)
  
  ;Replace the master data structure with what the user has created
  (define (save-data-structure)
    (set! master-ds (build-list editing-table))
    (load-data-structure))
  
  ;Display the help output
  (define (display-help)
    (begin
      (write "Supported Commands:")
      (newline)
      (write "draw - Draws the data structure")
      (newline)
      (write "draw-enclosed - Draws the data structure with gridlines")
      (newline)
      (write "help - Print this help menu")
      (newline)
      (write "save - Saves the data structure and returns it")
      (newline)))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Dispatch procedure
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (define (dispatch m [replace-with null] [replace-entry null])
    (cond ((eq? m 'draw) (begin (draw-data-structure) master-target))
          ((eq? m 'draw-enclosed) (begin (draw-enclosed-data-structure) master-target))
          ((eq? m 'help) (display-help))
          ((eq? m 'load) (load-data-structure))
          ((eq? m 'peek-table) master-table)
          ((eq? m 'peek-target) master-target)
          ((eq? m 'peek-ds) master-ds)
          ((eq? m 'replace-data) (replace-data-data-structure replace-with replace-entry))
          ((eq? m 'save) (save-data-structure))
          (else (error "Unknown request: "
                       m))))
  
  (set! master-ds data-structure)
  (load-data-structure)
  dispatch)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; External helper procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (copy-struct table)
  (if (null? table)
      null
      (cons (car table)
            (copy-struct (cdr table)))))
