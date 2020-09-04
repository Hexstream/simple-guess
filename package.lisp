(cl:defpackage #:simple-guess
  (:use #:cl)
  (:export #:manager
           #:advisor
           #:inquire

           #:advisor-mixin
           #:advisors-mixin
           #:advisors

           #:*make-advisor-function*
           #:make-advisor
           #:constant-advisor
           #:advice
           #:eager-advisor
           #:query-variant-advisor
           #:query-transformer

           #:macro-advisor
           #:expansion
           #:standard-macro-advisor
           #:compute-expansion
           #:query-variants-advisor
           #:query-transformers
           #:grouping-function))
