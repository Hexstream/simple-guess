(cl:defpackage #:simple-guess_tests
  (:use #:cl #:parachute)
  (:import-from #:simple-guess #:inquire)
  (:import-from #:fakenil #:nil*))

(cl:in-package #:simple-guess_tests)


(defclass toxic-advisor (simple-guess:advisor) ())

(defmethod inquire ((manager simple-guess:manager) (advisor toxic-advisor) &key)
  (error "Barf."))

(defclass echo-advisor (simple-guess:advisor) ())

(defmethod inquire ((manager simple-guess:manager) (advisor echo-advisor) &rest query)
  query)


(define-test "main"
  (let ((manager (make-instance 'simple-guess:manager))
        (t-advisor (simple-guess:constant-advisor t))
        (nil-advisor (simple-guess:constant-advisor nil))
        (nil*-advisor (simple-guess:constant-advisor nil*))
        (toxic-advisor (make-instance 'toxic-advisor))
        (echo-advisor (make-instance 'echo-advisor)))
    (flet ((inquire-ignoring-query (expected-advice advisor)
             (is eq expected-advice (inquire manager advisor))
             (is eq expected-advice (inquire manager advisor :literally :anything))))
      (let ((constant (simple-guess:constant-advisor 'advice)))
        (is eq 'advice (simple-guess:advice constant))
        (inquire-ignoring-query 'advice constant)
        (is eq constant (simple-guess:eager-advisor constant)))
      (let ((advisor (simple-guess:eager-advisor
                      t-advisor
                      toxic-advisor)))
        (is equal (list t-advisor toxic-advisor)
            (simple-guess:advisors advisor))
        (inquire-ignoring-query t advisor))
      (inquire-ignoring-query t (simple-guess:eager-advisor
                                 nil-advisor
                                 t-advisor))
      (inquire-ignoring-query nil* (simple-guess:eager-advisor
                                    nil*-advisor
                                    t-advisor))
      (let ((transformer (lambda (query)
                           (list* :arg (* (getf query :arg) 2)
                                  query))))
        (is equal '(:arg 8 :other-arg :initial :arg 4)
            (inquire manager
                     (simple-guess:query-variant-advisor echo-advisor transformer)
                     :other-arg :initial
                     :arg 4))
        (is equal '(:arg 8 :other-arg :initial :arg 4)
            (inquire manager
                     (simple-guess:query-variants-advisor echo-advisor (list transformer
                                                                             (lambda (query)
                                                                               (declare (ignore query))
                                                                               (error "Shadowed."))))
                     :other-arg :initial
                     :arg 4))))))
