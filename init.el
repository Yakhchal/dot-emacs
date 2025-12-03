;; -*- lexical-binding: t; -*-
(defun personal/eval-buffer ()
  "One-stop-shop for evaluating elisp quickly for me.
(Badly) implements evaluating the file that an org-mode file tangles into."
  (interactive)
  (cond
   ((or (eq major-mode 'lisp-interaction-mode)
	(eq major-mode 'emacs-lisp-mode))
    (eval-buffer (current-buffer)))
   ((eq major-mode 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (if (re-search-forward ":tangle\s\\(.*\\)" nil t)
	  (load-file (match-string 1))
	(message "This org-mode file does not tangle into anything!"))))
   (else (message "Evaluation failed."))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(use-package emacs
  :ensure t
  :hook ((prog-mode . display-line-numbers-mode)
	 (after-init . (lambda () (dotimes (_ 2) (global-text-scale-adjust 2)))))
  :bind (:map global-map
	      ("M-o" . other-window)
	      ("C-c b" . personal/eval-buffer))
  :custom
  (enable-recursive-minibuffers t)
  (completion-ignore-case t)
  (debug-on-error t)
  (warning-minimum-level :error)
  (disabled-command-function nil)
  (visible-bell t)
  :config
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1)
  (blink-cursor-mode -1)
  (global-hl-line-mode 1)
  (minibuffer-depth-indicate-mode 1))

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox t))

(use-package org-mode
  :defer t
  :hook (org-mode . org-indent-mode)
  :custom
  (org-return-follows-link t)
  (org-startup-with-inline-images t)
  (org-hide-emphasis-markers t)
  (org-startup-folded 'content)
  :config
  ;;; These (especially 'org-format-latex-options') behave weirdly when placed in ':custom'.
  (setopt org-latex-create-formula-image-program 'dvisvgm)
  (setopt org-format-latex-options (plist-put org-format-latex-options :scale 3)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless)))

(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

(use-package consult
  :ensure t
  :bind ((:map global-map ("C-M-s" . consult-line))
	 (:map minibuffer-mode-map ("C-M-s" . consult-history))))

(use-package popper
  :ensure t
  :bind (("C--" . popper-toggle)
	 ("M--" . popper-cycle)
	 ("C-M--" . popper-toggle-type))
  :config
  (popper-mode 1)
  (popper-echo-mode 1))

(use-package vundo
  :ensure t
  :bind ("C-z" . vundo))

(use-package magit
  :ensure t
  :defer t)

(use-package yasnippet
  :ensure t
  :bind (:map yas-minor-mode-map ("TAB" . yas-expand)))
(use-package yasnippet-snippets
  :ensure t)

(use-package eglot
  :hook ((c-mode . eglot-ensure)
	 (eglot-managed-mode . yas-minor-mode))
  :custom
  (eglot-extend-to-xref t)
  (eglot-autoshutdown t))

(use-package corfu
  :ensure t
  :hook ((lisp-mode . corfu-mode)
  	 (eglot-managed-mode . corfu-mode))
  :bind (:map corfu-map ("RET" . nil))
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1))

(use-package sly
  :ensure t
  :defer t
  :hook (sly-mrepl . corfu-mode)
  :bind (:map lisp-mode-map
  	      ("C-c b" . sly-eval-buffer))
  :custom
  (inferior-lisp-program "sbcl"))

(use-package tetris
  :bind (:map tetris-mode-map
	      ("w" . tetris-rotate-prev)
	      ("a" . tetris-move-left)
	      ("s" . tetris-move-down)
	      ("d" . tetris-move-right)
	      ("e" . tetris-move-bottom))
  :defer t)

(use-package snake
  :bind (:map snake-mode-map
	      ("w" . snake-move-up)
	      ("a" . snake-move-left)
	      ("s" . snake-move-down)
	      ("d" . snake-move-right))
  :defer t)

(use-package erc
  :defer t
  :custom
  (erc-nick "yakh"))
