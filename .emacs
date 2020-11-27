(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages
   '(fill-column-indicator clang-format sr-speedbar req-package irony-eldoc flycheck-irony flycheck-clang-tidy flycheck-clang-analyzer eglot company-irony company-flx company-c-headers cmake-mode cmake-ide))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; TODO: Define requires, set-up auto install for packages

;; Startup
;; Start sr-speedbar
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq sr-speedbar-default-width 15)
	    (setq sr-speedbar-width 15)
	    (setq sr-speedbar-right-side nil)
	    (sr-speedbar-refresh-turn-off)
	    (sr-speedbar-open)))

;; Visual:
;; No toolbar
(setq tool-bar-mode nil)
;; Trunate lines for CC
(add-hook
 'c-mode-common-hook
 '(lambda ()
    (toggle-truncate-lines 1)
    )
 )
;; Font
(set-frame-font "Hack 10" nil t)

(set-default 'truncate-lines t)

;; Utils:
;; Disable Z suspend
(global-unset-key [(control z)])
(global-unset-key [(control x)(control z)])

;; Save to external folder
(setq auto-save-file-name-transforms
  `((".*" "~/.saves/" t)))

;; Term on f1
(global-set-key [f1] 'eshell)

;; Enable desktop save
(setq desktop-path (list "~/.saves/"))
(desktop-save-mode 1)

;; Packages:
;; Add melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Sr-speedbar
(require 'sr-speedbar)

;; Company global
(add-hook 'after-init-hook 'global-company-mode)

;; Flycheck CC
(add-hook 'after-init-hook 'global-flycheck-mode)

;; Eldoc CC
(add-hook 'c-mode-common-hook 'eldoc-mode)

;; Column indicator globally
(setq fci-rule-column 80)
(define-globalized-minor-mode global-fci-mode fci-mode
  (lambda () (fci-mode 1)))

(add-hook 'after-init-hook 'global-fci-mode)

;; Clang format on save
(add-hook 'c-mode-common-hook
          (function (lambda ()
                    (add-hook 'before-save-hook
                              'clang-format-buffer))))

;; Irony
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; Irony : Flycheck
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; Irony : Eldoc
(add-hook 'irony-mode-hook #'irony-eldoc)

;; Irony : Company
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
