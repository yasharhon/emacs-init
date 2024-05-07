;; .emacs.d/init.el

;; ===================================
;; Custom variables
;; ===================================

(defvar myBackupDirectory "/my/backup/path")

; myPackages contains a list of package names
(defvar myPackages
  '(material-theme                  ;; Theme
    ;better-defaults                ;; Changed defaults for Emacs. Should be added to own file instead
    elpy                            ;; Emacs Lisp Python Environment
    php-mode                        ;; Major mode for PHP
    )
  )

;; ===================================
;; MELPA Package Support
;; ===================================
; Enables basic packaging support
(require 'package)

; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

; Initializes the package infrastructure
(package-initialize)

; Refresh packages. Seems to always be needed
(package-refresh-contents)

; Installs packages by scanning the list in myPackages
; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)     ;; Hide the startup message
(load-theme 'material t)             ;; Load material theme
(global-linum-mode t)                ;; Enable line numbers globally
(desktop-save-mode 1)                ;; Save session
(setq visible-bell 1)                ;; Mute bell
(delete-selection-mode 1)            ;; Always delete selection 

;; ===================================
;; Advanced Customization
;; ===================================

; Set backup location
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    `(("." . ,myBackupDirectory))    ; don't litter my fs tree
   auto-save-file-name-transforms
    `((".*" ,myBackupDirectory t))
   delete-old-versions t
   kept-new-versions 1
   kept-old-versions 3
   version-control t)       ; use versioned backups

; Delete old backup files
(message "Deleting old backup files...")
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files temporary-file-directory t))
    (when (and (backup-file-name-p file)
               (> (- current (float-time (fifth (file-attributes file))))
                  week))
      (message "%s" file)
      (delete-file file))))

;; ====================================
;; Development Setup
;; ====================================
; Enable elpy
(elpy-enable)

; Might need to run elpy-rpc-reinstall-virtualenv
; Make sure to install virtualenv!
(setq
      python-shell-interpreter "python3"
      python-shell-interpreter-args "-i"
      elpy-rpc-python-command "python3"
       )

;; ====================================
;; User-Defined init.el ends here
;; ====================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(elpy material-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
