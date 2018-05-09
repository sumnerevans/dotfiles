;;; setup-dev --- Setup packages for easy development
;;;
;;; Commentary:
;;; Setup really nice things for making development nice.
;;;
;;; Code:

(require 'evil)

;;; Show unnecessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook
          (lambda () (interactive)
            (setq show-trailing-whitespace 1)))

;; set appearance of a tab that is represented by 8 spaces
(setq-default tab-width 8)
(setq-default indent-tabs-mode nil)

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file contatining the main routine at startup
 gdb-show-main t)

;; Reload file's buffer when the file changes on disk
(global-auto-revert-mode 1)

;;; Company (complete anything) mode
(use-package company
  :ensure t
  :init
  (progn
    (add-hook 'after-init-hook 'global-company-mode))
  :config
  (progn
    (delete 'company-semantic company-backends)
    (define-key company-active-map (kbd "RET") 'company-complete-selection)))

;; Language Server
(unless (package-installed-p 'lsp-mode)
  (package-install 'lsp-mode))
(require 'lsp-mode)

;; Project integration
(use-package projectile
  :ensure t
  :defer nil
  :bind
  (:map mode-specific-map
        ("p" . projectile-command-map))
  :config
  (progn
    (projectile-mode)))

;; Editor config
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))


(provide 'setup-dev)
;;; setup-dev.el ends here
