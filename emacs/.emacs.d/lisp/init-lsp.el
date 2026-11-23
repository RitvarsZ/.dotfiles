;;; init-lsp.el --- LSP setup -*- lexical-binding: t; -*-

;; lsp: bigger reads from language servers (default 4k is too small)
(setq read-process-output-max (* 1024 1024))
(setq gc-cons-threshold (* 100 1024 1024))

;; in-buffer completion popup (like nvim-cmp)
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)            ; pop up while typing
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode 1))

;; PHP: built-in tree-sitter mode (Emacs 30+)
;; grammars: M-x php-ts-mode-install-parsers (once; only defined after php-ts-mode loads)
;; color variables and full `use' paths as one token each, $this as a keyword (like PhpStorm)
(defun my/php-uniform-font-lock ()
  (setq-local treesit-font-lock-settings
              (append treesit-font-lock-settings
                      (treesit-font-lock-rules
                       :language 'php
                       :feature 'uniform
                       :override t
                       '((variable_name) @font-lock-variable-name-face)
                       :language 'php
                       :feature 'this
                       :override t)))
  (treesit-font-lock-recompute-features '(uniform this)))

(use-package php-ts-mode
  :ensure nil
  :mode "\\.php\\'"
  :hook (php-ts-mode . my/php-uniform-font-lock))

;; TypeScript: built-in tree-sitter modes; grammars installed on first .ts/.tsx open
;; (:config, not :init: the grammar recipes are only registered once the mode loads)
(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.[cm]?ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'"     . tsx-ts-mode))
  :config
  (dolist (lang '(typescript tsx))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

;; Vue: web-mode highlights template/script/style in one buffer;
;; own derived mode so only .vue (not every html file) starts LSP
(use-package web-mode
  :ensure t
  :config
  (define-derived-mode my/vue-mode web-mode "Vue")
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . my/vue-mode)))

;; SPC d shows LSP docs for the symbol at point in a popup (child frame);
;; SPC d again jumps into the popup to scroll/search/yank, q closes it
(defun my/lsp-doc-K ()
  (interactive)
  (if (lsp-ui-doc--frame-visible-p)
      (lsp-ui-doc-focus-frame)
    (lsp-ui-doc-glance)))

(defun my/lsp-doc-close ()
  (interactive)
  (lsp-ui-doc-unfocus-frame)
  (lsp-ui-doc-hide))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-completion-provider :none)          ; let corfu show completions
  (lsp-headerline-breadcrumb-enable nil)   ; less noise
  :hook
  ((php-ts-mode . lsp-deferred)
   (my/vue-mode . lsp-deferred)
   (typescript-ts-mode . lsp-deferred)
   (tsx-ts-mode . lsp-deferred)
   (lsp-mode . lsp-enable-which-key-integration))
  :config
  ;; don't file-watch composer deps (still indexed, they just aren't watched)
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]vendor\\'")
  ;; TypeScript 7 (native rewrite) ships no tsserver, which ts-ls needs; pin to 6
  (with-eval-after-load 'lsp-javascript
    (lsp-dependency 'typescript
                    '(:system "tsserver")
                    '(:npm :package "typescript" :path "tsserver" :version "^6")))
  ;; install servers if missing (like :ensure t for packages)
  ;; Vue = volar (add-on) + ts-ls with the @vue/typescript-plugin; the plugin path
  ;; is resolved when lsp-volar loads, so restart Emacs once after first install
  (dolist (server '(iph                    ; intelephense
                    ts-ls                  ; typescript-language-server
                    vue-semantic-server))  ; @vue/language-server
    (lsp-ensure-server server)))

;; popup docs; only on demand via SPC d (closes when the cursor moves)
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :custom
  (lsp-ui-doc-enable nil)               ; no auto hover popups
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable nil)          ; no inline diagnostics/code actions noise
  :config
  ;; inside the focused popup: MOTION state so j/k scroll and q reaches this map
  (keymap-set lsp-ui-doc-frame-mode-map "q" #'my/lsp-doc-close)
  (add-hook 'lsp-ui-doc-frame-mode-hook #'meow-motion-mode))

(provide 'init-lsp)
;;; init-lsp.el ends here
