#| This file is part of cl-matrix
   Copyright (C) 2018-2019 Gnuxie <Gnuxie@protonmail.com> |#
(in-package :cl-matrix)

(defclass account (matrix-requests:url-formats)
  ((username :accessor username
             :initarg :username
             :initform ""
             :type string
             :documentation "The username for the account should be in the format \"@<username>:<homeserver>\"")

   (password :accessor password
             :initarg :password
             :initform ""
             :type string
             :documentation "The password for the account")

   (rooms :accessor %rooms
          :initarg :rooms
          :initform (make-hash-table :test 'equal :size 200)
          :type hash-table
          :documentation "a hash table containing room-ids that point to different room instances")

   (room-list :accessor room-list
              :initform nil
              :type list
              :documentation "a list representing the rooms which are in the hashtable")))

(defmethod print-object ((this-account account) stream)
  (print-unreadable-object (this-account stream :type t :identity t)
    (format stream "~a" (username this-account))))

(defun get-hostname (user-id) (elt (nth-value 1 (cl-ppcre:scan-to-strings "@.*:(.*)" user-id)) 0))

(defun make-account (username password &optional (homeserver (get-hostname username)))
  (make-instance 'account :username username :password password :homeserver homeserver))

(defmacro with-account ((this-account &optional logout-p) &body body)
  `(let ((*account* ,this-account))

     (unwind-protect (progn (unless (access-token ,this-account)
                              (login (username ,this-account) (password ,this-account))) 
                       ,@body)
       ,(when logout-p '(logout)))))

(defun get-room (room-id)
  (gethash room-id (%rooms *account*)))

(defun add-room (room-id room)
  (push room-id (room-list *account*))
  (setf (gethash room-id (%rooms *account*)) room))
