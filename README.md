# CL-MATRIX
cl-matrix is a WIP client library for [matrix](https://matrix.org)

## Hello World!
Here is a hello world example

```

(defvar *user-one* (cl-matrix:make-account "@my-username:my-homeserver" "******"))

(cl-matrix:with-account (*user-one*)
  (cl-matrix:msg-send "hello world!" "!someRoomId:matrix.org"))
```

## What is supported
At the moment most apis are usable and there are classes for accounts and rooms

There is now also event listening and I will be writing more documentation on this shortly.

## Why did you make this?
I made this so I could write my own bots and tools for matrix, I am planning on sharing them as soon as this library has a release since most of them rely on it one change in this repo is going to break the others.

I have tried to make this as extensible as possible.

## What can I expect this to become
There is a chance that the code base could be abandoned still as it still hasn't had a release.
That being said, it's a fairly simple code base and there will be things here that are useful for similar libraries.

It is more likely though that I change some of the fundamental apis of this library rather than abandon it, for example by changing the way the functions interact with ACCOUNT objects (which atm they use a special variable \*ACCOUNT\* to do so).
