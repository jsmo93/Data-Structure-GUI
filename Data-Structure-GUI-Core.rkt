#lang racket

(require "Diagram-Drawing.rkt")
(require "Table-Deconstruction.rkt")
(require "Table-Construction.rkt")

(provide data-structure-core)
(define (data-structure-core data-structure)
  (define master-ds null)
  (define master-table null)
  (define master-target null)
  (define master-dc null)
  
  (define (load-data-structure)
    (set! master-table (build-table master-ds)))
  
  (define (draw-data-structure)
    (set! master-target (make-target master-table))
    (set! master-dc (make-dc master-target))
    (draw-table master-table master-dc))
  
  (define (draw-enclosed-data-structure)
    (set! master-target (make-target master-table))
    (set! master-dc (make-dc master-target))
    (draw-enclosed-table master-table master-dc))
  
  (define (save-data-structure)
    (set! master-ds (build-list master-table)))
  
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
  
  (define (dispatch m)
    (cond ((eq? m 'draw) (begin (draw-data-structure) master-target))
          ((eq? m 'draw-enclosed) (begin (draw-enclosed-data-structure) master-target))
          ((eq? m 'help) (display-help))
          ((eq? m 'load) (load-data-structure))
          ((eq? m 'peek-table) master-table)
          ((eq? m 'peek-ds) master-ds)
          ((eq? m 'save) (save-data-structure))
          (else (error "Unknown request: "
                       m))))
  
  (set! master-ds data-structure)
  (load-data-structure)
  dispatch)
