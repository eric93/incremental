#lang s-exp rosette/safe

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
  