;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ben"
      user-mail-address "benkel97@protonmail.com")

(setq org-directory "~/org/")

(setq display-line-numbers-type t)

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
(setq doom-modeline-percent-position nil)
(nyan-mode)
(nyan-toggle-wavy-trail)

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
 '((python . t) (rust . t) (C . t))) ; this line activates ditaa

(org-display-inline-images)

(setq org-roam-db-autosync-enable t)

;; enable clock in modeline
(display-time-mode)

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

;;(setq treemacs-width 20)

(map!
 (:leader
  (:prefix "f"
   :desc "Toggle Treemacs" "t" #'treemacs)
  (:prefix "o"
   :desc "Open kill ring" "k" #'+default/yank-pop
   :desc "Open notes.org" "n" #'org-notes-open))
 )

(map! :map ivy-minibuffer-map :prefix "S" "return" #'ivy-immediate-done)

;;(elcord-mode)
(setq irony-server-install-prefix "/run/current-system/sw/")

;; Org mode
(defun org-config-func ()
  ;(linum-mode 0)
  (setq tab-bar-show nil)
  (setq line-spacing 15)
)
(rainbow-delimiters-mode)

(setq catppuccin-flavor 'mocha)
(setq doom-theme 'catppuccin)

(require 'zone)
(zone-when-idle 120)

(setq elfeed-feeds
      '("http://www.chm.bris.ac.uk/motm/rss.xml"
        "http://www.xn--hrdin-gra.se/feed/all.atom.xml"
        "https://100r.co/links/rss.xml"
        "https://asahilinux.org/blog/index.xml"
        "https://blog.nelhage.com/atom.xml"
        "https://buttondown.email/nelhage/rss"
        "https://daniel.haxx.se/blog/feed/"
        "https://drewdevault.com/blog/index.xml"
        "https://dataswamp.org/~solene/rss.xml"
        "https://emersion.fr/blog/atom.xml"
        "https://grimgrains.com/links/rss.xml"
        "https://herman.bearblog.dev/feed/"
        "https://iliana.fyi/atom.xml"
        "https://j3s.sh/feed.atom"
        "https://mattstoller.substack.com/feed"
        "https://memex.marginalia.nu/log/feed.xml"
        "https://palant.info/rss.xml"
        "https://pluralistic.net/feed/"
        "https://solar.lowtechmagazine.com/feeds/all-en.atom.xml"
        "https://sourcehut.org/blog/index.xml"
        "https://webzine.nixos.cafe/atom.xml"
        "https://thephd.dev/feed.xml"
        "https://webzine.puffy.cafe/atom.xml"
        "https://words.filippo.io/dispatches/rss/"
        "https://xeiaso.net/blog.atom"
        "https://xkcd.com/atom.xml"
        "https://yuzu-emu.org/index.xml" ))
