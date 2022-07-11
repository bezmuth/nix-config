;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ben"
      user-mail-address "benkel97@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;(set-face-attribute 'default nil :font "Fira Code" :height 110)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(set-default 'truncate-lines t)
(setq default-directory "~/Projects/")
(setq gc-cons-threshold 1000000000) ;; 1GiB garbage collection
(blink-cursor-mode 0)
;;(pixel-scroll-mode 1)
(setq scroll-conservatively 10000)

;; Some QOL
(scroll-bar-mode -1) ; disable scroll bar
(tool-bar-mode -1)   ; disable toolbar
(tooltip-mode -1)    ; ??
(set-fringe-mode 10) ; add some padding
(menu-bar-mode -1)   ; no menubar
(setq visible-bell t); makes top and bottom of window flash instead of bell
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; makes escape quit a buffer
(fset 'yes-or-no-p 'y-or-n-p)

;; evil config
(define-key evil-motion-state-map (kbd "/") 'swiper)

;; modeline
(setq doom-modeline-height 15)

;; org config
(setq org-roam-directory (file-truename "/home/bezmuth/org/roam/"))

(setq org-todo-keywords
      '((sequence "TODO" "PARTIAL" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . org-warning) ("PARTIAL" . "yellow")))
(setq org-enforce-todo-dependencies t)
(setq org-hide-emphasis-markers t)
(add-hook 'org-mode-hook (lambda () (setq line-spacing 0.1)))
(evil-define-key 'normal org-mode-map (kbd "RET") 'org-open-at-point) ; open org links with enter

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t) (python . t))) ; this line activates ditaa

(org-display-inline-images)

(setq org-roam-db-autosync-enable t)

;; enable clock in modeline
(display-time-mode)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (R . t)
   (C . t)))

(add-hook 'org-mode-hook 'org-download-enable)

(setq org-todo-keywords
      '((sequence "TODO" "PARTIAL" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . "dark red") ("PARTIAL" . "orange")))

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

(setq reftex-default-bibliography '("/home/bezmuth/org/bibtext"))
;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "/home/bezmuth/org/bibtext/notes.org"
      org-ref-default-bibliography '("/home/bezmuth/org/bibtext/references.bib")
      org-ref-pdf-directory "/home/bezmuth/org/bibtext/bibtex-pdfs/")

(setq treemacs-width 20)

(map!
 (:leader
  (:prefix "f"
   :desc "Toggle Treemacs" "t" #'+treemacs/toggle-project)
  (:prefix "o"
   :desc "Open kill ring" "k" #'+default/yank-pop
   :desc "Open notes.org" "n" #'org-notes-open))
 )

;;(elcord-mode)

(setq irony-server-install-prefix "/run/current-system/sw/")

;; Org mode
(defun org-config-func ()
  ;(linum-mode 0)
  (setq tab-bar-show nil)
  (setq line-spacing 15)
  (face-remap-add-relative 'default :family "etBook")
)
;(advice-add 'org-mode :after #'org-config-func)
(let* ((variable-tuple
          (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
                ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
                ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
                ((x-list-fonts "Verdana")         '(:font "Verdana"))
                ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
         (base-font-color     (face-foreground 'default nil 'default))
         (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-6 ((t (,@headline ,@variable-tuple))))
     `(org-level-5 ((t (,@headline ,@variable-tuple))))
     `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
     `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
     `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))
(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "ETBembo" :height 180))))
 '(fixed-pitch ((t ( :family "Fira Code Retina" :height 160)))))
(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'visual-line-mode)
  (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(direnv-mode)
