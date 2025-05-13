;;; -*- mode: emacs-lisp; -*-
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
(setq doom-theme 'catppuccin)

(setq doom-font (font-spec :family "Iosevka" :size 20 :weight 'bold))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; might want to change this to a single dir, but it works for now
(setq org-agenda-files '("~/org"))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(setq confirm-kill-emacs nil)

(use-package! org-roam
  :config
  ;; Org roam capture templates
  ;; https://org-roam.discourse.group/t/org-roam-basics-how-org-roam-capture-templates-work/3670
  (push
   '("d"                                              ;; key
     "default"                                        ;; description
     plain                                            ;; type of content to insert
     "%?"                                             ;; the text content to insert
     :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" ;; File name and header content
                        "#+title: ${title}\n")
     :unnarrowed t)
   org-roam-capture-templates)

  (push
   '("l"                                              ;; key
     "blog link"                                        ;; description
     plain                                            ;; type of content to insert
     "%?"                                             ;; the text content to insert
     :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" ;; File name and header content
                        "#+title: ${title}\n#+filetags: :links:\n")
     :unnarrowed t)
   org-roam-capture-templates)
  )


(use-package! org-noter
  :config
  (map! :map pdf-view-mode-map
        :nvi "i" #'org-noter-insert-note))

;; elfeed-protocol
(after! elfeed
(setq elfeed-search-filter "-Youtube -podcasts +unread")

;; curl recommend
(setq elfeed-use-curl t)
(elfeed-set-timeout 36000)
(setq elfeed-curl-extra-arguments '("--insecure")) ;necessary for https without a trust certificate

;; setup feeds
(setq elfeed-protocol-feeds '(("fever+https://bezmuth@miniflux.bezmuth.uk"
                               :api-url "https://miniflux.bezmuth.uk/fever/"
                               :password (getenv "MINIFLUX_TOKEN"))))

;; enable elfeed-protocol
(setq elfeed-protocol-enabled-protocols '(fever newsblur owncloud ttrss))
(elfeed-protocol-enable)
)


(defun capture-post-w3m ()
  (interactive)
  (let* ((buffer (get-buffer "*w3m*"))
         (url (buffer-local-value 'w3m-current-url buffer))
         (title (buffer-local-value 'w3m-current-title buffer)))
    (org-roam-capture-
     :node (org-roam-node-create :title title)
     :templates
     `(("d" "Default Template" plain "%?"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          ,(format "#+title: ${title}\n#+filetags: :links:\n%s\n" url))
        :unnarrowed t)))))


(defun capture-post-elfeed ()
  (interactive)
  (let* ((buffer (get-buffer "*elfeed-entry*"))
         (elfeed-entry (buffer-local-value 'elfeed-show-entry buffer)))
    (org-roam-capture-
     :node (org-roam-node-create :title (elfeed-entry-title elfeed-entry))
     :templates
     `(("d" "Default Template" plain "%?"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          ,(format "#+title: ${title}\n#+filetags: :links:%s:\n%s\n"
                                   (symbol-name (car (elfeed-entry-tags elfeed-entry)))
                                   (elfeed-entry-link elfeed-entry)))
        :unnarrowed t)))))

(map! :after w3m
      :map w3m-lynx-like-map
      :leader
      "n r p" #'capture-post-w3m)

(map! :after elfeed
      :map elfeed-show-mode-map
      :leader "n r p" #'capture-post-elfeed)

;; Press u inside a elfeed article to mark it as unread
(evil-define-key 'normal elfeed-show-mode-map (kbd "u") 'elfeed-show-tag--unread)

(setq mastodon-instance-url "https://social.bezmuth.uk")  ;; Set your instance URL
(setq mastodon-active-user "bezmuth")  ;; Set your Mastodon username
(setq mastodon-tl--show-avatars t)
(progn

  ;; set font for emoji
  ;; if before emacs 28, this should come after setting symbols, because emacs 28 now has 'emoji . before, emoji is part of 'symbol

  (set-fontset-font
   t
   (if (< emacs-major-version 28)
       '(#x1f300 . #x1fad0)
     'emoji
     )
   (cond
    ((member "Noto Color Emoji" (font-family-list)) "Noto Color Emoji")
    ((member "Noto Emoji" (font-family-list)) "Noto Emoji"))))

(setq display-time-24hr-format t)
(after! doom-modeline
  (setq doom-modeline-time-icon nil))
(display-time)
(display-battery-mode)
(require 'mastodon-async)
(after! mastodon
  (map! :map mastodon-mode-map
      :n "mm" (lambda ()
                  (interactive)
                  (mastodon-tl--more)))
)


(after! w3m
  (setq w3m-search-default-engine "duckduckgo")
  (setq w3m-display-mode 'plain)
  (setq w3m-fill-column 80)
  (setq w3m-display-image t)
  )
(setq browse-url-browser-function 'w3m-goto-url-new-session)

(map! :leader "ow" 'w3m-search)

(org-noter-enable-org-roam-integration)
