;;; init.el --- Entrypoint for Emacs config
;;;
;;; Inspired by https://github.com/edwargix/emacs


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")

(load-file "~/.emacs.d/lisp/setup-packages.el")

(require 'setup-keys)
(require 'setup-appearance)
(require 'setup-dev)

;;; Save backup files in ~/tmp
(setq backup-directory-alist `(("." . "~/tmp/emacs"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      backup-by-copying t
      version-control t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-org evil-magit use-package evil-surround evil-collection))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
