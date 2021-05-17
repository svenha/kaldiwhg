; guile.scm
; portability for Guile (need to be loaded after general.scm because of filter definition?)

;(cond-expand-provide (current-module) '(debug)) 
(set! %cond-expand-features (cons 'debug %cond-expand-features)) ; set debug feature-identifier for cond-expand

(cond-expand (debug
(define-syntax assrt
  (syntax-rules ()
    ((assrt a . l)
     (unless a (error 'assert
                      (with-output-to-string (lambda () (write a)))
                      (list . l)))
     )))
)(else ; cond-expand
(define-syntax assrt
  (syntax-rules
    ()
    ((assrt a . l)
     #t)))
))

(cond-expand (utf8
(define-syntax lat1 ; a string from Latin-1
  (syntax-rules ()
    ((lat1 s)
     (iso-latin1->utf8 s))))
)(else
(define-syntax lat1
  (syntax-rules ()
    ((lat1 s)
     s))))) ; char or string

(cond-expand (utf8
(define-syntax lat1n ; numeric character code from Latin-1
  (syntax-rules ()
    ((lat1n s)
     (iso-latin1-code->utf8 s))))
)(else
(define-syntax lat1n
  (syntax-rules ()
    ((lat1n s)
     (integer->char s))))))

(define-syntax let-optionals*
  (syntax-rules ()
    ((let-optionals* . l)
     (let-optional* . l))))

(define (append-output-file f)
  (open-file f "a"))

(define (change-directory s)
  (chdir s))

(define (current-directory)
  (getcwd))

(define (current-minutes)
  (/ (current-second) 60.0)) ; from (scheme time)

(define (current-process-id)
  1) ; dummy

(define (directory-files d)
  (let ((l (scandir d)))
    (and l
         (remp (lambda (f)
                 (member f '("." "..")))
               l))))

(define (directory? f)
  (eq? (stat:type (stat f)) 'directory))

(define (file-size f)
  (stat:size (stat f)))

(define (flush-output-port p)
  (force-output p))

(define get-runtime (lambda ()
  (list (quotient (* (get-internal-run-time) 1000) internal-time-units-per-second) 0) ; SCM etc.
;  (let ((t (times))) (list (* (tms:utime t) 10) (* (tms:stime t) 10))) ; guile
  ))

(define (get-hostname) (gethostname)) ; (get-environment-variable "HOSTNAME")

(define (home-directory) (get-environment-variable "HOME"))

(define (integer->string n)
  (number->string n))

(define read-line-string (lambda (port)
  (read-line port))) ; needs (use-modules (ice-9 rdelim))
;  (let ((characters (read-line-characters input-stream))) ; normal definition does not work
;    (if (not characters)
;      #f
;      (list->string characters)))))

(define (read-with-shared-structure/file f)
  (call-with-input-file f (lambda (port)
                            (read-with-shared-structure port))))

(define string->integer string->number)

(define try (lambda (a b)
  a))

(define (with-directory dir pred)
  (let ((old-dir (current-directory)))
    (change-directory dir)
    (let ((result (pred)))
      (change-directory old-dir)
      result)))

(define (shell-command . args)
  (let ((command (reduce-r (lambda (arg result)
                              (string-append (if (symbol? arg) (symbol->string arg) arg) " " result))
                            args)))
    (system command)))

(define shell-command-output-strings (lambda args
  (let ((port (apply open-pipe* OPEN_READ args)))
    (let ((result (read-lines-string port)))
      (close-input-port port)
      result))))

(define shell-command-output-terms (lambda args
  (let ((port (apply open-pipe* OPEN_READ args)))
    (let ((result (read-terms port)))
      (close-input-port port)
      result))))

(define (open-input-gzip-file f)
  (open-input-pipe (string-append "gzip -cd " f)))

(define call-with-input-gzip-file (lambda (file pred)
  (let* ((port (open-input-gzip-file file))
         (result (pred port)))
    (close-input-port port)
    result)))

; functions as in scheme48

(define ascii->char integer->char)

(define char->ascii char->integer)

; bigloo hashtables:
;(define (make-hashtable . maybe-size) ; Warning: don't supply other arguments !
;  (let ((size (and (pair? maybe-size)
;                   (car maybe-size))))
;    (cond (size
;            (make-hash-table)) ; size not supported?
;      (else
;        (make-hash-table)))))
;(define hashtable-for-each hash-table-walk)
;(define (hashtable-get h key)
  ;;(and (hash-table-exists? h key)
  ;;     (hash-table-ref h key))
;  (hash-table-ref/default h key #f)) ; faster than above implementation
;(define hashtable-key-list hash-table-keys)
;(define hashtable-put! hash-table-set!)
;(define hashtable-size hash-table-size)

; fixnum operations: (not needed if importing: (rnrs arithmetic fixnums (6)))
;(define fx+ +)
;(define fx- -)
;(define fx* *)
;(define fx/ /)
;(define fx< <)
;(define fx= =)
;(define fx> >)
;(define fx<= <=)
;(define fx>= >=)
;(define fxmin min)
;(define fxmax max)
;(define fx< fx<?)
;(define fx= fx=?)
;(define fx> fx>?)
;(define fx<= fx<=?)
;(define fx>= fx>=?)
