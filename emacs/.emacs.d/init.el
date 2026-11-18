;; -*- lexical-binding: nil; -*-

(package-initialize)

;; melpa setup
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities
      '(("gnu" . 30) ("nongnu" . 25) ("melpa-stable" . 20) ("melpa" . 0)))

;; font
(add-to-list 'default-frame-alist
	'(font . "JetBrainsMono Nerd Font-26"))

;; hide bs
(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

;; line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; misc
(setq dired-kill-when-opening-new-dired-buffer t)
(which-key-mode 1)
(savehist-mode 1)
(setq backup-directory-alist `(("." . ,(locate-user-emacs-file "backups")))
      backup-by-copying t)
(setq create-lockfiles nil)

;; vim bindings
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (defvar evil-mode-buffers '())
  :config
  (defun my/recenter-after (&rest _)
    "Center the screen on the cursor, like zz."
    (recenter))

  (advice-add 'evil-scroll-down :after #'my/recenter-after)
  (advice-add 'evil-scroll-up   :after #'my/recenter-after)
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; leader key
(use-package general
  :ensure t
  :after evil
  :config
  (general-create-definer my/leader
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  ;; (my/leader "pp" '(project-switch-project :which-key "switch project"))
  )

;; completion: vertical list, out-of-order matching, annotations
(use-package vertico
  :ensure t
  :bind (:map vertico-map
    ("C-j" . vertico-next)
    ("C-k" . vertico-previous))
  :init
  (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

;; basically telescope
(use-package consult
  :ensure t)

;; git
(use-package magit
  :ensure t)

;; keymaps
(keymap-global-set "C-/" #'comment-line)

;; theme
(use-package atom-one-dark-theme
  :ensure t
  :config
  (load-theme 'atom-one-dark t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(atom-one-dark-theme consult evil-collection general magit marginalia
			 orderless vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
