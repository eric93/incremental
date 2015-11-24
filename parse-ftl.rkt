#lang racket

(require parser-tools/lex)
(require (prefix-in : parser-tools/lex-sre))
(require parser-tools/yacc)
(require racket/match)

(provide parse-ftl 
         serialize-ftl
         (struct-out iface)
         (struct-out body)
         (struct-out trait)
         (struct-out asgn)
         (struct-out attr)
         (struct-out children)
         (struct-out class))

(define-empty-tokens e-tkns (INTERFACE 
                             RBRACE 
                             LBRACE 
                             VAR 
                             INPUT 
                             TRAIT 
                             CLASS 
                             CHILDREN 
                             ATTRIBUTES 
                             ACTIONS
                             LOOP
                             ASSIGN
                             FOLD
                             FOLD-SEP
                             END-STMT
                             COND
                             COLON
                             PLUS
                             MINUS
                             AND
                             OR
                             DIV
                             MUL
                             LPAREN
                             RPAREN
                             LBRACKET
                             RBRACKET
                             COMMA
                             DOT
                             GE
                             LE
                             GEQ
                             LEQ
                             EQ
                             NEQ
                             NOT
                             EOF))

(define-tokens tkns (IDENT
                     NUMERIC
                     BOOL
                     INDEX))

(define-lex-trans int
  (syntax-rules ()
    ((_)
     (:+ (char-range "0" "9")))))

(define-lex-trans exponent
  (syntax-rules ()
    ((_)
     (:seq (:or "e" "E") (:? (:or "+" "-")) (:+ (char-range "0" "9"))))))

(define-lex-trans float
  (syntax-rules ()
    ((_)
     (:or (:seq (:+ (char-range "0" "9")) "." (:* (char-range "0" "9")) (:? (exponent)) (:? "f"))
          (:seq "." (:+ (char-range "0" "9")) (:? (exponent)))
          (:seq (:+ (char-range "0" "9")) (exponent))))))

(define-lex-trans number
  (syntax-rules ()
    ((_)
     (:or (int) (float)))))

(define-lex-trans ident
  (syntax-rules ()
    ((_)
     (:seq (:or (char-range "a" "z") (char-range "A" "Z") "_" "&") (:* (:or (char-range "a" "z") (char-range "A" "Z") (char-range "0" "9") "_" "-"))))))

(define-lex-trans comment 
  (syntax-rules ()
    ((_)
     (:or (:seq "//" (:* (char-complement (:or "\r" "\n"))) (:? "\r") "\n")
          (:seq "/*" (:* any-char) "*/")))))

(define ftl-lex 
  (lexer
   [(comment) (ftl-lex input-port)]
   ["true" (token-BOOL #t)]
   ["false" (token-BOOL #f)]
   ["interface" (token-INTERFACE)]
   ["}" (token-RBRACE)]
   ["{" (token-LBRACE)]
   ["var" (token-VAR)]
   ["input" (token-INPUT)] 
   ["trait" (token-TRAIT)] 
   ["class" (token-CLASS)] 
   ["children" (token-CHILDREN)]
   ["attributes" (token-ATTRIBUTES)]
   ["actions" (token-ACTIONS)]
   ["loop" (token-LOOP)]
   [":=" (token-ASSIGN)]
   ["fold" (token-FOLD)]
   [".." (token-FOLD-SEP)]
   [";" (token-END-STMT)]
   ["?" (token-COND)]
   [":" (token-COLON)]
   ["+" (token-PLUS)]
   ["-" (token-MINUS)]
   ["&&" (token-AND)]
   ["||" (token-OR)]
   ["/" (token-DIV)]
   ["*" (token-MUL)]
   ["(" (token-LPAREN)]
   [")" (token-RPAREN)]
   ["[" (token-LBRACKET)]
   ["]" (token-RBRACKET)]
   ["," (token-COMMA)]
   ["." (token-DOT)]
   [">" (token-GE)]
   ["<" (token-LE)]
   [">=" (token-GEQ)]
   ["<=" (token-LEQ)]
   ["==" (token-EQ)]
   ["!=" (token-NEQ)]
   ["!" (token-NOT)]
   [(:seq "$" (:or "-" "i" "0" "$")) (token-INDEX lexeme)]
   [(eof) (token-EOF)]
   [(number) (token-NUMERIC (string->number lexeme))]
   [(ident) (token-IDENT lexeme)]
   [whitespace (ftl-lex input-port)]))



(struct iface (name fields))
(struct body (children attributes actions))
(struct trait (name body))
(struct asgn (lhs rhs) #:transparent)
(struct attr (loc index name) #:transparent)
(struct children (name type))
(struct class (name traits interface body))

(define (merge-body elem prev-body)
  (body (append (car elem) (body-children prev-body))
        (append (cadr elem) (body-attributes prev-body))
        (append (caddr elem) (body-actions prev-body))))

(define ftl-parse
  (parser
   (start decl-list)
   (tokens tkns e-tkns)
   (end EOF)
   (error (print "ERROR!"))
   (grammar
    (decl-list
     ((decl) (list $1))
     ((decl decl-list) (cons $1 $2)))
    (decl 
     ((iface-decl) $1)
     ((trait-decl) $1)
     ((class-decl) $1))
    
    (class-decl
     ((CLASS IDENT COLON IDENT LBRACE class-body RBRACE) (class $2 '() $4 $6))
     ((CLASS IDENT LPAREN trait-list RPAREN COLON IDENT LBRACE class-body RBRACE) (class $2 $4 $7 $9)))
    
    (trait-list
     ((IDENT COMMA trait-list) (cons $1  $3))
     ((IDENT) (list $1)))
     
    (iface-decl
     ((INTERFACE IDENT LBRACE attr-list RBRACE) (iface $2 $4)))
    
    (attr-list ((attr-def IDENT COLON IDENT END-STMT attr-list) (cons (list $1 $2 $4) $6))
               ((attr-def IDENT COLON IDENT END-STMT) (list (list $1 $2 $4))))
    
    (attr-def ((VAR) "var")
              ((INPUT) "input"))
    
    (trait-decl
     ((TRAIT IDENT LBRACE class-body RBRACE) (trait $2 $4)))
    
    (class-body
     ((body-elem class-body) (merge-body $1 $2))
     ((body-elem) (body (car $1) (cadr $1) (caddr $1))))
    
    (body-elem
     ((ACTIONS LBRACE asgn-list RBRACE) `(() () ,$3))
     ((CHILDREN LBRACE child-list RBRACE) `(,$3 () ()))
     ((ATTRIBUTES LBRACE attr-list RBRACE) `(() ,$3 ())))
    
    (asgn
     ((LOOP IDENT LBRACE asgn-list RBRACE) `(loop ,$2 ,$4))
     ((attr-ref ASSIGN expr END-STMT) (asgn $1 $3)))
    
    (asgn-list
     ((asgn asgn-list) (cons $1 $2))
     ((asgn) (list $1)))
    
    (attr-ref
     ((IDENT) (attr "self" "" $1))
     ((IDENT DOT IDENT) (attr $1 "" $3))
     ((INDEX DOT IDENT) (attr "self" $1 $3))
     ((IDENT INDEX DOT IDENT) (attr $1 $2 $4)))
    
    (child-list
     ((IDENT COLON child-type END-STMT child-list) (append (children $1 $3) $5))
     ((IDENT COLON child-type END-STMT) (list (children $1 $3))))
    
    (child-type
     ((IDENT) $1)
     ((LBRACKET IDENT RBRACKET) (string-append "[" $2 "]")))
    
    (expr
     ((cond-expr) $1)
     ((FOLD cond-expr FOLD-SEP cond-expr) `(fold ,$2 ,$4)))
    
    (cond-expr
     ((and-expr) $1)
     ((and-expr COND and-expr COLON and-expr) `(ite ,$1 ,$3 ,$5)))
    
    (and-expr
     ((or-expr) $1)
     ((or-expr AND and-expr) `(and ,$1 ,$3)))
    
    (or-expr
     ((comparison) $1)
     ((comparison OR or-expr) `(or ,$1 ,$3)))
    
    (comparison
     ((term) $1)
     ((NOT term) `(not ,$2))
     ((term GE term) `(> ,$1 ,$3))
     ((term LE term) `(< ,$1 ,$3))
     ((term GEQ term) `(>= ,$1 ,$3))
     ((term LEQ term) `(<= ,$1 ,$3))
     ((term EQ term) `(= ,$1 ,$3))
     ((term EQ term) `(!= ,$1 ,$3)))
    
    (term
     ((factor) $1)
     ((factor PLUS term) `(+ ,$1 ,$3))
     ((factor MINUS term) `(- ,$1 ,$3)))
    
    (factor
     ((prim-expr) $1)
     ((prim-expr MUL factor) `(* ,$1 ,$3))
     ((prim-expr DIV factor) `(/ ,$1 ,$3)))
    
    (prim-expr
     ((MINUS prim-expr) `(- ,$2))
     ((attr-ref) `(ref ,$1))
     ((NUMERIC) `(num ,$1))
     ((BOOL) `(bool ,$1))
     ((IDENT LPAREN arg-list RPAREN) `(call ,$1 ,$3))
     ((IDENT LPAREN RPAREN) `(call ,$1 ()))
     ((LPAREN expr RPAREN) $2))
    
    (arg-list
     ((expr) (list $1))
     ((expr COMMA arg-list) (cons $1 $3))))))
    



(define (serialize-ftl root)
  (define (m decl)
    (cond
      [(iface? decl) (serialize-iface decl)]
      [(trait? decl) (serialize-trait decl)]
      [(class? decl) (serialize-class decl)]))
  (string-join (map m root) "\n"))

(define (serialize-iface iface)
  (define header (string-append "interface " (iface-name iface) " {\n"))
  (define body (string-join (map serialize-attr-def (iface-fields iface)) "\n"))
  (define footer "\n}\n")
  (string-append header body footer))

(define (serialize-attr-def attr-def)
  (string-append "    " (car attr-def) " " (cadr attr-def) " : " (caddr attr-def) ";"))

(define (serialize-trait trait)
  (define header (string-append "trait " (trait-name trait) " {\n"))
  (define body (serialize-body (trait-body trait)))
  (define footer "\n}\n")
  (string-append header body footer))

(define (serialize-class class)
  (define header (string-append 
    "class " 
    (class-name class) 
    (if (equal? (class-traits class) '())
        "" 
        (string-append "(" (string-join (class-traits class) ",") ")"))
    " : "
    (class-interface class)
    " {\n"))
  (define body (serialize-body (class-body class)))
  (define footer "\n}\n")
  (string-append header body footer))

(define (serialize-body body)
  (define children (string-append "    children {\n" (serialize-children (body-children body)) "\n    }\n"))
  (define attributes (string-append "    attributes {\n" (string-join (map serialize-attr-def (body-attributes body)) "\n") "\n    }\n"))
  (define actions (string-append "    actions {\n" (serialize-assignments (body-actions body) 8) "\n    }\n"))
  (string-append children attributes actions))

(define (serialize-children children)
  (define (serialize-child child)
    (string-append "        " (children-name child) " : " (children-type child) ";\n"))
  (string-join (map serialize-child children) ""))

(define (spaces depth)
  (if (equal? depth 0)
      ""
      (string-append (spaces (- depth 1)) " ")))

(define (serialize-assignments asgns depth)
  (define (serialize-assignment asgn d)
    (string-append (spaces d) (serialize-ref (asgn-lhs asgn)) " := " (serialize-expr (asgn-rhs asgn)) " ;\n"))
  (define (serialize-loop loop d)
    (string-append (spaces d) "loop " (cadr loop) " {\n" (serialize-assignments (caddr loop) (+ d 4)) (spaces d) "}\n"))
  (string-join (map (lambda (x) (if (asgn? x) (serialize-assignment x depth) (serialize-loop x depth))) asgns) "\n"))

(define (serialize-ref attr-ref)
  (define loc (if (equal? (attr-loc attr-ref) "self") "" (attr-loc attr-ref)))
  (define index (attr-index attr-ref))
  (define dot (if (and (equal? loc "") (equal? index "")) "" "."))
  
  (string-append loc index dot (attr-name attr-ref)))

(define (serialize-expr expr)
  ;(displayln expr)
  (match expr
    [`(fold ,init ,step) (string-append "fold (" (serialize-expr init) ") .. (" (serialize-expr step) ")")]
    [`(ite ,if ,then ,else) (string-append "(" (serialize-expr if) ") ? (" (serialize-expr then) ") : (" (serialize-expr else) ")")]
    [`(and ,e1 ,e2) (string-append "(" (serialize-expr e1) ") && (" (serialize-expr e2) ")")]
    [`(or ,e1 ,e2) (string-append "(" (serialize-expr e1) ") || (" (serialize-expr e2) ")")]
    [`(not ,e) (string-append "! (" (serialize-expr e) ")")]
    [`(> ,e1 ,e2) (string-append "(" (serialize-expr e1) ") > (" (serialize-expr e2) ")")]
    [`(< ,e1 ,e2) (string-append "(" (serialize-expr e1) ") < (" (serialize-expr e2) ")")]
    [`(>= ,e1 ,e2) (string-append "(" (serialize-expr e1) ") >= (" (serialize-expr e2) ")")]
    [`(<= ,e1 ,e2) (string-append "(" (serialize-expr e1) ") <= (" (serialize-expr e2) ")")]
    [`(= ,e1 ,e2) (string-append "(" (serialize-expr e1) ") == (" (serialize-expr e2) ")")]
    [`(!= ,e1 ,e2) (string-append "(" (serialize-expr e1) ") != (" (serialize-expr e2) ")")]
    [`(+ ,e1 ,e2) (string-append "(" (serialize-expr e1) ") + (" (serialize-expr e2) ")")]
    [`(- ,e1 ,e2) (string-append "(" (serialize-expr e1) ") - (" (serialize-expr e2) ")")]
    [`(* ,e1 ,e2) (string-append "(" (serialize-expr e1) ") * (" (serialize-expr e2) ")")]
    [`(/ ,e1 ,e2) (string-append "(" (serialize-expr e1) ") / (" (serialize-expr e2) ")")]
    [`(- ,e) (string-append "- (" (serialize-expr e) ")")]
    [`(ref ,r) (serialize-ref r)]
    [`(num ,n) (number->string n)]
    [`(bool ,b) (if b "true" "false")]
    [`(call ,name ()) (string-append name "()")]
    [`(call ,name ,args) (string-append name "(" (string-join (map serialize-expr args) ",") ")")]))


(define (parse-ftl input)
  (ftl-parse (lambda () (ftl-lex input))))

(define (test) 
  (define test-file (open-input-file "test.ftl"))
  (define (next-token)
    (define ret (ftl-lex test-file))
    (displayln ret)
    ret)
  (define test-file-lexed next-token)

  (ftl-parse test-file-lexed))

(define (test-lex)
  (define (test-lex-helper inp)
    (define out (inp))
    (displayln out)
    (if (equal? out (token-EOF))
        (displayln "Done")
        (test-lex-helper inp)))
  (define x (open-input-file "test.ftl"))
  (test-lex-helper (lambda () (ftl-lex x))))
  

(define (test-serialize x)
  (define out (open-output-file "test-result.ftl" #:exists 'replace))
  (display (serialize-ftl x) out)
  (close-output-port out))
  


