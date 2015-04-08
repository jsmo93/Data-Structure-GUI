#lang racket
(require "Diagram-Components.rkt")
(require racket/draw)

(provide draw-node)
(define (draw-node dc path row col)
  (send dc draw-path path (* 55 col) (* 40 row)))

(provide draw-data)
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
       (send dc set-font (make-font #:size 12 #:family 'modern))
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