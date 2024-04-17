;;; emacs.el --- Bezmuth's emacs config

;;; Commentary:
;; TODO early init setup https://www.reddit.com/r/emacs/comments/enmbv4/earlyinitel_reduce_init_time_about_02_sec_and/
;; Mostly stolen from: https://github.com/ZacJoffe/zemacs/blob/master/init.el#L1415-L1540

;;; Code:
;;; EDITOR GENERAL
(setq inhibit-startup-message t)

;; Compat with emacs-overlay
;; add :ensure nil to base packages
(setq use-package-always-ensure t)

;; disable blink cursor mode
(setq blink-cursor-mode nil)

;; scratch buffer defaults
(setq initial-major-mode 'text-mode)

;; performance stuff
;; increase amount of data which emacs can read from processes (mainly for LSP mode https://emacs-lsp.github.io/lsp-mode/page/performance/)
(setq read-process-output-max (* 1024 1024) ;; 1 MB
      ;; increase the gc threshold
      gc-cons-threshold 100000000)


;; suppress native comp warnings
;; https://www.reddit.com/r/emacs/comments/l42oep/suppress_nativecomp_warnings_buffer/gkmnh3y/
(setq native-comp-async-report-warnings-errors nil)

;; disable the "‘buffer-local-value’ is an obsolete generalized variable." warning on init
(byte-compile-disable-warning 'obsolete)

;; turn off ad-redef warnings https://andrewjamesjohnson.com/suppressing-ad-handle-definition-warnings-in-emacs/
(setq ad-redefinition-action 'accept)

;; do not prompt minibuffer with "You can run command with ..." after running a command with M-x that has a hotkey
(setq suggest-key-bindings nil)

;; empty scratch buffer text
(setq initial-scratch-message "")

;; some editor settings
(setq-default indent-tabs-mode nil    ;; indent with spaces
              tab-width 4             ;; 1 tab <=> 4 spaces
              c-basic-offset 4        ;; indentation for cc modes
              c-default-style "linux" ;; https://en.wikipedia.org/wiki/Indentation_style
              fill-column 80          ;; wrap at 80 characters for auto-fill-mode
              word-wrap t             ;; do not wrap characters in the middle of words
              truncate-lines t)       ;; do not wrap by default

;; some sane defaults
(scroll-bar-mode -1) ;; disable visible scrollbar
(tool-bar-mode -1)   ;; disable the toolbar
(tooltip-mode -1)    ;; disable tooltips
(menu-bar-mode -1)   ;; disable the menu bar

;; sentences should end with 1 space
(setq sentence-end-double-space nil)

;; fringe setup (left . right)
(set-fringe-mode '(4 . 4))

;; Show trailing whitespace
;; show trailing whitespace
(setq-default show-trailing-whitespace nil)
(defun show-trailing-whitespace-hook ()
  "Hook to enable displaying trailing whitespace."
  (setq show-trailing-whitespace t))

(add-hook 'prog-mode-hook 'show-trailing-whitespace-hook)
(add-hook 'text-mode-hook 'show-trailing-whitespace-hook)
(add-hook 'org-mode-hook 'show-trailing-whitespace-hook)
(add-hook 'markdown-mode-hook 'show-trailing-whitespace-hook)


;; show tabs in the editor
(setq-default whitespace-style '(face tabs tab-mark))
(global-whitespace-mode 1)

;; prompt y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; setup line numbers
;; do not dynamically resize line number column when a digit needs to be added
(setq display-line-numbers-width-start t)

;; HACK prevent M-x from shrinking line number width
;; https://github.com/abo-abo/swiper/issues/1940#issuecomment-465374308
(setq display-line-numbers-width 3)

;; I don't want line numbers in help files, dired, etc.
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)

;; relative line numbers
(setq display-line-numbers-type 'relative)

;; scrolling config
(setq scroll-step            1 ;; smooth scroll
      scroll-conservatively  10000
      fast-but-imprecise-scrolling t

      ;; https://github.com/hlissner/doom-emacs/blob/master/core/core-ui.el#L150
      hscroll-margin 2
      hscroll-step 1
      scroll-margin 0
      scroll-preserve-screen-position t
      ;; Reduce cursor lag by a tiny bit by not auto-adjusting `window-vscroll'
      ;; for tall lines.
      auto-window-vscroll nil)

;; smoother scrolling (especially for trackpad) via emacs 29
(pixel-scroll-precision-mode 1)


;; disable bells (distracting)
(setq ring-bell-function 'ignore)

;; font
(set-face-attribute 'default nil :font "Iosevka" :height 140 :weight 'bold)

;; aspell setup
(setq ispell-dictionary "english"
      ;; force English dictionary, support camelCase
      ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))

;; straight.el bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; for emacs versions >= 27
(setq package-enable-at-startup nil)

;; always use straight.el when invoking use-package
(setq straight-use-package-by-default t)

;; install use-package with straight.el
(straight-use-package 'use-package)
;; always ensure packages
(setq use-package-always-ensure t)

;; put backup files and auto-save files in their own directory
(use-package no-littering
  ;; :straight (:commit f42f2f2024827035149eeccfb0b315050291c682)
  :init
  ;; https://github.com/emacscollective/no-littering#backup-files
  (setq backup-directory-alist
        `(("\\`/tmp/" . nil)
          ("\\`/dev/shm/" . nil)
          ("." . ,(no-littering-expand-var-file-name "backup/"))))
  ;; auto-saves go in another directory
  ;; https://github.com/emacscollective/no-littering#auto-save-settings
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))
        create-lockfiles nil))

;; HACK load general first to allow use of :general keyword
(use-package general)

;;;; EDITOR PACKAGES
;;; EVIL
;; evil
(use-package evil
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search
        evil-ex-complete-emacs-commands nil
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-shift-round nil
        evil-want-C-u-scroll t
        evil-want-integration t
        evil-want-keybinding nil
        evil-normal-state-cursor 'box
        evil-search-module 'evil-search
        evil-undo-system 'undo-fu
        evil-respect-visual-line-mode t
        evil-shift-width tab-width)
  :general
  ;; j and k should operate line-by-line with text wrapping
  (;[remap evil-next-line] 'evil-next-visual-line
                                        ;[remap evil-previous-line] 'evil-previous-visual-line
   ;; inverse of evil jump backward
   "C-S-o" 'evil-jump-forward)
  :config
  ;; highlight the current line (not explicitly evil but whatever)
  (global-hl-line-mode 1)

  ;; make horizontal movement cross lines
  (setq-default evil-cross-lines t)

  ;; HACK prevent evil from moving window location when splitting by forcing a recenter
  ;; also do not switch to new buffer
  ;;(advice-add 'evil-window-vsplit :after (lambda (&rest r) (progn (evil-window-prev 1) (recenter))))
  ;;(advice-add 'evil-window-split :after (lambda (&rest r) (progn (evil-window-prev 1) (recenter))))

  ;; HACK
  (advice-add 'evil-window-vsplit :override (lambda (&rest r) (split-window (selected-window) nil 'right)))
  (advice-add 'evil-window-split :override (lambda (&rest r) (split-window (selected-window) nil 'below)))

  (evil-mode))

;; evil collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; evil surround
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; evil org
(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; evil-commentary
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;; change numbers with evil
(use-package evil-numbers)

;; show evil actions
(use-package evil-goggles
  :after evil
  :init
  (setq evil-goggles-duration 0.1)
  :config
  (evil-goggles-mode))

;; undo-fu/vundo stack
(use-package undo-fu
  :after evil
  :config
  ;; increase history limits
  ;; https://github.com/emacsmirror/undo-fu#undo-limits
  (setq undo-limit 6710886400 ;; 64mb.
        undo-strong-limit 100663296 ;; 96mb.
        undo-outer-limit 1006632960) ;; 960mb.
  )

(use-package undo-fu-session
  :after undo-fu
  :init
  (undo-fu-session-global-mode)
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

(use-package vundo
  ;; :straight (vundo :type git :host github :repo "casouri/vundo")
  :config
  (setq vundo-compact-display t))

;; editor config
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; smartparens
(use-package smartparens
  :config
  (require 'smartparens-config)
  ;; https://github.com/doomemacs/doomemacs/blob/a570ffe16c24aaaf6b4f8f1761bb037c992de877/modules/config/default/config.el#L108-L120
  ;; Expand {|} => { | }
  ;; Expand {|} => {
  ;;   |
  ;; }
  (dolist (brace '("(" "{" "["))
    (sp-pair brace nil
             :post-handlers '(("||\n[i]" "RET") ("| " "SPC"))
             :unless '(sp-point-before-word-p sp-point-before-same-p)))
  (defun +sp-c-setup ()
    (sp-with-modes '(c++-mode c-mode)
      ;; HACK to get around lack of ability to set a negative condition (i.e. all but these commands) for delayed insertion
      (sp-local-pair "<" ">" :when '(("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
                                      "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")))
      (sp-local-pair "/*" "*/" :actions '(:rem insert))))
  ;; the block comment pair seems to be overwritten after c++-mode inits, so +sp-c-setup is added as a hook for c++-mode (and c-mode)
  (+sp-c-setup)

  (sp-with-modes '(LaTeX-mode)
    (sp-local-pair "$" "$"))

  ;; (sp-local-pair 'tuareg-mode "sig" nil :actions :rem)
  ;; do not highlight new block when pressing enter after creating set of new parens
  ;; https://stackoverflow.com/a/26708910
  (setq sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil
        show-paren-delay 0) ;; no delay for showing matching parens

  (smartparens-global-mode))


;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  :ensure nil
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


;; consult
(use-package consult)

;; integration with flycheck
(use-package consult-flycheck
  :after (consult flycheck))

;; integration with flyspell
(use-package consult-flyspell
  :straight (consult-flyspell :type git :host gitlab :repo "OlMon/consult-flyspell" :branch "master")
  :config
  ;; default settings
  (setq consult-flyspell-select-function nil
        consult-flyspell-set-point-after-word t
        consult-flyspell-always-check-buffer nil))


;; consult functions
(defun +consult/find-file (DIR)
  "Open file in directory DIR."
  (interactive "DSelect dir: ")
  (let ((selection (completing-read "Find file: " (split-string (shell-command-to-string (concat "find " DIR)) "\n" t))))
    (find-file selection)))

(defun +consult/ripgrep (DIR)
  "Ripgrep directory DIR."
  (interactive "DSelect dir: ")
  ;(let ((consult-ripgrep-args "rg --null --multiline --max-columns=1000 --path-separator /\ --smart-case --no-heading --line-number .")))
  (consult-ripgrep DIR))

(defun +consult/org-roam-ripgrep ()
  "Ripgrep org-directory."
  (interactive)
  (consult-ripgrep org-directory))

;; allow me to use `evil-ex-search-next' and `evil-ex-search-previous' on result from `consult-line'
(defun +consult-line ()
  "Wrapper around `consult-line' that populates evil search history."
  (interactive)
  (consult-line)
  (let ((search-pattern (car consult--line-history)))
    ;; HACK manually set the search pattern and evil ex highlighting
    (setq evil-ex-search-pattern (evil-ex-make-search-pattern search-pattern))
    (evil-ex-search-activate-highlight evil-ex-search-pattern)))


;; spelling
(use-package flyspell
  :ensure nil
  ;; turn on flyspell for magit commit
  :hook (git-commit-setup . git-commit-turn-on-flyspell))

;; spelling correction menu using completing-read (so consult)
(use-package flyspell-correct
  :after flyspell)

;; Project
;; projectile
(use-package projectile
  :init
  ;; some configs that doom uses https://github.com/doomemacs/doomemacs/blob/bc32e2ec4c51c04da13db3523b19141bcb5883ba/core/core-projects.el#L29
  (setq projectile-enable-caching t  ;; big performance boost, especially for `projectile-find-file'
        projectile-project-search-path '("~/Projects/"))
  :config
  (projectile-mode +1))
;;----

;; themes
(use-package catppuccin-theme
  :init
  (setq catppuccin-flavour 'macchiato))
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'catppuccin :no-confirm)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


;; modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :hook (doom-modeline-mode . size-indication-mode) ; filesize in modeline
  :hook (doom-modeline-mode . column-number-mode)   ; cursor column in modeline
  ; https://github.com/hlissner/doom-emacs/blob/master/modules/ui/modeline/config.el
  :init
  (setq display-time-default-load-average nil)
  (unless after-init-time
    ;; prevent flash of unstyled modeline at startup
    (setq-default mode-line-format nil))

  ;; We display project info in the modeline ourselves
  (setq projectile-dynamic-mode-line nil
        ;; set these early so they don't trigger variable watchers
        doom-modeline-bar-width 3
        doom-modeline-buffer-file-name-style 'truncate-nil

        ;; Only show file encoding if it's non-UTF-8 and different line endings
        ;; than the current OSes preference
        doom-modeline-buffer-encoding 'nondefault
        ;; default line endings are LF on mac/linux, CRLF on windows
        doom-modeline-default-eol-type (if (or (eq system-type 'gnu/linux) (eq system-type 'darwin)) 0 1))

  :config
  ;; display symlink file paths https://github.com/seagle0128/doom-modeline#faq
  (setq find-file-visit-truename t)
  ;; Don’t compact font caches during GC.
  (setq inhibit-compacting-font-caches t)

  ;; doom uses the default modeline that is defined here: https://github.com/seagle0128/doom-modeline/blob/master/doom-modeline.el#L90
  ;; as far as I can tell you can't change the ordering of segments without redefining the modeline entirely (segments can be toggled though)
  (doom-modeline-def-modeline 'my-line
    '(bar modals matches buffer-info buffer-position selection-info)
    '(buffer-encoding lsp major-mode process vcs check misc-info))

  ;; Add to `doom-modeline-mode-hook` or other hooks
  (defun setup-custom-doom-modeline ()
     (doom-modeline-set-modeline 'my-line 'default))
  (add-hook 'doom-modeline-mode-hook 'setup-custom-doom-modeline))
  (display-time)


;; highlight todos
(use-package hl-todo
  :hook ((prog-mode . hl-todo-mode)
         (markdown-mode . hl-todo-mode)
         (org-mode . hl-todo-mode)
         (LaTeX-mode . hl-todo-mode))
  :config
  ; https://github.com/hlissner/doom-emacs/blob/develop/modules/ui/hl-todo/config.el
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(;; For things that need to be done, just not today.
          ("TODO" warning bold)
          ;; For problems that will become bigger problems later if not
          ;; fixed ASAP.
          ("FIXME" error bold)
          ;; For tidbits that are unconventional and not intended uses of the
          ;; constituent parts, and may break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For things that were done hastily and/or hasn't been thoroughly
          ;; tested. It may not even be necessary!
          ("REVIEW" font-lock-keyword-face bold)
          ;; For especially important gotchas with a given implementation,
          ;; directed at another user other than the author.
          ("NOTE" success bold)
          ;; For things that just gotta go and will soon be gone.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; For a known bug that needs a workaround
          ("BUG" error bold)
          ;; For warning about a problematic or misguiding code
          ("XXX" font-lock-constant-face bold)
          ;; for temp comments or TODOs to be deleted
          ("DELETEME" error bold)
          ("KILLME" error bold)
          ;; for works in progress
          ("WIP" font-lock-keyword-face bold))))


;; rainbow delimiters
(use-package rainbow-delimiters
  :hook (LaTeX-mode . rainbow-delimiters-mode)
  :hook (prog-mode . rainbow-delimiters-mode))

;; highlight numbers
(use-package highlight-numbers
  :hook ((prog-mode . highlight-numbers-mode)))'

;; GIT
;; magit
(use-package magit
  ;; refresh status when you save file being tracked in repo
  :hook (after-save . magit-after-save-refresh-status)
  ;; start magit commit in insert mode https://emacs.stackexchange.com/a/20895
  :hook (git-commit-mode . evil-insert-state)
  :config
  ;; display magit status in current buffer (no popup) https://stackoverflow.com/a/58554387/11312409
  (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1
        magit-auto-revert-mode t
        ;; highlight commit message after 50 characters
        git-commit-summary-max-length 50
        ;; NOTE this is apparently DEPRECATED but it seems to do exactly what I want (autowrap commmit body at 72 chars)
        git-commit-fill-column 72))

(use-package git-gutter
  :init
  (global-git-gutter-mode 1))

(use-package git-gutter-fringe
  :config
  ;; pretty diff indicators
  ;; https://github.com/hlissner/doom-emacs/blob/master/modules/ui/vc-gutter/config.el#L106
  (setq-default fringes-outside-margins t)
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))
;;----

;;ibuffer-vc
(use-package ibuffer-vc)

;; Justfile runner
(use-package justl)
(general-evil-define-key '(normal) justl-mode-map
  "RET" 'justl-exec-recipe
  "S-RET" 'justl-exec-eshell)
;; Startup Dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; which-key
(use-package which-key
    :init
    (setq which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10)
    (which-key-mode))

;;IVY
(use-package ivy
 :init
 (setq ivy-use-virtual-buffers t)
 (setq enable-recursive-minibuffers t)
 (ivy-mode))
(use-package counsel
  :init
  (counsel-mode))
(use-package swiper)
;;----

;;; GENERAL.EL
;; https://github.com/hlissner/doom-emacs/blob/master/modules/config/default/config.el#L6
;; general keybindings
(general-evil-setup)
(general-override-mode) ;; https://github.com/noctuid/general.el/issues/99#issuecomment-360914335
(general-create-definer my-leader-def
  :prefix "SPC")
(my-leader-def
  :states '(motion normal visual)
  :keymaps 'override ;; https://github.com/noctuid/general.el/issues/99#issuecomment-360914335
  ;;
  "SPC" '(counsel-M-x :which-key "M-x")
  ;; File managment
  "f" '(:ignore t :which-key "Editor")
  "fs" '(save-buffer :which-key "Save Buffer")
  "fd" '(dired :which-key "Dired")
  "ff" '(find-file :which-key "Find File")
  "fr" '(recentf :which-key "Recent Files")
  ;; buffer
  ;;"TAB" '(switch-to-prev-buffer :which-key "Prev buffer")
  "b" '(:ignore t :which-key "Buffer")
  "bb" '(consult-project-buffer :which-key "consult-buffer")
  "bB" '(consult-buffer :which-key "consult-buffer")
  "bn" '(previous-buffer :which-key "Previous buffer") ;
  "bp" '(next-buffer :which-key "Next buffer")
  "bd" '(kill-current-buffer :which-key "Kill buffer")
  ;; window
  "w" '(:ignore t :which-key "Window")
  "ws" '(split-window-horizontally :which-key "Split horizontal")
  "wv" '(split-window-vertically :which-key "Split vertical")
  "wh" '(evil-window-left :which-key "Window Left")
  "wj" '(evil-window-down :which-key "Window Down")
  "wk" '(evil-window-up :which-key "Window Up")
  "wl" '(evil-window-right :which-key "Window Right")
  "wd" '(delete-window :which-key "Delete Window")
  ;; project
  "p" '(:ignore t :which-key "Projects")
  "pp" '(projectile-switch-project :which-key "Switch project")
  "pf" '(projectile-find-file :which-key "Find file in project")
  "pg" '(projectile-grep :which-key "Grep in project")
  "pr" '(projectile-replace :which-key "Replace in project")
  "pc" '(projectile-compile-project :which-key "Build project")
  ;; code/lsp
  "c" '(:ignore t :which-key "Code Actions")
  "ch" '(eldoc-print-current-symbol-info :which-key "Show docs for function")
  "cc" '(counsult-eglot-symbols :which-key "Opens lsp symbol broser")
  "cf" '(consult-flycheck :which-key "Consult flycheck")
  "ca" '(eglot-code-actions :which-key "Apply code actions at point")
  "cj" '(justl :which-key "Open justfile Menu")
  ;; git
  "g" '(:ignore t :which-key "Git") ; prefix
  "gg" '(magit-status :which-key "Git status")
  )

(general-define-key
 :states '(motion normal visual)
 :keymaps 'override
 "/" 'swiper
 )

;; magit
(general-define-key
 ;; https://github.com/emacs-evil/evil-magit/issues/14#issuecomment-626583736
 :keymaps 'transient-base-map
 "<escape>" 'transient-quit-one)

;; magit keybindings
;; TODO refactor within use-package
(general-define-key
 :states '(normal visual)
 :keymaps 'magit-mode-map
 ;; rebind "q" in magit-status to kill the magit buffers instead of burying them
 "q" '+magit/quit)

;; minibuffer keybindings
;; Unbind "C-j" if it's already boun
(general-unbind 'ivy-minibuffer-map
  "C-j"
  "C-k")
(general-define-key
 :keymaps 'ivy-minibuffer-map
 "C-j" 'ivy-next-line
 "C-k" 'ivy-previous-line)
;; (define-key ivy-minibuffer-map (kbd "C-j") nil)
;; ;; Bind "C-j" to ivy-next-line
;; (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
;; (define-key ivy-minibuffer-map (kbd "C-k") nil)
;; (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)
;;----

;;; LANGUAGES
(use-package eglot
  :straight (:type built-in)
  ;; https://github.com/minad/corfu/wiki
  :init
  :config
  )

(use-package consult-eglot)

;; direnv my beloved
(use-package direnv
 :config
 (direnv-mode))

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; tree sitter
;; TODO port config to use emacs29 native treesit
(use-package tree-sitter
  :init
  (global-tree-sitter-mode))

(use-package tree-sitter-langs
  ;; enable tree sitter syntax highlighting whenever possible https://emacs-tree-sitter.github.io/syntax-highlighting/
  :hook (tree-sitter-after-on . tree-sitter-hl-mode))

;; rust
(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (setq rustic-lsp-client 'eglot)
  (setq rustic-format-trigger 'on-save))

(push 'rustic-clippy flycheck-checkers)
(remove-hook 'rustic-mode-hook 'flycheck-mode)

(defun rustic-mode-auto-save-hook ()
  "Enable auto-saving in rustic-mode buffers."
  (when buffer-file-name
    (setq-local compilation-ask-about-save nil)))
(add-hook 'rustic-mode-hook 'rustic-mode-auto-save-hook)

;;----

;; nix
(use-package nix-mode
  :mode "\\.nix\\'"
  :commands nixfmt-on-save-mode)
;;----









(provide 'emacs)
;;; emacs.el ends here
