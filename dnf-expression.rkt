#lang s-exp rosette

(provide dnf-expression dnf-formula dnf-s-expr total-variables replace-dnf-variables simplify)
(define (zip . lists) (apply map list lists))

(define (dnf-expression variables num-clauses)
  (define (gen-symbols i)
    (if (= i 0) 
        '()
        (begin
          (define-symbolic* unused boolean?)
          (define-symbolic* negated boolean?)
          (cons (cons unused negated) (gen-symbols (- i 1))))))
  
  (define (add-symbols variable)
    (cons (gen-symbols num-clauses) variable))
  
  (define (generate-clause-flags i)
    (if (= i 0) 
        '()
        (begin
          (define-symbolic* clause-used boolean?)
          (cons clause-used (generate-clause-flags (- i 1))))))
  
  (cons (generate-clause-flags num-clauses) (map add-symbols variables)))

(define (replace-dnf-variables old-dnf new-vars)
  (define (replace-var zipped-dnf)
    (let* ([old-clauses (car (car zipped-dnf))]
           [new-var (cadr zipped-dnf)])
      (cons old-clauses new-var)))
  
  (cons (car old-dnf) 
        (map replace-var (zip (cdr old-dnf) new-vars))))

(define (zipped dnf-expr)
  (define (uniform term)
    (let* ([variable (cdr term)]
           [clauses (car term)])
      (map (lambda (clause) (cons clause variable)) clauses)))
  
  (define uniform-expr (map uniform dnf-expr))
  (apply zip uniform-expr))

(define (dnf-formula dnf-expr)
  (define clause-flags (car dnf-expr))
  (define (formula-term dnf-term)
    (let* ([variable (cdr dnf-term)]
           [unused (car (car dnf-term))]
           [negated (cdr (car dnf-term ))])
      (or unused (xor negated variable))))
  
  (define (formula-clause dnf-clause used)
    (apply && (cons used (map formula-term dnf-clause))))
  
  (define (formula-expr dnf)
    (apply || (for/list ([clause dnf]
                         [used-var clause-flags])
                       (formula-clause clause used-var))))
  (formula-expr (zipped (cdr dnf-expr))))

(define (dnf-s-expr dnf-expr model)
  (define clause-flags (car dnf-expr))
  (define (s-expr-term dnf-term)
    (let* ([variable (cdr dnf-term)]
           [unused (car (car dnf-term))]
           [negated (cdr (car dnf-term ))])
      (if (evaluate unused model)
          '()
          (if (evaluate negated model)
              `(not ,variable)
              variable))))
  
  (define (s-expr-clause dnf-clause)
    (define mapped-clause (cons '&& (map s-expr-term dnf-clause)))
    (filter (lambda (x) (or (not (list? x)) (> (length x) 0))) mapped-clause))
  (define (s-expr-root dnf-expr)
    (define (reduce-expr clause old-reduced)
      (define new-clause (s-expr-clause clause))
      (if (or (eq? old-reduced #t) (<= (length new-clause) 1))
          #t
          (append old-reduced (list new-clause))))
    
    (define filtered-expr (filter
                           (lambda (x) (evaluate (car x))) (zip clause-flags dnf-expr)))
    
    (define reduced-expr (foldl reduce-expr '() (map cadr filtered-expr)))
    (if (eq? reduced-expr #t)
        #t
        (cons '|| reduced-expr)))
  
  (s-expr-root (zipped (cdr dnf-expr))))

(define (limit-num-variables dnf-expr max-variables)
  (define (is-used variable)
    (define-symbolic* used number?)
    (define condition (apply && (map car (car variable))))
    (cons used (= used (if condition 0 1))))
  
  (define used-lst (map is-used dnf-expr))
  (define asgn-used-vals (apply && (map cdr used-lst)))
  (define sum-val (apply + (map car used-lst)))
  (&& asgn-used-vals (<= sum-val max-variables)))

(define (total-variables dnf-expr)
  (apply + (for*/list ([var (cdr dnf-expr)]
                       [term (car var)])
             (begin
               (define-symbolic* used number?)
               (if (car term) 0 1)))))

(define (simplify dnf-expr model)
  (define variables (map cdr (cdr dnf-expr)))
  
  (define (f vars)
    (dnf-formula (replace-dnf-variables dnf-expr vars)))
  (define (do-simplify cur bound)
    (define m1 (with-handlers ([exn:fail? (lambda (exn) 
                                            (begin
                                              (displayln exn)
                                              #f))])
                 (synthesize #:forall variables
                             #:guarantee (assert (&& (< (total-variables dnf-expr) bound)
                                                     (<=> (evaluate (f variables) cur)
                                                          (f variables)))))))
    (if (eq? m1 #f)
        (begin
          ;(display "final-complexity: ")
          ;(displayln (evaluate (total-variables dnf-expr) cur))
          cur)
        (begin
          (define complexity (evaluate (total-variables dnf-expr) m1))
          ;(display "complexity: ")
          ;(displayln complexity)
          ;(displayln (dnf-s-expr dnf-expr m1))
          
          (do-simplify m1 complexity))))
  
  (do-simplify model (evaluate (total-variables dnf-expr) model)))

(define (merge-dnf dnf1 dnf2)
  (if (eq? dnf1 '())
      '()
      (let* ([clauses1 (car (car dnf1))]
             [variable1 (cdr (car dnf1))]
             [clauses2 (car (car dnf2))]
             [variable2 (cdr (car dnf2))])
        (begin
          (synthesize #:forall (list variable1 variable2)
                      #:guarantee (<=> variable1 variable2))
          (cons (cons (append clauses1 clauses2) variable1) (merge-dnf (cdr dnf1) (cdr dnf2)))))))


(current-bitwidth 8)
(define-symbolic a boolean?)
(define-symbolic b boolean?)
(define-symbolic c boolean?)
(define-symbolic d boolean?)

(define dnf (dnf-expression (list a b) 2))
(define m (synthesize #:forall (list a b)
                      #:guarantee (assert (&& (< (total-variables dnf) 4)
                                              (<=> (or a b) (dnf-formula dnf))))))

(define (generate-symbol)
  (define-symbolic* x boolean?)
  x)
(define vars
  (list (generate-symbol) 
        (generate-symbol) 
        (generate-symbol) 
        (generate-symbol) 
        (generate-symbol)
        (generate-symbol)
        (generate-symbol)
        (generate-symbol)
        (generate-symbol)
        (generate-symbol)))
(define big-dnf (dnf-expression vars 8))

(define model (synthesize #:forall vars
                      #:guarantee (assert (<=> (dnf-formula big-dnf) #t))))