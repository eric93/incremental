#lang s-exp rosette
(require "synthesize.rkt")
(define-inputs (container-d static-x static-y container-width container-height) (inner-d shrink-to-fit intrins-height) (intrins-d width height ml mr mt mb left right top bottom))

(define-conditions (width-auto ml-auto mr-auto left-auto right-auto height-auto mt-auto mb-auto top-auto bottom-auto))

(define-outputs
  (rel-x (lambda (static-x 
                 static-y 
                 container-width
                 container-height
                 shrink-to-fit 
                 intrins-height 
                 width 
                 height 
                 ml 
                 mr 
                 mt 
                 mb 
                 left 
                 right 
                 top 
                 bottom 
                 width-auto 
                 ml-auto 
                 mr-auto 
                 left-auto 
                 right-auto 
                 height-auto
                 mt-auto 
                 mb-auto 
                 top-auto 
                 bottom-auto)
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
                        (+ static-x new-ml)))))))
  (inner-width (lambda (static-x 
                        static-y 
                        container-width
                        container-height
                        shrink-to-fit 
                        intrins-height 
                        width 
                        height 
                        ml 
                        mr 
                        mt 
                        mb 
                        left 
                        right 
                        top 
                        bottom 
                        width-auto 
                        ml-auto 
                        mr-auto 
                        left-auto 
                        right-auto 
                        height-auto
                        mt-auto 
                        mb-auto 
                        top-auto 
                        bottom-auto)
                 (if (not width-auto)
                     width
                     (if (|| left-auto right-auto)
                         shrink-to-fit
                         (- container-width (+ left right (if ml-auto 0 ml) (if mr-auto 0 mr)))))))
  (rel-y (lambda (static-x 
                  static-y 
                  container-width
                  container-height
                  shrink-to-fit 
                  intrins-height 
                  width 
                  height 
                  ml 
                  mr 
                  mt 
                  mb 
                  left 
                  right 
                  top 
                  bottom 
                  width-auto 
                  ml-auto 
                  mr-auto 
                  left-auto 
                  right-auto 
                  height-auto
                  mt-auto 
                  mb-auto 
                  top-auto 
                  bottom-auto)
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
                       (+ top mt))))))
  (inner-height (lambda (static-x 
                         static-y 
                         container-width
                         container-height
                         shrink-to-fit 
                         intrins-height 
                         width 
                         height 
                         ml 
                         mr 
                         mt 
                         mb 
                         left 
                         right 
                         top 
                         bottom 
                         width-auto 
                         ml-auto 
                         mr-auto 
                         left-auto 
                         right-auto 
                         height-auto
                         mt-auto 
                         mb-auto 
                         top-auto 
                         bottom-auto)
           (if height-auto
               (if (|| top-auto bottom-auto)
                   intrins-height
                   (- container-height (+ top bottom (if mt-auto  0 mt) (if mb-auto 0 mb))))
               height))))

(do-synthesis)
  