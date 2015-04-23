#lang racket

(require racket/gui/base)
(require racket/draw)
(require "Data-Structure-GUI-Core.rkt")

(provide ds-gui)
(define (ds-gui data-structure)
  
  ;Core variables
  (define gui-core (data-structure-core data-structure))
  (define elements (get-element-list (gui-core 'peek-table)))
  
  (define tools-frame (new frame% 
                           [label "Editing Tools"]
                           [x 0]
                           [y 0]))
  
    (define gui-frame (new frame% 
                           [label "Editing Tools"]
                           [x 0]
                           [y 0]))
  
  (define viewer-frame (new frame%
                            [label "DS Viewer"]
                            [x 350]
                            [y 0]))
    
  ;GUI components
  (define gui-panel (new vertical-panel% [parent gui-frame]))
  (define view-panel (new vertical-panel% [parent gui-panel] [alignment (list 'center 'center)]))
  (define view-button-panel (new horizontal-panel% [parent view-panel] [alignment (list 'center 'center)]))
  (define editor-panel (new vertical-panel% [parent gui-panel] [alignment (list 'center 'center)]))
  (define edit-button-panel (new horizontal-panel% [parent editor-panel] [alignment (list 'center 'center)]))
  (define editor-tools (new vertical-panel%
                            [parent editor-panel]
                            [min-width 280]
                            [alignment (list 'center 'top)]))
  (define editor-tools-selector (new vertical-panel% [parent editor-tools] [alignment (list 'center 'center)]))
  (define selector-message (new message% (parent editor-tools-selector) (label "Select Element:")))
  (define editor-tools-buttons (new vertical-panel% [parent editor-tools] [alignment (list 'center 'center)]))
  (define button-message (new message% (parent editor-tools-buttons) (label "Replace With:")))
  (define editor-tools-buttons-top (new horizontal-panel% [parent editor-tools-buttons] [alignment (list 'center 'center)]))
  (define editor-tools-buttons-bottom (new horizontal-panel% [parent editor-tools-buttons] [alignment (list 'center 'center)]))
  (define editor-data (new vertical-panel% [parent editor-panel] [alignment (list 'center 'center)]))
  (define data-message (new message% (parent editor-data) (label "Edit Data:")))
  
  (define data-panel (new vertical-panel% 
                            [parent viewer-frame]
                            [border 2]
                            [alignment (list 'center 'top)]))
  
  (define canvas (new bitmap-canvas%
                      [parent data-panel]
                      [min-width (+ 2 (send (gui-core 'peek-target) get-width))]
                      [min-height (+ 2(send (gui-core 'peek-target) get-height))]
                      [bitmap (gui-core 'peek-target)]))
  
  (define combo-field (new combo-field%
                         (label "")
                         (parent editor-tools-selector)
                         (choices elements)
                         (init-value (car elements))))
  
  (define text-field (new text-field%
                        (label "")
                        (parent editor-data)
                        (init-value "Null")))

  
  (new button% [parent editor-tools-buttons-top]
       [label "Node"]
       [min-width 110]
       [callback (lambda (x y) null)])
    
  (new button% [parent editor-tools-buttons-top]
       [label "Data Element"]
       [min-width 110]
       [callback (lambda (x y) null)])
  
  (new button% [parent editor-tools-buttons-bottom]
       [label "Terminal-Node"]
       [min-width 110]
       [callback (lambda (x y) null)])
  
  (new button% [parent editor-tools-buttons-bottom]
       [label "Bypass-Node"]
       [min-width 110]
       [callback (lambda (x y) null)])
  
  (new button% [parent view-button-panel]
       [label "Edit"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin 
                     (send view-panel show #f)
                     (send editor-panel show #t)
                     (gui-core 'draw-enclosed)
                     (draw-viewer-frame)))])
  
  (new button% [parent view-button-panel]
       [label "Exit"]
       [min-width 110]
       [callback (lambda (button event)
                   null)])
  
  (new button% [parent edit-button-panel]
       [label "Save"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (send view-panel show #t)
                     (send editor-panel show #f)
                     (gui-core 'draw)
                     (draw-viewer-frame)))])
  
  (new button% [parent edit-button-panel]
       [label "Cancel"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (send view-panel show #t)
                     (send editor-panel show #f)
                     (gui-core 'draw)
                     (draw-viewer-frame)))])

  (define (draw-viewer-frame)
    (if (not (null? (send data-panel get-children)))
        (send data-panel delete-child (car (send data-panel get-children)))
        null)
    (define canvas (new bitmap-canvas%
                        [parent data-panel]
                        [min-width (+ 2 (send (gui-core 'peek-target) get-width))]
                        [min-height (+ 2(send (gui-core 'peek-target) get-height))]
                        [bitmap (gui-core 'peek-target)]))
    (send viewer-frame show #t)
    #t)
  (send editor-panel show #f)
  (send viewer-frame show #t)
  (send gui-frame show #t))

  
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
               
(define (get-element-list table)
  (if(null? table)
     null
     (if (not (or
              (eqv? (caddr (car table)) 'down-arrow)
              (eqv? (caddr (car table)) 'down-line)
              (eqv? (caddr (car table)) 'right-arrow)
              (eqv? (caddr (car table)) 'right-line)))
         (begin
           (cons
            (string-append
             "("
             (number->string (car (car table)))
             ", "
             (number->string (cadr (car table)))
             ") "
             (symbol->string (caddr (car table))))
            (get-element-list (cdr table))))
         (get-element-list (cdr table)))))