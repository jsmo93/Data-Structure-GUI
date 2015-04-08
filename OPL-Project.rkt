#lang racket

(require racket/draw)
(require racket/gui)
(require "Diagram-Components.rkt")

(define (paint-dc dc path target)
  (send dc draw-path path)
  (make-object image-snip% target))

(define (paint-dc-enclosed dc path target)
  (send dc draw-path enclosure)
  (send dc draw-path path)
  (make-object image-snip% target))


(define (resize-data-box dc str x y)
  (send dc scale (* (/ 2 3) (string-length str)) 1)
  (send dc draw-text str (+ 3 x) (- y 1)))

(define (set-data dc str x y)
  (if (> (string-length str) 1)
      (resize-data-box dc str x y)
      (send dc draw-text str (+ 3 x) (- y 1))))

(define test-enclosed-target (make-bitmap 220 120))
(define test-enclosed-dc (new bitmap-dc% [bitmap test-enclosed-target]))
(define old-pen-enclosed (send test-enclosed-dc get-pen))
(define (paint-test-enclosed)
  ;Row 1
  (send test-enclosed-dc draw-path enclosure)
  (send test-enclosed-dc draw-path node)
  (send test-enclosed-dc set-pen "gray" 1 'short-dash)
  (send test-enclosed-dc draw-path enclosure 55 0)
  (send test-enclosed-dc draw-path spacer 55 0)
  (send test-enclosed-dc set-pen old-pen-enclosed)
  (send test-enclosed-dc draw-path enclosure 110 0)
  (send test-enclosed-dc draw-path node 110 0)
  (send test-enclosed-dc draw-path enclosure 165 0)
  (send test-enclosed-dc draw-path terminal-node 165 0)
  ;Row 2
  (send test-enclosed-dc draw-path enclosure 0 40)
  (send test-enclosed-dc draw-path node 0 40)
  (send test-enclosed-dc draw-path enclosure 55 40)
  (send test-enclosed-dc draw-path terminal-node 55 40)
  (send test-enclosed-dc draw-path enclosure 110 40)
  (send test-enclosed-dc draw-path data 110 40)
  (send test-enclosed-dc draw-path enclosure 165 40)
  (send test-enclosed-dc draw-path null-node 165 40)
  ;Row 3
  (send test-enclosed-dc draw-path enclosure 0 80)
  (send test-enclosed-dc draw-path data 0 80)
  (send test-enclosed-dc draw-path enclosure 55 80)
  (send test-enclosed-dc draw-path data 55 80)
  (send test-enclosed-dc draw-path enclosure 110 80)
  (send test-enclosed-dc draw-path enclosure 165 80)
  (make-object image-snip% test-enclosed-target))

(define test-target (make-bitmap 220 120))
(define test-dc (new bitmap-dc% [bitmap test-target]))
(define old-pen (send test-dc get-pen))
(define (paint-test)
  ;Row 1
  (send test-dc draw-path node)
  (send test-dc set-pen "gray" 1 'short-dash)
  (send test-dc draw-path spacer 55 0)
  (send test-dc set-pen old-pen)
  (send test-dc draw-path node 110 0)
  (send test-dc draw-path terminal-node 165 0)
  ;Row 2
  (send test-dc draw-path node 0 40)
  (send test-dc draw-path terminal-node 55 40)
  (send test-dc draw-path data 110 40)
  (send test-dc draw-text ".." 113 39)
  (send test-dc draw-path null-node 165 40)
  ;Row 3
  (send test-dc draw-path data 0 80)
  (send test-dc draw-path data 55 80)
  (make-object image-snip% test-target))