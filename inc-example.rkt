#lang s-exp rosette

(require rosette/lib/meta/meta)

(define (rel-x width
               width-auto
               ml
               ml-auto
               mr
               mr-auto
               left
               left-auto
               right
               right-auto
               static-x
               shrink-to-fit
               container-width)
  (if (not (|| width-auto left-auto right-auto))
      (if (&& ml-auto mr-auto) (+ left (/ (- container-width (+ left right width )) 2) )
          (+ left (if ml-auto 0 ml)))
      (let ([new-ml (if ml-auto 0 ml)])
        (if (not left-auto)
            (+ left new-ml)
            (if right-auto
                (if width-auto
                    (- container-width (+ right (if mr-auto 0 mr) shrink-to-fit))
                    (- container-width (+ right (if mr-auto 0 mr) width)))
                (+ static-x new-ml))))))

(define (inner-width width
                     width-auto
                     ml
                     ml-auto
                     mr
                     mr-auto
                     left
                     left-auto
                     right
                     right-auto
                     static-x
                     shrink-to-fit
                     container-width)
  (if (not width-auto)
      width
      (if (|| left-auto right-auto)
          shrink-to-fit
          (- container-width (+ left right (if ml-auto 0 ml) (if mr-auto 0 mr))))))

(define (rel-y height
               height-auto
               mt
               mt-auto
               mb
               mb-auto
               top
               top-auto
               bottom
               bottom-auto
               static-y
               intrins-height
               container-height)
  (if (|| top-auto bottom-auto height-auto)
      (if top-auto
          (if bottom-auto
              (+ static-y  (if mt-auto 0 mt))
              (if height-auto
                  (- container-height (+ bottom (if mb-auto 0 mb) intrins-height))
                  (- container-height (+ bottom (if mb-auto 0 mb) height))))
          (+ top (if mt-auto 0 mt)))
      (if (&& mt-auto mb-auto) 
          (+ top (/ (- container-height (+ top bottom height )) 2))
          (if mt-auto
              (- container-height (+ bottom height mb))
              (+ top mt)))))

(define (inner-height height
                      height-auto
                      mt
                      mt-auto
                      mb
                      mb-auto
                      top
                      top-auto
                      bottom
                      bottom-auto
                      static-y
                      intrins-height
                      container-height)
  (if height-auto
      (if (|| top-auto bottom-auto)
          intrins-height
          (- container-height (+ top bottom (if mt-auto  0 mt) (if mb-auto 0 mb))))
      height))

; Given an assignment of auto values, determine which dirty bits
; need to be propagated.
(define (solve-db-constraints cond-lst)
  (begin
    ; Construct symbols for old and new inputs
    (define-symbolic width number?)
    (define-symbolic ml number?)
    (define-symbolic mr number?)
    (define-symbolic left number?)
    (define-symbolic right number?)
    (define-symbolic static-x number?)
    (define-symbolic shrink-to-fit number?)
    (define-symbolic container-width number?)
    (define-symbolic width-new number?)
    (define-symbolic ml-new number?)
    (define-symbolic mr-new number?)
    (define-symbolic left-new number?)
    (define-symbolic right-new number?)
    (define-symbolic static-x-new number?)
    (define-symbolic shrink-to-fit-new number?)
    (define-symbolic container-width-new number?)
    
    (define-symbolic height number?)
    (define-symbolic mt number?)
    (define-symbolic mb number?)
    (define-symbolic top number?)
    (define-symbolic bottom number?)
    (define-symbolic static-y number?)
    (define-symbolic intrins-height number?)
    (define-symbolic container-height number?)
    (define-symbolic height-new number?)
    (define-symbolic mt-new number?)
    (define-symbolic mb-new number?)
    (define-symbolic top-new number?)
    (define-symbolic bottom-new number?)
    (define-symbolic static-y-new number?)
    (define-symbolic intrins-height-new number?)
    (define-symbolic container-height-new number?)
    
    (define (changed-w f)
      (not (eq? (f width
                   (car cond-lst)
                   ml
                   (cadr cond-lst)
                   mr
                   (caddr cond-lst)
                   left
                   (cadddr cond-lst)
                   right
                   (cadddr (cdr cond-lst))
                   static-x
                   shrink-to-fit
                   container-width)
                (f width-new
                   (car cond-lst)
                   ml-new
                   (cadr cond-lst)
                   mr-new
                   (caddr cond-lst)
                   left-new
                   (cadddr cond-lst)
                   right-new
                   (cadddr (cdr cond-lst))
                   static-x-new
                   shrink-to-fit-new
                   container-width-new))))
    
    (define (changed-h f)
      (not (eq? (f height
                   (cadddr (cddr cond-lst))
                   mt
                   (cadddr (cdddr cond-lst))
                   mb
                   (cadddr (cddddr cond-lst))
                   top
                   (cadddr (cddddr (cdr cond-lst)))
                   bottom
                   (cadddr (cddddr (cddr cond-lst)))
                   static-y
                   intrins-height
                   container-height)
                (f height-new
                   (cadddr (cddr cond-lst))
                   mt-new
                   (cadddr (cdddr cond-lst))
                   mb-new
                   (cadddr (cddddr cond-lst))
                   top-new
                   (cadddr (cddddr (cdr cond-lst)))
                   bottom-new
                   (cadddr (cddddr (cddr cond-lst)))
                   static-y-new
                   intrins-height-new
                   container-height-new)
                )))
    
    ; Construct formula for whether the outputs changed.
    ;(define output-changed
    ;  (|| (changed-w rel-x) (changed-w inner-width) (changed-h rel-y) (changed-h inner-height)))
    
    (define output-changed
      (changed-w rel-x))
    
    
    (define (is-sat? expr)
      (with-handlers ([exn:fail? (lambda (exn) (begin (displayln exn) #f))]) 
        (begin 
          (solve (assert expr))
          #t)))
    
    ; The formulae to solve are all of the form 
    ; "the output changed and some inputs are
    ; the same". This allows us to conclude 
    ; the change must have been instigated by a 
    ; variable not in this set.
    `(leaf
      ; Container dirty-bit
      ,(is-sat? (&& (= width width-new)
                    (= ml ml-new)
                    (= mr mr-new)
                    (= left left-new)
                    (= right right-new)
                    (= shrink-to-fit shrink-to-fit-new)
                    (= height height-new)
                    (= mt mt-new)
                    (= mb mb-new)
                    (= top top-new)
                    (= bottom bottom-new)
                    (= intrins-height intrins-height-new)
                    output-changed))
      ; Intrinsic dirty-bit
      ,(is-sat? (&& (= width width-new)
                    (= ml ml-new)
                    (= mr mr-new)
                    (= left left-new)
                    (= right right-new)
                    (= static-x static-x-new)
                    (= container-width container-width-new)
                    (= height height-new)
                    (= mt mt-new)
                    (= mb mb-new)
                    (= top top-new)
                    (= bottom bottom-new)
                    (= static-y static-y-new)
                    (= container-height container-height-new)
                    output-changed))
      ; Other dirty-bit
      ,(is-sat? (&& (= static-x static-x-new)
                    (= shrink-to-fit shrink-to-fit-new)
                    (= container-width container-width-new)
                    (= static-y static-y-new)
                    (= intrins-height intrins-height-new)
                    (= container-height container-height-new)
                    output-changed)))
    ))

; Recursive procedure to find the most precise dirty-bit function.
; Stored as a treemap from auto values to the set of dirty bits to 
; be propagated.
(define (get-precise-db cond-lst)
  (if (> (length cond-lst) 10)
      (solve-db-constraints cond-lst)
      `(,(get-precise-db (append cond-lst '(#t))) ,(get-precise-db (append cond-lst '(#f)))) 
      ))

; Compute the most accurate dirty-bit function
(define precise-db (get-precise-db '()))

;(solve-db-constraints '(#f #f #f #f #f #f #f #f #f #f))
  