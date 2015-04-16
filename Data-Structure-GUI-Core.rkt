#lang racket

(require "Diagram-Components.rkt")
(require "Diagram-Drawing.rkt")
(require "Load-Save-Utils.rkt")
(require "Table-Core-Utils.rkt")
(require "Table-Optimization.rkt")
(require "Table-Sorting.rkt")

(provide data-structure-core)
(define (data-structure-core data-structure)
  (define master-ds null)
  (define master-table null)
  (define master-target null)
  (define master-dc null)
  
  (define (load-data-structure)
    (define table-uc (load-list master-ds))
    (define table-c
      (sort-table-rows
       (compress-cols
        (sort-table-cols
         (compress-rows
          table-uc)))))
    (set! uncompressed-table table-uc)
    (set! master-table table-c))
  
  (define (draw-data-structure)
    (set! master-target (make-target master-table))
    (set! master-dc (make-dc master-target))
    (draw-table master-table master-dc))
  
  (define (draw-enclosed-data-structure)
    (set! master-target (make-target master-table))
    (set! master-dc (make-dc master-target))
    (draw-enclosed-table master-table master-dc))
  
  (define (save-data-structure)
   (define new-ds (save-helper master-table (table-entry-rc 0 0 master-table)))
    (set! master-ds new-ds)
    new-ds)
  
  (define (display-help)
    (begin
      (write "Supported Commands:")
      (newline)
      (write "draw - Draws the data structure")
      (newline)
      (write "draw-enclosed - Draws the data structure with gridlines")
      (newline)
      (write "save - Saves the data structure and returns it")
      (newline)))
  
  (define (dispatch m)
    (cond ((eq? m 'draw) (begin (draw-data-structure) master-target))
          ((eq? m 'draw-enclosed) (begin (draw-enclosed-data-structure) master-target))
          ((eq? m 'draw-uncompressed) (begin (draw-uncompressed-data-structure) uncompressed-target))
          ((eq? m 'draw-enclosed-uncompressed) (begin (draw-enclosed-uncompressed-data-structure) uncompressed-target))
          ((eq? m 'help) (display-help))
          ((eq? m 'load) (load-data-structure))
          ((eq? m 'peek-table) master-table)
          ((eq? m 'peek-ds) master-ds)
          ((eq? m 'peek-uncompressed) uncompressed-table)
          ((eq? m 'save) (save-data-structure))
          (else (error "Unknown request: MAKE-ACCOUNT"
                       m))))
    
  ;Debugging structures
  (define uncompressed-table null)
  (define uncompressed-target null)
  (define uncompressed-dc null)
  
  (define (draw-uncompressed-data-structure)
    (set! uncompressed-target (make-target uncompressed-table))
    (set! uncompressed-dc (make-dc uncompressed-target))
    (draw-table uncompressed-table uncompressed-dc))
  
  (define (draw-enclosed-uncompressed-data-structure)
    (set! uncompressed-target (make-target uncompressed-table))
    (set! uncompressed-dc (make-dc uncompressed-target))
    (draw-enclosed-table uncompressed-table uncompressed-dc))
  
  (set! master-ds data-structure)
  (load-data-structure)
  dispatch)
