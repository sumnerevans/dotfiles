;;; setup-helm --- Setup helm

;;; Commentary:

;; Set up helm and related packages

;;; Code:


;;; Helm: incremental completion and selection narrowing framework
(use-package helm
  :ensure t
  :defer nil
  :bind
  (("C-S-p" . helm-M-x)
   ("C-x r b" . helm-filtered-bookmarks)
   ("C-p" . helm-find-files)
   :map mode-specific-map
   ("SPC" . helm-M-x)
   :map helm-map
   ("M-j" . helm-next-line)
   ("M-k" . helm-previous-line)
   ("C-h" . helm-next-source)
   ("C-S-h" . describe-key)
   ([escape] . helm-keyboard-quit)
   ("<tab>" . helm-execute-persistent-action)
   ("C-i" . helm-execute-persistent-action)
   ("C-l" . helm-execute-persistent-action)
   :map helm-find-files-map
   ("C-l" . helm-execute-persistent-action)
   ("C-h" . helm-find-files-up-one-level)
   ("M-l" . helm-execute-persistent-action)
   ("M-h" . helm-find-files-up-one-level)
   :map helm-read-file-map
   ("C-l" . helm-execute-persistent-action)
   ("C-h" . helm-find-files-up-one-level)
   ("M-l" . helm-execute-persistent-action)
   ("M-h" . helm-find-files-up-one-level))
  :config
  (progn
    (require 'helm-config)
    (when (executable-find "curl")
      (setq helm-net-prefer-curl t))
    (add-hook 'helm-after-initialize-hook
              ;; hide the cursor in helm buffers
              (lambda ()
                (with-helm-buffer
                  (setq cursor-in-non-selected-windows nil))))
    (helm-mode 1)))


;;; Helm extension for yasnippet
(use-package helm-c-yasnippet
  :ensure t
  :after (yasnippet helm)
  :bind
  ("C-c y" . helm-yas-complete)
  (:map mode-specific-map ("y" . helm-yas-complete))
  :init
  (progn
    (setq helm-yas-space-match-any-greedy t)))


;;; Helm extension for gtags
(use-package helm-gtags
  :ensure t
  :commands (helm-gtags-mode)
  :init
  (progn
    (setq helm-gtags-ignore-case t
          helm-gtags-auto-update t
          helm-gtags-use-input-at-cursor t
          helm-gtags-pulse-at-cursor t
          helm-gtags-prefix-key (kbd "C-c g")
          helm-gtags-suggested-key-mapping t)
    (add-hook 'dired-mode-hook 'helm-gtags-mode)
    (add-hook 'eshell-mode-hook 'helm-gtags-mode)
    (add-hook 'asm-made-hook 'helm-gtags-mode))
  :config
  (progn
    (evil-define-key 'normal helm-gtags-mode-map (kbd "C-c g a")
      'helm-gtags-tags-in-this-function)
    (evil-define-key 'normal helm-gtags-mode-map (kbd "C-j")
      'helm-gtags-select)
    (evil-define-key 'normal helm-gtags-mode-map (kbd "M-.")
      'helm-gtags-dwim)
    (evil-define-key 'normal helm-gtags-mode-map (kbd "M-,")
      'helm-gtags-pop-stack)
    (evil-define-key 'normal helm-gtags-mode-map (kbd "C-c <")
      'helm-gtags-previous-history)
    (evil-define-key 'normal helm-gtags-mode-map (kbd "C-c >")
      'helm-gtags-next-history)))

;;; Helm extension for projectile
(use-package helm-projectile
  :ensure t
  :after (projectile helm)
  :config
  (helm-projectile-on)
  (setq projectile-completion-system 'helm)
  (setq projectile-indexing-method 'alien))


(use-package helm-pass
  :ensure t)


(provide 'setup-helm)
;;; setup-helm.el ends here
