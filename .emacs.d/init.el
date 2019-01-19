;; Set up package management
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Set up use package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

;; disable the title bar text
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; Ask "y" or "n" instead of "yes" or "no"
(fset 'yes-or-no-p 'y-or-n-p)

(set-default-font "Courier 15" nil t)
;; get rid of right fringe
(set-face-attribute 'fringe nil :background nil)

;; Change startup window size
(add-to-list 'default-frame-alist '(width . 100)) ; characters
(add-to-list 'default-frame-alist '(height . 45)) ; lines

;; Highlight corresponding parentheses when cursor is on one
(show-paren-mode t)

;; prevents line wrapping
(set-default 'truncate-lines t)

(save-place-mode 1)

(global-auto-revert-mode t)

(setq initial-major-mode 'fundamental-mode)

;; Turn off starting message
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)

;; Remove all backup files
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq auto-save-default nil)

;; Enable line numbers and col numbers
(global-linum-mode +1)
; (setq linum-format "%1d \u2502")
(setq column-number-mode t)

;; Isearch convenience, space matches anything (non-greedy)
(setq search-whitespace-regexp ".*?")

;; Disable interface
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
;; Remove initial scratch message
(setq initial-scratch-message "")

;; spaces not tabs
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 4 200 4))

;; Set max columns to 80
(setq-default fill-column 80)

;; Disable alarm sound
(setq ring-bell-function 'ignore)

;; Deletes selected region
(delete-selection-mode 1)

(hl-line-mode 1)

;; Make all file names unique
(require 'uniquify)

;; Electric Pair mode
(electric-pair-mode 1)

(defun smart-line-beginning ()
  "Move point to the beginning of text on the current line; if that is already
the current position of point, then move it to the beginning of the line."
  (interactive)
  (let ((pt (point)))
    (beginning-of-line-text)
    (when (eq pt (point))
      (beginning-of-line))))

;; Make org mode source code syntax highlighted
(setq org-src-fontify-natively t)
(setq org-startup-indented t)
(setq org-hide-leading-stars t)

;; MODE LINE
(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-modified
                " "
                default-directory
                mode-line-buffer-identification
                " "
                mode-line-position
                (vc-mode vc-mode)
                (flycheck-mode flycheck-mode-line)
                " "
                mode-line-misc-info
                mode-line-end-spaces))


;; KEYBINDINGS
(global-set-key (kbd "C-u") 'undo)
(global-unset-key (kbd "C-x u"))
(global-set-key (kbd "C-a") 'smart-line-beginning)
(global-set-key (kbd "s-w") 'kill-ring-save)
(global-set-key (kbd "s-i") 'dabbrev-expand)
(global-set-key (kbd "M-i") 'dabbrev-expand)
(global-set-key (kbd "s-f") 'forward-word)
(global-set-key (kbd "s-b") 'backward-word)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-x C-k") 'kill-buffer-and-window)

;; PACKAGES

(use-package base16-theme
  :if window-system
  :config
  (load-theme 'base16-default-dark t))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

(use-package which-key
  :config
  (which-key-mode))

(use-package expand-region
  :bind ("C-j" . er/expand-region)
  :init
  (add-hook 'org-mode-hook (lambda ()
                             (define-key org-mode-map "\C-j" 'er/expand-region)))
  :config
  (setq shift-select-mode nil))

(use-package counsel
  :demand
  :bind (("C-;" . counsel-imenu)
         ("C-c s" . swiper)
         ("C-c C-s" . swiper)
         ("C-c f" . counsel-rg)
         ("C-c o" . counsel-git)
         ("M-x" . counsel-M-x)
         ("s-x" . counsel-M-x)
         ("C-x b" . ivy-switch-buffer)
         ("C-x C-f" . counsel-find-file)
         ("C-c r" . counsel-recentf)
         (:map counsel-find-file-map
               ("RET" . ivy-alt-done)
               ("C-j" . ivy-immediate-done))
         ;; (:map org-mode-map
         ;;       ("C-s" . swiper))
         )
  :config
  (ivy-mode 1)
  (add-hook 'org-mode-hook
  (lambda ()
    (define-key org-mode-map "\C-s" 'swiper)))
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-extra-directories nil)
  (setq ivy-sort-matches-functions-alist
      '((t)
        (counsel-find-file . ivy--sort-files-by-date))))

(use-package company
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("C-n" . company-select-next-or-abort)
              ("C-p" . company-select-previous-or-abort))
  :config
  (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf
           company-dabbrev)
          ))
  (setq company-idle-delay 0.2))


;; (use-package flycheck
;;   :hook ((c-mode . flycheck-mode)
;;          (c++-mode . flycheck-mode)
;;          (python-mode . flycheck-mode)))

;; (use-package pipenv
;;   :hook (python-mode . pipenv-mode))


;; (use-package lsp-mode
;;   :bind (("C-c h" . lsp-describe-thing-at-point))
;;   :config
;;   (setq create-lockfiles nil)
;;   (setq lsp-enable-eldoc nil)
;;   (setq lsp-highlight-symbol-at-point nil)
;;   ;; make sure we have lsp-imenu everywhere we have LSP
;;   (require 'lsp-imenu)
;;   (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
;;   (setq lsp-message-project-root-warning t))

;; (use-package lsp-python
;;   :hook (python-mode . lsp-python-enable))

;; (use-package lsp-ui
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :config
;;   ;; (setq lsp-ui-flycheck-live-reporting nil)
;;   (setq lsp-ui-sideline-ignore-duplicate t)
;;   (setq lsp-ui-sideline-enable nil)
;;   (setq lsp-ui-sideline-show-hover nil)
;;   (setq lsp-ui-sideline-show-symbol nil)
;;   (setq lsp-ui-peek-enable nil)
;;   (setq lsp-ui-doc-enable nil))

;; (use-package company-lsp
;;   :after lsp-mode company
;;   :config
;;   (push 'company-lsp company-backends))

;; (defun cquery//enable ()
;;   (condition-case nil
;;       (lsp-cquery-enable)
;;     (user-error nil)))

;;   (use-package cquery
;;     :commands lsp-cquery-enable
;;     :init (add-hook 'c-mode-hook #'cquery//enable)
;;           (add-hook 'c++-mode-hook #'cquery//enable)
;;   :config
;;   (setq cquery-executable "/usr/local/bin/cquery"))

(use-package crux
  :bind
  (("C-c I" . crux-find-user-init-file)
   ("C-c D" . crux-delete-file-and-buffer)
   ("C-c R" . crux-rename-file-and-buffer)
   ("C-c t" . crux-visit-term-buffer)
   ("C-c C" . crux-copy-file-preserve-attributes)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-box-enable-icon nil)
 '(lsp-ui-sideline-enable nil)
 '(package-selected-packages
   (quote
    (crux cquery lsp-python company-lsp lsp-ui pipenv spaceline company-box eglot company dashboard counsel-etags undo-tree smex which-key use-package ido-vertical-mode ido-completing-read+ flx-ido expand-region exec-path-from-shell esup counsel base16-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-box-candidate ((t (:foreground "white")))))
