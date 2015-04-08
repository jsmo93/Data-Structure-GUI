#lang racket

(provide table-entry)
(define (table-entry entry-num table)
  (if (= 0 entry-num)
      (if (pair? table)
          (car table)
          null)
      (table-entry (- entry-num 1) (cdr table))))

(provide element-row)
(define (element-row table-element)
  (car table-element))

(provide element-column)
(define (element-column table-element)
  (cadr table-element))

(provide element-type)
(define (element-type table-element)
  (caddr table-element))

(provide element-parent)
(define (element-parent table-element)
  (cadddr table-element))

(provide element-value)
(define (element-value table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr table-element))))))

(provide element-car)
(define (element-car table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr
       (cdr table-element)))))))

(provide element-cdr)
(define (element-cdr table-element)
  (car
   (cdr
    (cdr
     (cdr
      (cdr
       (cdr
        (cdr table-element))))))))