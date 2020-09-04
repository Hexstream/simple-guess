(in-package #:simple-guess)

(defclass simple-guess:macro-advisor (simple-guess:advisor) ())

(defgeneric simple-guess:expansion (macro-advisor))

(defmethod inquire ((manager simple-guess:manager) (advisor simple-guess:macro-advisor) &rest query)
  (apply #'inquire manager (simple-guess:expansion advisor) query))


(defclass simple-guess:standard-macro-advisor (simple-guess:macro-advisor)
  ((%expansion :reader simple-guess:expansion
               :type simple-guess:advisor)))

(defgeneric simple-guess:compute-expansion (macro-advisor))

(defmethod shared-initialize :after ((macro simple-guess:standard-macro-advisor) slot-names &rest initargs)
  (declare (ignore slot-names initargs))
  (setf (slot-value macro '%expansion) (simple-guess:compute-expansion macro)))


(defclass simple-guess:query-variants-advisor (simple-guess:advisor-mixin simple-guess:standard-macro-advisor)
  ((%query-transformers :initarg :query-transformers
                        :reader simple-guess:query-transformers
                        :type list
                        :initform (error "~S is required." :query-transformers))
   (%grouping-function :initarg :grouping-function
                       :reader simple-guess:grouping-function
                       :type (or function symbol)
                       :initform #'simple-guess:eager-advisor)))

(defun simple-guess:query-variants-advisor (advisor query-transformers &key (group #'simple-guess:eager-advisor))
  (make-advisor 'simple-guess:query-variants-advisor
                :advisor advisor
                :query-transformers query-transformers
                :grouping-function group))

(defmethod simple-guess:compute-expansion ((advisor simple-guess:query-variants-advisor))
  (let ((advisor (simple-guess:advisor advisor))
        (query-transformers (simple-guess:query-transformers advisor))
        (grouping-function (simple-guess:grouping-function advisor)))
    (apply grouping-function
           (mapcar (lambda (transform)
                     (simple-guess:query-variant-advisor advisor transform))
                   query-transformers))))
