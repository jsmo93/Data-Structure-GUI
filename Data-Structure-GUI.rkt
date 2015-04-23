#lang racket

(require racket/gui/base)
(require racket/draw)
(require "Data-Structure-GUI-Core.rkt")

(provide ds-gui)
(define (ds-gui data-structure)
  
  ;Core variables
  (define gui-core (data-structure-core data-structure))
  (define element-strings (get-element-strings (gui-core 'peek-table)))
  (define elements (dmap element-strings (get-element-list (gui-core 'peek-table))))
  (define node-selected null)
  
  (define tools-frame (new frame% 
                           [label "Editing Tools"]
                           [x 0]
                           [y 0]))
  
  (define viewer-frame (new frame%
                            [label "DS Viewer"]
                            [x 350]
                            [y 0]))
    
  ;GUI components
  (define tools-panel (new vertical-panel% [parent tools-frame]))
  (define view-panel (new vertical-panel% [parent tools-panel] [alignment (list 'center 'center)]))
  (define view-button-panel (new horizontal-panel% [parent view-panel] [alignment (list 'center 'center)]))
  (define editor-panel (new vertical-panel% [parent tools-panel] [alignment (list 'center 'center)]))
  (define edit-button-panel (new horizontal-panel% [parent editor-panel] [alignment (list 'center 'center)]))
  (define editor-tools (new vertical-panel%
                            [parent editor-panel]
                            [min-width 280]
                            [alignment (list 'center 'top)]))
  (define editor-tools-selector (new vertical-panel% [parent editor-tools] [alignment (list 'center 'center)]))
  (define selector-message (new message% (parent editor-tools-selector) (label "Select Element:")))
  (define editor-tools-combobox (new vertical-panel% [parent editor-tools-selector]))
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
                         (parent editor-tools-combobox)
                         (choices element-strings)
                         [callback (lambda (button event)
                                     (refresh-node-selected))]
                                       
                         (init-value (car element-strings))))
  
  (set! node-selected (get-node-selected (send combo-field get-value) elements))
  
  (define text-field (new text-field%
                        (label "")
                        (parent editor-data)
                        [callback (lambda (button event)
                                      (draw-viewer-frame (gui-core 'replace-data (send text-field get-value) node-selected)))]
                        (init-value "Null")))

  (new button% [parent editor-tools-buttons-top]
       [label "Node"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (set! node-selected
                           (get-node-selected
                            (send combo-field get-value)
                            elements))
                     ((gui-core 'replace-node) 'node node-selected) 
                     (draw-viewer-frame (gui-core 'peek-target))))])
    
  (new button% [parent editor-tools-buttons-top]
       [label "Data Element"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (set! node-selected
                           (get-node-selected
                            (send combo-field get-value)
                            elements))
                     ((gui-core 'replace-node) 'data node-selected) 
                     (draw-viewer-frame (gui-core 'peek-target))))])
  
  (new button% [parent editor-tools-buttons-bottom]
       [label "Terminal-Node"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (set! node-selected
                           (get-node-selected
                            (send combo-field get-value)
                            elements))
                     ((gui-core 'replace-node) 'terminal-node node-selected) 
                     (draw-viewer-frame (gui-core 'peek-target))))])
  
  (new button% [parent editor-tools-buttons-bottom]
       [label "Bypass-Node"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin
                     (set! node-selected
                           (get-node-selected
                            (send combo-field get-value)
                            elements))
                     ((gui-core 'replace-node) 'bypass-node node-selected) 
                     (draw-viewer-frame (gui-core 'peek-target))))])
  
  (new button% [parent view-button-panel]
       [label "Edit"]
       [min-width 110]
       [callback (lambda (button event)
                   (begin 
                     (send view-panel show #f)
                     (send editor-panel show #t)
                     (refresh-node-selected)
                     (gui-core 'draw-enclosed)
                     (draw-viewer-frame (gui-core 'peek-target))))])
  
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
                     (gui-core 'save)
                     (gui-core 'draw)
                     (set! element-strings (get-element-strings (gui-core 'peek-table)))
                     (set! elements (dmap element-strings (get-element-list (gui-core 'peek-table))))
                     ;delete combo box and remake
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
  
  (new button% [parent edit-button-panel]
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
  
  (define (refresh-node-selected)
    (begin
      (set! node-selected (get-node-selected
                           (send combo-field get-value)
                           elements))
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
                  (number->string (car
                   (cdr
                    (cdr
                     (cdr
                      (cdr node-selected)))))))))))
  
  (send editor-panel show #f)
  (send viewer-frame show #t)
  (send tools-frame show #t))

  
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
               
(define (get-element-strings table)
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
            (get-element-strings (cdr table))))
         (get-element-strings (cdr table)))))

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
            (car table)
            (get-element-list (cdr table))))
         (get-element-list (cdr table)))))

(define (dmap l1 l2)
  (if (or (null? l1) (null? l2))
      null
      (cons (cons (car l1) (car l2))
            (dmap (cdr l1) (cdr l2)))))

(define (get-node-selected str elements)
  (cond ((null? elements) null)
        ((equal? str (car (car elements))) (cdr (car elements)))
        (else (get-node-selected str (cdr elements)))))