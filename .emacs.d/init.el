;; -*- lexical-binding: t; -*-

;; Core settings
(setq
      ;; Don't show the startup message
      inhibit-startup-message t

      ;; Instruct auto-save-mode to save to the current file, not a backup file
      auto-save-default nil

      ;; No backup files
      make-backup-files nil

      ;; Autosave every 1 sec
      auto-save-visited-interval 1

      ;; Make it easy to cycle through previous items in the mark ring
      set-mark-command-repeat-pop t

      ;; Don't warn on large files
      large-file-warning-threshold nil

      ;; Follow symlinks to VC-controlled files without warning
      vc-follow-symlinks t

      ;; Don't warn on advice
      ad-redefinition-action 'accept

      ;; Revert Dired and other buffers
      global-auto-revert-non-file-buffers t

      ;; Silence compiler warnings as they can be pretty disruptive
      native-comp-async-report-warnings-errors nil

      ;; Enable custom file
      custom-file (concat user-emacs-directory "custom.el"))

;; Local custom file if possible
(when (file-exists-p custom-file)
  (load custom-file))


;; Font
(set-frame-font "JetBrains Mono 13")

;; Core modes
(repeat-mode 1)                ;; Enable repeating key maps
(menu-bar-mode 0)              ;; Hide the menu bar
(tool-bar-mode 0)              ;; Hide the tool bar
(savehist-mode 1)              ;; Save minibuffer history
(scroll-bar-mode 0)            ;; Hide the scroll bar
(xterm-mouse-mode 1)           ;; Enable mouse events in terminal Emacs
(display-time-mode 1)          ;; Display time in mode line / tab bar
(column-number-mode 1)         ;; Show column number on mode line
(tab-bar-history-mode 1)       ;; Remember previous tab window configurations
(auto-save-visited-mode 1)     ;; Auto-save files at an interval
(global-visual-line-mode 1)    ;; Visually wrap long lines in all buffers
(global-auto-revert-mode 1)    ;; Refresh buffers with changed local files
(global-display-line-numbers-mode t) ;; Display line numbers
(auto-save-visited-mode 1) ;; Save to original file

;; Tabs to spaces
(setq-default indent-tabs-mode nil
	            tab-width 2)

;; Delete trailing whitespace before saving buffers
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setopt tab-always-indent 'complete
        read-buffer-completion-ignore-case t
        read-file-name-completion-ignore-case t

        ;; This *may* need to be set to 'always just so that you don't
        ;; miss other possible good completions that match the input
        ;; string.
        completion-auto-help t

        ;; Include more information with completion listings
        completions-detailed t

        ;; Move focus to the completions window after hitting tab
        ;; twice.
        completion-auto-select 'second-tab

        ;; If there are 3 or less completion candidates, don't pop up
        ;; a window, just cycle through them.
        completion-cycle-threshold 3

        ;; Cycle through completion options vertically, not
        ;; horizontally.
        completions-format 'vertical

        ;; Sort recently used completions first.
        completions-sort 'historical

        ;; Only show up to 10 lines in the completions window.
        completions-max-height 10

        ;; Don't show the unneeded help string at the top of the
        ;; completions buffer.
        completion-show-help nil

        ;; Add more `completion-styles' to improve candidate selection.
        completion-styles '(basic partial-completion substring initials))

;; auto-mode-alist entries
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode))

;; Eglot
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)
(add-hook 'nix-ts-mode-hook #'eglot-ensure)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(nix-ts-mode . ("nixd"))))
(setq completion-category-overrides '((eglot (styles . (orderless)))))

(use-package ocaml-eglot
  :ensure t
  :after tuareg
  :hook
  (tuareg-mode . ocaml-eglot)
  (ocaml-eglot . eglot-ensure))

;; Editorconfig
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; Vertico
(use-package vertico
  :init
  (vertico-mode))

;; Corfu
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  :init
  (global-corfu-mode))

;; Corfu popup info
(use-package corfu-popupinfo
  :after corfu
  :init
  (corfu-popupinfo-mode))

;; Git gutter
(global-git-gutter-mode t)
(custom-set-variables
 '(git-gutter:update-interval 1))
(custom-set-variables
 '(git-gutter:modified-sign " ")
 '(git-gutter:added-sign "+")
 '(git-gutter:deleted-sign "-"))
(set-face-background 'git-gutter:modified "orange")
(set-face-foreground 'git-gutter:added "green")
(set-face-foreground 'git-gutter:deleted "red")

;; Undo tree
(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history nil)
  (global-undo-tree-mode))

(use-package vterm
  :ensure t)
