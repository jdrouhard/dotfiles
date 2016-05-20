(setq c-c++-ide-packages
      '(
        cc-mode
        cmake-ide
        cmake-mode
        company
        irony
        company-irony
        company-irony-c-headers
        irony-eldoc
        flycheck
        flycheck-irony
        rtags
        xcscope
        helm-cscope
        gdb-mi
        ))

(defun c-c++-ide/init-cc-mode ()
  (use-package cc-mode
    :defer t
    :init
    (add-to-list 'auto-mode-alist `("\\.h$" . c++-mode))
    :config
    (progn
      (require 'compile)
      (c-toggle-auto-newline 1)
      (spacemacs/set-leader-keys-for-major-mode 'c-mode
        "ga" 'projectile-find-other-file
        "gA" 'projectile-find-other-file-other-window)
      (spacemacs/set-leader-keys-for-major-mode 'c++-mode
        "ga" 'projectile-find-other-file
        "gA" 'projectile-find-other-file-other-window))))

(defun c-c++-ide/init-cmake-ide ()
  (cmake-ide-setup))

(defun c-c++-ide/init-cmake-mode ()
  (use-package cmake-mode
    :mode (("CMakeLists\\.txt\\'" . cmake-mode) ("\\.cmake\\'" . cmake-mode))
    :init (push 'company-cmake company-backends-cmake-mode)))

(defun c-c++-ide/post-init-company ()
  (spacemacs|add-company-hook c-mode-common)
  (spacemacs|add-company-hook cmake-mode))

  ;; (setq company-backends (delete 'company-semantic company-backends))
  ;; (add-to-list 'company-backends '(company-irony-c-headers company-irony)))

(defun c-c++-ide/init-irony ()
  (use-package irony
    :defer t
    :commands (irony-mode irony-install-server)
    :init
    (progn
      (add-hook 'c-mode-hook 'irony-mode)
      (add-hook 'c++-mode-hook 'irony-mode))
    :config
    (progn
      ;; (setq irony-user-dir (f-slash (f-join user-home-directory ".irony" "irony")))
      ;; (setq irony-server-install-prefix irony-user-dir)
      (add-hook 'c-mode-hook (lambda () (setq irony-additional-clang-options '("-std=c++11"))))
      (add-hook 'c++-mode-hook (lambda () (setq irony-additional-clang-options '("-std=c++11"))))
      (defun irony/irony-mode-hook ()
        (define-key irony-mode-map [remap completion-at-point] 'irony-completion-at-point-async)
        (define-key irony-mode-map [remap complete-symbol] 'irony-completion-at-point-async))

      (add-hook 'irony-mode-hook 'irony/irony-mode-hook)
      (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))))

(when (configuration-layer/layer-usedp 'auto-completion)
  (defun c-c++-ide/init-company-irony ()
    (use-package company-irony
      :if (configuration-layer/package-usedp 'company)
      :commands (company-irony)
      :defer t
      :init
      (progn
        (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
        (push 'company-irony company-backends-c-mode-common)))))

(when (configuration-layer/layer-usedp 'auto-completion)
  (defun c-c++-ide/init-company-irony-c-headers ()
    (use-package company-irony-c-headers
      :if (configuration-layer/package-usedp 'company)
      :defer t
      :commands (company-irony-c-headers)
      :init
      (push 'company-irony-c-headers company-backends-c-mode-common))))

(defun c-c++-ide/init-irony-eldoc ()
  (use-package irony-eldoc
    :commands (irony-eldoc)
    :init
    (add-hook 'irony-mode-hook 'irony-eldoc)))

(defun c-c++-ide/post-init-flycheck ()
  (dolist (hook '(c-mode-hook c++-mode-hook))
    (spacemacs/add-flycheck-hook hook)))

(defun c-c++-ide/init-gdb-mi ()
  (use-package gdb-mi
    :defer t
    :init
    (setq
     ;; use gdb-many-windows by default when `M-x gdb'
     gdb-many-windows t
     ;; Non-nil means display source file containing the main routine at startup
     gdb-show-main t)))

;; (when (configuration-layer/layer-usedp 'syntax-checking)
;;   (defun c-c++-ide/init-flycheck-irony ()
;;     (use-package flycheck-irony
;;       :if (configuration-layer/package-usedp 'flycheck)
;;       :defer t
;;       :init (add-hook 'irony-mode-hook 'flycheck-irony-setup))))

(defun c-c++-ide/init-rtags ()
  (use-package rtags
    :defer t
    :init (setq rtags-use-helm t)
    :config
    (progn
      (rtags-enable-standard-keybindings)
      (dolist (mode '(c-mode c++-mode))
        (spacemacs/set-leader-keys-for-major-mode mode
          "g," 'rtags-find-references-at-point
          "g." 'rtags-find-symbol-at-point
          "g/" 'rtags-find-all-references-at-point
          "g;" 'rtags-find-file
          "g<" 'rtags-find-references
          "g>" 'rtags-find-symbol
          "g[" 'rtags-location-stack-back
          "g]" 'rtags-location-stack-forward
          "gB" 'rtags-show-rtags-buffer
          "gD" 'rtags-diagnostics
          "gE" 'rtags-preprocess-file
          "gF" 'rtags-fixit
          "gG" 'rtags-guess-function-at-point
          "gI" 'rtags-imenu
          "gK" 'rtags-make-member
          "gL" 'rtags-copy-and-print-current-location
          "gM" 'rtags-symbol-info
          "gO" 'rtags-goto-offset
          "gP" 'rtags-dependency-tree-all
          "gR" 'rtags-rename-symbol
          "gS" 'rtags-display-summary
          "gT" 'rtags-taglist
          "gV" 'rtags-print-enum-value-at-point
          "gX" 'rtags-fix-fixit-at-point
          "gY" 'rtags-cycle-overlays-on-screen
          "ga" 'rtags-print-source-arguments
          "ge" 'rtags-reparse-file
          "gh" 'rtags-print-class-hierarchy
          "gl" 'rtags-list-results
          "gp" 'rtags-dependency-tree
          "gv" 'rtags-find-virtuals-at-point))))

  (when (configuration-layer/layer-usedp 'syntax-checking)
    (use-package flycheck-rtags
      :if (configuration-layer/package-usedp 'flycheck)
      :defer t
      :init
      (progn
        (setq
          rtags-autostart-diagnostics t
          flycheck-disabled-checkers '(c/c++-clang c/c++-gcc)
          )

        (defun setup-flycheck-rtags ()
          (require 'flycheck-rtags)
          (flycheck-select-checker 'rtags)
          (setq-local flycheck-highlighting-mode nil)
          (setq-local flycheck-check-syntax-automatically nil))

        (dolist (hook '(c-mode-hook c++-mode-hook))
          (add-hook hook 'setup-flycheck-rtags))))))

  ;; (when (configuration-layer/layer-usedp 'auto-completion)
  ;;   (use-package company-rtags
  ;;     :if (configuration-layer/package-usedp 'company)
  ;;     :commands (company-rtags)
  ;;     :defer t
  ;;     :init
  ;;     (progn
  ;;       (push 'company-rtags company-backends-c-mode-common)
  ;;       (add-hook 'c-mode-common-hook (lambda () (company-mode)))
  ;;       (setq
  ;;         company-rtags-begin-after-member-access t
  ;;         rtags-autostart-diagnostics t
  ;;         rtags-completions-enabled t
  ;;         ;; company-backends (delete 'company-clang company-backends)
  ;;         )

(defun c-c++-ide/pre-init-xcscope ()
  (spacemacs|use-package-add-hook xcscope
    :post-init
    (dolist (mode '(c-mode c++-mode))
      (spacemacs/set-leader-keys-for-major-mode mode "gi" 'cscope-index-files))))

(when (configuration-layer/layer-usedp 'spacemacs-helm)
  (defun c-c++-ide/pre-init-helm-cscope ()
    (spacemacs|use-package-add-hook xcscope
      :post-init
      (dolist (mode '(c-mode c++-mode))
        (spacemacs/setup-helm-cscope mode)))))

