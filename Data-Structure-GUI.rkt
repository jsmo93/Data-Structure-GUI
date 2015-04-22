#lang racket

(require racket/gui/base)
(require racket/draw)
(require "Data-Structure-GUI-Core.rkt")

(provide ds-gui)
(define (ds-gui data-structure)
  
  ;Core variables
  (define gui-core (data-structure-core data-structure))
  (define elements (get-element-list (gui-core 'peek-table)))
  
  (define gui-frame (new frame% 
                         [label "Data Structure GUI"]
                         [x 0]
                         [y 0]))
  
  ;GUI components
  (define gui-panel (new horizontal-panel% [parent gui-frame]))
  (define gui-left (new vertical-panel% [parent gui-panel] [alignment (list 'left 'center)]))
  (define gui-right (new vertical-panel% [parent gui-panel] [alignment (list 'right 'center)]))
  (define editor-tools (new vertical-panel%
                            [parent gui-left]
                            [min-width 280]
                            [alignment (list 'center 'top)]))
  (define editor-tools-selector (new vertical-panel% [parent editor-tools] [alignment (list 'center 'center)]))
  (define selector-message (new message% (parent editor-tools-selector) (label "Select Element:")))
  (define editor-tools-buttons (new vertical-panel% [parent editor-tools] [alignment (list 'center 'center)]))
  (define button-message (new message% (parent editor-tools-buttons) (label "Replace With:")))
  (define editor-tools-buttons-top (new horizontal-panel% [parent editor-tools-buttons] [alignment (list 'center 'center)]))
  (define editor-tools-buttons-bottom (new horizontal-panel% [parent editor-tools-buttons] [alignment (list 'center 'center)]))
  (define editor-data (new vertical-panel% [parent gui-left] [alignment (list 'center 'center)]))
  (define data-message (new message% (parent editor-data) (label "Edit Data:")))
  (define data-panel (new vertical-panel% 
                         [parent gui-right]
                         [border 2]
                         [min-width (send (gui-core 'peek-target) get-width)]
                         [min-height (send (gui-core 'peek-target) get-height)]
                         [alignment (list 'center 'top)]))
  (define view-editor-panel (new vertical-panel% [parent gui-right] [alignment (list 'center 'center)]))
  (define view-button-panel (new horizontal-panel% [parent view-editor-panel] [alignment (list 'center 'center)]))
  (define edit-button-panel (new horizontal-panel% [parent view-editor-panel] [alignment (list 'center 'center)]))
  
  (define canvas (new bitmap-canvas% [parent data-panel] [bitmap (gui-core 'peek-target)]))
  
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
       [callback (lambda (x y) null)])
    
  (new button% [parent editor-tools-buttons-top]
       [label "Data Element"]
       [callback (lambda (x y) null)])
  
  (new button% [parent editor-tools-buttons-bottom]
       [label "Terminal-Node"]
       [callback (lambda (x y) null)])
  
  (new button% [parent editor-tools-buttons-bottom]
       [label "Bypass-Node"]
       [callback (lambda (x y) null)])

  
  (new button% [parent view-button-panel]
       [label "Edit"]
       [callback (lambda (x y) null)])
  
  (new button% [parent view-button-panel]
       [label "Exit"]
       [callback (lambda (x y) null)])
  
  (new button% [parent edit-button-panel]
       [label "Save"]
       [callback (lambda (x y) null)])
  
  (new button% [parent edit-button-panel]
       [label "Undo"]
       [callback (lambda (x y) null)])
  
  (new button% [parent edit-button-panel]
       [label "Redo"]
       [callback (lambda (x y) null)])
  
  (new button% [parent edit-button-panel]
       [label "Cancel"]
       [callback (lambda (x y) null)])
#|
(define mb (new menu-bar% [parent vis_frame]))

(define m_file (new menu% [label "File"] [parent mb]))
(define m_help (new menu% [label "Help"] [parent mb]))

(new menu-item%
       [parent m_help]
       [label "About"]
       [callback (lambda (b e) (message-box "About" "This is an exploration!" vis_frame))])

(new menu-item%
       [parent m_help]
       [label "Contact"]
       [callback (lambda (b e) (message-box "Contact" "Contact Info: John Smith" vis_frame))])

(new menu-item%
       [parent m_file]
       [label "Load"]
       [callback (lambda (b e)  (send edit_frame show #t))])

(new menu-item%
       [parent m_file]
       [label "Save"]
       [callback (lambda (b e)  (send edit_frame show #f))])

(new menu-item%
       [parent m_file]
       [label "Exit"]
       [callback (lambda (b e)  (send vis_frame show #f))])

(new separator-menu-item% [parent m_file])

(define panel (new horizontal-panel% [parent vis_frame] [alignment '(center center)]))
c

(new button% [parent panel]
             [label "Save File"]
             [callback (lambda (button event)
                         (send edit_frame show #f))])

(new button% [parent panel]
             [label "Exit"]
             [callback (lambda (button event)
                         (send vis_frame show #f))])

(define msg (new message% [parent vis_frame]
                          [label "Open a .rkt file containing a single list named lst"]))

(define edit_msg (new message% [parent edit_frame]
                          [label "This is the data editing window"]))
|#
(send gui-frame show #t))

  
;Bitmap-Canvas courtesy of stackoverflow
(define bitmap-canvas%
  (class canvas%
    (init-field [bitmap #f])
    (inherit get-dc)
    (define/override (on-paint)
      (send (get-dc) draw-bitmap bitmap 0 0))
    (super-new)))

(define (get-element-list table)
  (if(null? table)
     null
     (cons
      (string-append
       "("
       (number->string (car (car table)))
       ", "
       (number->string (cadr (car table)))
       ") "
       (symbol->string (caddr (car table))))
      (get-element-list (cdr table)))))