;; -*- lexical-binding: t; -*
(setq package-archives '(("melpa"  . "https://melpa.org/packages/")
			 ("gnu"    . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(setq comp-async-report-warnings-errors nil)

(defvar native-comp-deferred-compilation-deny-list ())
(defvar native-comp-jit-compilation-deny-list ())
(defvar bootstrap-version)
(defvar comp-deferred-compilation-deny-list ()) ; workaround, otherwise straight shits itself
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 ;;"https://raw.git0hubusercontent.com/raxod502/straight.el/develop/install.el"
	 "https://radian-software.github.io/straight.el/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq straight-host-usernames
      '((github . "tungegan")
	(gitlab . "tungegan")))

(setq straight-vc-git-default-remote-name "straight")

(straight-use-package '(use-package :build t))
(setq use-package-always-ensure t)

(defalias 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode 1)

(setq-default font-lock-multiline nil)

			       ;;; better defaults
(set-language-environment "utf-8")
(set-default-coding-systems 'utf-8)
(setq default-input-method nil)

			   ;;; undo
(setq undo-limit        10000000 ;; 1mb (default is 160kb)
      undo-strong-limit 100000000 ;; 100mb (default is 240kb)
      undo-outer-limit  1000000000) ;; 1gb (default is 24mb)

;; set fullscreen
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; better simple ui
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode 0)

(setq-default frame-title-format "%b - Emacs")

(use-package catppuccin-theme
  :straight (:build t)
  :ensure t
					;config
					;(setq catppuccin-flavor 'mocha)) ;; or 'latte, or 'frappe 'macchiato, or 'mocha 
  )

(use-package doom-themes
  :straight (:build t)
  :ensure t
  :config
  (load-theme 'catppuccin t ))
					;(catppuccin-set-color 'base "#0d1117") ;; change base to #000000 for the currently active flavor
					;(catppuccin-set-color 'crust "#222222" 'frappe) ;; change crust to #222222 for frappe
					;(catppuccin-reload)

(set-face-attribute 'default nil
		    :font "jetbrains mono"
		    :weight 'light
		    :height 140)

;; set the fixed pitch face
(set-face-attribute 'fixed-pitch nil
		    :font "jetbrains mono"
		    :weight 'light
		    :height 140)

;; set the variable pitch face
(set-face-attribute 'variable-pitch nil
		    ;; :font "cantarell"
		    :font "jetbrains mono"
		    :height 140
		    :weight 'light)
;;(setq frame-title-format "")

(require 'time)
(setq display-time-format "%y-%b-%d %H:%M")
(display-time-mode 1) 

(use-package doom-modeline
  :straight t
  :custom
  (doom-modeline-height 35)
  (doom-modeline-bar-width 8)
  (doom-modeline-time-icon nil)
  (doom-modeline-buffer-encoding 'nondefault)
  (doom-modeline-unicode-fallback t))
(setq evil-normal-state-tag   (propertize "[NORMAL]" 'face '((:background "greenyellow" :foreground "black")))
      evil-emacs-state-tag    (propertize "[EMACS]" 'face '((:background "orange" :foreground "black")))
      evil-insert-state-tag   (propertize "[INSERT]" 'face '((:background "red") :foreground "white"))
      evil-motion-state-tag   (propertize "[MOTION]" 'face '((:background "blue") :foreground "white"))
      evil-visual-state-tag   (propertize "[VISUAL]" 'face '((:background "yellow" :foreground "black")))
      evil-operator-state-tag (propertize "[OPERATOR]" 'face '((:background "purple"))))
;; use moody for the mode bar
(use-package moody
  :straight (:build t)
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

(use-package minions
  :straight (:build t)
  :config
  (setq minions-mode-line-lighter ""
	minions-mode-line-delimiters '("" . ""))
  (minions-mode 1))
(setq evil-insert-state-cursor '((bar . 2) "orange")
      evil-normal-state-cursor '(box "orange"))


					; display time in modeline

(use-package rainbow-delimiters
  :straight (:build t)
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

;; make esc quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; enable line numbers for some modes
(dolist (mode '(text-mode-hook
		prog-mode-hook
		conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1)))) 

(setq global-display-line-numbers-mode t)
(setq tab-always-indent nil
      whitespace-action '(cleanup auto-cleanup))

(use-package hydra
  :straight (:build t)
  :defer t)
(defhydra windows-adjust-size ()
  "
^Zoom^                                ^Other
^^^^^^^-----------------------------------------
[_j_/_k_] shrink/enlarge vertically   [_q_] quit
[_l_/_h_] shrink/enlarge horizontally
"
  ("q" nil :exit t)
  ("l" shrink-window-horizontally)
  ("j" enlarge-window)
  ("k" shrink-window)
  ("h" enlarge-window-horizontally))

(use-package evil
  :straight (:build t)
  :ensure t
  :after (general)
  :init
  (setq evil-want-integration t
	evil-want-keybinding nil
	evil-want-C-u-scroll t
	evil-want-C-i-jump nil)
  (require 'evil-vars)
  (evil-set-undo-system 'undo-tree)
  :config
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-global-set-key 'motion "w" 'evil-avy-goto-word-1)
  (global-set-key (kbd "C-'") #'evil-window-next)
  (evil-mode 1)
  (setq evil-want-fine-undo t) ; more granular undo with evil
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :straight (:build t)
  :config
  (evil-collection-init))
(use-package evil-org
  :straight (:build t)
  :after (org)
  :hook (org-mode . evil-org-mode)
  :config
  (setq-default evil-org-movement-bindings
		'((up    . "k")
		  (down  . "j")
		  (left  . "h")
		  (right . "l")))
  (evil-org-set-key-theme '(textobjects navigation calendar additional shift operators))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(defun tx/switch-to-previous-buffer ()
  "Switch to previously open buffer.
    Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(use-package bm
  :demand t
  :init
  ;; restore on load (even before you require bm)
  (setq bm-restore-repository-on-load t)

  :config
  ;; Allow cross-buffer 'next'
  (setq bm-cycle-all-buffers t

	;; where to store persistant files
	bm-repository-file "~/.emacs.d/bm-repository")

  ;; save bookmarks
  (setq-default bm-buffer-persistence t)

  ;; Loading the repository from file when on start up.
  (add-hook 'after-init-hook 'bm-repository-load)

  ;; Saving bookmarks
  (add-hook 'kill-buffer-hook #'bm-buffer-save)

  ;; must save all bookmarks first.
  (add-hook 'kill-emacs-hook #'(lambda nil
				 (bm-buffer-save-all)
				 (bm-repository-save)))

  (add-hook 'after-save-hook #'bm-buffer-save)

  ;; Restoring bookmarks
  (add-hook 'find-file-hooks   #'bm-buffer-restore)
  (add-hook 'after-revert-hook #'bm-buffer-restore)

  (add-hook 'vc-before-checkin-hook #'bm-buffer-save)

  ;; key binding
  :bind (("C-4" . bm-toggle)
	 ("C-5" . bm-lifo-next)
	 ("C-8" . bm-lifo-previous)
	 ("C-1" . bm-show-all))
  )

(use-package general
  :straight (:build t)
  :init
  (general-auto-unbind-keys)
  :config
  (general-create-definer tx/underfine
    :keymaps 'override
    :states '(normal emacs))
  (general-create-definer tx/evil
    :states '(normal))
  (general-create-definer tx/leader-key
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")
  (general-create-definer tx/major-leader-key
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix ","
    :global-prefix "M-m"))

(use-package ripgrep
  :if (executable-find "rg")
  :straight (:build t)
  :defer t)
(use-package projectile
  :straight (:build t)
  :diminish projectile-mode
  :custom ((projectile-completion-system 'ivy))
  :init
  (setq projectile-switch-project-action #'projectile-dired)
  :config
  (projectile-mode)
  (add-to-list 'projectile-ignored-projects "~/")
  (add-to-list 'projectile-globally-ignored-directories "^node_modules$")
  :general
  (tx/leader-key
    "p" '(:keymap projectile-command-map :which-key "projectile")))
(use-package counsel-projectile
  :straight (:build t)
  :after (counsel projectile)
  :config (counsel-projectile-mode))

(use-package undo-tree
  :defer t
  :straight (:build t)
  :custom
  (undo-tree-history-directory-alist
   `(("." . ,(expand-file-name (file-name-as-directory "undo-tree-hist")
			       user-emacs-directory))))
  :init
  (global-undo-tree-mode)
  :config
  (setq undo-tree-visualizer-diff       t
	undo-tree-auto-save-history     t
	undo-tree-enable-undo-in-region t
	undo-limit        (* 800 1024)
	undo-strong-limit (* 12 1024 1024)
	undo-outer-limit  (* 128 1024 1024)))

(use-package bufler
  :straight (:build t)
  :bind (("C-M-j" . bufler-switch-buffer)
	 ("C-M-k" . bufler-workspace-frame-set))
  :config
  (evil-collection-define-key 'normal 'bufler-list-mode-map
    (kbd "RET")   'bufler-list-buffer-switch
    (kbd "M-RET") 'bufler-list-buffer-peek
    "D"           'bufler-list-buffer-kill)

  (setf bufler-groups
	(bufler-defgroups
	  ;; Subgroup collecting all named workspaces.
	  (group (auto-workspace))
	  ;; Subgroup collecting buffers in a projectile project.
	  (group (auto-projectile))
	  ;; Grouping browser windows
	  (group
	   (group-or "Browsers"
		     (name-match "Vimb" (rx bos "vimb"))
		     (name-match "Qutebrowser" (rx bos "Qutebrowser"))
		     (name-match "Chromium" (rx bos "Chromium"))))
	  (group
	   (group-or "Chat"
		     (mode-match "Telega" (rx bos "telega-"))))
	  (group
	   ;; Subgroup collecting all `help-mode' and `info-mode' buffers.
	   (group-or "Help/Info"
		     (mode-match "*Help*" (rx bos (or "help-" "helpful-")))
		     ;; (mode-match "*Helpful*" (rx bos "helpful-"))
		     (mode-match "*Info*" (rx bos "info-"))))
	  (group
	   ;; Subgroup collecting all special buffers (i.e. ones that are not
	   ;; file-backed), except `magit-status-mode' buffers (which are allowed to fall
	   ;; through to other groups, so they end up grouped with their project buffers).
	   (group-and "*Special*"
		      (name-match "**Special**"
				  (rx bos "*" (or "Messages" "Warnings" "scratch" "Backtrace" "Pinentry") "*"))
		      (lambda (buffer)
			(unless (or (funcall (mode-match "Magit" (rx bos "magit-status"))
					     buffer)
				    (funcall (mode-match "Dired" (rx bos "dired"))
					     buffer)
				    (funcall (auto-file) buffer))
			  "*Special*"))))
	  ;; Group remaining buffers by major mode.
	  (auto-mode))))

(use-package flycheck
  :straight (:build t)
  :defer t
  :init
  (global-flycheck-mode)
  :config
  (setq flycheck-emacs-lisp-load-path 'inherit)

  ;; Rerunning checks on every newline is a mote excessive.
  (delq 'new-line flycheck-check-syntax-automatically)
  ;; And don’t recheck on idle as often
  (setq flycheck-idle-change-delay 2.0)

  ;; For the above functionality, check syntax in a buffer that you
  ;; switched to on briefly. This allows “refreshing” the syntax check
  ;; state for several buffers quickly after e.g. changing a config
  ;; file.
  (setq flycheck-buffer-switch-check-intermediate-buffers t)

  ;; Display errors a little quicker (default is 0.9s)
  (setq flycheck-display-errors-delay 0.2))

(use-package avy
  :defer t
  :straight t
  :config
  (defun my/avy-goto-url ()
    "Jump to url with avy."
    (interactive)
    (avy-jump "https?://"))
  (defun my/avy-open-url ()
    "Open url selected with avy."
    (interactive)
    (my/avy-goto-url)
    (browse-url-at-point))
  :general
  (tx/evil
    :pakages 'avy
    "gc" #'evil-avy-goto-char-timer
    "gl" #'evil-avy-goto-line)
  (tx/leader-key
    :packages 'avy
    :infix "j"
    "b" #'avy-pop-mark
    "c" #'evil-avy-goto-char-timer
    "l" #'avy-goto-line)
  (tx/leader-key
    :packages 'avy
    :infix "A"
    "c"  '(:ignore t :which-key "copy")
    "cl" #'avy-copy-line
    "cr" #'avy-copy-region
    "k"  '(:ignore t :which-key "kill")
    "kl" #'avy-kill-whole-line
    "kL" #'avy-kill-ring-save-whole-line
    "kr" #'avy-kill-region
    "kR" #'avy-kill-ring-save-region
    "m"  '(:ignore t :which-key "move")
    "ml" #'avy-move-line
    "mr" #'avy-move-region
    "mt" #'avy-transpose-lines-in-region
    "n"  #'avy-next
    "p"  #'avy-prev
    "u"  #'my/avy-goto-url
    "U"  #'my/avy-open-url)
  (tx/major-leader-key
    :packages '(avy org)
    :keymaps 'org-mode-map
    "A" '(:ignore t :which-key "avy")
    "Ar" #'avy-org-refile-as-child
    "Ah" #'avy-org-goto-heading-timer))

(use-package maple-iedit
  :ensure nil
  :commands (maple-iedit-match-all maple-iedit-match-next maple-iedit-match-previous)
  :config
  (setq maple-iedit-ignore-case t)

  (defhydra maple/iedit ()
    ("n" maple-iedit-match-next "next")
    ("t" maple-iedit-skip-and-match-next "skip and next")
    ("T" maple-iedit-skip-and-match-previous "skip and previous")
    ("p" maple-iedit-match-previous "prev"))
  :bind (:map evil-visual-state-map
	      ("n" . maple/iedit/body)
	      ;; ("C-n" . maple-iedit-match-next)
	      ;; ("C-p" . maple-iedit-match-previous)
	      ("C-t" . maple-iedit-skip-and-match-next)))

(use-package hideshow
  :hook
  (prog-mode . hs-minor-mode)
  :bind
  ("C-<tab>" . hs-cycle)
  ("C-<iso-lefttab>" . hs-global-cycle)
  ("C-S-<tab>" . hs-global-cycle))
(defun hs-cycle (&optional level)
  (interactive "p")
  (let (message-log-max
	(inhibit-message t))
    (if (= level 1)
	(pcase last-command
	  ('hs-cycle
	   (hs-hide-level 1)
	   (setq this-command 'hs-cycle-children))
	  ('hs-cycle-children
	   ;; called twice to open all folds of the parent
	   ;; block.
	   (save-excursion (hs-show-block))
	   (hs-show-block)
	   (setq this-command 'hs-cycle-subtree))
	  ('hs-cycle-subtree
	   (hs-hide-block))
	  (_
	   (hs-hide-block)
	   (hs-hide-level 1)
	   (setq this-command 'hs-cycle-children)))
      (hs-hide-level level)
      (setq this-command 'hs-hide-level))))

(defun hs-global-cycle ()
  (interactive)
  (pcase last-command
    ('hs-global-cycle
     (save-excursion (hs-show-all))
     (setq this-command 'hs-global-show))
    (_ (hs-hide-all))))

(use-package move-text
  :straight (:build t))

(global-set-key (kbd "s-j") #'move-text-down)
(global-set-key (kbd "s-k") #'move-text-up)

(use-package popwin
  :straight t)
(use-package vterm
  :defer t
  :straight t
  :general
  (tx/leader-key
    "ot" '(+popwin:vterm :which-key "vTerm popup")
    "oT" '(vterm :which-key "vTerm"))
					;:preface
					;(when noninteractive
					;(advice-add #'vterm-module-compile :override #'ignore)
					;(provide 'vterm-module))
  :custom
  (vterm-max-scrollback 5000)
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  (setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000)
  (with-eval-after-load 'popwin
    (defun +popwin:vterm ()
      (interactive)
      (popwin:display-buffer-1
       (or (get-buffer "*vterm*")
	   (save-window-excursion
	     (call-interactively 'vterm)))
       :default-config-keywords '(:position :bottom :height 8)))))  

(use-package multi-vterm
  :after vterm
  :defer t
  :straight (:build t)
  :general
  (tx/major-leader-key
    :packages '(vterm multi-vterm)
    :keymap 'vterm-mode-map
    "c" #'multi-vterm
    "j" #'multi-vterm-next
    "k" #'multi-vterm-prev))

(use-package which-key
  :straight (:build t)
  :defer t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package which-key-posframe
  :config
  (which-key-posframe-mode))

(use-package helpful
  :straight (:build t)
  :after (counsel ivy)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key]      . helpful-key))

(use-package org
  :defer t
  :config
  (require 'org-protocol)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (rust . t)))
  )



(use-package company
  :straight (:build t)
  :defer t
  :hook (company-mode . evil-normalize-keymaps)
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length     2
	company-toolsip-limit             14
	company-idle-dalay                0.2
	company-tooltip-align-annotations t
	company-require-match             'never
	company-global-modes              '(not erc-mode message-mode help-mode gud-mode)
	company-frontends
	'(company-pseudo-tooltip-frontend ; always show candidates in overlay tooltip
	  company-echo-metadata-frontend) ; show selected candidate docs in echo area
	company-backends '(company-capf)
	company-auto-commit         nil
	company-auto-complete-chars nil
	company-dabbrev-other-buffers nil
	company-dabbrev-ignore-case nil
	company-dabbrev-downcase    nil))

(use-package ivy
  :straight t
  :defer t
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 ("C-u" . ivy-scroll-up-command)
	 ("C-d" . ivy-scroll-down-command)
	 :map ivy-switch-buffer-map
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  (setq ivy-wrap                        t
	ivy-height                      17
	ivy-sort-max-size               50000
	ivy-fixed-height-minibuffer     t
	ivy-read-action-functions       #'ivy-hydra-read-action
	ivy-read-action-format-function #'ivy-read-action-format-columns
	projectile-completion-system    'ivy
	ivy-on-del-error-function       #'ignore
	ivy-use-selectable-prompt       t))

(use-package counsel
  :straight t
  :after recentf
  :after ivy
  :bind (("M-x"     . counsel-M-x)
	 ("C-x b"   . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package yasnippet
  :defer t
  :straight (:build t)
  :init
  (yas-global-mode))

(use-package yasnippet-snippets
  :defer t
  :after yasnippet
  :straight (:build t))
(use-package ivy-yasnippet
  :defer t
  :after (ivy yasnippet)
  :straight (:build t)
  :general
  (tx/leader-key
    :infix "i"
    :packages 'ivy-yasnippet
    "y" #'ivy-yasnippet))

(tx/evil
  ;;:packages '(counsel)
  "s" '(window-configuration-to-register :wk "Register Window")
  "f" '(jump-to-register :wk "Jump Register")
  "K"   #'eldoc-doc-buffer
  "U"   #'evil-redo
  "C-a" #'my-smarter-move-beginning-of-line
  "C-e" #'end-of-line
  "*"   #'dired-create-empty-file
  "C-y" #'yank
  "M-y" #'counsel-yank-pop)

(tx/leader-key
  "SPC" '(counsel-M-x :which-key "M-x")
  "."  '(dirvish-dwim :which-key "Dirvish")
  "J"  '(dired-jump :which-key "Dired Jump")
  "'"   '(shell-pop :which-key "shell-pop")
  ","  '(magit-status :which-key "Magit Status")
  "j" '(bufler-switch-buffer :which-key "Switch Buffer")
  "k" '(tx/switch-to-previous-buffer :which-key "Switch to previous buffer")
  "oa" '(org-agenda :color blue :which-key "Agenda")
  "of" '(browse-file-directory :which-key "Open File in Directory")

  "a" '(:ignore t :which-key "Application")
  "ac" '(calendar :which-key "Calendar")

  "s" '(:ignore t :which-key "Set Timer")
  "st" '(org-timer :which-key "Timer")
  "si" '(org-timer-item :which-key "Timer")
  "ss" '(org-timer-set-timer :which-key "Set Timer")
  "sp" '(org-timer-pause-or-continue :which-key "Pause / Continue")
  "s1" '(org-timer-start :which-key "Start")
  "s2" '(org-timer-stop :which-key "Stop")

  "d" '(:ignore t :which-key "Dirvish")
  "ds" '(dirvish-side :which-key "Side")
  "il" '(org-insert-last-stored-link :which-key "Insert Stored Link")
  "is" '(org-store-link :which-key "Store Link"))

(tx/leader-key
  :packages '(bufler)
  "b" '(:ignore t :which-key "Buffers")
  "bb" '(bufler-switch-buffer :which-key "Switch Buffer")
  "bB" '(bury-buffer :which-key "Bury Buffer")
  "bc" '(clone-indirect-buffer :which-key "Clone Indirect")
  "bC" '(clone-indirect-buffer-other-window :which-key "Clone Indirect Other Window")
  "bl" '(bufler :which-key "Bufler")
  "bk" '(kill-this-buffer :which-key "Kill This Buffer")
  "bD" '(kill-buffer :which-key "Kill Buffer")
  "bh" '(dashboard-refresh-buffer :which-key "Dashboard Refresh Buffer")
  "bm" '(switch-to-message-buffer :which-key "Switch to message buffer")
  "bn" '(next-buffer :which-key "Next Buffer")
  "bp" '(previous-buffer :which-key "Next Buffer")
  "br" '(counsel-buffer-or-recentf :which-key "Recentf Buffer")
  "bs" '(switch-to-scratch-buffer :which-key "Scratch Buffer"))

(tx/leader-key
  :packages '(treemacs)
  "t" '(:ignore t :wk "Treemacs")
  "tc" '(:ignore t :wk "Create")
  "tcd" '(treemacs-create-dir :which-key "Create Dir")
  "tcf" '(treemacs-create-file :which-key "Create File")
  "tci" '(treemacs-create-icon :which-key "Create Icon")
  "tct" '(treemacs-create-theme :which-key "Create Theme")
  "td" '(treemacs-delete-file :which-key "delete")
  "tw" '(:ignore t :wk "Workspace")
  "tws" '(treemacs-switch-workspace :which-key "Switch Workspace")
  "twc" '(treemacs-create-workspace :which-key "Create Workspace")
  "twr" '(treemacs-remove-workspace :which-key "Remove Workspace")
  "tf" '(:ignore t :wk "Files")
  "tff" '(treemacs-find-file :which-key "Find File")
  "tft" '(treemacs-find-tag :which-key "Find Tag")
  "tl" '(:ignore t :wk "LSP")
  "tls" '(treemacs-expand-lsp-symbol :which-key "Lsp Symbol")
  "tld" '(treemacs-expand-lsp-treemacs-deps :which-key "Lsp treemacs deps")
  "tlD" '(treemacs-collapse-lsp-treemacs-deps :which-key "Collapse lsp Deps")
  "tlS" '(treemacs-collapse-lsp-symbol :which-key "Collapse Lsp Symbol")
  "tp" '(:ignore t :wk "Projcets")
  "tpa" '(treemacs-add-project :which-key "Add project")
  "tpf" '(treemacs-project-follow-mode :which-key "Follow mode")
  "tpn" '(treemacs-project-of-node :which-key "Of Node")
  "tpp" '(treemacs-project-at-point :which-key "At Point")
  "tpr" '(treemacs-remove-project-from-workspace :which-key "Remove project")
  "tpt" '(treemacs-move-project-down :which-key "Project Down")
  "tps" '(treemacs-move-project-up :which-key "Project Up")
  "tr" '(:ignore t :wk "Rename")
  "trf" '(treemacs-rename-file :which-key "Rename File")
  "trp" '(treemacs-rename-project :which-key "Rename project")
  "trr" '(treemacs-rename :which-key "Rename")
  "trw" '(treemacs-rename-workspace :which-key "Rename Workspace")
  "tT" '(:ignore t :wk "Toggle")
  "tTd" '(treemacs-toggle-show-dotfiles :which-key "Toggle show Dotfiles")
  "tTn" '(treemacs-toggle-node :which-key "Toggle Node")
  "tv" '(:ignore t :wk "Visit Node")
  "tva" '(treemacs-visit-node-ace :which-key "Visit Ace")
  "tvc" '(treemacs-visit-node-close-treemacs :which-key "Visit Node Close")
  "tvn" '(treemacs-visit-node-default :which-key "Visit Node")
  "ty" '(:ignore t :wk "Yank")
  "tya" '(treemacs-copy-absolute-path-at-point :which-key "Absolute")
  "typ" '(treemacs-copy-project-path-at-point :which-key "Project")
  "tyr" '(treemacs-copy-relative-path-at-point :which-key "Relative")
  "tyr" '(treemacs-copy-file :which-key "file"))

(tx/leader-key
  "c"   '(:ignore t :wk "code")
  "cl"  #'evilnc-comment-or-uncomment-lines

  "e"  '(:ignore t :which-key "errors")
  "e." '(hydra-flycheck/body :wk "hydra")
  "el" '(counsel-flycheck :wk "Flycheck")
  "eF" #'flyspell-hydra/body

  "f"   '(:ignore t :wk "Files")
  "ff" '(counsel-find-file :wk "Find Files")
  "fD" '(tx/delete-this-file :wk "Delete Files")
  "fr" '(counsel-recentf :wk "Recentf Files"))

(tx/leader-key
  "h"   '(:ignore t :wk "Help")
  "hi" '(info :wk "Info")
  "hI" '(info-display-manual :wk "Info Display")
  "hd"   '(:ignore t :wk "Describe")
  "hdk" '(helpful-key :wk "Key")
  "hdm" '(helpful-macro :wk "Macro")
  "hds" '(helpful-symbol :wk "Symbol")
  "hdv" '(helpful-variable :wk "Variable")

  "i"   '(:ignore t :wk "insert")
  "iu"  #'counsel-unicode-char

  "t"   '(:ignore t :wk "Insert")
  "tt"  #'my/modify-frame-alpha-background/body
  "tT"  #'counsel-load-theme
  "tml"  #'modus-themes-load-operandi
  "tmd"  #'modus-themes-load-vivendi
  "td"  '(:ignore t :wk "Debug")
  "tde"  #'toggle-debug-on-error
  "tdq"  #'toggle-debug-on-quit
  "ti"   '(:ignore t :wk "Input")
  "tit"  #'toggle-input-method
  "tis"  #'set-input-method

  "T"   '(:ignore t :wk "Input")
  "Te"  #'string-edit-at-point
  "Tu"  #'downcase-region
  "TU"  #'upcase-region
  "Tz"  #'hydra-zoom/body

  "w"   '(:ignore t :wk "Windows")
  "wh" '(evil-window-left :wk "Left")
  "wj" '(evil-window-down :wk "Down")
  "wk" '(evil-window-up :wk "Up")
  "wl" '(evil-window-right :wk "Right")
  "ws" '(evil-window-split :wk "Split")
  "wv" '(evil-window-vsplit :wk "Verticle Split")
  "wi" '(windows-adjust-size/body :wk "Window Size")
  "w1" #'winum-select-window-1
  "w2" #'winum-select-window-2
  "w3" #'winum-select-window-3
  "w4" #'winum-select-window-4
  "wc" '(kill-buffer-and-delete-window :wk "Kill & Delete")
  "wO" '(tx/kill-other-buffers :wk "Kill other window")
  "wd" '(delete-window :wk "Delete window")
  "wo" '(delete-other-windows :wk "delete others window")

  "ag"   '(:ignore t :wk "Gcal")
  "agp"  #'org-gcal-post-at-point
  "agR"  #'org-gcal-reload-client-id-secret
  "ags"  #'org-gcal-sync
  "agS"  #'org-gcal-sync-buffer
  "agf"  #'org-gcal-fetch
  "agF"  #'org-gcal-fetch-buffer
  "agd"  #'org-gcal-delete-at-point
  "agr"  #'org-gcal-request-token
  "agt"  #'org-gcal-toggle-debug

  "n"   '(:ignore t :wk "Gcal")
  "nn"  #'org-roam-node-find
  "naa"  #'org-roam-alias-add
  "nar"  #'org-roam-alias-remove
  "ni"  #'org-roam-node-insert
  "nl"  #'org-roam-buffer-toggle
  "nct"  #'org-roam-dailies-capture-today
  "ncT"  #'org-roam-dailies-capture-tomorrow
  "nfd"  #'org-roam-dailies-find-date
  "nft"  #'org-roam-dailies-find-today
  "nfy"  #'org-roam-dailies-find-yesterday
  "nfT"  #'org-roam-dailies-find-tomorrow
  "ng"  #'org-roam-graph
  "nbs"  #'bookmark-set
  "nbj"  #'bookmark-jump
  "nbi"  #'bookmark-insert
  "nbl"  #'bookmark-bmenu-list

  "l"   '(:ignore t :wk "Lsp")
  "ll"  #'lsp
  "lm"  #'lsp-ui-imenu
  "lR"  #'lsp-workspace-restart
  "ls"  #'lsp-treemacs-symbols
  "le"  #'lsp-treemacs-errors-list
  "ld"  #'xref-find-definitions
  "lr"  #'lsp-rename
  "lD"  #'lsp-find-declaration

  "all" #'leetcode
  "ald" #'leetcode-daily
  "alo" #'leetcode-show-problem-in-browser
  "alO" #'leetcode-show-problem-by-slub
  "alS" #'leetcode-submit
  "als" #'leetcode-show-problem

  "p" '(:ignore t :wk "Projectile")
  "p!" #'projectile-run-shell-command-in-root
  "p&" #'projectile-run-async-shell-command-in-root
  "pb" #'counsel-projectile-switch-to-buffer
  "pc" #'counsel-projectile
  "pr" #'projectile-remove-known-project
  "pd" #'counsel-projectile-find-dir
  "pe" #'projectile-edit-dir-locals
  "pf" #'counsel-projectile-find-file
  "pg" #'projectile-find-tag
  "pk" #'project-kill-buffers
  "pp" #'counsel-projectile-switch-project
  "pt" #'ivy-magit-todos
  "pv" #'projectile-vc

  "u"   #'universal-argument
  "U"   #'undo-tree-visualize


  "fc"  '((lambda ()
	    (interactive)
	    (find-file "~/.emacs.d/eamon.org"))
	  wk "emacs.org")

  "fi"  '((lambda ()
	    (interactive)
	    (find-file (concat user-emacs-directory "init.el")))
	  :which-key "init.el")

  "fR"  '((lambda ()
	    (interactive)
	    (counsel-find-file ""
			       (concat user-emacs-directory
				       (file-name-as-directory "straight")
				       (file-name-as-directory "repos"))))
	  :which-key "straight package")

  "owg"  '((lambda ()
	     (interactive)
	     (browse-url "https://github.com/eamondang"))
	   :wk "My Github")

  "owe"  '((lambda ()
	     (interactive)
	     (browse-url "https://remix.ethereum.org/"))
	   :wk "Remix IDE")

  "owr"  '((lambda ()
	     (interactive)
	     (browse-url "https://reddit.com/"))
	   :wk "Reddit")

  "owc"  '((lambda ()
	     (interactive)
	     (browse-url "https://calendar.google.com/calendar/u/0/r?pli=1"))
	   :wk "My Calender")

  "owwc"  '((lambda ()
	      (interactive)
	      (browse-url "https://chat.openai.com"))
	    :wk "Chat GPT"))

(use-package all-the-icons
  :defer t
  :straight t)

(use-package lsp-mode
  :defer t
  :straight (:build t)
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands (lsp lsp-deferred)
  :hook (;(c-mode          . lsp-deferred)
					;(c++-mode        . lsp-deferred)
					;(html-mode       . lsp-deferred)
	 ;;(sh-mode         . lsp-deferred)
	 ;;(rustic-mode     . lsp-deferred)
					;(go-mode         . lsp-deferred)
	 ;; (text-mode       . lsp-deferred)
	 ;;(move-mode       . lsp-deferred)
	 ;;(toml-mode       . lsp-deferred)
	 ;;(sql-mode       . lsp-deferred)
	 ;;(json-mode       . lsp-deferred)
					;(typescript-mode . lsp-deferred)
	 (lsp-mode        . lsp-enable-which-key-integration)
	 (lsp-mode        . lsp-ui-mode))
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-use-plist t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "shellcheck")
		    :major-modes '(sh-mode)
		    :remote? t
		    :server-id 'shellcheck-remote)))
(setq lsp-sqls-workspace-config-path nil)




(use-package lsp-ui
  :after lsp
  :defer t
  :straight (:build t)
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil)
  :general
  (tx/major-leader-key
    :keymaps 'lsp-ui-peek-mode-map
    :packages 'lsp-ui
    "h" #'lsp-ui-pook--select-prev-file
    "j" #'lsp-ui-pook--select-next
    "k" #'lsp-ui-pook--select-prev
    "l" #'lsp-ui-pook--select-next-file))


(use-package lsp-ivy
  :straight (:build t)
  :defer t
  :after lsp
  :commands lsp-ivy-workspace-symbol)

(use-package exec-path-from-shell
  :defer t
  :straight (:build t)
  :init (exec-path-from-shell-initialize))

(use-package lsp-treemacs
  :defer t
  :straight (:build t)
  :requires treemacs
  :config
  (treemacs-resize-icons 15))


(use-package consult-lsp
  :defer t
  :after lsp
  :straight (:build t)
  :general
  (tx/evil
    :keymaps 'lsp-mode-map
    [remap xref-find-apropos] #'consult-lsp-symbols))


;; Dap-mode -----> debug

(use-package dap-mode
  :straight (:build t)
  :ensure
  :config
  (dap-ui-mode 1)
  (dap-ui-controls-mode 1)
  (dap-tooltip-mode 1)

  (require 'dap-lldb)
  (require 'dap-gdb-lldb)
  ;; installs .extension/vscode
  (dap-gdb-lldb-setup))
(setq dap-auto-configure-features '(sessions locals controls breakpoints expressions repl tooltip))

(dap-register-debug-template "Rust::LLDB Run Configuration"
			     (list :type "lldb-mi"
				   :request "launch"
				   :name "LLDB::Run"
				   :gdbpath "rust-lldb"
				   :target nil
				   :cwd nil))
(with-eval-after-load 'dap-mode
  (setq dap-default-terminal-kind "integrated") ;; Make sure that terminal programs open a term for I/O in an Emacs buffer
  (dap-auto-configure-mode +1))

(define-minor-mode +dap-running-session-mode
  "A mode for adding keybindings to running sessions"
  nil
  nil
  (make-sparse-keymap)
  (evil-normalize-keymaps) ;; if you use evil, this is necessary to update the keymaps
  ;; The following code adds to the dap-terminated-hook
  ;; so that this minor mode will be deactivated when the debugger finishes
  (when +dap-running-session-mode
    (let ((session-at-creation (dap--cur-active-session-or-die)))
      (add-hook 'dap-terminated-hook
		(lambda (session)
		  (when (eq session session-at-creation)
		    (+dap-running-session-mode -1)))))))

;; Activate this minor mode when dap is initialized
(add-hook 'dap-session-created-hook '+dap-running-session-mode)

;; Activate this minor mode when hitting a breakpoint in another file
(add-hook 'dap-stopped-hook '+dap-running-session-mode)

;; Activate this minor mode when stepping into code in another file
(add-hook 'dap-stack-frame-changed-hook (lambda (session)
					  (when (dap--session-running session)
					    (+dap-running-session-mode 1))))

(use-package move-mode
  :straight (:build t :host github :repo "amnn/move-mode" :branch "main"))

(add-hook 'move-mode-hook #'eglot-ensure)
;;(add-to-list 'eglot-server-programs '(move-mode "move-analyzer"))

(defun my/move-lsp-project-root (dir)
  (and-let* (((boundp 'eglot-lsp-context))
	     (eglot-lsp-context)
	     (override (locate-dominating-file dir "Move.toml")))
    (cons 'Move.toml override)))

(add-hook 'project-find-functions #'my/move-lsp-project-root)
(cl-defmethod project-root ((project (head Move.toml)))
  (cdr project))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(move-mode . "move"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "move-analyzer")
    :activation-fn (lsp-activate-on "move")
    :priority -1
    :server-id 'move-analyzer)))

(use-package eglot
  :straight t
  :ensure t
  :config
  (add-hook 'move-mode-hook #'eglot-ensure)
  (add-to-list 'eglot-server-programs '(move-mode "move-analyzer"))
  )

(use-package rustic
  :defer t
  :straight (:build t)
  :mode ("\\.rs\\'" . rustic-mode)
  :hook (rustic-mode-local-vars . rustic-setup-lsp)
  :hook (rustic-mode . lsp-deferred)
  :hook (rustic-mode . eglot-ensure)
  :init
  (with-eval-after-load 'org
    (defalias 'org-babel-execute:rust #'org-babel-execute:rustic)
    (add-to-list 'org-src-lang-modes '("rust" . rustic)))
  ;;(setq rustic-lsp-client 'lsp-mode)
  (setq rustic-lsp-client 'eglot)
  (add-hook 'rustic-mode-hook #'tree-sitter-hl-mode)
  (add-hook 'rust-mode-hook
	    (lambda ()
	      (setq indent-tabs-mode nil)
	      (setq tab-width 2)
	      (setq rust-indent-offset 2)))
  :general
  (general-define-key
   :keymaps 'rustic-mode-map
   :packages 'lsp
   "M-t" #'lsp-ui-imenu
   "M-?" #'lsp-find-references)
  (tx/major-leader-key
    :keymaps 'rustic-mode-map
    :packages 'rustic
    "b"  '(:ignore t :which-key "build")
    "bB" #'rustic-cargo-build
    "bB" #'rustic-cargo-bench
    "bc" #'rustic-cargo-check
    "bC" #'rustic-cargo-clippy
    "bn" #'rustic-cargo-new
    "bo" #'rustic-cargo-outdated
    "d" '(:ignore t :which-key "Debugging")
    "dr" #'dap-debug
    "dh" #'dap-hydra
    "dl" #'dap-debug-last
    "dR" #'dap-debug-restart
    "dq" #'dap-disconnect
    "da" #'dap-breakpoint-add
    "dt" #'dap-breakpoint-toggle
    "dd" #'dap-breakpoint-delete
    "dD" #'dap-breakpoint-delete-all
    "D" #'rustic-cargo-doc
    "f" #'rustic-cargo-fmt
    "a" #'rustic-cargo-add
    "r" #'rustic-cargo-run
    "cf" #'rustic-cargo-clippy-fix
    "cr" #'rustic-cargo-clippy-run
    "cc" #'rustic-cargo-clippy
    "l"  '(:ignore t :which-key "lsp")
    "la" #'lsp-execute-code-action
    "lr" #'lsp-rename
    "lq" #'lsp-workspace-restart
    "lQ" #'lsp-workspace-shutdown
    "ls" #'lsp-rust-analyzer-status
    "T" #'rustic-cargo-test
    "t" #'rustic-cargo-current-test)
  :config
  (setq rustic-indent-method-chain    t
	rustic-babel-format-src-block nil
	rustic-format-trigger         nil)
  (remove-hook 'rustic-mode-hook #'flycheck-mode)
  (remove-hook 'rustic-mode-hook #'flymake-mode-off)
  (remove-hook 'rustic-mode-hook #'rustic-setup-lsp))
;; Use Rustfmt for formatting Rust code in Rustic mode
(setq rustic-format-on-save t)
(setq rustic-format-display-method 'echo)
(setq rustic-format-trigger 'on-save)
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-lsp-format t)
(setq rustic-lsp-client nil)
(setq rustic-rustfmt-bin (executable-find "rustfmt"))
(setq rustic-rustfmt-config "~/.rustfmt.toml")

;; (use-package parinfer-rust-mode
;;   :defer t
;;   :straight (:build t)
;;   :diminish parinfer-rust-mode
;;   :hook emacs-lisp-mode common-lisp-mode scheme-mode
;;   :init
;;   (setq parinfer-rust-auto-download     t
;;         parinfer-rust-library-directory (concat user-emacs-directory
;;                                                 "parinfer-rust/"))
;;   (add-hook 'parinfer-rust-mode-hook
;;             (lambda () (smartparens-mode -1)))
;;   :general
;;   (tx/major-leader-key
;;     :keymaps 'parinfer-rust-mode-map
;;     "m" #'parinfer-rust-switch-mode
;;     "M" #'parinfer-rust-toggle-disable))

;; Add my library path to load-path
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/screenshot.el")
(add-to-list 'load-path "~/.emacs.d/lisp/oauth2.el")
(add-to-list 'load-path "~/.emacs.d/lisp/cadence-mode")
(add-to-list 'load-path "~/.emacs.d/lisp/cadence-mode/cadence-mode.el")
(add-to-list 'load-path "~/.emacs.d/lisp/maple-iedit")
(add-to-list 'load-path "~/.emacs.d/lisp/protobuf-mode/")

(require 'cadence-mode)
(require 'oauth2)
(require 'screenshot)

(use-package engine-mode
  :config
  (engine/set-keymap-prefix (kbd "C-c s"))
  ;;(setq browse-url-browser-function 'browse-url-default-macosx-browser
  ;;      engine/browser-function 'browse-url-default-macosx-browser)
  ;;(setq engine/browser-function 'eww-browse-url)
  (setq browse-url-browser-function 'browse-url-default-browser)
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d")

  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "1")

  (defengine gitlab
    "https://gitlab.com/search?search=%s&group_id=&project_id=&snippets=false&repository_ref=&nav_source=navbar"
    :keybinding "2")

  (defengine stack-overflow
    "https://stackoverflow.com/search?q=%s"
    :keybinding "s")

  (defengine npm
    "https://www.npmjs.com/search?q=%s"
    :keybinding "n")

  (defengine crates
    "https://crates.io/search?q=%s"
    :keybinding "c")

  (defengine localhost
    "http://localhost:%s"
    :keybinding "l")

  (defengine vocabulary
    ;; "https://dictionary.cambridge.org/dictionary/english/%s"
    "https://www.vocabulary.com/dictionary/%s"
    :keybinding "t")

  (defengine translate
    "https://translate.google.com/?hl=vi&sl=en&tl=vi&text=%s&op=translate"
    :keybinding "T")

  (defengine youtube
    "http://www.youtube.com/results?aq=f&oq=&search_query=%s"
    :keybinding "y")

  (defengine google
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
    :keybinding "g")

  (engine-mode 1))

(setenv  "SHELL" "/bin/zsh")

(use-package protobuf-mode
  :mode "\\.proto3"
  )
