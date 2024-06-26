;; cd ~/android && ln -s android-dict/manifest.scm

;; What follows is a "manifest" equivalent to the command line you gave.
;; You can store it in a file that you may then pass to any 'guix' command
;; that accepts a '--manifest' (or '-m') option.

;; This file was initially created by
;;     guix shell PACKAGES --export-manifest

(use-modules
 (guix profiles)
 ;; fun fact: multiple modules can be addressed by a single prefix
 ;; ((bost gnu packages babashka) #:prefix bst:)
 ;; ((bost gnu packages clojure) #:prefix bst:)
 (srfi srfi-1) ; lset-union
 )

(use-package-modules
 admin
 android
 base
 bash
 certs
 compression
 curl
 databases
 file
 fontutils
 gcc
 gnupg
 guile
 java
 less
 libusb
 linux
 man
 ncurses
 node
 python
 rsync
 rust-apps
 shells
 shellutils
 ssh
 version-control
 vim
 xdisorg
 xorg

 gl
 java-compression
 patool
 chromium
 ninja
 llvm
 ;; cmake ; guix has 3.25.1; 3.22.1-g37088a8 is installed by Android-Studio
 pkg-config
 gtk
 qt
 )

(define (partial fun . args) (lambda x (apply fun (append args x))))


;; sudo apt-get install -y xz-utils libglu1-mesa
(define flutter-packages
  (list
   zip
   unzip

   glu
   mesa
   ;; mesa-headers
   ;; mesa-opencl
   ;; mesa-utils

   xz
   java-xz
   ;; pixz

   ncurses
   ;; version: 6.2.20210619
   ;; version: 5.9.20141206
   
   ;; libzim ;; libz
   ;; libzen ;; libz

   patool ;; bz2
   lbzip2 ;; bz2

   ungoogled-chromium
   ;; chromium
   ninja
   clang
   ;; cmake ; guix has 3.25.1; 3.22.1-g37088a8 is installed by Android-Studio
   pkg-config

   ;; gtk ;; Cross-platform widget toolkit
   gtk+ ;; Cross-platform widget toolkit
   ;; webkitgtk-for-gtk3 ;; gnu/packages/webkit
   ;; gtkglext ;; OpenGL extension to GTK+; gnu/packages/gnome.scm
   ;; gtkmm ;; C++ Interfaces for GTK+ and GNOME; gnu/packages/gtk.scm

   ))

(define project-packages
  (list
   qtwebglplugin
   adb
   android-file-transfer
   android-make-stub
   android-udev-rules
   bash
   bzip2
   coreutils
   binutils
   direnv
   e2fsprogs
   fd
   file
   findutils
   (@(nongnu packages mozilla) firefox)
   fontconfig
   freetype
   git
   glibc-locales
   gnupg
   grep
   help2man
   htop
   java-commons-cli
   libgccjit
   gcc
   libusb
   libx11
   libxext
   libxi
   libxrandr
   libxrender
   libxtst
   openjdk
   procps
   ripgrep
   sed
   strace
   sudo
   ;; '--container' causes wrong time. Preserving:
   ;;     --preserve='^GUIX_LOCPATH$' \
   ;;     --preserve='^TZDIR$' \
   ;; doesn't help. Including tzdata to the manifest.scm doesn't help.
   ;; tzdata
   usbutils
   vim
   which
   xdotool
   zlib
   ;; `guix shell openjdk@<version>:jdk PACKAGES --export-manifest' ignores the
   ;; '@<version>' if it matches the installed version. (The '@18' was added
   ;; manually.)
   ;; openjdk package removes javadoc libs, one has to use ONLY openjdk:jdk
   ;; https://github.com/clojure-emacs/orchard/issues/117#issuecomment-859987280
   ;; "openjdk@18:jdk"
   ))

(define project-manifest
  ((compose
    manifest
    (partial map package->manifest-entry))
   (append project-packages flutter-packages)))

(define corona-packages
  (list
   ;; ./heroku.clj needs babashka. Also `guix shell ...` contain
   ;; '--share=/usr/bin' so that shebang (aka hashbang) #!/bin/env/bb works
   (@(bost gnu packages babashka) babashka)
   bash

   ;; 1. The `ls' from busybox is causing problems. However it is overshadowed
   ;; when this list is reversed. (Using Guile or even on the command line.)
   ;;
   ;; 2. It seems like busybox is not needed if invoked with:
   ;;     guix shell ... --share=/usr/bin
   #;busybox

   ;; CLI tools to start a Clojure repl, use Clojure and Java libraries, and
   ;; start Clojure programs. See https://clojure.org/releases/tools
   ;; clojure-tools not clojure must be installed so that clojure binary
   ;; available on the CLI
   (@(gnu packages clojure) clojure-tools)

   binutils ;; ld
   coreutils
   curl
   direnv
   fish
   git
   grep

   ;; specifying only 'guile' leads to "error: guile: unbound variable", also guile-3.0
   ;; produces warning
   ;;   ldconfig: /lib/libguile-3.0.so.1.6.0-gdb.scm is not an ELF file - it has the wrong magic bytes at the start.
   ;; see https://issues.guix.gnu.org/64794
   guile-3.0

   iproute ; provides ss - socket statistics
   less
   ncurses
   nss-certs
   openssh

   ;; Heroku currently offers Postgres version 14 as the default.
   ;; https://devcenter.heroku.com/articles/heroku-postgresql#version-support
   ;; The ./var/log/postgres.log may contain:
   ;; FATAL:  database files are incompatible with server
   ;; DETAIL:  The data directory was initialized by PostgreSQL version 13, which is not compatible with this version 14.6.
   postgresql-13

   ;; provides: free pgrep pidof pkill pmap ps pwdx slabtoptload top vmstat w
   ;; watch sysctl
   procps

   ripgrep
   rsync
   sed
   which

   ;; #begin# for heroku installation
   node-lts
   python
   gnu-make ;; i.e. `make`
   ;; #end# for heroku installation

   neofetch ;; pimp my ride
   ))

((compose
  concatenate-manifests
  (partial list project-manifest)
  manifest
  ;; openjdk package removes javadoc libs, one has to use ONLY openjdk:jdk
  ;; https://github.com/clojure-emacs/orchard/issues/117#issuecomment-859987280
  (partial append (list (package->manifest-entry openjdk "jdk")))
  (partial map package->manifest-entry))
 corona-packages)
