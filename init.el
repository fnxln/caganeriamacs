(setq inhibit-startup-message t) ; disable ugly emacs screen

(scroll-bar-mode -1); Disable scrollbar
(tool-bar-mode -1) ; disalbe the toolbar
(tooltip-mode -1) ; Disable tooltips
(set-fringe-mode 10) ; Give some space


(menu-bar-mode -1)  ; Disalbe menu  bar

(setq visible-bell t) ; Setup the visual bell


(set-face-attribute 'default nil :font "Source Code Pro Black") ; set font


;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; show lines
(column-number-mode)
(global-display-line-numbers-mode t)

;; Init package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

; Disble line numbers for some modes
(dolist(mode '(org-mode-hook
	       term-mode-hook
	       shell-mode-hook
	       eshell-mode-hook))
 (add-hook mode (lambda()   (display-line-numbers-mode  0 ))))

;; show keys when appearing
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; add doom themes
  (setq sml/no-confirm-load-theme t)
  (use-package doom-themes
    :ensure t
    :config
    ;; Global settings (defaults)
    (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	  doom-themes-enable-italic t) ; if nil, italics is universally disabled
    (load-theme 'doom-acario-dark t)

    ;; Enable flashing mode-line on errors
    (doom-themes-visual-bell-config)
    ;; Enable custom neotree theme (all-the-icons must be installed!)
    (doom-themes-neotree-config)
    ;; or for treemacs users
    (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
    (doom-themes-treemacs-config)
    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
	:init (doom-modeline-mode 1))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; use counsel
(use-package counsel
	:bind (("M-x" . counsel-M-x)
	       ("C-x b" . counsel-ibuffer)
	       ("C-x C-f" . counsel-find-file)

	       :map minibuffer-local-map
	       ("C-r" . 'counsel-minibuffer-history)))

;; show what im typinng
(use-package command-log-mode)

   ;; use ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)	
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; ivy rich for helpful tooltips for ivy

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package treemacs
:ensure t
:init
)

(use-package treemacs-all-the-icons
:ensure t
:init)

(treemacs-load-theme "all-the-icons")

(use-package vterm
    :ensure t)

(electric-pair-mode t)

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;;         (XXX-mode . lsp)
	 (rust-mode . lsp)
	 ;; if you want which-key integration
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package dap-mode)

(use-package company)

(use-package rust-mode
  :ensure t)

(use-package nix-mode
   :ensure t)

;; icon font
(use-package all-the-icons
  :if (display-graphic-p))

;; rainbow here we go
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; discord
(use-package elcord
  :ensure t
  )
(elcord-mode)

;;evil mode
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)
;; general.el
(use-package general
  :config
  (general-create-definer caganeira/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "s-SPC")

  (caganeira/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "b"  '(:ignore b :which-key "buffer menu")
    "bb" '(counsel-switch-buffer :which-key "switch buffer")
    "bd" '(kill-buffer :which-key "kill buffer")

    "w" '(:ignore w :which-key "window menu")
    "wc" '(delete-window :which-key "delete current window")
    "wv" '(split-window-right :which-key "vertical split")
    "wh" '(split-window-below :which-key "horizontal split")

    "f" '(:ignore f :which-key "file and buffer menu")
    "fs" '(save-buffer :wich-key "save buffer")

    "g" '(:ignore g :which-key "magit menu")
    "gg" '(magit :which-key "magit buffer")


    "o" '(:ignore 0 :which-key "open menu")
    "ot" '(vterm :which-key "open vterm")
    "op" '(treemacs :which-key "open treemacs")

    "." '(counsel-find-file :which-key "open dired")
    ))

; (bind-key "<tab>" #'company-active-map company-complete-selection)

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Source Code Pro Black" :weight 'regular :height (cdr face)))   

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;(defun efs/org-mode-visual-fill ()
 ;(setq visual-fill-column-width 100
   ;     visual-fill-column-center-text t)
  ;(visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(setq org-cycle-include-plain-lists 'integrate)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
				("mkv" . "mpv")
				("webm" . "mpv")
				("mp4" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))
