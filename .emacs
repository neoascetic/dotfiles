(setq custom-file "~/.emacs.d/custom.el")
(setq make-backup-files nil)
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/saves/" t)))

(setq-default fill-column 80)

(menu-bar-mode -1)

(setq linum-format "%d ")
(global-linum-mode)

(setq-default indent-tabs-mode nil)
(setq tab-width 4)

(setq isearch-forward t)
(setq savehist-additional-variables
      '(search-ring regexp-search-ring))
(savehist-mode t)

(setq vc-follow-symlinks t)

(xterm-mouse-mode t)
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

;; copy-paste to the global clipboard
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))
(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq package-selected-packages
      '(highlight-symbol
	rainbow-mode
	editorconfig
	clojure-mode
	git-gutter
	undo-tree
	company
	hl-sexp
	go-mode
        neotree
	paredit
	goto-chg ; evil's dependency
	evil))
(setq package-load-list
      (mapcar (lambda (p) `(,p t))
	      package-selected-packages))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(package-install-selected-packages)

(setq show-paren-when-point-inside-paren t)

(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist `(("." . "~/.emacs.d/undo")))

(add-to-list 'auto-mode-alist '("\\.md\\'" . text-mode))

(global-set-key [f8] 'neotree-toggle)
(add-hook
  'neotree-mode-hook
  (lambda ()
    (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)
    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
    (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
    (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
    (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

(setq evil-want-C-u-scroll t)
(setq evil-ex-substitute-global t)
(setq evil-toggle-key "")
(evil-mode)

;; erlang stuff
(setq erlang-path "/usr/local/lib/erlang") ; TODO: make it work with kerl
(setq load-path (cons (concat erlang-path "/lib/tools-2.11.1/emacs/") load-path))
(setq erlang-root-dir erlang-path)
(setq exec-path (cons (concat erlang-path "/bin") exec-path))
(require 'erlang-start)
(require 'erlang-flymake)

(add-hook 'prog-mode-hook 'editorconfig-mode)
(add-hook 'prog-mode-hook 'global-company-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
(setq highlight-symbol-idle-delay 0.5)

(add-hook 'lisp-mode-hook 'hl-sexp-mode)
(add-hook 'clojure-mode-hook 'hl-sexp-mode)
(add-hook 'emacs-lisp-mode-hook 'hl-sexp-mode)

(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'paredit-mode)
(add-hook
  'paredit-mode-hook
  (lambda ()
    (define-key paredit-mode-map (kbd "ESC <right>") 'paredit-backward-barf-sexp)
    (define-key paredit-mode-map (kbd "ESC <left>") 'paredit-forward-barf-sexp)
    (define-key paredit-mode-map (kbd "M-f") 'paredit-forward-slurp-sexp)
    (define-key paredit-mode-map (kbd "M-b") 'paredit-backward-slurp-sexp)))

;; g-q to refill a region or M-q to refill a paragraph
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook
 'text-mode-hook
 (lambda ()
   (setq default-justification 'full)))

(with-eval-after-load 'evil
  (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance)
  (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat)
  (defalias #'forward-evil-word #'forward-evil-symbol))

;; my-own stupid theme
(let ((fg-gray "#808080")
      (bg-gray "#282828")
      (lg-gray "#2f2f2f")
      (purple  "#ff00ff")
      (yellow  "#ffff00")
      (blue    "#00ffff")
      (warning "#ff0000"))
  (custom-set-faces
    `(default ((t (:foreground ,fg-gray :background ,bg-gray))))
    `(cursor ((t (:background ,fg-gray))))
    `(fringe ((t (:background ,bg-gray))))
    `(linum ((t (:foreground ,fg-gray))))
    `(mode-line ((t (:foreground ,bg-gray :background ,fg-gray))))
    `(region ((t (:background ,lg-gray))))
    `(secondary-selection ((t (:background ,lg-gray))))
    `(font-lock-builtin-face ((t (:foreground ,fg-gray))))
    `(font-lock-comment-face ((t (:foreground ,purple))))
    `(font-lock-function-name-face ((t (:foreground ,fg-gray))))
    `(font-lock-keyword-face ((t (:foreground ,fg-gray))))
    `(font-lock-string-face ((t (:foreground ,yellow))))
    `(font-lock-type-face ((t (:foreground ,fg-gray))))
    `(font-lock-constant-face ((t (:foreground ,blue))))
    `(font-lock-variable-name-face ((t (:foreground ,fg-gray))))
    `(minibuffer-prompt ((t (:foreground ,fg-gray :bold t))))
    `(font-lock-warning-face ((t (:foreground ,warning :bold t))))))

; higlight numbers as constants
(make-face 'font-lock-number-face)
(set-face-attribute 'font-lock-number-face nil :inherit font-lock-constant-face)
(setq font-lock-number-face 'font-lock-number-face)
(defun add-font-lock-number ()
  (font-lock-add-keywords
   nil
   (list
    (list "\\<\\([+-]?[0-9]+\\([eE][+-]?[0-9]*\\)?\\)\\>" 0 font-lock-number-face)
    (list "\\<\\(0[xX][0-9a-fA-F]+\\)\\>" 0 font-lock-number-face))))
(add-hook 'prog-mode-hook 'add-font-lock-number)
