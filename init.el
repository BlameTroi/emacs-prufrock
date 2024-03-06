;;;  ________                                                _______                 __                            __
;;; /        |                                              /       \               /  |                          /  |
;;; $$$$$$$$/ _____  ____   ______   _______  _______       $$$$$$$  | ______   ____$$ | ______   ______   _______$$ |   __
;;; $$ |__   /     \/    \ /      \ /       |/       |      $$ |__$$ |/      \ /    $$ |/      \ /      \ /       $$ |  /  |
;;; $$    |  $$$$$$ $$$$  |$$$$$$  /$$$$$$$//$$$$$$$/       $$    $$</$$$$$$  /$$$$$$$ /$$$$$$  /$$$$$$  /$$$$$$$/$$ |_/$$/
;;; $$$$$/   $$ | $$ | $$ |/    $$ $$ |     $$      \       $$$$$$$  $$    $$ $$ |  $$ $$ |  $$/$$ |  $$ $$ |     $$   $$<
;;; $$ |_____$$ | $$ | $$ /$$$$$$$ $$ \_____ $$$$$$  |      $$ |__$$ $$$$$$$$/$$ \__$$ $$ |     $$ \__$$ $$ \_____$$$$$$  \
;;; $$       $$ | $$ | $$ $$    $$ $$       /     $$/       $$    $$/$$       $$    $$ $$ |     $$    $$/$$       $$ | $$  |
;;; $$$$$$$$/$$/  $$/  $$/ $$$$$$$/ $$$$$$$/$$$$$$$/        $$$$$$$/  $$$$$$$/ $$$$$$$/$$/       $$$$$$/  $$$$$$$/$$/   $$/

;;; Minimal init.el

;;; Contents:
;;;
;;;  - Basic settings
;;;  - Discovery aids
;;;  - Minibuffer/completion settings
;;;  - Interface enhancements/defaults
;;;  - (txb) MacBook Trackpad and Mouse configuration
;;;  - Tab-bar configuration
;;;  - Theme
;;;  - Optional extras
;;;  - Built-in customization framework

;;; Guardrail

(when (< emacs-major-version 29)
  (error (format "Emacs Bedrock only works with Emacs 29 and newer; you have version ~a" emacs-major-version)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Package initialization
;;
;; We'll stick to the built-in GNU and non-GNU ELPAs (Emacs Lisp Package
;; Archive) for the base install, but there are some other ELPAs you could look
;; at if you want more packages. MELPA in particular is very popular. See
;; instructions at:
;;
;;    https://melpa.org/#/getting-started
;;
;; You can simply uncomment the following if you'd like to get started with
;; MELPA packages quickly:
;;
;; txb -- changed from melpa to melpa stable, and set priorities to favor
;;        gnu first and melpa-stable last.
(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
  (setq package-archive-priorities
	'(("gnu" . 10) ("nongnu" . 9) ("melpa-stable" . 8))))

;; txb -- maintain a sense of identity and authenticity
(setopt user-full-name "Troy Brumley")
(setopt user-mail-address "BlameTroi@gmail.com")
(setopt auth-sources '("~/.authinfo.gpg"))
(setopt auth-source-cache-expiry nil)

;; txb -- i had these options in prior configs and am pulling them forward
;;        after review.
(setopt package-native-compile t)
(setopt use-package-always-ensure t)

;; If you want to turn off the welcome screen, uncomment this
(setopt inhibit-splash-screen t)

(setopt initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
(setopt display-time-default-load-average nil) ; this information is useless for most

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Some systems don't do file notifications well; see
;; https://todo.sr.ht/~ashton314/emacs-bedrock/11
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Save history of minibuffer
(savehist-mode)

;; Move through windows with Ctrl-<arrow keys>
;; txb -- mac uses control arrow to switch desktops
;(windmove-default-keybindings 'control) ; You can use other modifiers here

;; Fix archaic defaults
(setopt sentence-end-double-space nil)

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.emacs.d/backup or wherever
;; txb -- using my old backup directories
(defun bedrock--backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* ((backupRootDir "~/.tmp/emacs-backup/")
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path
         (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'bedrock--backup-file-name)

;; txb -- use the trashcan if available
(setopt delete-by-moving-to-trash t)

;; txb -- i prefer to move to the help window when it opens
;;        and allow 'q' to close it.
(setopt help-window-select t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Discovery aids
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the help buffer after startup
(add-hook 'after-init-hook 'help-quick)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Minibuffer/completion settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For help, see: https://www.masteringemacs.org/article/understanding-minibuffer-completion

(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

(setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
(setopt completions-max-height 20)                     ; This is arbitrary
(setopt completions-detailed t)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)            ; Much more eager
;(setopt completion-auto-select t)                     ; See `C-h v completion-auto-select' for more possible values

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

;; For a fancier built-in completion option, try ido-mode,
;; icomplete-vertical, or fido-mode. See also the file extras/base.el

;(icomplete-vertical-mode)
;(fido-vertical-mode)
;(setopt icomplete-delay-completions-threshold 4000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Interface enhancements/defaults
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consistent

(setopt show-trailing-whitespace nil)      ; By default, don't underline trailing spaces
(setopt indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin

;; Enable horizontal scrolling
;; txb -- nope, not for me. i brush my touchpad too frequently so i turn all these
;;        touchy-feely things off.
;(setopt mouse-wheel-tilt-scroll t)
;(setopt mouse-wheel-flip-direction t)

;; We won't set these, but they're good to know about
;;
;; (setopt indent-tabs-mode nil)
;; (setopt tab-width 4)

;; txb -- i do set defaults here for these and more.
;;        my idea of rational indenting and spacing follows. i
;;        had been using 2, but on wide screens i find 3 more
;;        agreeable.
;;
;;        editorconfig will overide some of these at times,
;;        so these are more fallback values.
(setopt indent-tabs-mode nil)
(setopt tab-width 3)
(setopt standard-indent 3)
(setopt mode-require-final-newline t)

;; txb -- i think it's reasonable to put editorconfig in init.el along with
;;        which-key. it is ubiquitous. if the user does not have a config
;;        file, it won't hurt. if he does, then he should know what to
;;        expect.
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; txb -- in programming modes i expect return/enter to re-indent
;;        program text. while markdown actually wants trailing
;;        spaces on some lines, i don't want that in my code.
;;        i've learned about C-j and C-o so i'm not doing the
;;        remap of RET for now.
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))
;;  (add-hook 'prog-mode-hook
;;            (lambda ()
;;              (local-set-key (kbd "RET") 'newline-and-indent)))

;; Misc. UI tweaks
(blink-cursor-mode -1)                                ; Steady cursor
;; txb -- after removing mouse wheel support, leaving pixel-scroll-precision-mode
;;        on caused scroll bar drags to be very painfully slow. commented out and
;;        all is fine.
;(pixel-scroll-precision-mode)                         ; Smooth scrolling
;; txb -- more to my liking.
(setopt scroll-preserve-screen-position t)
(setopt scroll-margin 0)
(setopt scroll-setp 1)
(setopt scroll-conservatively 10000) ;; this in particular works a bit like vim

;; Use common keystrokes by default
;; txb -- nope, if i wanted cua, i'd use soemthing different.
;(cua-mode)

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   MacBook Trackpad and Mouse configuration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; txb -- a rather heavy handed (but working) way to stop the mac touchpad
;;        from moving things on me. i tried to find way to do this as a doom
;;        after! but the double and triple variants kept being active. yes, i
;;        searched the source. no, i couldn't find where that was done.
;;
;;        the customize interface isn't showing me these options in any way
;;        that i understand. the goal here is to prevent my ham handed taps
;;        and brushes of the touchpad from moving stuff around. i have mixed
;;        feelings about drag-the-scrollbar mouse scrolling, but i don't like
;;        the mouse wheel in text editing.
;;
;;        the following worked in doom, hopefully it works well here as well.

(add-to-list
 'emacs-startup-hook
 (lambda ()
   (global-set-key [wheel-up] 'ignore)
   (global-set-key [double-wheel-up] 'ignore)
   (global-set-key [triple-wheel-up] 'ignore)
   (global-set-key [wheel-down] 'ignore)
   (global-set-key [double-wheel-down] 'ignore)
   (global-set-key [triple-wheel-down] 'ignore)
   (global-set-key [wheel-left] 'ignore)
   (global-set-key [double-wheel-left] 'ignore)
   (global-set-key [triple-wheel-left] 'ignore)
   (global-set-key [wheel-right] 'ignore)
   (global-set-key [double-wheel-right] 'ignore)
   (global-set-key [triple-wheel-right] 'ignore)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Tab-bar configuration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the tab-bar as soon as tab-bar functions are invoked
(setopt tab-bar-show 1)

;; Add the time to the tab-bar, if visible
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setopt display-time-format "%a %F %T")
(setopt display-time-interval 1)
(display-time-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(use-package emacs
;  :config
;  (load-theme 'modus-vivendi))          ; for light theme, use modus-operandi
;; txb -- my preferred theme. some things to consider are marking the theme
;;        as safe in customization and remove the t flag, but maybe not. i mean,
;;        really, is one any safer than the other?
(use-package ef-themes
  :config
  (load-theme 'ef-melissa-dark t))
;; txb -- other themes i like include vegetative.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Optional extras
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Uncomment the (load-file …) lines or copy code from the extras/ elisp files
;; as desired

;; txb -- after looking at this i prefer the load-file approach taken here to
;;        updating the load-path and using require/provide. it's more deliberate
;;        and controlled.

;; UI/UX enhancements mostly focused on minibuffer and autocompletion interfaces
;; These ones are *strongly* recommended!
(load-file (expand-file-name "extras/base.el" user-emacs-directory))

;; Packages for software development
;; txb -- packages and configuration for the languages i use will be
;;        added to extras/ and invoked from dev.el as they are done.
;(load-file (expand-file-name "extras/dev.el" user-emacs-directory))

;; txb -- i'm going to resist evil for now
;; Vim-bindings in Emacs (evil-mode configuration)
;(load-file (expand-file-name "extras/vim-like.el" user-emacs-directory))

;; Org-mode configuration
;; WARNING: need to customize things inside the elisp file before use! See
;; the file extras/org-intro.txt for help.
;(load-file (expand-file-name "extras/org.el" user-emacs-directory))

;; Email configuration in Emacs
;; WARNING: needs the `mu' program installed; see the elisp file for more
;; details.
;(load-file (expand-file-name "extras/email.el" user-emacs-directory))

;; Tools for academic researchers
;(load-file (expand-file-name "extras/researcher.el" user-emacs-directory))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in customization framework
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; txb -- isolate customization interface changes into a separate file and load
;;        it at the end of inititalization. this keeps customization changes
;;        out of init.el. custom.el is still under source control so diffs will
;;        be available and hopefully helpful. it is possible (?likely?) that i
;;        will want to pull some things out of custom and script them.
(setopt custom-file (concat user-emacs-directory "custom.el"))
(when (file-readable-p custom-file)
  (load custom-file))
