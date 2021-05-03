(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)
(server-start)

(tool-bar-mode -1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq is-mac (equal system-type 'darwin))

;; Initialize use package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(use-package diminish)
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Update packages regularly
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; Sensible startup
(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(setq backup-directory-alist '(("." . "~/.emacs_backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs_autosaves/" t)))
(setq mac-command-modifier 'control)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(set-face-attribute 'default nil :height 160)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(setq-default indent-tabs-mode nil)
(delete-selection-mode 1)
(global-set-key (kbd "M-,") 'pop-tag-mark)
(global-set-key (kbd "M-i") 'imenu)
(defun my-open-new-line ()
  "Replace Emacs' newline with Vim's. Create a new line and move to it."
  (interactive)
  (move-end-of-line ())
  (newline))
(defun my-open-previous-line ()
  "Create a new line above the current one and move to it."
  (interactive)
  (beginning-of-visual-line)
  (newline)
  (previous-line))
(global-set-key (kbd "C-S-o") 'my-open-previous-line)
(global-set-key (kbd "C-o") 'my-open-new-line)
(global-set-key (kbd "M-o") 'other-window)

;; Line wrap
(global-visual-line-mode)
(diminish 'visual-line-mode)

;; Autocomplete brackets
(electric-pair-mode 1)
(show-paren-mode 1)
(setq electric-pair-preserve-balance nil)

;; Org mode
(setq org-todo-keywords
      '((sequence "TODO" "WAITING" "IN PROGRESS" "|" "DONE" "DELEGATED")))

;; Multiple cursors
(use-package multiple-cursors
  :bind
  ("C->" . 'mc/mark-next-like-this)
  ("C-<" . 'mc/mark-previous-like-this)
  ("C-c C-<" . 'mc/mark-all-like-this))

;; Magit
(use-package magit
  :bind ("C-x g" . 'magit-status))

;; Dumb jump
(use-package dumb-jump
  :bind (("C-M-," . dumb-jump-go)
         ("C-M-." . dumb-jump-go-other-window))
  :config
  (dumb-jump-mode))

;; Dired configuration
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

;; Zenburn theme
(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

;; Ivy
(use-package ivy
  :diminish ivy-mode
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-display-style 'fancy)
  :config
  (ivy-mode 1)
  :bind ("C-x b" . 'ivy-switch-buffer))

(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)
        (t . ivy--regex-ignore-order)))

(use-package counsel
  :diminish counsel-mode
  :bind (("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> o" . counsel-describe-symbol)
         ("<f1> l" . counsel-find-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate)
         ("C-S-s" . swiper))
  :config (counsel-mode 1)
  (setq ivy-initial-inputs-alist nil)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

;; Company
(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;; Flycheck config
(defun flycheck-restart ()
  "Restarts flycheck mode."
  (interactive)
  (flycheck-mode)
  (flycheck-mode))

(use-package flycheck
  :diminish flycheck-mode
  :bind (("C-c ! r" . flycheck-restart))
  :init
  (setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages)
  (global-flycheck-mode))

(use-package flycheck-pos-tip
  :after flycheck)

;; C
(setq c-default-style "linux"
      c-basic-offset 2)
(add-hook 'c-mode-hook (lambda() (local-set-key (kbd "C-c o") 'ff-find-other-file)))

;; Rust
(use-package rust-mode
  :init
  (setq rust-format-on-save t)
  :config
  (lambda () (setq indent-tabs-mode nil)))

(use-package cargo
  :hook rust-mode
  :bind (:map rust-mode-map
              ("C-c C-t" . cargo-process-test)
              ("C-c C-b" . cargo-process-build)
              ("C-c C-c" . cargo-process-run)))

(use-package flycheck-rust
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
;  (global-flycheck-inline-mode t))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :init
  (setq projectile-completion-system 'ivy)
  (setq projectile-project-search-path '("~/Dev/"))
  :bind (("M-p" . projectile-command-map))
  :config
  (projectile-mode +1))

;; Which Key
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

;; Haskell

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(package-selected-packages
   '(hackernews haskell-mode nasm-mode flycheck-clojure flycheck-pos-tip company paredit cider flycheck-inline flycheck-rust zenburn-theme which-key projectile cargo rust-mode dumb-jump magit multiple-cursors use-package exec-path-from-shell diminish)))

(use-package haskell-mode
  :hook interactive-haskell-mode)

;; Hackernews

(use-package hackernews
  :config
  (setq hackernews-top-story-limit 40))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
