(in-package #:simple-guess)

(defvar simple-guess:*make-advisor-function* #'make-instance)

(defun make-advisor (advisor-class &rest initargs)
  (apply simple-guess:*make-advisor-function* advisor-class initargs))


(defclass simple-guess:constant-advisor (simple-guess:advisor)
  ((%advice :initarg :advice
            :reader simple-guess:advice
            :initform nil)))

(defun simple-guess:constant-advisor (advice)
  (make-advisor 'simple-guess:constant-advisor :advice advice))

(defmethod inquire ((manager simple-guess:manager) (advisor simple-guess:constant-advisor) &rest query)
  (declare (ignore query))
  (simple-guess:advice advisor))


(defclass simple-guess:eager-advisor (simple-guess:advisors-mixin simple-guess:advisor)
  ())

(defun simple-guess:eager-advisor (&rest advisors)
  (if (consp advisors)
      (if (cdr advisors)
          (make-advisor 'simple-guess:eager-advisor :advisors advisors)
          (let ((advisor (car advisors)))
            (check-type advisor simple-guess:advisor)
            advisor))
      (simple-guess:constant-advisor nil)))

(defmethod inquire ((manager simple-guess:manager) (advisor simple-guess:eager-advisor) &rest query)
  (some (lambda (advisor)
          (apply #'inquire manager advisor query))
        (simple-guess:advisors advisor)))


(defclass simple-guess:query-variant-advisor (simple-guess:advisor-mixin simple-guess:advisor)
  ((%query-transformer :initarg :query-transformer
                       :reader simple-guess:query-transformer
                       :initform (error "~S is required." :query-transformer))))

(defun simple-guess:query-variant-advisor (advisor query-transformer)
  (make-advisor 'simple-guess:query-variant-advisor
                :advisor advisor :query-transformer query-transformer))

(defmethod inquire ((manager simple-guess:manager) (advisor simple-guess:query-variant-advisor) &rest query)
  (apply #'inquire manager (simple-guess:advisor advisor)
         (funcall (simple-guess:query-transformer advisor) query)))
