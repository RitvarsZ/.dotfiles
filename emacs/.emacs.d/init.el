;; -*- lexical-binding: t; -*-

(package-initialize)

;; melpa setup
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities
      '(("gnu" . 30) ("nongnu" . 25) ("melpa-stable" . 20) ("melpa" . 0)))
(add-to-list 'package-pinned-packages '(web-server . "melpa"))

(setq inhibit-startup-screen t
      initial-scratch-message nil)

;; keep Custom's auto-generated settings out of init.el
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;; extra config modules live in ~/.emacs.d/lisp/
(add-to-list 'load-path (locate-user-emacs-file "lisp"))

;; font: size scales with the monitor's pixel height
(defvar my/font-family "JetBrainsMono Nerd Font")
(defvar my/font-size-at-1440p 24)

(defun my/font-size-for-frame (frame)
  (let ((height (nth 3 (frame-monitor-attribute 'geometry frame))))
    (round (* my/font-size-at-1440p (/ height 1440.0)))))

(defun my/set-font-for-frame (&optional frame)
  "Set FRAME's font size to suit the monitor it is on."
  (let ((frame (or frame (selected-frame))))
    (when (display-graphic-p frame)
      (set-frame-font (format "%s-%d" my/font-family (my/font-size-for-frame frame))
                      t (list frame)))))

(add-hook 'window-setup-hook #'my/set-font-for-frame)          ; initial frame
(add-hook 'after-make-frame-functions #'my/set-font-for-frame) ; new frames, emacsclient -c

;; hide bs
(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

;; theme
(use-package atom-one-dark-theme
  :ensure t
  :config
  (load-theme 'atom-one-dark t))

;; line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; misc
(setq dired-kill-when-opening-new-dired-buffer t)
(which-key-mode 1)
(savehist-mode 1)

;; move backups and auto saves out of sight
(setq backup-directory-alist `(("." . ,(locate-user-emacs-file "backups")))
      backup-by-copying t)
(setq create-lockfiles nil)
(let ((dir (locate-user-emacs-file "auto-saves/")))
  (make-directory dir t)
  (setq auto-save-file-name-transforms `((".*" ,dir t))))

(defun my/recenter-after (&rest _)
  "Center the screen on the cursor, like zz."
  (recenter))
(advice-add 'scroll-up-command   :after #'my/recenter-after)
(advice-add 'scroll-down-command :after #'my/recenter-after)

;; modal editing (meow, selection-first; qwerty layout)
(use-package meow
  :ensure t
  :demand t
  :custom
  (meow-use-clipboard t)
  (meow-keypad-ctrl-meta-prefix nil)
  :config
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (set-face-attribute 'meow-cheatsheet-command nil :height 1.0)
  (setq meow-use-cursor-position-hack t
      meow-use-enhanced-selection-effect t)
  ;; meow-undo replays this key; C-/ is rebound to comment-line below
  (setq meow--kbd-undo "C-_")
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  ;; leader: SPC <key> runs C-c <key>
  (meow-leader-define-key
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet)
   '("p p" . project-switch-project)
   '("p b" . consult-project-buffer)
   '("p f" . project-find-file)
   '("p s" . consult-ripgrep)
   '("g s" . magit)
   '("g r" . lsp-find-references)
   '("g d" . lsp-find-definition)
   '("g i" . lsp-find-implementation)
   '("d" . lsp-ui-doc-glance)
   '("D" . lsp-ui-doc-focus-frame)
   '("j" . next-error)
   '("k" . previous-error)
   '("]" . flymake-goto-next-error)
   '("[" . flymake-goto-prev-error)
   '("e" . display-local-help))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . undo-redo)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore))
  ;; terminals start in INSERT so keys go straight to the shell
  (add-to-list 'meow-mode-state-list '(ghostel-mode . insert))
  (meow-global-mode 1))

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
  :ensure t
  :config
  ;; k is meow's move-up, so discard/delete lives on x (was magit-reset-quickly)
  (keymap-set magit-mode-map "x" #'magit-discard))

;; gitsigns
(use-package diff-hl
  :ensure t
  :hook
  ((magit-pre-refresh  . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh)
   (dired-mode         . diff-hl-dired-mode))
  :init
  (global-diff-hl-mode 1)
  :config
  ;; theme only sets fg; diff-hl fills the indicator with bg, so copy fg -> bg
  (dolist (f '(diff-hl-insert diff-hl-change diff-hl-delete))
    (set-face-background f (face-foreground f nil t)))
  (diff-hl-flydiff-mode 1))

;; keymaps
(keymap-global-set "C-/" #'comment-line)
(keymap-global-set "C-c a" #'org-agenda)
(keymap-global-set "C-c c" #'org-capture)
(keymap-global-set "C-x C-b" #'ibuffer)
(keymap-global-set "C-x b" #'consult-buffer)

;; ibuffer
(use-package ibuffer
  :custom
  (ibuffer-saved-filter-groups
   '(("default"
      ("Files" (visiting-file))
      ("Emacs" (name . "^\\*")))))
  :hook
  (ibuffer-mode . (lambda () (ibuffer-switch-to-saved-filter-groups "default"))))

;; modeline
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1))

;; terminal-emulator
(use-package ghostel
  :ensure t)

(add-to-list 'trusted-content "~/.dotfiles/")
(add-to-list 'trusted-content (abbreviate-file-name user-emacs-directory))
(use-package elisp-mode
  :ensure nil
  :custom
  ;; compile with my packages + modules visible, so require/use-package resolve
  (elisp-flymake-byte-compile-load-path (cons "./" load-path))
  :hook
  (emacs-lisp-mode . (lambda ()
                       ;; checkdoc nags about docstrings/headers; byte-compile only
                       (remove-hook 'flymake-diagnostic-functions
                                    #'elisp-flymake-checkdoc t)
                       (flymake-mode 1))))

;; lsp (corfu, php-ts-mode, lsp-mode + intelephense)
(require 'init-lsp)

;; org?
(use-package org
  :custom
  (org-directory "~/org/")
  (org-default-notes-file "~/org/inbox.org")
  (org-agenda-files '("~/org/"))
  (org-capture-templates
   '(("t" "Todo" entry (file "inbox.org")
      "* TODO %?\n%U\n%a")
     ("n" "Note" entry (file "notes.org")
      "* %?\n%U"))))

; claude
(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-;" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (setq claude-code-ide-terminal-backend 'ghostel)
  (claude-code-ide-emacs-tools-setup))
