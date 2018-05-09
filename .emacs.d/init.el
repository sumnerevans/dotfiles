;;; init.el --- Entrypoint for Emacs config
;;;
;;; Commentary:
;;;

;;; Inspired by https://github.com/edwargix/emacs

;;; Code:

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")

(load-file "~/.emacs.d/lisp/setup-packages.el")

(require 'setup-keys)
(require 'setup-appearance)
(require 'setup-dev)
(require 'setup-helm)
(require 'setup-defaults)
(require 'setup-lisp)
;(require 'setup-treemacs)

;;; Save backup files in ~/tmp
(setq backup-directory-alist `(("." . "~/tmp/emacs"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      backup-by-copying t
      version-control t)

;;; Markdown mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package smartparens
  :ensure t
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode t)))

;;; Magit: a Git Porcelain inside Emacs
(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status)
   ("C-x M-g" . magit-dispatch-popup)))

;;; Syntax/error checking for GNU Emacs
(use-package flycheck
  :ensure t
  :init
  (progn
    (global-flycheck-mode)
    (evil-define-key 'normal
      flycheck-error-list-mode-map (kbd "q") 'quit-window)))

;;; Quickhelp (documentation lookup) for company
(use-package company-quickhelp
  :ensure t
  :after company
  :config
  (progn
    (setq company-quickhelp-idle-delay 1)
    (company-quickhelp-mode 1)))

;;; Yasnippet: yet another snippet extension
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;;; Org mode for keeping notes, todo lists, planning, and fast
;;; documenting
(use-package org
  :init
  (progn
    (load-file "~/Dropbox/org/setup.el")
    (unless (package-installed-p 'org-plus-contrib)
      (package-install 'org-plus-contrib))
    (setq org-default-notes-file "~/Dropbox/org/notes.org"
          org-return-follows-link t
          org-read-date-force-compatible-dates nil)
    (setq org-src-fontify-natively t
          org-src-tab-acts-natively t)
    (setq org-latex-pdf-process
          '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
    (use-package htmlize :ensure t))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c b" . org-iswitchb)
   ("C-c l" . org-store-link)
   ("C-c o" . org-open-at-point-global))
  :config
  (progn
    (require 'ox-md)
    (require 'ox-beamer)
    ;; (add-to-list 'org-latex-packages-alist '("" "minted"))
    ;; (setq org-latex-listings 'minted)
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (python . t)
       (dot . t)
       (org . t)
       (gnuplot . t)))))

;;; UTF-8 bullets for org-mode
(use-package org-bullets
  :ensure t
  :after org
  :config
  (progn
    (add-hook 'org-mode-hook 'org-bullets-mode)))

;(use-package org-contacts
;  :after org
;  :config
;  (progn
;    (setq org-contacts-files '("~/Dropbox/org/contacts.org"))))


;;; Paradox: a modern package menu
(use-package paradox
  :ensure t
  :commands (paradox-enable paradox-quit-and-close)
  :init
  (progn
    (paradox-enable)
    (evil-set-initial-state 'paradox-menu-mode 'motion)))


(use-package which-key
  :ensure t
  :config
  (which-key-mode))


(use-package system-packages
  :ensure t)


;;; mu4e email client
(when (file-exists-p "~/scripts/setup-mu4e.el")
  (load-file "~/scripts/setup-mu4e.el"))


(use-package ess
  :ensure t)


(use-package tex
  :ensure auctex)


(use-package pyvenv
  :ensure t
  :commands (pyvenv-activate pyvenv-workon))

(use-package anaconda-mode
  :ensure t
  :after python
  :config (progn
            (add-hook 'python-mode-hook 'anaconda-mode)
            (add-hook 'python-mode-hook 'anaconda-eldoc-mode)))

(use-package company-anaconda
  :ensure t
  :after anaconda-mode)

(use-package lorem-ipsum
  :ensure t)

(use-package winum
  :ensure t
  :config
  (progn
    (winum-mode)))

;;; Start Emacs Daemon
(require 'server)
(unless (server-running-p)
  (server-start))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("6dd2b995238b4943431af56c5c9c0c825258c2de87b6c936ee88d6bb1e577cb9" "9a155066ec746201156bb39f7518c1828a73d67742e11271e4f24b7b178c4710" "43c1a8090ed19ab3c0b1490ce412f78f157d69a29828aa977dae941b994b4147" default)))
 '(fci-rule-color "#3E4451")
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (evil-org evil-magit use-package evil-surround))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
