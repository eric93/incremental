#lang racket

(require "parse-ftl.rkt")

(define (translate root)
  (define (translate-elem elem)
    (cond
      [(iface? elem) (translate-iface elem)]
      [(trait? elem) (translate-trait elem)]
      [(class? elem) (translate-class elem)]))
  (map translate-elem root))

(define (translate-iface old-iface)
  (iface (iface-name old-iface) (translate-attr-defs (iface-fields old-iface))))

(define (translate-attr-defs attrs)
  (define (attr-fn attr prev-attrs)
    (define kind (car attr))
    (define name (cadr attr))
    (define type (caddr attr))
    (append 
     prev-attrs
     (if (equal? kind "var")
         (list attr 
               `(,kind ,(string-append name "_delta_0") "bool")
               `(,kind ,(string-append name "_delta") "bool")
               `("input" ,(string-append name "_old") ,type)
               `("input" ,(string-append name "_old_0") ,type))
         (list attr
               `(,kind ,(string-append name "_delta") "bool")))))
  (foldl attr-fn '() attrs))

(define (translate-trait t)
  (trait (trait-name t) (translate-body (trait-body t))))

(define (translate-class c)
  (class (class-name c) (class-traits c) (class-interface c) (translate-body (class-body c))))

(define (translate-body b)
  (define children (body-children b))
  (define attr-list (body-attributes b))
  (define actions (body-actions b))
  (body children (translate-attr-defs attr-list) (translate-assignments actions)))

(define (old-ref attrib)
  (define loc (attr-loc attrib))
  (define name (attr-name attrib))
  (define index (attr-index attrib))
  (attr loc index (string-append name "_old")))

(define (old-0-ref attrib)
  (define loc (attr-loc attrib))
  (define name (attr-name attrib))
  (define index (attr-index attrib))
  (attr loc index (string-append name "_old_0")))

(define (delta-ref attrib)
  (define loc (attr-loc attrib))
  (define name (attr-name attrib))
  (define index (attr-index attrib))
  (attr loc index (string-append name "_delta")))

(define (delta-0-ref attrib)
  (define loc (attr-loc attrib))
  (define name (attr-name attrib))
  (define index (attr-index attrib))
  (attr loc index (string-append name "_delta_0")))

(define (free-vars expr)
  (match expr
    [`(fold ,init ,step) (append (free-vars init) (free-vars step))]
    [`(ite ,if ,then ,else) (append (free-vars if) (free-vars then) (free-vars else))]
    [`(and ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(or ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(not ,e) (append (free-vars e))]
    [`(> ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(< ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(>= ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(<= ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(= ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(!= ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(+ ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(- ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(* ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(/ ,e1 ,e2) (append (free-vars e1) (free-vars e2))]
    [`(- ,e) (append (free-vars e))]
    [`(ref ,r) (list r)]
    [`(num ,n) '()]
    [`(bool ,b) '()]
    [`(call ,name ()) '()]
    [`(call ,name ,args) (apply append (map free-vars args))]))

(define (construct-delta-0 vars)
  (match vars 
    ['() `(bool #f)]
    [`(,v) `(ref ,(delta-ref v))]
    [vs `(or (ref ,(delta-ref (car vs))) ,(construct-delta-0 (cdr vs)))]))

(define (reindex-multichild attrib)
  ;TODO: need to check if the attrib is on a singleton child
  (if (eq? (attr-loc attrib) "self")
      attrib
      (reindex attrib "$i")))

(define (translate-expr expr attrib)
  (define delta-0-expr (construct-delta-0 (free-vars expr)))
  (define delta-expr `(!= (ref ,(reindex-multichild attrib)) (ref ,(reindex-multichild (old-0-ref attrib)))))
  (define new-expr `(ite (ref ,(delta-0-ref attrib)) ,expr (ref ,(old-0-ref attrib))))
  (list delta-0-expr new-expr delta-expr))

(define (reindex attrib new-idx)
  (define idx (attr-index attrib))
  (attr (attr-loc attrib) (if (equal? idx "") new-idx idx) (attr-name attrib)))

(define (hoist-deltas asgns)
  (define (needs-hoisting a)
    (match (asgn-rhs a)
      [`(fold ,init ,step) #f]
      [_ (equal? (attr-loc (asgn-lhs a)) "self")]))
  (define hoisted (filter needs-hoisting asgns))
  (define not-hoisted (filter (lambda (x) (not (needs-hoisting x))) asgns))
  (list not-hoisted hoisted))
  
(define (translate-assignments asgns)
  (define (translate-assign assign prev-assigns)
    (define lhs (asgn-lhs assign))
    (define rhs (asgn-rhs assign))
    
    (define (refold exprs1 exprs2)
      (for/list ([expr1 exprs1]
                 [expr2 exprs2])
        `(fold ,expr1 ,expr2)))
    
    (define (self-fold init step)
      (define child-vars (filter (lambda (x) (not (equal? (attr-loc x) "self"))) (free-vars step)))
      (define unsupported-vars (filter (lambda (x) (and (equal? (attr-loc x) "self") (not (equal? (attr-name x) (attr-name lhs))))) (free-vars step)))
      (unless (equal? unsupported-vars '()) (begin (displayln (attr-name lhs)) (displayln (map attr-name unsupported-vars)) (error "Unsupported fold.")))
      (define init-vars (free-vars init))
      (define delta-0-expr `(fold ,(construct-delta-0 init-vars) (or (ref ,(reindex (delta-0-ref lhs) "$-")) ,(construct-delta-0 child-vars))))
      (define new-expr `(fold (ite (ref ,(delta-0-ref lhs)) ,init (ref ,(old-ref lhs))) (ite (ref ,(delta-0-ref lhs)) ,step (ref ,(reindex lhs "$-")))))
      (define delta-expr `(!= (ref ,lhs) (ref ,(old-0-ref lhs))))
      (list delta-0-expr new-expr delta-expr))
    
    (define (child-fold init step)
      (define init-exprs (translate-expr init lhs))
      (refold (list (car init-exprs) init `(num 0)) (translate-expr step (reindex lhs "$i"))))
    
    (define exprs 
      (match rhs
        [`(fold ,init ,step) (if (equal? (attr-loc lhs) "self") (self-fold init step) (child-fold init step))]
        [e (translate-expr e lhs)]))
                   
    (append
     prev-assigns
     (list
      (asgn (delta-0-ref lhs) (car exprs))
      (asgn (asgn-lhs assign) (cadr exprs))
      (asgn (delta-ref lhs) (caddr exprs)))))
  
  (define (translate-loop loop prev-assigns)
    (define new-assigns (hoist-deltas (translate-assignments (caddr loop))))
    (define inner (car new-assigns))
    (define outer (cadr new-assigns))
    (cons (list 'loop (cadr loop) inner) (append outer prev-assigns)))

  
  (foldl (lambda (a b) (if (asgn? a) (translate-assign a b) (translate-loop a b))) '() asgns))

(define (test)
  (define inp (open-input-file "test.ftl"))
  (define parsed (parse-ftl inp))
  (define translated (translate parsed))
  (define result (serialize-ftl translated))
  (define out (open-output-file "test-result.ftl" #:exists 'replace))
  (display result)
  (display result out)
  (close-output-port out))

(define (run-translate file)
  (define inp (open-input-file (string-append file ".ftl")))
  (define parsed (parse-ftl inp))
  (define translated (translate parsed))
  (define result (serialize-ftl translated))
  (define out (open-output-file (string-append file "_update.ftl") #:exists 'replace))
  (display result out)
  (close-output-port out))

    

