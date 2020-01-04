#|
    Copyright (C) 2019 Gnuxie <Gnuxie@protonmail.com>
|#

(in-package :cl-matrix)

;;; This file is just going to be for functions like get-joined-rooms, that only
;;; need simple wrapping of the cl-matrix.api.* funs to make them more useful.

;;; we could actually just add some kind of post operation to the generator
;;; since all these are really simple, but imo, you'd still have to
;;; make a seperate function because otherwise it's just inconsistent

;;; actually this is something we should absoloutley look into

(defun room-members (account room-id &key at membership not-membership)
  "Get the JSON for the room members list.

AT is the point in time (pagination token) to return members for in the room.

MEMBERSHIP is the kind of membership to filter for. Defaults to no filtering if unspecified. It can be one of: join, invite, leave, ban.

NOT-MEMBERSHIP is the kind of membership to exclude from the results. Defaults to no filtering if unspecified.

See https://matrix.org/docs/spec/client_server/r0.6.0#id259"
  (jsown:val (cl-matrix.api.client:get-rooms/roomid/members
              account room-id
              :parameters (append
                           (when at
                             (list (cons "at" at)))
                           (when membership
                             (list (cons "membership" membership)))
                           (when not-membership
                             (list (cons "not_membership" not-membership)))))
             "chunk"))

(defun joined-rooms (account)
  (jsown:val (cl-matrix.api.client:get-joined-rooms account)
             "joined_rooms"))

(defun room-leave (account room-id)
  (cl-matrix.api.client:post-rooms/roomid/leave account room-id "{}"))

(defun room-forget (account room-id)
  (cl-matrix.api.client:post-rooms/roomid/forget account room-id "{}"))
