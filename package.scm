;;
;; Package Gauche-mecab
;;

(define-gauche-package "Gauche-mecab"
  :version "1.0.1"

  ;; Description of the package.  The first line is used as a short
  ;; summary.
  :description "MeCab binding for Gauche"

  ;; List of dependencies.
  :require (("Gauche" (>= "0.9.5_pre1")))

  ;; List name and contact info of authors.
  :authors ("Kimura Fuyuki"
            "naoya_t"
            "Shiro Kawai <shiro@acm.org>")

  ;; List name and contact info of package maintainers, if they differ
  :maintainers ("Shiro Kawai <shiro@acm.org>")

  ;; List licenses
  :licenses ("BSD")

  ;; Homepage URL, if any.
  ; :homepage "http://example.com/@@package@@/"

  ;; Repository URL, e.g. github
  :repository "http://github.com/shirok/Gauche-mecab.git"
  )
