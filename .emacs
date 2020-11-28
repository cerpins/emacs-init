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
   '(package fill-column-indicator clang-format sr-speedbar req-package irony-eldoc flycheck-irony flycheck-clang-tidy flycheck-clang-analyzer eglot company-irony company-flx company-c-headers cmake-mode cmake-ide))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Guarantee initialized packages
(package-initialize)

;; Globals for on-install pkg behavior
(defvar cerps-irony-already-installed (package-installed-p 'irony))

;; Guarantee melpa & use-package
(progn
  (unless (package-installed-p 'package)
    (progn
      (package-install 'package)
      (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)))
      (package-refresh-contents)
      (package-list-packages)
  (unless (package-installed-p 'use-package)
    (progn
      (package-initialize)
      (package-refresh-contents)
      (package-list-packages)
      (package-install 'use-package))))

(progn
  (use-package sr-speedbar
    :ensure t
    :config
    (add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq sr-speedbar-default-width 15)
	    (setq sr-speedbar-width 15)
	    (setq sr-speedbar-right-side nil)
	    (sr-speedbar-refresh-turn-off)
	    (sr-speedbar-open))))
  (use-package irony
    :ensure t
    :config
    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)
    (add-hook 'objc-mode-hook 'irony-mode)
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
    (unless (cerps-irony-already-installed)
      (error "Fresh install detected, do: M-x RET īrony-install-server RET"))
    (use-package company
      :ensure t
      :config
      (setq company-idle-delay 0)
      (setq company-minimum-prefix-length 1)
      (setq company-tooltip-idle-delay 0)
      (use-package company-irony
	:ensure t
	:config
	(add-to-list 'company-backends 'company-irony)))
    (use-package flycheck
      :ensure t
      :config
      (add-hook 'after-init-hook 'global-flycheck-mode)
      (use-package flycheck-irony
	:ensure t
	:config
	(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)))
    (use-package eldoc
      :ensure t
      :config
      (setq eldoc-idle-delay 0)
      (use-package irony-eldoc
	:ensure t
	:config
	(add-hook 'irony-mode-hook #'irony-eldoc)))))

;; END: PACKAGES


;; Startup
;; Start sr-speedbar

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

;; Keys
;; Remove z suspends
(global-unset-key [(control z)])
(global-unset-key [(control x)(control z)])
;; Term on f1
(global-set-key [f1] 'eshell)
;; Tab forward/backward f2 f3, open close f4 f5
(global-set-key [f2] 'tab-bar-switch-to-prev-tab)
(global-set-key [f3] 'tab-bar-switch-to-next-tab)
(global-set-key [f4] 'tab-bar-new-tab)
(global-set-key [f5] 'tab-bar-close-tab)

;; Enable desktop save at specified dir
(desktop-save-mode 1)
(setq desktop-path (list "~/.saves/"))
;; Save backups to external folder
(setq auto-save-file-name-transforms
  `((".*" "~/.saves/" t)))

;; Clang format on save
(add-hook 'c-mode-common-hook
          (function (lambda ()
                    (add-hook 'before-save-hook
                              'clang-format-buffer))))

;; Column indicator globally
(setq display-fill-column-indicator-column 80)
(setq display-fill-column-indicator t)
(add-hook 'c-mode-common-hook 'display-fill-column-indicator-mode)

