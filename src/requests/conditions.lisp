#| This file is part of cl-matrix
   Copyright (C) 2018-2019 Gnuxie <Gnuxie@protonmail.com> |#
(in-package :matrix-requests)

(define-condition cl-matrix-error (error)
  ((description :initarg :description
                :reader error-description))
  (:report (lambda (condition stream)
             (write-string (format nil "~a~%~a" (type-of condition) (error-description condition)) stream))))

(define-condition api-error (cl-matrix-error) ())

(define-condition forbidden (api-error) ())

(define-condition bad-state (api-error) ())

(docs:define-docs
  (type cl-matrix-error
        "Base Condition for all conditions defined in this package.")

  (type api-error
    "A base condition for all conditions raised by the matrix server in it's response content e.g. when the server returns an error object, this is different to when a HTTP error happens.

Contains a slot DESCRIPTION with a reader ERROR-DESCRIPTION which should contain the value of errcode and error from the error json object.
Will report the content of the ERROR-DESCRIPTION to a stream.

if the type of api-error has not been defined then this condition should be raised.

See https://matrix.org/docs/spec/client_server/latest.html#api-standards")

  (type forbidden
    "A condition for the matrix api error of FORBIDDEN

See https://matrix.org/docs/spec/client_server/latest.html#api-standards"))


(defun handle-request (request)
  (let ((response (jsown:parse (funcall request))))
    (if (jsown:keyp response "error")
        (let ((errcode (jsown:val response "errcode"))
              (error-msg (jsown:val response "error")))
          (cond ((search "M_LIMIT_EXCEEDED" errcode)
                 (sleep (/ (jsown:val response "retry_after_ms") 1000))
                 (handle-request request))

                ((search "FORBIDDEN" errcode)
                 (error 'forbidden :description error-msg))

                ((search "BAD_STATE" errcode)
                 (error 'bad-state :description error-msg))

                ((search "NOT_FOUND" errcode)
                 nil)

                (t (error 'api-error :description (format nil "errcode: ~a~%errmsg: ~a~%" errcode error-msg)))))
        response)))