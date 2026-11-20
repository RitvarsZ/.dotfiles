;;; init-lsp.el --- LSP setup -*- lexical-binding: t; -*-

;; lsp: bigger reads from language servers (default 4k is too small)
(setq read-process-output-max (* 1024 1024))
(setq gc-cons-threshold (* 100 1024 1024)

;; in-buffer completion popup (like nvim-cmp)
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)            ; pop up while typing
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode 1))

;; PHP major mode
(use-package php-mode
  :ensure t)

;; K shows LSP docs for the symbol at point
(defun my/lsp-lookup-setup ()
  (setq-local evil-lookup-func #'lsp-describe-thing-at-point))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-completion-provider :none)          ; let corfu show completions
  (lsp-headerline-breadcrumb-enable nil)   ; less noise
  :hook
  ((php-mode . lsp-deferred)
   (lsp-mode . lsp-enable-which-key-integration)
   (lsp-mode . my/lsp-lookup-setup))
  :config
  ;; don't file-watch composer deps (still indexed, they just aren't watched)
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]vendor\\'")
  ;; install servers if missing (like :ensure t for packages)
  (lsp-ensure-server 'iph))                ; intelephense

(provide 'init-lsp)
;;; init-lsp.el ends here
