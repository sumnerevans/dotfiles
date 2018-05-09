;;; setup-keys --- Setup keys
;;;
;;; Commentary:
;;; Setup keybindings how I like them.

;;; Code:

;;; Evil (Extensible VI Layer)
(use-package evil
  :ensure t
  :init
  (progn
    (setq evil-want-C-u-scroll t
	  evil-want-integration nil))
  :config
  (progn
    (require 'evil)
    (evil-define-key 'motion help-mode-map (kbd "<tab>") 'forward-button)
    (evil-define-key 'motion help-mode-map (kbd "S-<tab>") 'backward-button)
    (define-key evil-ex-map "b " 'helm-mini)
    (define-key evil-ex-map "e " 'helm-find-files)
    (evil-global-set-key 'normal (kbd "SPC") mode-specific-map)
    (evil-global-set-key 'motion (kbd "SPC") mode-specific-map)
    (evil-mode 1)))

;;; Scrolling
(setq scroll-step 1
      scroll-margin 5
      delete-selection-mode 1)

;;; Easily surround text. Like vim-surround.
(use-package evil-surround
  :ensure t
  :after evil
  :config
  (progn
    (global-evil-surround-mode 1)))

;;; Evil keybindings for magit
(use-package evil-magit
  :after (evil magit)
  :ensure t)

;;; Evil keybindings for org
(use-package evil-org
  :ensure t
  :after (evil org)
  :config
  (progn
    (add-hook 'org-mode-hook 'evil-org-mode)
    (add-hook 'evil-org-mode-hook
              (lambda ()
                (evil-org-set-key-theme)))))

;;; Function keys

(provide 'setup-keys)
;;; setup-keys.el ends here
