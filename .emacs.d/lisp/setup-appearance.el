;;; setup-apearance --- Setup how Emacs looks
;;;
;;; Commentary:
;;;
;;; Setup the appearance of Emacs

;;; Code:

(setq frame-title-format "emacs")

;;; Font
(set-frame-font
 (font-spec
  :name "Iosevka Term"
  :size 24
  :weight 'normal
  :width 'normal)
 nil t)

;;; Disable menu bar
(menu-bar-mode 0)

;;; Disable scroll bar
(scroll-bar-mode 0)

;;; Disable tool bar
(tool-bar-mode 0)

;;; Turn off cursor blinking
(blink-cursor-mode 0)

;;; Show column number next to line number in mode line
(column-number-mode)

;;; Column Marker
;(use-package 'column-marker)

;;; Highlight parentheses
(show-paren-mode)

;;; Highlight stuff with M-s h
(global-hi-lock-mode 1)

;;; Spell check in comments and strings
(flyspell-prog-mode)

;;; Custom themes
;; Default theme
(unless (package-installed-p 'oceanic-theme)
  (package-install 'oceanic-theme))
(load-theme 'oceanic t)

(unless (package-installed-p 'atom-one-dark-theme)
  (package-install 'atom-one-dark-theme))
;; Alternate theme (bright)
(unless (package-installed-p 'leuven-theme)
  (package-install 'leuven-theme))
(load-theme 'leuven t t)

;;; Make symbols look nice in the buffer.
(use-package pretty-mode
  :ensure t
  :hook ((emacs-lisp-mode python) . turn-on-pretty-mode))

(provide 'setup-appearance)
;;; setup-appearance.el ends here
