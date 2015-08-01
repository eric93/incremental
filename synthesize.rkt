#lang s-exp rosette

(define inputs '())
(define outputs '())
(define conditions '())

(define (set-inputs! x) (set! inputs x))
(define (set-outputs! x) (set! outputs x))
(define (set-conditions! x) (set! conditions x))

(provide do-synthesis set-inputs! set-outputs! set-conditions!)
(provide define-inputs define-outputs define-conditions)
(require "dnf-expression.rkt")

(define-syntax-rule (define-inputs (input-bit input ...) ...)
  (begin
    (define (gen-sym-pair)
      (define-symbolic* input-old number?)
      (define-symbolic* input-new number?)
      (cons input-old input-new))
    (begin
      (define-symbolic input-bit boolean?)
      (begin (define input (gen-sym-pair))
             ...
             ))
    ...
    (set-inputs! (list (cons input-bit (list input ...)) ...))))

(define-syntax-rule (define-outputs (output output-function) ...)
  (begin
    (define (gen-sym-pair)
      (define-symbolic* output-old number?)
      (define-symbolic* output-new number?)
      (cons output-old output-new))
    
    (define output (gen-sym-pair))
    ...
    (set-outputs! (list (cons output output-function) ...))))

(define-syntax-rule (define-conditions (cond ...))
  (begin
    (define-symbolic cond boolean?)
    ...
    (set-conditions! (list cond ...))))

;(define-syntax-rule (do-synthesis)
;  (get-precise inputs outputs (length conditions) '()))

(define (do-synthesis)
  (define precise (get-precise inputs outputs (length conditions) '()))
  (compute-approximation inputs conditions precise))
  ;(define (num-true len precise)
  ;  (if (= len 0)
  ;      (apply + (map (lambda (x) (if x 0 1)) precise))
  ;      (+ (num-true (- len 1) (car precise)) (num-true (- len 1) (cadr precise)))))
  ;(num-true (length conditions) precise)
  ;(print precise))


(define (outputs-changed? outputs)
  (apply || (map (lambda (output)
                   (not (= (car (car output)) (cdr (car output)))))
                 outputs)))

(define (inputs-same? inputs)
  (apply && (map (lambda (input-lst)
                   (apply && (map (lambda (input)
                                    (= (car input) (cdr input))) 
                                  (cdr input-lst))))
                 inputs)))

(define (output-values inputs outputs cond-lst)
  (define old-inputs (for*/list ([input-lst inputs]
                                 [input (cdr input-lst)])
                       (car input)))
  (define new-inputs (for*/list ([input-lst inputs]
                                 [input (cdr input-lst)])
                       (cdr input)))
  
  (define output-constraints (for/list ([output outputs])
                               (let ([old-out (car (car output))]
                                     [new-out (cdr (car output))]
                                     [out-func (cdr output)])
                                 (&& (= old-out (apply out-func (append old-inputs cond-lst)))
                                     (= new-out (apply out-func (append new-inputs cond-lst)))))))
  (apply && output-constraints))
                                     

; Recursive procedure to find the most precise dirty-bit function.
; Stored as a treemap from auto values to the set of dirty bits to 
; be propagated.
(define (get-precise inputs outputs num-conditions cond-lst)
  (if (= (length cond-lst) num-conditions)
      (solve-constraints inputs outputs cond-lst)
      `(,(get-precise inputs outputs num-conditions (append cond-lst '(#t))) 
        ,(get-precise inputs outputs num-conditions (append cond-lst '(#f)))) 
      ))

(define (solve-constraints inputs outputs cond-lst)
  (define (is-sat? expr)
      (with-handlers ([exn:fail? (lambda (exn) (begin (displayln exn) #f))]) 
        (begin 
          (define m (solve (assert expr)))
          ;(print m)
          #t)))
  (define (all-false? lst) (> 0 (length (filter (lambda (x) x) lst))))
  (define (solve-constraints-helper prev rest)
    (if (eq? rest '())
        '()
        (let* ([head (car rest)]
               [new-rest (cdr rest)]
               [result (begin
                         ;(displayln (output-values inputs outputs cond-lst))
                         ;(displayln (outputs-changed? outputs))
                         ;(displayln (inputs-same? prev))
                         ;(displayln (inputs-same? new-rest))
                         ;(newline)
                         (is-sat? (&& (output-values inputs outputs cond-lst)
                                      (outputs-changed? outputs)
                                      (inputs-same? prev)
                                      (inputs-same? new-rest))))])
          (cons result (solve-constraints-helper (cons head prev) new-rest)))))
  
  (solve-constraints-helper '() inputs))

(define (compute-approximation inputs conditions precise)
  (define (soundness-constraint lst precise inputs)
    (if (= (length lst) 0)
        (apply || (for/list ([input inputs]
                             [p-val precise])
                    (if p-val input #f)))
        (|| (&& (not (car lst))
                (soundness-constraint (cdr lst) (cadr precise) inputs))
            (&& (car lst)
                (soundness-constraint (cdr lst) (car precise) inputs)))))
  
  (define cond-lst conditions)
  (define input-lst (map car inputs))
  (define sound (soundness-constraint cond-lst precise input-lst))
  
  ; approximate must be a list of functions taking as input
  ; the condition list and the ith function must output
  ; whether or not the ith change bit is propagated
  (define (precision precise approximate)
    (define count 0)
    (define (do-count in-lst p)
      (if (= (length in-lst) (length cond-lst))
          (for ([p-val p]
                [approx approximate])
            (let ([a-val (approx in-lst)])
              (cond
                [(&& p-val (not a-val)) (error "Invalid approximation")]
                [(&& (not p-val) a-val) (set! count (+ count 1))])))
          (begin 
            (do-count (append in-lst '(#t)) (car p))
            (do-count (append in-lst '(#f)) (cadr p)))))
    (begin
      (do-count '() precise)
      count))
            
      
  (define dnf-exprs (for/list ([input input-lst])
                      (dnf-expression cond-lst 8)))
  
  (define (f inputs conditions)
    (apply || (for/list ([dnf dnf-exprs]
                         [input inputs])
                (and input (dnf-formula (replace-dnf-variables dnf conditions))))))
  
  (define (gen-witness)
    (define (generate-variable x)
      (define-symbolic* new-var boolean?)
      new-var)
    (cons (map generate-variable inputs) (map generate-variable conditions)))
  
  (define initial-m (synthesize
                     #:forall (append cond-lst input-lst)
                     #:guarantee (assert (&& (<=> sound (f input-lst cond-lst))))))
  
  
  (define initial-complexity (map (lambda (x) (evaluate (total-variables x) (simplify x initial-m))) dnf-exprs))
  
  (display "Maximum complexity: ")
  (displayln (apply + initial-complexity))
  
  (define (synth f-old bounds)
    (define witness (gen-witness))
    (define input-w (car witness))
    (define cond-w (cdr witness))
   
    
    (define m (synthesize 
                   #:forall (append cond-lst input-lst)
                   #:guarantee (assert (&& (implies sound (f input-lst cond-lst))
                                           (f-old input-w cond-w)
                                           (not (f input-w cond-w))
                                           (apply && (for/list ([dnf dnf-exprs]
                                                                [bound initial-complexity])
                                                       (<= (total-variables dnf) bound)))
                                           bounds
                                           ))))
    
    (displayln "Found function:")
    (for/list ([input input-lst]
               [dnf dnf-exprs])
      (display input)
      (display ": ")
      (print (dnf-s-expr dnf m))
      (newline))
    
    (display "Initial complexity: ")
    (displayln (apply + (map (lambda (x) (evaluate (total-variables x) m)) dnf-exprs)))
    
    (define final-complexity (apply + (map (lambda (x) (evaluate (total-variables x) (simplify x m))) dnf-exprs)))
    (display "Final complexity: ")
    (displayln final-complexity)
    
    (define (f-new inputs conditions)
      (evaluate (f inputs conditions) m))
   
    (define (eval-dnf dnf cond model)
      (evaluate (dnf-formula (replace-dnf-variables dnf cond)) model))
    (define approx (map (lambda (dnf) (lambda (conditions) 
                                        (eval-dnf dnf conditions m)))
                        dnf-exprs))
    
    (display "Computing precision...")
    (displayln (precision precise approx))
    (newline)
    
    (define concrete-input-w (map (lambda (x) (evaluate x m)) input-w))
    (define concrete-cond-w (map (lambda (x) (evaluate x m)) cond-w))
    
    (with-handlers ([exn:fail? (lambda (exn) (begin 
                                               (displayln exn)
                                               (display  "computing precision... ")
                                               (print (precision precise approx))
                                               (newline)
                                               f-new))])
      (synth f-new (&& bounds (not (f concrete-input-w concrete-cond-w))))))
  
  (synth (lambda x #t) #t))

;(define-inputs (abd a b) (cd c))
;(define-conditions (m))
;(define-outputs (x (lambda (a b c m) (if m (+ a c) b)))
;  (y (lambda (a b c m) b)))
;
;(do-synthesis)