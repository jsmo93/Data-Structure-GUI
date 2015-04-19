#lang racket

(require "Table-Core-Utils.rkt")
(require "Table-Sorting.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Table building procedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Takes a list and builds the representative table
(provide build-table)
(define (build-table lst)
  (sort-table-rows
   (build-table-helper lst null 0 0 0 0 'right)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Helper function to build a table
(define (build-table-helper lst table current-row current-col parent-row parent-col direction)
  (define placement-car (find-next-open table (+ current-row 1) current-col 'right))
  (define placement-cdr (find-next-open table current-row (+ current-col 1) 'down))
  (define parent-entry null)
  (cond ((null? lst)    
         table)
        ((not (pair? lst))
         (begin        
           (set! table (append table (list (new-entry current-row current-col 'data parent-row parent-col lst -1 -1 -1 -1))))         
           table))
        ((and (null? (car lst)) (null? (cdr lst)))
         (begin         
           (set! table (append table (list (new-entry current-row current-col 'null-node parent-row parent-col null -1 -1 -1 -1))))      
           table))
        ((null? (car lst))
         (begin
           (if (= current-row (car placement-cdr))
               (begin
                 (set! table (fill-spaces table parent-row parent-col current-row current-col))
                 (set! table (fill-spaces table current-row current-col (car placement-cdr) (cadr placement-cdr)))
                 (set! table (append table (list (new-entry current-row current-col 'bypass-node parent-row parent-col null -1 -1 (car placement-cdr) (cadr placement-cdr))))))
               (if (null? (table-entry-rc (car placement-cdr) current-col table))
                   (if (= parent-row current-row) ;if these are already on the same level, stop, don't mess up the rest
                   (error "could not load structure due to spacing conflicts")
                   (begin
                     (set! parent-entry (table-entry-rc parent-row parent-col table))
                     (set! table
                      (replace-entry
                      table
                      parent-row
                      parent-col
                      (new-entry
                       parent-row
                       parent-col
                      (element-type parent-entry)
                      (car (element-parent parent-entry))
                      (cadr (element-parent parent-entry))
                      null
                      (car placement-cdr)
                      (cadr (element-car parent-entry))
                      (car (element-cdr parent-entry))
                      (cadr (element-cdr parent-entry)))))
                     (set! table (append table (list (new-entry (car placement-cdr) current-col 'bypass-node parent-row parent-col null -1 -1 (car placement-cdr) (cadr placement-cdr)))))
                     (set! table (fill-spaces table parent-row parent-col (car placement-cdr) current-col))
                     (set! table (fill-spaces table (car placement-cdr) current-col (car placement-cdr) (cadr placement-cdr)))))
                   (error "could not load structure due to spacing conflicts")))                
           (set! table (build-table-helper (cdr lst) table (car placement-cdr) (cadr placement-cdr) current-row current-col 'down))   
           table))
        ((null? (cdr lst))
         (begin
           (if (= current-col (cadr placement-car))
               (begin
                 (set! table (append table (list (new-entry current-row current-col 'terminal-node parent-row parent-col null (car placement-car) (cadr placement-car) -1 -1))))
                 (set! table (fill-spaces table parent-row parent-col current-row current-col))
                 (set! table (fill-spaces table current-row current-col (car placement-car) (cadr placement-car))))
               (if (null? (table-entry-rc current-row (cadr placement-car) table))
                   (if (= current-col parent-col)
                       (error "could not load structure due to spacing conflicts")
                       (begin
                         (set! parent-entry (table-entry-rc parent-row parent-col table))
                         (set! table
                               (replace-entry
                                table
                                parent-row
                                parent-col
                                (new-entry
                                 parent-row
                                 parent-col
                                 (element-type parent-entry)
                                 (car (element-parent parent-entry))
                                 (cadr (element-parent parent-entry))
                                 null
                                 (car (element-car parent-entry))
                                 (cadr (element-car parent-entry))
                                 (car (element-cdr parent-entry))
                                 (cadr placement-car))))
                         (set! table (append table (list (new-entry current-row (cadr placement-car) 'terminal-node parent-row parent-col null (car placement-car) (cadr placement-car) -1 -1))))
                         (set! table (fill-spaces table parent-row parent-col current-row (cadr placement-car)))
                         (set! table (fill-spaces table current-row (cadr placement-car) (car placement-car) (cadr placement-car)))))
                   (error "could not load structure due to spacing conflicts"))) 
           (set! table (build-table-helper (car lst) table (car placement-car) (cadr placement-car) current-row current-col 'right)) 
           table))
        (else
         (begin
           (cond ((and (= current-col (cadr placement-car)) (= current-row (car placement-cdr)))
                  (begin
                    (set! table (append table (list (new-entry current-row current-col 'node parent-row parent-col null (car placement-car) (cadr placement-car) (car placement-cdr) (cadr placement-cdr)))))
                    (set! table (fill-spaces table parent-row parent-col current-row current-col))
                    (set! table (fill-spaces table current-row current-col (car placement-cdr) (cadr placement-cdr)))
                    (set! table (fill-spaces table current-row current-col (car placement-car) (cadr placement-car)))
                    (set! table (build-table-helper (cdr lst) table (car placement-cdr) (cadr placement-cdr) current-row current-col 'down))
                    (set! table (build-table-helper (car lst) table (car placement-car) (cadr placement-car) current-row current-col 'right))
                    table))
                 ((not (= current-row (car placement-cdr)))
                  (if (null? (table-entry-rc (car placement-cdr) current-col table))
                      (if (= parent-row current-row) ;if these are already on the same level, stop, don't mess up the rest
                          (error "could not load structure due to spacing conflicts")
                          (begin
                            (set! parent-entry (table-entry-rc parent-row parent-col table))
                            (set! table
                                  (replace-entry
                                   table
                                   parent-row
                                   parent-col
                                   (new-entry
                                    parent-row
                                    parent-col
                                    (element-type parent-entry)
                                    (car (element-parent parent-entry))
                                    (cadr (element-parent parent-entry))
                                    null
                                    (car placement-cdr)
                                    (cadr (element-car parent-entry))
                                    (car (element-cdr parent-entry))
                                    (cadr (element-cdr parent-entry)))))
                            (set! table (append table (list (new-entry (car placement-cdr) current-col 'node parent-row parent-col null
                                                                       (if (null? (table-entry-rc (+ 1 (car placement-cdr)) (cadr placement-car) table))
                                                                           (+ 1 (car placement-cdr))
                                                                           (error "could not load structure due to spacing conflicts"))
                                                                       (cadr placement-car) (car placement-cdr) (cadr placement-cdr)))))
                            (set! table (fill-spaces table parent-row parent-col (car placement-cdr) current-col))
                            (set! table (fill-spaces table (car placement-cdr) current-col (car placement-cdr) (cadr placement-cdr)))
                            (set! table (fill-spaces table (car placement-cdr) current-col (+ 1 (car placement-cdr)) (cadr placement-car)))
                            (set! table (build-table-helper (cdr lst) table (car placement-cdr) (cadr placement-cdr) (car placement-cdr) current-col 'down))
                            (set! table (build-table-helper (car lst) table (+ 1 (car placement-cdr)) (cadr placement-car) (car placement-cdr) current-col 'right))
                            table))
                      (error "could not load structure due to spacing conflicts")))   
                  ((not (= current-col (cadr placement-car)))
                   (if (null? (table-entry-rc current-row (cadr placement-car) table))
                       (if (= current-col parent-col)
                           (error "could not load structure due to spacing conflicts")
                           (begin
                             (set! parent-entry (table-entry-rc parent-row parent-col table))
                             (set! table
                                   (replace-entry
                                    table
                                    parent-row
                                    parent-col
                                    (new-entry
                                     parent-row
                                     parent-col
                                     (element-type parent-entry)
                                     (car (element-parent parent-entry))
                                     (cadr (element-parent parent-entry))
                                     null
                                     (car (element-car parent-entry))
                                     (cadr (element-car parent-entry))
                                     (car (element-cdr parent-entry))
                                     (cadr placement-car))))
                             (set! table (append table (list (new-entry current-row (cadr placement-car) 'node parent-row parent-col null (car placement-car) (cadr placement-car) (car placement-cdr)
                                                                        (if (null? (table-entry-rc (car placement-cdr) (+ 1 (cadr placement-car)) table))
                                                                           (+ 1 (cadr placement-car))
                                                                           (error "could not load structure due to spacing conflicts"))))))
                             (set! table (fill-spaces table parent-row parent-col current-row (cadr placement-car)))
                             (set! table (fill-spaces table current-row (cadr placement-car) (car placement-cdr) (+ 1 (cadr placement-car))))
                             (set! table (fill-spaces table current-row (cadr placement-car) (car placement-car) (cadr placement-car)))
                             (set! table (build-table-helper (cdr lst) table (car placement-cdr) (+ 1 cadr placement-car) current-row (cadr placement-car) 'down))
                             (set! table (build-table-helper (car lst) table (car placement-car) (cadr placement-car) current-row (cadr placement-car) 'right))
                             table))
                       (error "could not load structure due to spacing conflicts")))
                 (else
                  (error "could not load structure due to spacing conflicts")))
           table))
        ))

;Takes a cell and finds the next open row and column
(define (find-next-open table ideal-row ideal-col direction)
  (cond ((null? table) (list ideal-row ideal-col))
        ((null? (table-entry-rc ideal-row ideal-col table)) (list ideal-row ideal-col))
        ((eqv? direction 'right) (find-next-open table ideal-row (+ ideal-col 1) direction))
        ((eqv? direction 'down) (find-next-open table (+ ideal-row 1) ideal-col direction))))

;As you build the table, fill in spaces between non-adjacent cell with the appropriate
;diagram element
(define (fill-spaces table starting-row starting-col ending-row ending-col)
  (if (= 0 starting-row starting-col ending-row ending-col)
      table
      (if (= starting-row ending-row)
          (fill-col-spaces table starting-row starting-col ending-row ending-col)
          (fill-row-spaces table starting-row starting-col ending-row ending-col))))

;Fill the column spaces with right spacers
(define (fill-col-spaces table starting-row starting-col ending-row ending-col)
  (add-right-spacers table starting-row (+ 1 starting-col) ending-row ending-col))
 
;Fill the row spaces with down spacers
(define (fill-row-spaces table starting-row starting-col ending-row ending-col)
  (add-down-spacers table (+ 1 starting-row) starting-col ending-row ending-col))

;Decide to fill with a right arrow or line
(define (add-right-spacers table starting-row starting-col ending-row ending-col)
  (define desired-cell (table-entry-rc starting-row starting-col table))
 (cond ((= starting-col ending-col) table)
       ((= 1 (- ending-col starting-col))
        (if (or (null? desired-cell) (eqv? 'right-arrow (element-type desired-cell)))
            (begin
              (set! table (append table (list (new-entry starting-row starting-col 'right-arrow -1 -1 null -1 -1 -1 -1))))
              (set! table (add-right-spacers table starting-row (+ 1 starting-col) ending-row ending-col))
              table)
             (error "could not load structure due to spacing conflicts")))
       (else
        (if (or (null? desired-cell) (eqv? 'right-line (element-type desired-cell)))
            (begin
              (set! table (append table (list (new-entry starting-row starting-col 'right-line -1 -1 null -1 -1 -1 -1))))
              (set! table (add-right-spacers table starting-row (+ 1 starting-col) ending-row ending-col))
              table)
             (error "could not load structure due to spacing conflicts")))))
        
;Decide to fill with a left arrow or line
(define (add-down-spacers table starting-row starting-col ending-row ending-col)
  (define desired-cell (table-entry-rc starting-row starting-col table))
 (cond ((= starting-row ending-row) table)
       ((= 1 (- ending-row starting-row))
        (if (or (null? desired-cell) (eqv? 'down-arrow (element-type desired-cell)))
            (begin
              (set! table (append table (list (new-entry starting-row starting-col 'down-arrow -1 -1 null -1 -1 -1 -1))))
              (set! table (add-down-spacers table (+ 1 starting-row) starting-col ending-row ending-col))
              table)
             (error "could not load structure due to spacing conflicts")))
       (else
        (if (or (null? desired-cell) (eqv? 'down-line (element-type desired-cell)))
            (begin
              (set! table (append table (list (new-entry starting-row starting-col 'down-line -1 -1 null -1 -1 -1 -1))))
              (set! table (add-down-spacers table (+ 1 starting-row) starting-col ending-row ending-col))
              table)
             (error "could not load structure due to spacing conflicts")))))