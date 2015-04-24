#lang racket

(provide dealership-template)
(define dealership-template
  (list
   (list "Chevrolet" "Cobalt" "2008" "20000 miles" "$8000")
   (list "Chevrolet" "Silverado" "2007" "400000 miles" "$9300")
   (list "Chevorlet" "Spark" 2014 "1000 miles" "$13000")))

(provide race-times)
(define race-times
  (list
   (list "Baystate Marathon" "4:02")
   (list "Boston Marathon" "4:33")
   (list "New York Marathon" "4:15")
   (list "Tough Mudder" "5:01")
   (list "Spartan Beast" "4:49")))
  
(provide beer-template)
(define beer-template 
  (list 
   (list "HOPS:" "1oz Cascade" "1oz Citra" "2oz Zythos")
   (list "SUGARS:" "4lbs Malt Extract" "1lb Honey" "1lb Dextrose")
   (list "FRUIT:" "6cups Lime Juice" "1oz Apple Extract")))