#lang racket
(require "Diagram-Components.rkt")
(require "Table-Core-Utils.rkt")
(require racket/draw)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Drawing procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Make target based on expected grid size
(provide make-target)
(define (make-target table)
  (make-bitmap (* 55 (count-cols table)) (* 40 (count-rows table))))

;Make the bitmap for the target
(provide make-dc)
(define (make-dc target)
  (new bitmap-dc% [bitmap target]))

;Top level drawing function
(provide draw-table)
(define (draw-table table dc)
  (draw-table-elements table 0 dc))

;Top level drawing function - debugging/visualization aid
(provide draw-enclosed-table)
(define (draw-enclosed-table table dc)
  (draw-table-enclosures table 0 0 dc)
  (draw-table-elements table 0 dc))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Draw enclosure grid first, then elements on top
(define (draw-table-enclosures table current-row  current-col dc)
  (draw-node
   dc
   enclosure
   current-row
   current-col)
  (if (= current-col (- (count-cols table) 1))
      (if (= current-row (- (count-rows table) 1))
          null
          (draw-table-enclosures table (+ current-row 1) 0 dc))
      (draw-table-enclosures table current-row (+ current-col 1) dc)))

;Iterate through the table and draw each element
(define (draw-table-elements table current-entry dc)
  (define this-entry (table-entry current-entry table))
  (cond ((null? table) null)
        ((pair? table) 
           (if (null? this-entry)
               null
               (begin
                 (cond ((eqv? (element-type this-entry) 'data)
                        (draw-data
                         dc
                         (element-value this-entry)
                         (element-row this-entry)
                         (element-col this-entry)))
                       (else 
                        (draw-node
                         dc
                         (type-to-path (element-type this-entry))
                         (element-row this-entry)
                         (element-col this-entry))))
                 (draw-table-elements table (+ current-entry 1) dc))))))

;Function to draw a specific node in a given cell of the grid
(define (draw-node dc path row col)
  (send dc draw-path path (* 55 col) (* 40 row)))

;Function to dynamically draw the first 5 characters of data
;  in a given cell of the grid.
(define (draw-data dc data-str row col)
  (define old-font (send dc get-font))
  (if (number? data-str)
      (begin 
         (set! data-str (number->string data-str))
         (cond ((= (string-length data-str) 1) 
                (send dc draw-path data (* 55 col) (* 40 row))
                (send dc draw-text data-str (+ 3 (* 55 col)) (- (* 40 row) 1)))
               ((< (string-length data-str) 6)
                (send dc draw-rectangle (* 55 col) (* 40 row) (+ 2 (* 10 (string-length data-str))) 16)
                (send dc draw-text data-str (+ 1 (* 55 col)) (- (* 40 row) 1)))
               (else
                (begin (send dc draw-rectangle (* 55 col) (* 40 row) 53 16))
                (send dc draw-text (substring data-str 0 4) (+ 1 (* 55 col)) (- (* 40 row) 1))
                (send dc draw-text ".." (+ 41 (* 55 col)) (- (* 40 row) 1))))
         (set! data-str (string->number data-str)))
      (begin
       (send dc set-font (make-font #:size 12 #:family 'modern)) ;Use a constant width font
       (cond ((= (string-length data-str) 1) 
              (send dc draw-path data (* 55 col) (* 40 row))
              (send dc draw-text data-str (+ 3 (* 55 col)) (- (* 40 row) 1)))
             ((< (string-length data-str) 6)
              (send dc draw-rectangle (* 55 col) (* 40 row) (+ 2 (* 10 (string-length data-str))) 16)
              (send dc draw-text data-str (+ 1 (* 55 col)) (- (* 40 row) 1)))
             (else
              (begin (send dc draw-rectangle (* 55 col) (* 40 row) 53 16))
              (send dc draw-text (substring data-str 0 4) (+ 1 (* 55 col)) (- (* 40 row) 1))
              (send dc set-font old-font)
              (send dc draw-text ".." (+ 41 (* 55 col)) (- (* 40 row) 1))))
         (send dc set-font old-font))))

;Helper function for table -> diagram conversion
(define (type-to-path type)
  (cond ((eqv? type 'node) node)
        ((eqv? type 'bypass-node) bypass-node)
        ((eqv? type 'terminal-node) terminal-node)
        ((eqv? type 'null-node) null-node)
        (else null)))

;Helper function for initial list -> table conversion
(define (element-categorizer elmnt)
  (cond ((pair? elmnt)
         (cond ((null? (car elmnt))
                (if (null? (cdr elmnt))
                    'null-node
                    'bypass-node))
               ((null? (cdr elmnt)) 'terminal-node)
               (else 'node)))
        ((null? elmnt) 'null)
        (else 'data)))