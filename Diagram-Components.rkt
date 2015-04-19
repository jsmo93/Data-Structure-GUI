#lang racket

(require racket/gui)
(require racket/draw)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Diagram components
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Empty data diagram
(provide data)
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
;in non-adjacent cells
(provide down-arrow)
(define down-arrow
  (let ([p (new dc-path%)])
    (send p move-to 7 0)
    (send p line-to 7 39)
    (send p move-to 7 39)
    (send p line-to 12 29)
    (send p move-to 7 39)
    (send p line-to 2 29)
    (send p close)
    p))

;Down arrow for connecting nodes
;in adjacent cells
(provide car-arrow)
(define car-arrow
  (let ([p (new dc-path%)])
    (send p move-to 7 7)
    (send p line-to 7 39)
    (send p move-to 7 39)
    (send p line-to 12 29)
    (send p move-to 7 39)
    (send p line-to 2 29)
    (send p close)
    p))

;Used to extend down arrows
(provide down-line)
(define down-line
  (let ([p (new dc-path%)])
    (send p move-to 7 0)
    (send p line-to 7 39)
    (send p close)
    p))

;Used to extend down arrows.
;Compose spaced node elements
(provide car-line)
(define car-line
  (let ([p (new dc-path%)])
    (send p move-to 7 7)
    (send p line-to 7 39)
    (send p close)
    p))

;Right arrow for connecting non-
;adjacent nodes
(provide right-arrow)
(define right-arrow
  (let ([p (new dc-path%)])
    (send p move-to 0 7)
    (send p line-to 54 7)
    (send p move-to 54 7)
    (send p line-to 44 12)
    (send p move-to 54 7)
    (send p line-to 44 2)
    (send p close)
    p))

;Right arrow for connecting
;adjacent nodes
(provide cdr-arrow)
(define cdr-arrow
  (let ([p (new dc-path%)])
    (send p move-to 23 7)
    (send p line-to 54 7)
    (send p move-to 54 7)
    (send p line-to 44 12)
    (send p move-to 54 7)
    (send p line-to 44 2)
    (send p close)
    p))

;Used to extend right arrows.
;Composed spaced node elements
(provide cdr-line)
(define cdr-line
  (let ([p (new dc-path%)])
    (send p move-to 23 7)
    (send p line-to 54 7)
    (send p close)
    p))

;Used to extend right arrows
(provide right-line)
(define right-line
  (let ([p (new dc-path%)])
    (send p move-to 0 7)
    (send p line-to 54 7)
    (send p close)
    p))

;Base element of the list
(provide node)
(define node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p append car-arrow)
    (send p append cdr-arrow)
    (send p close)
    p))

;Node who's car and cdr is not
;in an adjacent cell
(provide spaced-node)
(define spaced-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p append car-line)
    (send p append cdr-line)
    (send p close)
    p))

;Node who's car is not in an adjacent cell
(provide spaced-car-node)
(define spaced-car-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p append car-line)
    (send p append cdr-arrow)
    (send p close)
    p))

;Node who's cdr is not in an adjacent cell
(provide spaced-cdr-node)
(define spaced-cdr-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p append car-arrow)
    (send p append cdr-line)
    (send p close)
    p))

;Last node in a list
(provide terminal-node)
(define terminal-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 15 0)
    (send p line-to 30 15)
    (send p append car-arrow)
    (send p close)
    p))

;Last node in a list who's car
;is not in an adjacent cell
(provide spaced-terminal-node)
(define spaced-terminal-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 15 0)
    (send p line-to 30 15)
    (send p append car-line)
    (send p close)
    p))

;Node without a car
(provide bypass-node)
(define bypass-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 0 0)
    (send p line-to 15 15)
    (send p append cdr-arrow)
    (send p close)
    p))

;Bypass node who's cdr isn't
;in an adjacent cell
(provide spaced-bypass-node)
(define spaced-bypass-node
  (let ([p (new dc-path%)])
    (send p append double-box)
    (send p move-to 0 0)
    (send p line-to 15 15)
    (send p append cdr-line)
    (send p close)
    p))

;Node with no contents
(provide null-node)
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
(define enclosure
  (let ([p (new dc-path%)])
    (send p move-to 0 0)
    (send p line-to 54 0)
    (send p line-to 54 39)
    (send p line-to 0 39)
    (send p line-to 0 0)
    (send p close)
    p))