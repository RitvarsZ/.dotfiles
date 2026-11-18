;; -*- lexical-binding: t; -*-

(package-initialize)

;; melpa setup
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities
      '(("gnu" . 30) ("nongnu" . 25) ("melpa-stable" . 20) ("melpa" . 0)))

;; keep Custom's auto-generated settings out of init.el
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

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

;; :q / :wq / :x close the window or buffer, never Emacs itself (:qa still quits)
(defun my/quit-window-or-buffer ()
  "Close this window, or kill the buffer if it's the last window."
  (interactive)
  (if (one-window-p)
      (kill-current-buffer)
    (delete-window)))

(defun my/save-and-quit ()
  "Save, then close the window or buffer, but never quit Emacs."
  (interactive)
  (save-buffer)
  (my/quit-window-or-buffer))

(with-eval-after-load 'evil
  (evil-ex-define-cmd "q[uit]" #'my/quit-window-or-buffer)
  (evil-ex-define-cmd "wq"     #'my/save-and-quit)
  (evil-ex-define-cmd "x[it]"  #'my/save-and-quit))

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

;; gitsigns
(use-package diff-hl
  :ensure t
  :hook
  ((magit-pre-refresh  . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh)
   (dired-mode         . diff-hl-dired-mode))          ; changed files marked in dired
  :init
  (global-diff-hl-mode 1)
  :config
  (diff-hl-flydiff-mode 1))                            ; update as you type, not only on save

;; keymaps
(keymap-global-set "C-/" #'comment-line)
(keymap-global-set "C-x C-b" #'ibuffer)
(keymap-global-set "C-x b" #'consult-buffer)
(keymap-global-set "C-x p b" #'consult-project-buffer)

;; ibuffer
(use-package ibuffer
  :custom
  (ibuffer-saved-filter-groups
   '(("default"
      ("Files" (visiting-file))
      ("Emacs" (name . "^\\*")))))
  :hook
  (ibuffer-mode . (lambda () (ibuffer-switch-to-saved-filter-groups "default"))))

;; theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-spacegrey t))

;; modeline
(use-package doom-modeline
  :ensure t
  :custom
  (doom-modeline-project-name t)   ; show current project.el project
  :init
  (doom-modeline-mode 1))

;; terminal-emulator
(use-package eat
  :ensure t)
