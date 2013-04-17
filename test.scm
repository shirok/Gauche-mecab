;; -*- coding:euc-jp -*-
;;
;; dictionary-independent tests for mecab module
;;

(use gauche.test)

(test-start "mecab: dictionary-independent tests")
(use text.mecab)
(test-module 'text.mecab)

;;
;; write-object / ctor
;;
(define-macro (displayed-string obj)
  `(with-output-to-string (lambda () (display ,obj))))

(test-section "write-object (display)")
(let1 m (mecab-new '())
  (test* "(mecab-new '())" "#<mecab ()>" (displayed-string m))
  (mecab-destroy m))
(let1 m (mecab-new '("-O" "chasen"))
  (test* "(mecab-new '(\"-O\" \"chasen\"))" "#<mecab ((output-format-type chasen))>" (displayed-string m))
  (mecab-destroy m))
(let1 m (mecab-new2 "")
  (test* "(mecab-new2 \"\")" "#<mecab ()>" (displayed-string m))
  (mecab-destroy m))
(let1 m (mecab-new2 "-Ochasen")
  (test* "(mecab-new2 \"-Ochasen\")" "#<mecab ((output-format-type chasen))>" (displayed-string m))
  (mecab-destroy m))
(let1 m (mecab-new2 "-O chasen")
  (test* "(mecab-new2 \"-O chasen\")" "#<mecab ((output-format-type chasen))>" (displayed-string m))
  (mecab-destroy m))

(test-section "reader-ctor")
(let1 m #,(mecab "") ;; with reader-ctor
  (test* "#,(mecab \"\") : mecab?" #t (mecab? m))
  (test* "#,(mecab \"\") : options" '() (mecab-options m))
  (mecab-destroy m))
(let1 m #,(mecab "-Ochasen") ;; with reader-ctor
  (test* "#,(mecab \"-Ochasen\") : mecab?" #t (mecab? m))
  (test* "#,(mecab \"-Ochasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m #,(mecab :O chasen :l 1) ;; with reader-ctor
  (test* "#,(mecab :O chasen :l 1) : mecab?" #t (mecab? m))
  (test* "#,(mecab :O chasen :l 1) : mecab-options" '((output-format-type chasen) (lattice-level 1)) (mecab-options m))
  (mecab-destroy m))

;;
;; mecab?, mecab-node?, mecab-dictionary-info?
;;
(let* ([m (mecab-new2 "")]
       [node (mecab-sparse-tonode m "")]
       [dinfo (mecab-dictionary-info m)])
  (test-section "mecab?, mecab-node?, mecab-dictionary-info?")

  (test* "is-a? m <mecab>" #t (is-a? m <mecab>))
  (test* "is-a? node <mecab>" #t (is-a? node <mecab-node>))
  (test* "is-a? dinfo <mecab>" #t (is-a? dinfo <mecab-dictionary-info>))

  (test* "mecab? m" #t (mecab? m))
  (test* "mecab? node" #f (mecab? node))
  (test* "mecab? dinfo" #f (mecab? dinfo))

  (test* "mecab-node? m" #f (mecab-node? m))
  (test* "mecab-node? node" #t (mecab-node? node))
  (test* "mecab-node? dinfo" #f (mecab-node? dinfo))

  (test* "mecab-dictionary-info? m" #f (mecab-dictionary-info? m))
  (test* "mecab-dictionary-info? node" #f (mecab-dictionary-info? node))
  (test* "mecab-dictionary-info? dinfo" #t (mecab-dictionary-info? dinfo))

  (mecab-destroy m))

;; mecab, mecab-options
(test-section "mecab-options")
(let1 m (mecab-new '())
  (test* "(mecab-new '())" '() (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab-new '("-O" "chasen"))
  (test* "(mecab-new '(\"-O\" \"chasen\"))" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab-new2 "")
  (test* "(mecab-new2 \"\"" '() (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab-new2 "-Ochasen")
  (test* "mecab?" #t (mecab? m))
  (test* "(mecab-new2 \"-Ochasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab-new2 "-O chasen")
  (test* "mecab?" #t (mecab? m))
  (test* "(mecab-new2 \"-O chasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab-new2 "--output-format-type chasen")
  (test* "mecab?" #t (mecab? m))
  (test* "(mecab-new2 \"--output-format-type chasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab-new2 "--output-format-type=chasen")
  (test* "mecab?" #t (mecab? m))
  (test* "(mecab-new2 \"--output-format-type=chasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab "")
  (test* "(mecab \"\") : mecab?" #t (mecab? m))
  (test* "(mecab \"\") : options" '() (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab "-Ochasen")
  (test* "(mecab \"-Ochasen\") : mecab?" #t (mecab? m))
  (test* "(mecab \"-Ochasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab "-O chasen")
  (test* "(mecab \"-O chasen\") : mecab?" #t (mecab? m))
  (test* "(mecab \"-O chasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab "-O" "chasen")
  (test* "(mecab \"-O\" \"chasen\") : mecab?" #t (mecab? m))
  (test* "(mecab \"-O\" \"chasen\") : options" '((output-format-type chasen)) (mecab-options m))
  (mecab-destroy m))
(let1 m (mecab :O 'chasen :l 1)
  (test* "(mecab :O chasen :l 1) : mecab?" #t (mecab? m))
  (test* "(mecab :O chasen :l 1) : mecab-options" '((output-format-type chasen) (lattice-level 1)) (mecab-options m))
  (mecab-destroy m))

;;
;; APIs
;;
(test-section "mecab-new")
(let1 m (mecab-new '())
  (test* "is-a? <mecab>" #t (is-a? m <mecab>))
  (test* "mecab?" #t (mecab? m))

  (test-section "mecab-destroy")
  (test* "not destroyed yet" #f (mecab-destroyed? m))
  (mecab-destroy m)
  (test* "destroyed" #t (mecab-destroyed? m))
  )

(test-section "mecab-new2")
(let1 m (mecab-new2 "")
  (test* "is-a? <mecab>" #t (is-a? m <mecab>))
  (test* "mecab?" #t (mecab? m))
  (test* "options" '() (mecab-options m))
  (mecab-destroy m))

(test-section "mecab-version")
(test* "mecab-version" 1
       (rxmatch-num-matches
        (#/^[0-9]+\.[0-9]+[.0-9A-Za-z]*$/ (mecab-version))))

(test-section "mecab-strerror")
(mecab-new2 "")
(test* "at mecab-new2 (ok)" "" (mecab-strerror #f))

(mecab-new2 "-d //") ;; => "tagger.cpp(149) [load_dictionary_resource(param)] param.cpp(71) [ifs] no such file or directory:  //dicrc"
(test* "at mecab-new (err)" #f (string=? "" (mecab-strerror #f)))
(test* "no such file or directory" #f (not (#/no such file or directory/ (mecab-strerror #f))))

(let1 m (mecab-new2 "")
  (mecab-sparse-tostr m "空が青い。")
  (test* "noerr" "" (mecab-strerror m))
  (mecab-destroy m))

(let1 m (mecab-new2 "")
  (test-section "mecab-get-partial / mecab-set-partial")
  (test* "default partial mode [0|1]" #t
         (and (memq (mecab-get-partial m) '(0 1)) #t))
  (mecab-set-partial m 1)
  (test* "set to 1" 1 (mecab-get-partial m))
  (mecab-set-partial m 0)
  (test* "set to 0" 0 (mecab-get-partial m))

  (test-section "mecab-get-theta / mecab-set-theta")
  (let1 theta (mecab-get-theta m)
    (test* "default partial mode [0..1]" #t (and (number? theta) (<= 0.0 theta 1.0))))
  (mecab-set-theta m 1.0)
  (test* "set to 1.0" 1.0 (mecab-get-theta m))
  (mecab-set-theta m 0.5)
  (test* "set to 0.5" 0.5 (mecab-get-theta m))

  (test-section "mecab-get-lattice-level / mecab-set-lattice-level")
  (test* "default lattice-level [0|1|2]" #t
         (and (memq (mecab-get-lattice-level m) '(0 1 2)) #t))
  (mecab-set-lattice-level m 1)
  (test* "set to 1" 1 (mecab-get-lattice-level m))
  (mecab-set-lattice-level m 2)
  (test* "set to 2" 2 (mecab-get-lattice-level m))
  (mecab-set-lattice-level m 0)
  (test* "set to 0" 0 (mecab-get-lattice-level m))

  (test-section "mecab-get-all-morphs / mecab-set-all-morphs")
  (test* "default all-morphs [0|1]" #t
         (and (memq (mecab-get-all-morphs m) '(0 1)) #t))
  (mecab-set-all-morphs m 1)
  (test* "set to 1" 1 (mecab-get-all-morphs m))
  (mecab-set-all-morphs m 0)
  (test* "set to 0" 0 (mecab-get-all-morphs m))
  )

(test-end)
