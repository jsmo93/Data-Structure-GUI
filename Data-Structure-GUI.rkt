#lang racket

(require racket/gui/base)
(require racket/draw)
(require "Data-Structure-GUI-Core.rkt")

(define outside null)

(provide ds-gui)
(define (ds-gui data-structure)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; GUI data structures
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Core variables, store state of user interface
  (define gui-core (data-structure-core data-structure))
  (define element-strings (get-element-strings (gui-core 'peek-table)))
  (define elements (dmap element-strings (get-element-list (gui-core 'peek-table))))
  (define node-selected null)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; GUI components
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Main frames
  (define tools-frame (new frame% [label "Editing Tools"] [x 0] [y 0]))
  (define viewer-frame (new frame% [label "DS Viewer"] [x 350] [y 0]))
    
  ;GUI panels
  (define tools-panel (new vertical-panel% [parent tools-frame]))
  (define data-panel (new vertical-panel% [parent viewer-frame] [border 2] [alignment (list 'center 'top)]))
  
  (define view-panel (new vertical-panel% [parent tools-panel] [alignment (list 'center 'center)]))
  (define editor-panel (new vertical-panel% [parent tools-panel] [alignment (list 'center 'center)]))
  
  (define view-button-panel (new horizontal-panel% [parent view-panel] [alignment (list 'center 'center)]))
  (define edit-button-panel (new horizontal-panel% [parent editor-panel] [alignment (list 'center 'center)]))
  (define editor-tools (new vertical-panel% [parent editor-panel] [min-width 280] [alignment (list 'center 'center)]))
  (define editor-data (new vertical-panel% [parent editor-panel] [alignment (list 'center 'center)]))
  
  (define selector-message (new message% [parent editor-tools] [label "Select Data Element:"]))
  (define editor-tools-combobox (new vertical-panel% [parent editor-tools]))
  (define data-message (new message% [parent editor-data] [label "Edit Data:"]))
  
  ;GUI fields
  (define canvas (new bitmap-canvas%
                      [parent data-panel]
                      [min-width (+ 2 (send (gui-core 'peek-target) get-width))]
                      [min-height (+ 2(send (gui-core 'peek-target) get-height))]
                      [bitmap (gui-core 'peek-target)]))
  
  (define combo-field (new combo-field%
                         [label ""]
                         [parent editor-tools-combobox]
                         [choices element-strings]
                         [callback (lambda (button event) (refresh-node-selected))]             
                         [init-value (car element-strings)]))
  
  (define text-field (new text-field%
                        [label ""]
                        [parent editor-data]
                        [callback (lambda (button event)
                                      (draw-viewer-frame
                                       (gui-core 'replace-data (send text-field get-value) node-selected)))]
                        [init-value "Null"]))
  
  ;GUI buttons
  ;Edit button
  (new button%
       [parent view-button-panel]
       [label "Edit"]
       [min-width 220]
       [callback (lambda (button event)
                   (begin 
                     (send view-panel show #f)
                     (send editor-panel show #t)
                     (refresh-node-selected)
                     (gui-core 'draw-enclosed)
                     (draw-viewer-frame (gui-core 'peek-target))))])
  ;Save button
  (new button% 
       [parent edit-button-panel]
       [label "Save"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (send view-panel show #t)
                     (send editor-panel show #f)
                     (gui-core 'save)
                     (gui-core 'draw)
                     (set! element-strings (get-element-strings (gui-core 'peek-table)))
                     (set! elements (dmap element-strings (get-element-list (gui-core 'peek-table))))
                     (send editor-tools-combobox delete-child (car (send editor-tools-combobox get-children)))
                     (set! combo-field (new combo-field%
                                            (label "")
                                            (parent editor-tools-combobox)
                                            (choices element-strings)
                                            [callback (lambda (button event)
                                                        (refresh-node-selected))]
                                            (init-value (car element-strings))))
                     (send combo-field set-value (car element-strings))
                     (refresh-node-selected)
                     (draw-viewer-frame (gui-core 'peek-target))))])
  ;Cancel button
  (new button%
       [parent edit-button-panel]
       [label "Cancel"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (send view-panel show #t)
                     (send editor-panel show #f)
                     (gui-core 'load)
                     (gui-core 'draw)
                     (send combo-field set-value (car element-strings))
                     (refresh-node-selected)
                     (draw-viewer-frame (gui-core 'peek-target))))])
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Dispatch procedure
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (define (dispatch m [replace-with null] [replace-entry null])
    (cond ((eqv? m 'exit)
           (begin
             (send viewer-frame show #f)
             (send tools-frame show #f)))
          ((eqv? m 'help)
           (begin
             (write "Supported Commands:")
             (newline)
             (write "start - Opens DS-GUI")
             (newline)
             (write "save - Outputs the current data structure")
             (newline)
             (write "exit - Closes DS-GUI")
             (newline)))
          ((eqv? m 'save) (gui-core 'peek-ds))
          ((eqv? m 'start)
           (begin
             (send viewer-frame show #t)
             (send tools-frame show #t)))                        
          (else (error "Unknown request: "
                       m))))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Internal helper procedures
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Redraws what's in the ds viewer window
  (define (draw-viewer-frame btmp)
    (if (not (null? (send data-panel get-children)))
        (send data-panel delete-child (car (send data-panel get-children)))
        null)
    (define canvas (new bitmap-canvas%
                        [parent data-panel]
                        [min-width (+ 2 (send btmp get-width))]
                        [min-height (+ 2(send btmp get-height))]
                        [bitmap btmp]))
    (send viewer-frame show #t)
    #t)
  
  ;Update the value in the text box and the state variable
  ;for the combo box
  (define (refresh-node-selected)
    (begin
      (set!
       node-selected
       (get-node-selected (send combo-field get-value) elements))
      (if (null?
           (car
            (cdr
             (cdr
              (cdr
               (cdr node-selected))))))
          (begin
            (send editor-data show #f)
            (send data-message show #f))
          (begin
            (send editor-data show #t)
            (send data-message show #t)
            (send text-field set-value
                  (cond ((number? (car
                                   (cdr
                                    (cdr
                                     (cdr
                                      (cdr node-selected))))))
                         (number->string (car
                                          (cdr
                                           (cdr
                                            (cdr
                                             (cdr node-selected)))))))
                        ((string? (car
                                   (cdr
                                    (cdr
                                     (cdr
                                      (cdr node-selected))))))
                         (car
                          (cdr
                           (cdr
                            (cdr
                             (cdr node-selected))))))
                        ((symbol? (car
                                   (cdr
                                    (cdr
                                     (cdr
                                      (cdr node-selected))))))
                         (symbol->string (car
                                          (cdr
                                           (cdr
                                            (cdr
                                             (cdr node-selected)))))))))))))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Initial tasks
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (set! node-selected (get-node-selected (send combo-field get-value) elements))
  (send editor-panel show #f)
  (send viewer-frame show #f)
  (send tools-frame show #f)
  dispatch)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; External helper procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Bitmap-Canvas courtesy of stackoverflow
(define bitmap-canvas%
  (class canvas%
    (init-field [bitmap #f])
    (inherit get-dc)
    (define/override (on-paint)
      (send (get-dc) draw-bitmap bitmap 0 0))
    (define/public (set-bitmap new-bitmap)
      (set! bitmap new-bitmap))
    (define/public (repaint)
      (send (get-dc) draw-bitmap bitmap 0 0))
    (super-new)))

;Get a list of strings composed of data elements, their positions, and values
(define (get-element-strings table)
  (define val null)
  (if (null? table)
      null
      (if (eqv? (caddr (car table)) 'data)
          (begin
            (set! val (car (cdr (cdr (cdr (cdr (car table)))))))
            (cons
             (string-append
              "("
              (number->string (car (car table)))
              ", "
              (number->string (cadr (car table)))
              ") -> "
              (cond((number? val) (number->string val))
                   ((symbol? val) (symbol->string val))
                   ((string? val) val)))
             (get-element-strings (cdr table))))
          (get-element-strings (cdr table)))))

;Get the list of data elements themselves
(define (get-element-list table)
  (if(null? table)
     null
     (if (eqv? (caddr (car table)) 'data)
         (begin
           (cons
            (car table)
            (get-element-list (cdr table))))
         (get-element-list (cdr table)))))

;Used to combine the data strings and elements
(define (dmap l1 l2)
  (if (or (null? l1) (null? l2))
      null
      (cons (cons (car l1) (car l2))
            (dmap (cdr l1) (cdr l2)))))

;Get the currently selected node from the combobox
;and find the corresponding element
(define (get-node-selected str elements)
  (cond ((null? elements) null)
        ((equal? str (car (car elements))) (cdr (car elements)))
        (else (get-node-selected str (cdr elements)))))