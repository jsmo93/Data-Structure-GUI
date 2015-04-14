#lang racket

(require racket/gui)
(require racket/draw)

;Empty data diagram
(provide data)
(define data-target (make-bitmap 55 40))
(define data-dc (new bitmap-dc% [bitmap data-target]))
(define data
  (let ([p (new dc-path%)])
    (send p move-to 0 0)
    (send p line-to 15 0)
    (send p line-to 15 15)
    (send p line-to 0 15)
    (send p line-to 0 0)
    (send p close)
    p))

;Basic double box, used as the base for nodes
(provide double-box)
(define double-box-target (make-bitmap 55 40))
(define double-box-dc (new bitmap-dc% [bitmap double-box-target]))
(define double-box
  (let ([p (new dc-path%)])
    (send p move-to 0 0)
    (send p line-to 30 0)
    (send p line-to 30 15)
    (send p line-to 0 15)
    (send p move-to 15 0)
    (send p line-to 15 15)
    (send p close)
    p))

;Down arrow for connecting nodes
(provide down-arrow)
(define down-arrow-target (make-bitmap 55 40))
(define down-arrow-dc (new bitmap-dc% [bitmap down-arrow-target]))
(define down-arrow
  (let ([p (new dc-path%)])
    (send p move-to 7 7)
    (send p line-to 7 39)
    (send p move-to 7 39)
    (send p line-to 12 29)
    (send p move-to 7 39)
    (send p line-to 2 29)
    (send p close)
    p))

;Right arrow for connecting nodes
(provide right-arrow)
(define right-arrow-target (make-bitmap 55 40))
(define right-arrow-dc (new bitmap-dc% [bitmap right-arrow-target]))
(define right-arrow
  (let ([p (new dc-path%)])
    (send p move-to 23 7)
    (send p line-to 54 7)
    (send p move-to 54 7)
    (send p line-to 44 12)
    (send p move-to 54 7)
    (send p line-to 44 2)
    (send p close)
    p))

;Used to extend right arrows
(provide right-line)
(define right-line-target (make-bitmap 55 40))
(define right-line-dc (new bitmap-dc% [bitmap right-line-target]))
(define right-line
  (let ([p (new dc-path%)])
    (send p move-to 23 7)
    (send p line-to 54 7)
    (send p close)
    p))

;Base element of the list
(provide node)
(define node-target (make-bitmap 55 40))
(define node-dc (new bitmap-dc% [bitmap node-target]))
(define node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p append down-arrow)
    (send p append right-arrow)
    (send p close)
    p))

;Node who's cdr is not in an adjacent cell
(provide spaced-node)
(define spaced-node-target (make-bitmap 55 40))
(define spaced-node-dc (new bitmap-dc% [bitmap spaced-node-target]))
(define spaced-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p append down-arrow)
    (send p append right-line)
    (send p close)
    p))

;Last node in a list
(provide terminal-node)
(define terminal-node-target (make-bitmap 55 40))
(define terminal-node-dc (new bitmap-dc% [bitmap terminal-node-target]))
(define terminal-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 15 0)
    (send p line-to 30 15)
    (send p append down-arrow)
    (send p close)
    p))

;Node without a car
(provide bypass-node)
(define bypass-node-target (make-bitmap 55 40))
(define bypass-node-dc (new bitmap-dc% [bitmap bypass-node-target]))
(define bypass-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 0 0)
    (send p line-to 15 15)
    (send p append right-arrow)
    (send p close)
    p))

;Bypass node who's car isn't in the cell below it
(provide spaced-bypass-node)
(define spaced-bypass-node-target (make-bitmap 55 40))
(define spaced-bypass-node-dc (new bitmap-dc% [bitmap spaced-bypass-node-target]))
(define spaced-bypass-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 0 0)
    (send p line-to 15 15)
    (send p append right-line)
    (send p close)
    p))

;Node with no contents
(provide null-node)
(define null-node-target (make-bitmap 55 40))
(define null-node-dc (new bitmap-dc% [bitmap null-node-target]))
(define null-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 0 0)
    (send p line-to 15 15)
    (send p move-to 15 0)
    (send p line-to 30 15)
    (send p close)
    p))

;Used for grid visualization
(provide enclosure)
(define enclosure-target (make-bitmap 55 40))
(define enclosure-dc (new bitmap-dc% [bitmap enclosure-target]))
(define enclosure
  (let ([p (new dc-path%)])
    (send p move-to 0 0)
    (send p line-to 54 0)
    (send p line-to 54 39)
    (send p line-to 0 39)
    (send p line-to 0 0)
    (send p close)
    p))