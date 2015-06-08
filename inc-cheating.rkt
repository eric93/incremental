#lang s-exp rosette/safe

(require rosette/lib/meta/meta)

; Easy dirty-bit propagation function
(define (f-easy pos-d
                width-d
                height-d
                auto-d
                top-auto
                bottom-auto
                left-auto
                right-auto
                mt-auto
                mb-auto
                ml-auto
                mr-auto
                width-auto
                height-auto)
  (|| pos-d width-d height-d auto-d))

; Complicated dirty-bit propagation function
(define (f-hard pos-d
                width-d
                height-d
                auto-d
                top-auto
                bottom-auto
                left-auto
                right-auto
                mt-auto
                mb-auto
                ml-auto
                mr-auto
                width-auto
                height-auto)
  (if auto-d
      (|| pos-d width-d height-d auto-d)
      (|| (if (|| (&& top-auto bottom-auto) (&& left-auto right-auto)) pos-d #f)
          (if (|| (not (&& left-auto ml-auto mr-auto right-auto width-auto))
                  (&& (not (&& top-auto mt-auto mb-auto bottom-auto)) (|| (not height-auto) (&& (not top-auto) bottom-auto)))) 
              (|| width-d height-d)
              #f)
          (if (|| (&& (not left-auto) right-auto) (&& (not top-auto) bottom-auto)) 
              (|| width-d height-d pos-d) #f))))
        

(define-syntax decision-tree
  (syntax-rules ()
    [(decision-tree cond1 cond2 ... leaf) (if cond1 (decision-tree cond2 ... leaf) (decision-tree cond2 ... leaf))]
    [(decision-tree leaf) leaf]))

(define (choose-db)
  (define-symbolic* auto boolean?)
  (define-symbolic* pos boolean?)
  (define-symbolic* width boolean?)
  (define-symbolic* height boolean?)
  (list auto pos width height))
 
(define (run-f-hard db-lst auto-lst)
  (apply f-hard (append db-lst auto-lst)))
  
(define sol-num 0)
(define (print-sol-num)
  (print "Generating expression ")
  (print sol-num)
  (newline)
  (set! sol-num (+ sol-num 1)))

(define-symbolic f-auto boolean?)
(define-symbolic f-pos boolean?)
(define-symbolic f-width boolean?)
(define-symbolic f-height boolean?)
(define-symbolic auto boolean?)
(define-symbolic pos boolean?)
(define-symbolic width boolean?)
(define-symbolic height boolean?)
(define (solve-constraints lst)
  (let ([f-out (run-f-hard `(,f-pos ,f-width ,f-height ,f-auto) lst)])
    (begin (print-sol-num)
           (define m1 
             (synthesize #:forall (list f-auto f-pos f-width f-height)
                         #:guarantee (assert (eq? (|| (and auto f-auto) 
                                                      (and pos f-pos)
                                                      (and width f-width)
                                                      (and height f-height)) f-out))))
           `(,lst ,(evaluate auto m1) ,(evaluate pos m1) ,(evaluate width m1) ,(evaluate height m1)))))

  
(define (find-full-helper lst)
  (if (> (length lst) 9)
      (solve-constraints lst)
      (append (find-full-helper (append lst '(#t))) (find-full-helper (append lst '(#f))))))

(find-full-helper '())

