;;; packages.el --- rls layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author:  <iovxw@outlook.com>
;; URL: https://github.com/iovxw/spacemacs-rls
;;
;; This file is not part of GNU Emacs.
;;
;;; License: UNLICENSE

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `rls-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `rls/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `rls/pre-init-PACKAGE' and/or
;;   `rls/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst rls-packages
  '(
    company
    rust-mode
    toml-mode
    eglot
    )
  "The list of Lisp packages required by the rls layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun rls/init-eglot ()
  (use-package eglot
    :commands eglot-ensure
    :init
    (progn
      (add-hook 'rust-mode-hook 'eglot-ensure)
      (spacemacs/set-leader-keys-for-major-mode 'rust-mode
        "r" 'eglot-rename
        "h" 'eglot-help-at-point
        "g" 'xref-find-definitions
        "f" 'xref-find-references)
      ;; for spacemacs/jump-to-definition and `gd` `gD`
      ;; (add-to-list 'spacemacs-jump-handlers-rust-mode 'xref-find-definitions)
      ;; (spacemacs/declare-prefix-for-mode 'rust-mode "mg" "goto")
      )))

(defun rls/init-rust-mode ()
  (use-package rust-mode
    :defer t
    :init
    (progn
      (spacemacs/set-leader-keys-for-major-mode 'rust-mode
        "=" 'rust-format-buffer))))

(defun rls/init-toml-mode ()
  (use-package toml-mode
    :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'"))

(defun rls/post-init-company ()
  (spacemacs|add-company-backends
    :backends company-capf
    :modes rust-mode
    :variables company-tooltip-align-annotations t))

;;; packages.el ends here
