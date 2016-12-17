;;------------------------------------------------------------------------------
;;
;; My Customizations
;;
;;------------------------------------------------------------------------------

;; For debugging the init file
(setq debug-on-error t)


;;------------------------------------------------------------------------------
;; Increase Font size
;;------------------------------------------------------------------------------
(set-face-attribute 'default nil :height 140)

;;------------------------------------------------------------------------------
;; Remove annoying alarm bell
;;------------------------------------------------------------------------------
;; quiet, please! No dinging!
 (setq ring-bell-function 'ignore)

;;------------------------------------------------------------------------------
;; Reopen buffers from last session
;;------------------------------------------------------------------------------
(desktop-save-mode 1)

;;------------------------------------------------------------------------------
;; N automatic line breaks
;;------------------------------------------------------------------------------
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default fill-column 90)


;;----------------------------------------------
;; Set color
;;----------------------------------------------
(custom-set-variables
 '(custom-enabled-themes (quote (wombat))))

;;------------------------------------------------------------------------------
;;  ESS
;;------------------------------------------------------------------------------
(custom-set-variables
  ;; No history file
 '(ess-history-file nil)
  ;; Set language to R (because S is default)
 '(ess-language "S")
 '(ess-dialect "R")
  ;; automatically complete even in scrpt
 '(ess-tab-complete-in-script (quote on))
 '(ess-use-auto-complete t))

; Highlight search object
(setq search-highlight t)
;; Don't ask for a directory when starting ESS
(setq ess-ask-for-ess-directory nil)
;; Buffer name
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window w1 nil t))
        (R)
        (set-window-buffer w2 "*R*")
        (set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
          '(lambda()
	     ;; Use C-up and C-down to scroll through command history
             (local-set-key [C-up] 'comint-previous-input)
             (local-set-key [C-down] 'comint-next-input)))
(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
;;(require 'ess-site)

;; start R in vanilla mode: don't want to save or load anything
(setq inferior-R-args "--vanilla")



;; change window with C - TAB
(global-set-key [C-tab] 'other-window)


;  For latex
(setq TeX-show-compilation nil)


;; start-up messages unterdruecken
(setq inhibit-startup-message t)


;; Emacs alt key für mac anpassen
;; (when (eq system-type 'darwin)
;;   (setq mac-right-option-modifier 'none))


;; for additional modules
(add-to-list 'load-path "~/Dropbox/DiesUndDas/emacs/")

;;------------------------------------------------------------------------------
;; Menues and toolbar
;;------------------------------------------------------------------------------
;; Menue und Toolbar unterdruecken
 (menu-bar-mode -1)
 (tool-bar-mode -1)
;; Scrollbar unterdrücken
(scroll-bar-mode -1)
;; Colum als default anzeigen lassen
(setq column-number-mode t)
;; show line number
(global-linum-mode t)


;;------------------------------------------------------------------------------
;; Indention
;;------------------------------------------------------------------------------
;; Funktion um den ganzen Buffer according to current mode zu indenten
(defun indent-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max))
)


;;------------------------------------------------------------------------------
;; Solve Problem with emacs and Anthy
;; So you can type tilde again
;;------------------------------------------------------------------------------
(load-library "iso-transl")


;;------------------------------------------------------------------------------
;; Including ORG - Mode
;; Folder has to be in the same as this file
;;------------------------------------------------------------------------------
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;------------------------------------------------------------------------------
;; Browser setting
;;------------------------------------------------------------------------------
;; Making Google Chrome the default browser

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

;;------------------------------------------------------------------------------
;; Add repositories
;;------------------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/")) 


;;------------------------------------------------------------------------------
;;
;; Interactively Doing Things
;; Handy for switching buffer, general auto-completion with common typed words
;;------------------------------------------------------------------------------
(require 'ido)
(ido-mode t)

;;------------------------------------------------------------------------------
;; make buffer movable
;;------------------------------------------------------------------------------
(load "buffer-move.el" nil t)


;;------------------------------------------------------------------------------
;; auto - close brackets
;;------------------------------------------------------------------------------
(electric-pair-mode 1)


;;------------------------------------------------------------------------------
;; Setup Emacs as Python IDE
;;------------------------------------------------------------------------------
;; I need this so that the ipython installation can be found by emacs
(require 'exec-path-from-shell) ;; if not using the ELPA package
(exec-path-from-shell-initialize)

;; Setup elpy for getting a Python REPL, autocompletion and more
;; See https://github.com/jorgenschaefer/elpy/wiki/Installation
(require 'elpy)
(package-initialize)
(elpy-enable)
;; I want to use ipython
;(exec-path-from-shell-copy-env "PYTHONPATH")
;(elpy-use-ipython)
(setq python-shell-interpreter "ipython")
(setenv "IPY_TEST_SIMPLE_PROMPT" "1")
;; For using Python 3, see:
;;http://emacs.stackexchange.com/questions/16637/how-to-set-up-elpy-to-use-python3

;; Improved syntax checking
;; Install flycheck with M-x package-install RET flycheck RET
(defvar myPackages
  '(better-defaults
    elpy
    flycheck ;; add the flycheck package
    material-theme))
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; PEP8 Compliance (Autopep8)
(defvar myPackages
  '(better-defaults
    elpy
    flycheck
    material-theme
    py-autopep8)) ;; add the autopep8 package
;; Dont forget to do 'M-x package-install RET py-autopep8' before
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)


;; Setup ipython notebooks
;; Install 'ein' package with 'package-install RET ein RET'
(defvar myPackages
  '(better-defaults
    ein ;; add the ein package (Emacs ipython notebook)
    elpy
    flycheck
    material-theme
    py-autopep8))


;;------------------------------------------------------------------------------
;; Use magit
;;------------------------------------------------------------------------------
(add-to-list 'load-path "magit-1.2.0")


;;------------------------------------------------------------------------------
;; Make scripts in org-mode usabel
;;------------------------------------------------------------------------------

; Must have org-mode loaded before we can configure org-babel
(require 'org-install)

; Some initial langauges we want org-babel to support
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (sh . t)
   (python . t)
   (R . t)
   (ruby . t)
   (ditaa . t)
   (dot . t)
   (octave . t)
   (sqlite . t)
   (perl . t)
   ))


;;------------------------------------------------------------------------------
;;Spell checking
;;------------------------------------------------------------------------------
(setq ispell-program-name "aspell")
(add-to-list 'exec-path "/usr/local/bin")



;;------------------------------------------------------------------------------
;; Indicate that your code is too long
;;------------------------------------------------------------------------------
(add-to-list 'load-path "fill-column-indicator.el")
(require 'fill-column-indicator)
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)
