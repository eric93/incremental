#lang s-exp rosette

(require rosette/lib/meta/meta)
(define base-ns (make-base-namespace))
(require "dnf-expression.rkt")

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
    (define output-changed
      (|| (changed-w rel-x) (changed-w inner-width) (changed-h rel-y) (changed-h inner-height)))
    
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
    `(
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
      ; Inner dirty-bit
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
      ; Intrinsic dirty-bit
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
  (if (> (length cond-lst) 9)
      (solve-db-constraints cond-lst)
      `(,(get-precise-db (append cond-lst '(#t))) ,(get-precise-db (append cond-lst '(#f)))) 
      ))

(define (synthesize-expression precise)
  (define-symbolic width-auto boolean?)
  (define-symbolic ml-auto boolean?)
  (define-symbolic mr-auto boolean?)
  (define-symbolic left-auto boolean?)
  (define-symbolic right-auto boolean?)
  (define-symbolic height-auto boolean?)
  (define-symbolic mt-auto boolean?)
  (define-symbolic mb-auto boolean?)
  (define-symbolic top-auto boolean?)
  (define-symbolic bottom-auto boolean?)
  
  (define-symbolic container-d boolean?)
  (define-symbolic inner-d boolean?)
  (define-symbolic intrins-d boolean?)
  
  (define auto-lst (list width-auto ml-auto mr-auto left-auto right-auto height-auto mt-auto mb-auto top-auto bottom-auto))
  

  
  
  
  (define (soundness-constraint lst precise)
    (if (= (length lst) 0)
        (|| (if (car precise) container-d #f) (if (cadr precise) inner-d #f) (if (caddr precise) intrins-d #f))
        (|| (&& (not (car lst))
                (soundness-constraint (cdr lst) (cadr precise)))
            (&& (car lst)
                (soundness-constraint (cdr lst) (car precise))))))
  (define sound (soundness-constraint auto-lst precise))
  
  (define (precision precise approximate)
    (define count 0)
    (define (do-count in-lst p)
      (if (> (length in-lst) 9)
          (begin
            (if (|| (&& (car p) (not (approximate #t #f #f in-lst)))
                    (&& (cadr p) (not (approximate #f #t #f in-lst)))
                    (&& (caddr p) (not (approximate #f #f #t in-lst))))
                (begin
                  (error "Invalid approximation"))
                #f)
            (set! count (+ count (if (&& (not (car p)) (approximate #t #f #f in-lst)) 1 0)))
            (set! count (+ count (if (&& (not (cadr p)) (approximate #f #t #f in-lst)) 1 0)))
            (set! count (+ count (if (&& (not (caddr p)) (approximate #f #f #t in-lst)) 1 0))))
          (begin 
            (do-count (append in-lst '(#t)) (car p))
            (do-count (append in-lst '(#f)) (cadr p)))))
    (do-count '() precise)
    count)
  
;  (define-synthax (auto-expr k autos)
;    #:assert (> k 0)
;    [choose
;     #t
;     #f
;     (car autos) 
;     (cadr autos) 
;     (caddr autos) 
;     (cadddr autos) 
;     (car (cddddr autos)) 
;     (cadr (cddddr autos)) 
;     (caddr (cddddr autos)) 
;     (cadddr (cddddr autos)) 
;     (car (cddddr (cddddr autos))) 
;     (cadr (cddddr (cddddr autos)))
;     (not (auto-expr (- k 1) autos))
;     ([choose && ||] (auto-expr (- k 1) autos) (auto-expr (- k 1) autos) (auto-expr (- k 1) autos) (auto-expr (- k 1) autos))
;     ])
  
  
;  (define-synthax (one-of autos)
;    [choose #t #f
;             (car autos) 
;             (not (car autos)) 
;             (cadr autos) 
;             (not (cadr autos)) 
;             (caddr autos) (not (caddr autos))
;             (cadddr autos) (not (cadddr autos))
;             (car (cddddr autos)) (not (car (cddddr autos)))
;             (cadr (cddddr autos)) (not (cadr (cddddr autos)))
;             (caddr (cddddr autos)) (not (caddr (cddddr autos)))
;             (cadddr (cddddr autos)) (not (cadddr (cddddr autos)))
;             (car (cddddr (cddddr autos))) (not (car (cddddr (cddddr autos))))
;             (cadr (cddddr (cddddr autos))) (not (cadr (cddddr (cddddr autos))))])
;  
;  (define-synthax (subset autos)
;    (and
;     [choose #t (car autos) (not (car autos))]
;     [choose #t (cadr autos) (not (cadr autos))]
;     [choose #t (caddr autos) (not (caddr autos))]
;     [choose #t (cadddr autos) (not (cadddr autos))]
;     [choose #t (car (cddddr autos)) (not (car (cddddr autos)))]
;     [choose #t (cadr (cddddr autos)) (not (cadr (cddddr autos)))]
;     [choose #t (caddr (cddddr autos)) (not (caddr (cddddr autos)))]
;     [choose #t (cadddr (cddddr autos)) (not (cadddr (cddddr autos)))]
;     [choose #t (car (cddddr (cddddr autos))) (not (car (cddddr (cddddr autos))))]
;     [choose #t (cadr (cddddr (cddddr autos))) (not (cadr (cddddr (cddddr autos))))]))
    
;  (define-synthax (auto-expr autos)
;    (or (subset autos) (subset autos) (subset autos) (subset autos) (subset autos) (subset autos) (subset autos)))
  
  (define db1-expr (dnf-expression auto-lst 8))
  (define db2-expr (dnf-expression auto-lst 8))
  (define db3-expr (dnf-expression auto-lst 8))
  
  (define (f db1 db2 db3 autos) (or (and (dnf-formula (replace-dnf-variables db1-expr autos)) db1) 
                                    (and (dnf-formula (replace-dnf-variables db2-expr autos)) db2) 
                                    (and (dnf-formula (replace-dnf-variables db3-expr autos)) db3)))
  (define limit-variables-formula (limit-num-variables (merge-dnf db1-expr (merge-dnf db2-expr db3-expr)) 9))
  
  (define (synth f-old bounds)
    (displayln "synthesizing...")

    (define-symbolic* width-auto-w boolean?)
    (define-symbolic* ml-auto-w boolean?)
    (define-symbolic* mr-auto-w boolean?)
    (define-symbolic* left-auto-w boolean?)
    (define-symbolic* right-auto-w boolean?)
    (define-symbolic* height-auto-w boolean?)
    (define-symbolic* mt-auto-w boolean?)
    (define-symbolic* mb-auto-w boolean?)
    (define-symbolic* top-auto-w boolean?)
    (define-symbolic* bottom-auto-w boolean?)

    (define-symbolic* container-d-w boolean?)
    (define-symbolic* inner-d-w boolean?)
    (define-symbolic* intrins-d-w boolean?)

    (define auto-lst-w (list width-auto-w ml-auto-w mr-auto-w left-auto-w right-auto-w height-auto-w mt-auto-w mb-auto-w top-auto-w bottom-auto-w))

    ;(define f-new-expr (tag [result] (f container-d inner-d intrins-d auto-lst)))
    (define m (synthesize 
                   #:forall (append auto-lst (list container-d inner-d intrins-d))
                   #:guarantee (assert (&& (implies sound (f container-d inner-d intrins-d auto-lst))
                                           (f-old container-d-w inner-d-w intrins-d-w auto-lst-w)
                                           (not (f container-d-w inner-d-w intrins-d-w auto-lst-w))
                                           bounds
                                           limit-variables-formula
                                           ))))
    (displayln "found expression: ")
    (display "container-d: ")
    (displayln (dnf-s-expr db1-expr m))
    (display "inner-d: ")
    (displayln (dnf-s-expr db2-expr m))
    (display "intrins-d: ")
    (displayln (dnf-s-expr db3-expr m))
    (newline)
    (define (f-new db1 db2 db3 lst)
      (evaluate (f db1 db2 db3 lst) m))
                   
    
    (display  "computing precision... ")
    (print (precision precise f-new))
    (newline)

    (define concrete-witness
      `(,(evaluate container-d-w m)
        ,(evaluate inner-d-w m)
        ,(evaluate intrins-d-w m)
        (,(evaluate width-auto-w m)
         ,(evaluate ml-auto-w m)
         ,(evaluate mr-auto-w m)
         ,(evaluate left-auto-w m)
         ,(evaluate right-auto-w m)
         ,(evaluate height-auto-w m)
         ,(evaluate mt-auto-w m)
         ,(evaluate mb-auto-w m)
         ,(evaluate top-auto-w m)
         ,(evaluate bottom-auto-w m))))

    (with-handlers ([exn:fail? (lambda (exn) (begin 
                                               (displayln exn)
                                               (display  "computing precision... ")
                                               (print (precision precise f-new))
                                               (newline)
                                               f-new))])
      (synth f-new (&& bounds (not (f (car concrete-witness) 
                                      (cadr concrete-witness)
                                      (caddr concrete-witness)
                                      (cadddr concrete-witness))))))
    )
  
  (synth (lambda (db1 db2 db3 lst) #t) #t)
  )

(displayln "Starting execution...")
; Compute the most accurate dirty-bit function
(define precise-db (get-precise-db '()))

(define m (synthesize-expression precise-db))

;(solve-db-constraints '(#f #f #f #f #f #f #f #f #f #f))
