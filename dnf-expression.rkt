#lang s-exp rosette

(provide dnf-expression dnf-formula dnf-s-expr limit-num-variables merge-dnf replace-dnf-variables)
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
  
  (map add-symbols variables))

(define (replace-dnf-variables old-dnf new-vars)
  (define (replace-var zipped-dnf)
    (let* ([old-clauses (car (car zipped-dnf))]
           [new-var (cadr zipped-dnf)])
      (cons old-clauses new-var)))
  
  (map replace-var (zip old-dnf new-vars)))

(define (zipped dnf-expr)
  (define (uniform term)
    (let* ([variable (cdr term)]
           [clauses (car term)])
      (map (lambda (clause) (cons clause variable)) clauses)))
  
  (define uniform-expr (map uniform dnf-expr))
  (apply zip uniform-expr))

(define (dnf-formula dnf-expr)
  (define (formula-term dnf-term)
    (let* ([variable (cdr dnf-term)]
           [unused (car (car dnf-term))]
           [negated (cdr (car dnf-term ))])
      (or unused (xor negated variable))))
  
  (define (formula-clause dnf-clause)
    (apply && (map formula-term dnf-clause)))
  
  (define (formula-expr dnf)
    (apply || (map formula-clause dnf)))
  (formula-expr (zipped dnf-expr)))

(define (dnf-s-expr dnf-expr model)
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
    
    (define reduced-expr (foldl reduce-expr '() dnf-expr))
    (if (eq? reduced-expr #t)
        #t
        (cons '|| reduced-expr)))
  
  (s-expr-root (zipped dnf-expr)))

(define (limit-num-variables dnf-expr max-variables)
  (define (is-used variable)
    (define-symbolic* used number?)
    (define condition (apply && (map car (car variable))))
    (cons used (= used (if condition 0 1))))
  
  (define used-lst (map is-used dnf-expr))
  (define asgn-used-vals (apply && (map cdr used-lst)))
  (define sum-val (apply + (map car used-lst)))
  (&& asgn-used-vals (<= sum-val max-variables)))

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

(define-symbolic a boolean?)
(define-symbolic b boolean?)
(define-symbolic c boolean?)
(define-symbolic d boolean?)

(define dnf (dnf-expression (list a b) 2))
(define m (synthesize #:forall (list a b)
                      #:guarantee (assert (<=> (or a b) (dnf-formula dnf)))))