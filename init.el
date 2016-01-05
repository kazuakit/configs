;; -*- coding: utf-8 -*-

;;; ------------------------------------------------------------
;;; How to write init.el
;;; ------------------------------------------------------------
;;; * Put together one file as much as possible.
;;; * Semicolon should be used properly.
;;;   ; in-line, ;; line level, ;;; block level
;;; * Configure sectionaly
;;;   - Package
;;;   - Frame
;;;   - Mode Line
;;;   - Buffer
;;;   - Key Bind
;;;   - Major Mode
;;;   - OS
;;;   - Others

;;; ------------------------------------------------------------
;;; Package
;;; ------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; http://qiita.com/kai2nenobu/items/5dfae3767514584f5220
(unless (require 'use-package nil t)
  (defmacro use-package (&rest args)))

(add-to-list 'load-path "~/.emacs.d/lisp")

;;; ------------------------------------------------------------
;;; Frame
;;; ------------------------------------------------------------
;; http://d.hatena.ne.jp/sandai/20120304/p2
(set-frame-parameter (selected-frame) 'alpha '(0.9))
(setq frame-title-format
      (format "%%f - %s@%s" (user-login-name) (system-name)))

;;; ------------------------------------------------------------
;;; Modeline
;;; ------------------------------------------------------------
(line-number-mode t)
(column-number-mode t)

;;; ------------------------------------------------------------
;;; Buffer
;;; ------------------------------------------------------------
(defconst tab-width 2)

(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(fringe-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)

(global-linum-mode t)
;;(setq linum-format "%4d ")
(setq linum-format "%4i ")
(global-set-key [f12]   'linum-mode)

(global-font-lock-mode t)
(setq transient-mark-mode 1)

(setq default-truncate-lines t)
(setq truncate-lines t)
(setq truncate-partial-width-windows t)

(setq ring-bell-function 'ignore)

(setq kill-whole-line t)

(setq mouse-drag-copy-region t)

(setq-default show-trailing-whitespace t)
(setq require-final-newline t)
(setq next-line-add-newlines nil)
(global-hl-line-mode)

;; Language
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(set-file-name-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(setq default-process-coding-system '(undecided-dos . utf-8-unix))

;; Locale
(setq system-time-locale "C")

;; To address characters corruption
(set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
                      'katakana-jisx0201 'iso-8859-1 'cp1252 'unicode)
(set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)

;; Theme
;; https://github.com/owainlewis/emacs-color-themes
;; (load-theme 'dichromacy t)
;;(load-theme 'spolsky t)
(load-theme 'odersky t)
(set-face-attribute 'linum nil
                    :foreground "#E0E4CC"
                    :underline nil)

;; Cursor color
;;(list-colors-display)
;;(setq cursor-type 'box)
;;(set-cursor-color "#bfcddb")
;;(set-face-background 'region "pale turquoise")
;;(set-face-background 'region "light blue")

;; http://www.emacswiki.org/emacs/UntabifyUponSave
(setq-default indent-tabs-mode nil)
(add-hook 'write-file-hooks
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))
            nil))

;; Drag'n Drop
(define-key global-map [ns-drag-file] 'ns-find-file)
(setq ns-pop-up-frames nil)

;; icomplete
;; (icomplete-mode 1)

;; recentf
(recentf-mode 1)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; undo-tree
;; C-/ : undo, C-Shift-/ or M-/ : redo
(use-package undo-tree
  :config
  (global-undo-tree-mode t)
  (global-set-key (kbd "M-/") 'undo-tree-redo))

;; for rectangular selection
;; (cua-mode t)
;; (setq cua-enable-cua-keys nil)

;; C-w behavior
(defun backward-kill-word-or-kill-region ()
  (interactive)
  (if mark-active
      (kill-region (point) (mark))
    (backward-kill-word 1)))
(global-set-key (kbd "C-w") 'backward-kill-word-or-kill-region)

;; C-. insert-date
(defun insert-date ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d(%a)")))
(global-set-key (kbd "C-.") 'insert-date)

;; swap-screen-with-cursor
;; http://www49.atwiki.jp/ntemacs/pages/1.html
(defun swap-screen-with-cursor()
  "Swap two screen,with cursor in same buffer."
  (interactive)
  (let ((thiswin (selected-window))
        (thisbuf (window-buffer)))
    (other-window 1)
    (set-window-buffer thiswin (window-buffer))
    (set-window-buffer (selected-window) thisbuf)))
(global-set-key (kbd "M-t") 'swap-screen-with-cursor)

;; Browse URL at (point)
;; http://tototoshi.hatenablog.com/entry/20100630/1277897703
(defun browse-url-at-point ()
  (interactive)
  (let ((url-region (bounds-of-thing-at-point 'url)))
    (when url-region
      (browse-url (buffer-substring-no-properties (car url-region)
              (cdr url-region))))))
(global-set-key (kbd "C-c C-o") 'browse-url-at-point)

(defun kill-other-buffers ()
  "Kill buffers except current-buffer and *scratch* ."
  (interactive)
  (let* ((buffers-to-kill
          (set-difference (buffer-list)
                          (list (current-buffer) (get-buffer "*scratch*")))))
    (mapc 'kill-buffer buffers-to-kill)))

;; http://www.clear-code.com/blog/2011/2/16.html
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Backup
(setq auto-save-default nil)
(setq make-backup-files nil)

;;; ------------------------------------------------------------
;;; Key Bindings
;;; ------------------------------------------------------------

;; http://steve.yegge.googlepages.com/effective-emacs
;; http://d.hatena.ne.jp/goinger/20070709/1183997129
(define-key global-map [?¥] "\\") ; http://lists.sourceforge.jp/mailman/archives/macemacsjp-users/2006-June/001125.html
(global-set-key (kbd "C-]") 'redo)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-^") 'enlarge-window)
(global-set-key (kbd "C-c C-e") 'call-last-kbd-macro)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-c C-n") 'execute-extended-command)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x C-h") 'mark-whole-buffer)
(global-set-key (kbd "C-x C-i") 'indent-region)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-x C-n") 'execute-extended-command)
(global-set-key (kbd "C-x l") 'goto-line)
(global-set-key (kbd "M-k") (lambda () (interactive) (kill-buffer (buffer-name))))
(global-set-key (kbd "M-<return>") 'toggle-truncate-lines)

;; font-size control
(global-set-key (kbd "C-+") '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C--") '(lambda() (interactive) (text-scale-decrease 1)))
(global-set-key (kbd "C-0") '(lambda() (interactive) (text-scale-set 0)))

;; aliases
(defalias 'cr 'comment-region)
(defalias 'ur 'uncomment-region)
(defalias 'df 'describe-function)
(defalias 'fd 'find-dired)
(defalias 'gf 'grep-find)
(defalias 'qr 'query-replace)
(defalias 'rr 'replace-regexp)
(defalias 'rs 'replace-string)
(defalias 'ini (lambda () (interactive) (find-file "~/.emacs.d/init.el")))


;;; ------------------------------------------------------------
;;; Major Mode
;;; ------------------------------------------------------------
;; ruby
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rb$latex " . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))

;; http://blog.livedoor.jp/ooboofo3/archives/53748087.html
(use-package ruby-end
  :config
  (add-hook 'ruby-mode-hook
            '(lambda ()
               (abbrev-mode 1)
               (electric-pair-mode t)
               (electric-indent-mode t)
               (electric-layout-mode t))))

;;; haskell
;; http://blog.kzfmix.com/entry/1352807844

(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-cabal "haskell-cabal" nil t)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)

(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode))
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))

(add-hook 'haskell-mode-hook 'inf-haskell-mode)

;; ghc-mod
;; https://github.com/kazu-yamamoto/ghc-mod
(add-to-list 'exec-path (concat (getenv "HOME") "/cabal/bin"))
(add-to-list 'load-path (concat (getenv "HOME") "/cabal/x86_64-windows-ghc-7.8.3/ghc-mod-5.2.1.2"))
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))
;; (add-to-list 'ac-sources 'ac-source-ghc-mod)

;;; org
(use-package org
  :disabled t
  :config
  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)")))
  ;; (setq org-log-done 'time)

  ;; To display day-of-week in Common format like, Mon, Tsu, ...
  (setq system-time-locale "C")
  (custom-set-variables
   '(org-display-custom-times t)
   '(org-time-stamp-custom-formats (quote ("<%Y-%m-%d (%a)>" . "<%Y-%m-%d (%a) %H:%M>")))))

;;; gtd (Local Package)
;;; http://www.emacswiki.org/emacs/OutlineMinorMode
;;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Outline-Visibility.html#Outline-Visibility
(use-package gtd-mode
  :commands (gtd-mode)
  :mode (("\\.gtd\\'" . gtd-mode)
         ("\\.todo\\'" . gtd-mode)
         ("\\.todo.log\\'" . gtd-log-mode)
         ("\\.gtd.log\\'" . gtd-log-mode)))

;;; auto-complete
;; http://keisanbutsuriya.hateblo.jp/entry/2015/02/08/175005
(use-package auto-complete-config
  :config
  (ac-config-default)
  (add-to-list 'ac-modes 'text-mode)
  (add-to-list 'ac-modes 'fundamental-mode)
  (add-to-list 'ac-modes 'org-mode)
  (ac-set-trigger-key "TAB")
  (setq ac-use-menu-map t))

;;; helm
;; https://monolog.linkode.co.jp/articles/kotoh/Emacs%E3%81%A7helm%E3%82%92%E4%BD%BF%E3%81%86
(use-package helm-config
  :config
  (helm-mode 1)

  (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))

  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

  (defvar helm-source-emacs-commands
    (helm-build-sync-source "Emacs commands"
      :candidates (lambda ()
                    (let ((cmds))
                      (mapatoms
                       (lambda (elt) (when (commandp elt) (push elt cmds))))
                      cmds))
      :coerce #'intern-soft
      :action #'command-execute)
    "A simple helm source for Emacs commands.")

  (defvar helm-source-emacs-commands-history
    (helm-build-sync-source "Emacs commands history"
      :candidates (lambda ()
                    (let ((cmds))
                      (dolist (elem extended-command-history)
                        (push (intern elem) cmds))
                      cmds))
      :coerce #'intern-soft
      :action #'command-execute)
    "Emacs commands history")

  (custom-set-variables
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-recentf
                                 helm-source-files-in-current-dir
                                 helm-source-emacs-commands-history
                                 helm-source-emacs-commands
                                 )))

  (define-key global-map (kbd "C-;") 'helm-mini)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring))

;; migemo
;; http://grugrut.hatenablog.jp/entry/2015/04/emacs-migemo-on-windows
;; http://www.kaoriya.net/software/cmigemo/
(use-package migemo
  :config
  (setq migemo-dictionary "C:/Root/Apps/cmigemo-default-win64/dict/utf-8/migemo-dict")
  (setq migemo-command "C:/Root/Apps/cmigemo-default-win64/cmigemo")
  (setq migemo-options '("-q" "--emacs" "-i" "\a"))
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
;;  (load-library "migemo")
  (migemo-init))


;;; ------------------------------------------------------------
;;; OS
;;; ------------------------------------------------------------
;; Windows
;; http://cha.la.coocan.jp/doc/NTEmacs.html#sec5

;; *** Before running Emacs ***
;; You should set environment variable [HOME] (ex C:\Users\yourname),
;; make the shortcut somewhere and right click it and edit the working directory (ex %HOME%)

(when (equal system-type 'windows-nt)
  ;; Font
  (set-face-font 'default "Migu 1M-11")
  (set-face-font 'variable-pitch "Migu 1M-11")
  (set-face-font 'fixed-pitch "Migu 1M-11")
  (set-face-font 'tooltip "Migu 1M-9")

  ;; Language
  (setq file-name-coding-system 'shift_jis)

  ;; w32-symlinks.el
  (custom-set-variables '(w32-symlinks-handle-shortcuts t))
  (require 'w32-symlinks)
  (defadvice insert-file-contents-literally (before insert-file-contents-literally-before activate)
    (set-buffer-multibyte nil))
  (defadvice minibuffer-complete (before expand-symlinks activate)
    (let ((file (expand-file-name
                 (buffer-substring-no-properties
                  (line-beginning-position) (line-end-position)))))
      (when (file-symlink-p file)
        (delete-region (line-beginning-position) (line-end-position))
        (insert (w32-symlinks-parse-symlink file)))))

  ;; Enable Japanese input on mini-buffer
  ;; http://sanrinsha.lolipop.jp/blog/2010/07/emacs-1.html#isearch
  (defun w32-isearch-update ()
    (interactive)
    (isearch-update))
  (define-key isearch-mode-map [compend] 'w32-isearch-update)
  (define-key isearch-mode-map [kanji] 'isearch-toggle-input-method)
  (add-hook 'isearch-mode-hook
            (lambda () (setq w32-ime-composition-window (minibuffer-window))))
  (add-hook 'isearch-mode-end-hook
            (lambda () (setq w32-ime-composition-window nil)))

  ;; Cygwin
  ;; http://www.emacswiki.org/emacs/NTEmacsWithCygwin

  ;; Sets your shell to use cygwin's bash, if Emacs finds it's running
  ;; under Windows and c:\cygwin exists. Assumes that C:\cygwin\bin is
  ;; not already in your Windows Path (it generally should not be).
  ;;
  (let* ((cygwin-root "c:/cygwin64")
         (cygwin-bin (concat cygwin-root "/bin")))
    (when (and (eq 'windows-nt system-type)
               (file-readable-p cygwin-root))
      (setq exec-path (cons cygwin-bin exec-path))

      (setenv "PATH" (concat cygwin-bin ";" (getenv "PATH")))
      ;; By default use the Windows HOME.
      ;; Otherwise, uncomment below to set a HOME
      ;;      (setenv "HOME" (concat cygwin-root "/home/eric"))

      ;; NT-emacs assumes a Windows shell. Change to bash.
      (setq shell-file-name "zsh")
      (setenv "SHELL" shell-file-name)
      (setq explicit-shell-file-name shell-file-name)

      ;; This removes unsightly ^M characters that would otherwise
      ;; appear in the output of java applications.
      (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)))

  ;; Open files with associated application
  ;; http://d.hatena.ne.jp/j-kyoda/20110128
  (defun file-file-by-app-assoc ()
    "open file."
    (interactive)
    (let ((file (dired-get-filename)))
      (message "Opening %s..." file)
      (call-process "cmd.exe" nil 0 nil "/c" "start" ""
                    (to-dos-filename file))
      (recentf-add-file file)
      (message "Opening %s...done" file))
    )

  (defun to-dos-filename (s)
    (encode-coding-string
     (concat (mapcar '(lambda (x) (if(= x ?/) ?\\ x)) (string-to-list s)))
     'sjis))

  (add-hook 'dired-mode-hook
            (lambda ()
              (define-key dired-mode-map "z" 'file-file-by-app-assoc)))
  ) ; end-of (when (equal system-type 'windows-nt)

;;; MacOS
(when (equal system-type 'darwin)
  ;; Command-Key and Option-Key
  (setq ns-command-modifier (quote meta))
  (setq ns-alternate-modifier (quote super))

  (set-frame-font "fontset-bitstreammarugo")
  (set-fontset-font (frame-parameter nil 'font)
                    'unicode
                    (font-spec :family "Hiragino Maru Gothic ProN" :size 12)
                    nil
                    'append))

;;; ------------------------------------------------------------
;;; Others
;;; ------------------------------------------------------------

;; stext-mode
(define-derived-mode stext-mode text-mode "STEXT" "Symbol sensitive text mode"
  (setq font-lock-defaults '((("#.*$" . font-lock-type-face)
                              ("*.*$" . font-lock-warning-face)))))
(add-to-list 'auto-mode-alist '("\\.txt" . stext-mode))

;; Cygwin
;; http://www.emacswiki.org/emacs/setup-cygwin.el
;; http://www.emacswiki.org/emacs/cygwin-mount.el
;; (use-package setup-cygwin)

;; Server
;; (require 'server)
;; (unless (server-running-p)
;;  (server-start))
