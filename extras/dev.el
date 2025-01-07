;;; Emacs Bedrock
;;;
;;; Extra config: Development tools

;;; Usage: Append or require this file from init.el for some software
;;; development-focused packages.
;;;
;;; It is **STRONGLY** recommended that you use the base.el config if you want to
;;; use Eglot. Lots of completion things will work better.
;;;
;;; This will try to use tree-sitter modes for many languages. Please run
;;;
;;;   M-x treesit-install-language-grammar
;;;
;;; Before trying to use a treesit mode.

;;; Contents:
;;;
;;;  - Built-in config for developers
;;;  - Version Control
;;;  - Common file types
;;;  - Eglot, the built-in LSP client for Emacs

;; txb -- not implemented yet, but i use the following languages.

;;(load-file (expand-file-name "extras/fortran.el" user-emacs-directory))
;; txb -- fortran the treesitter parser for fortran will need to be installed
;;        and configured manually/interactively. leaving that as a todo when
;;        i figure out what all needs to be done.

;; txb -- pascal
;;(load-file (expand-file-name "extras/pascal.el" user-emacs-directory))

;; txb -- guile/scheme
;;(load-file (expand-file-name "extras/guile.el" user-emacs-directory))

;; txb -- it's unclear if make/cmake/apheleia should be separated out or
;;        done for each language. same for repls like geiser.

;; txb -- gud? i want to debug from emacs.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in config for developers
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; txb -- i don't do js or webish stuff so i've removed those languages to
;;        keep things simple while i get fortran working.

(use-package emacs
	:config
	;; Treesitter config

	;; Tell Emacs to prefer the treesitter mode
	;; You'll want to run the command `M-x treesit-install-language-grammar' before editing.
	(setq major-mode-remap-alist
      '((yaml-mode . yaml-ts-mode)
          (bash-mode . bash-ts-mode)
          (json-mode . json-ts-mode)
			 (python-mode . python-ts-mode)))
	:hook
	;; Auto parenthesis matching
	((prog-mode . electric-pair-mode)))

;; ;; txb -- this needs to be moved but i'm not sure if it becomes part of the
;; ;;        above or part of the modern fortran block. i'm not sure of the
;; ;;        ts-mode and remap yet.
;; (setq troi-f90-tsauto-config
;;    (make-treesit-auto-recipe
;;       :lang 'f90
;;       :ts-mode 'f90-ts-mode
;; 		:remap '(f90-mode)
;; 		:url "https://github.com/stadelmanma/tree-sitter-fortran"
;;       :revision "master"
;;       :source-dir "src"
;;       :ext "\\.f90\\'"))
;; (add-to-list 'treesit-auto-recipe-list troi-f90-tsauto-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Version Control
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; txb -- yes it probably is but i am still stuck at the command line using
;;        git in a primitive manner. until i'm ready to expand my horizon
;;        gitward, leaving off.

;; Magit: best Git client to ever exist
;; (use-package magit
;;   :ensure t
;;   :bind (("C-x g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Common file types
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; txb -- do i need to do anything to get gfm support here?
(use-package markdown-mode
	:ensure t
   :hook ((markdown-mode . visual-line-mode)))

;; (use-package yaml-mode
;; 	:ensure t)
;; (use-package json-mode
;; 	:ensure t)

;; Emacs ships with a lot of popular programming language modes. If it's not
;; built in, you're almost certain to find a mode for the language you're
;; looking for with a quick Internet search.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Eglot, the built-in LSP client for Emacs
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helpful resources:
;;
;;  - https://www.masteringemacs.org/article/seamlessly-merge-multiple-documentation-sources-eldoc

;; txb -- my doom setup was using lsp-mode and not eglot. i've done some reading
;;        and i think for my usage, eglot is the better answer. we'll go with
;;        eglot. fortls shouldn't care who is calling it.

(use-package eglot

	:ensure t

	;; Configure hooks to automatically turn-on eglot for selected modes
	:hook
	(((python-mode ruby-mode elixir-mode) . eglot))

	:custom
	(eglot-send-changes-idle-time 0.1)
	(eglot-extend-to-xref t)              ; activate Eglot in referenced non-project files

	:config
	;; txb -- off while getting working
	;; (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event

	;; Sometimes you need to tell Eglot where to find the language server
	(add-to-list 'eglot-server-programs '(f90-mode . ("fortls" "--notify_init" "--nthreads=4")))

	;; (add-to-list 'eglot-server-programs
	;;              '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
	)

;;; dev.el ends here
