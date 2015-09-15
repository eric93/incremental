#lang s-exp rosette
(require "synthesize.rkt")
(define-inputs (self-changed p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right) (parent-changed available-width) (intrins-changed intrins-width))

(define-conditions (mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto))


(define-outputs 
  (self-intrins-width (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
                        (if width-auto 0 (if width-percent (- available-width intrins-width) intrins-width))))
  (pt (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if pt-percent (- available-width p-top) p-top)))
  (pb (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if pb-percent (- available-width p-bottom) p-bottom)))
  (pl (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if pl-percent (- available-width p-left) p-left)))
  (pr (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if pr-percent (- available-width p-right) p-right)))
  (mt (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if mt-auto 0 (if mt-percent (- available-width m-top) m-top))))
  (mb (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if mb-auto 0 (if mb-percent (- available-width m-bottom) m-bottom))))
  (ml (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if ml-auto 
            (if width-auto 0 (if mr-auto 
                                 (/ (- available-width (+ pr pl br bl self-intrins-width)) 2) 
                                 (- available-width (+ pr pl br bl self-intrins-width (if mr-auto 0 (if mr-percent (- available-width m-right) m-right))))))
            (if ml-percent (- available-width m-left) m-left))))
  (mr (lambda (p-top p-bottom p-left p-right bt bb bl br m-top m-bottom m-left m-right available-width intrins-width 
                     mt-percent mb-percent ml-percent mr-percent mt-auto mb-auto ml-auto mr-auto pt-percent pb-percent pl-percent pr-percent width-percent width-auto
                     self-intrins-width pt pb pl pr mt mb ml mr)
        (if (&& (not mr-auto) (|| width-auto mr-auto))
            (if mr-percent (- available-width m-right) m-right)
            (if width-auto 0 (if ml-auto
                                 (/ (- available-width (+ pr pl br bl self-intrins-width)) 2)
                                 (- available-width (+ pr pl br bl self-intrins-width (if ml-auto 0 (if ml-percent (- available-width m-left) m-left))))))))))

(do-synthesis)


