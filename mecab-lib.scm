;;;
;;; mecab.stub - MeCab binding
;;;
;;;   Copyright (c) 2004 Kimura Fuyuki, All rights reserved.
;;;
;;;   Redistribution and use in source and binary forms, with or without
;;;   modification, are permitted provided that the following conditions
;;;   are met:
;;;
;;;   1. Redistributions of source code must retain the above copyright
;;;      notice, this list of conditions and the following disclaimer.
;;;
;;;   2. Redistributions in binary form must reproduce the above copyright
;;;      notice, this list of conditions and the following disclaimer in the
;;;      documentation and/or other materials provided with the distribution.
;;;
;;;   3. Neither the name of the authors nor the names of its contributors
;;;      may be used to endorse or promote products derived from this
;;;      software without specific prior written permission.
;;;
;;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;;   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;;   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;;   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;;;   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;;   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;;;   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;;   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;;   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;
;;;  $Id: mecab-lib.scm,v 1.3 2009/03/25 09:42:14 naoya_t Exp $
;;;

(define-module text.mecab
  (use srfi-1)
  (use srfi-13)
  (use gauche.charconv)
  (export <mecab> <mecab-node> <mecab-dictionary-info>
          mecab? mecab-node? mecab-dictionary-info?
          mecab-do mecab-new mecab-new2
          mecab-version mecab-strerror mecab-destroy mecab-destroyed?
          mecab mecab-options

          mecab-tagger ; message passing
          <mecab-tagger> mecab-make-tagger ; class

          mecab-get-partial mecab-set-partial
          mecab-get-theta mecab-set-theta
          mecab-get-lattice-level mecab-set-lattice-level
          mecab-get-all-morphs mecab-set-all-morphs

          mecab-sparse-tostr mecab-sparse-tostr2 ;; mecab-sparse-tostr3
          mecab-sparse-tonode mecab-sparse-tonode2
          mecab-nbest-sparse-tostr mecab-nbest-sparse-tostr2 ;; mecab-nbest-sparse-tostr3
          mecab-nbest-init mecab-nbest-init2
          mecab-nbest-next-tostr ;; mecab-nbest-next-tostr2
          mecab-nbest-next-tonode
          mecab-format-node
          mecab-dictionary-info
          mecab-dict-index mecab-dict-gen
          mecab-cost-train mecab-system-eval mecab-test-gen

          mecab-node-prev mecab-node-next mecab-node-enext mecab-node-bnext
          mecab-node-surface mecab-node-feature
          mecab-node-length mecab-node-rlength
          mecab-node-id mecab-node-rc-attr mecab-node-lc-attr
          mecab-node-posid mecab-node-char-type
          mecab-node-stat mecab-node-best?
          mecab-node-alpha mecab-node-beta mecab-node-prob
          mecab-node-wcost mecab-node-cost

          mecab-dictionary-info-filename mecab-dictionary-info-charset
          mecab-dictionary-info-size mecab-dictionary-info-type
          mecab-dictionary-info-lsize mecab-dictionary-info-rsize
          mecab-dictionary-info-version mecab-dictionary-info-next
          ))
(select-module text.mecab)

;; This should be configurable, since mecab can be compiled to use utf-8.
(define-constant MECAB_ENCODING 'euc-jp)

;; We need cv-send and cv-recv if MeCab is configured with --enable-utf8-only option.
;(define (cv-send str)
;  (ces-convert str (gauche-character-encoding) MECAB_ENCODING))
;(define (cv-recv str)
;  (and str (ces-convert str MECAB_ENCODING)))
(define (cv-send str) str)
(define (cv-recv str) str)

(define (mecab-do args)
  (unless (every string? args)
    (error "mecab-do: list of strings required, but got:" args))
  (%mecab-do (map cv-send args)))

(define (mecab-new args)
  (unless (every string? args)
    (error "mecab-new: list of strings required, but got:" args))
  (%mecab-new (map cv-send args) (mecab-parse-options args)))

(define (mecab-new2 str)
  (%mecab-new2 (cv-send str) (mecab-parse-options str)))

(define (mecab-strerror m)
; (cv-recv (%mecab-strerror m))) ;; m can be #f
  (cv-recv (if m (%mecab-strerror m) (%mecab-strerror-with-null))))

(define (mecab-sparse-tostr m str)
  (cv-recv (%mecab-sparse-tostr m (cv-send str))))

(define (mecab-sparse-tostr2 m str len)
  (cv-recv (%mecab-sparse-tostr2 m (cv-send str) len)))

(define (mecab-sparse-tonode m str)
  (%mecab-sparse-tonode m (cv-send str)))

(define (mecab-sparse-tonode2 m str len)
  (%mecab-sparse-tonode2 m (cv-send str) len))

(define (mecab-nbest-sparse-tostr m n str)
  (cv-recv (%mecab-nbest-sparse-tostr m n (cv-send str))))

(define (mecab-nbest-sparse-tostr2 m n str len)
  (cv-recv (%mecab-nbest-sparse-tostr2 m n (cv-send str) len)))

(define (mecab-nbest-init m str)
  (%mecab-nbest-init m (cv-send str)))

(define (mecab-nbest-init2 m str len)
  (%mecab-nbest-init2 m (cv-send str) len))

(define (mecab-nbest-next-tostr m)
  (cv-recv (%mecab-nbest-next-tostr m)))

(define (mecab-format-node m node)
  (cv-recv (%mecab-format-node m node)))

(define (mecab-dict-index args)
  (unless (every string? args)
    (error "mecab-dict-index: list of strings required, but got:" args))
  (%mecab-dict-index (map cv-send args)))

(define (mecab-dict-gen args)
  (unless (every string? args)
    (error "mecab-dict-gen: list of strings required, but got:" args))
  (%mecab-dict-gen (map cv-send args)))

(define (mecab-cost-train args)
  (unless (every string? args)
    (error "mecab-cost-train: list of strings required, but got:" args))
  (%mecab-cost-train (map cv-send args)))

(define (mecab-system-eval args)
  (unless (every string? args)
    (error "mecab-system-eval: list of strings required, but got:" args))
  (%mecab-system-eval (map cv-send args)))

(define (mecab-test-gen args)
  (unless (every string? args)
    (error "mecab-test-gen: list of strings required, but got:" args))
  (%mecab-test-gen (map cv-send args)))

;; mecab_node_t
(define (mecab-node-surface n)
  (cv-recv (%mecab-node-surface n)))

(define (mecab-node-feature n)
  (cv-recv (%mecab-node-feature n)))

(define (mecab-node-stat n)
  (vector-ref #(mecab-nor-node mecab-unk-node mecab-bos-node mecab-eos-node)
              (%mecab-node-stat n)))

;; mecab_dictionary_info_t
(define (mecab-dictionary-info-type dinfo)
  (vector-ref #(mecab-sys-dic mecab-usr-dic mecab-unk-dic)
              (%mecab-dictionary-info-type dinfo)))

;;
(inline-stub
 "#include <mecab.h>"

 ;; mecab_t type holder.
 "typedef struct ScmMeCabRec {
   SCM_HEADER;
   mecab_t *m; /* NULL if closed */
   ScmObj   options;
 } ScmMeCab;

 typedef struct ScmMeCabNodeRec {
   SCM_HEADER;
   const mecab_node_t *node;
 } ScmMeCabNode;

 typedef struct ScmMeCabDictionaryInfoRec {
   SCM_HEADER;
   const mecab_dictionary_info_t *dic_info;
 } ScmMeCabDictionaryInfo;"

 (define-cclass <mecab> :private ScmMeCab* "Scm_MeCabClass"
   ()
   ())

 (define-cclass <mecab-node> :private ScmMeCabNode* "Scm_MeCabNodeClass"
   ()
   ())

 (define-cclass <mecab-dictionary-info> :private ScmMeCabDictionaryInfo* "Scm_MeCabDictionaryInfoClass"
   ()
   ())

 ;; internal utility functions
 (define-cfn mecab-cleanup (m::ScmMeCab*) ::void :static
   (unless (== (-> m m) NULL)
     (mecab-destroy (-> m m))
     (set! (-> m m) NULL)))
 
 (define-cfn mecab-finalize (obj data::void*) ::void :static
   (mecab-cleanup (SCM_MECAB obj)))

 (define-cfn make-mecab (m::mecab_t* options::ScmObj) :static
   (when (== m NULL) (mecab-strerror NULL))
   (let* ([obj::ScmMeCab* (SCM_NEW ScmMeCab)])
     (SCM_SET_CLASS obj (& Scm_MeCabClass))
     (set! (-> obj m) m)
     (set! (-> obj options) options)
     (Scm_RegisterFinalizer (SCM_OBJ obj) mecab-finalize NULL)
     (return (SCM_OBJ obj))))

 (define-cfn make-mecab-node (n::"const mecab_node_t*") :static
   ;; returns #f when n==NULL ... for convenience of mecab_nbest_next_*
   (if (== n NULL) (return SCM_FALSE)
       (let* ([obj::ScmMeCabNode* (SCM_NEW ScmMeCabNode)])
         (SCM_SET_CLASS obj (& Scm_MeCabNodeClass))
         (set! (-> obj node) n)
         (return (SCM_OBJ obj)))))

 (define-cfn make-mecab-dictionary-info (dic_info::"const mecab_dictionary_info_t*") :static
   ;; returns #f when dic_info==NULL ... for convenience of mecab-dictionary-info-next
   (if (== dic_info NULL) (return SCM_FALSE)
       (let* ([obj::ScmMeCabDictionaryInfo* (SCM_NEW ScmMeCabDictionaryInfo)])
         (SCM_SET_CLASS obj (& Scm_MeCabDictionaryInfoClass))
         (set! (-> obj dic_info) dic_info)
         (return (SCM_OBJ obj)))))

 ;;
 ;; MeCab API
 ;;
 ;;  NB: for the default configuration, MeCab API takes EUC-JP string.
 ;;  The conversion is handled in the Scheme level.
 (define-cproc %mecab-do (args::<list>) ::<int>
   (let* ([argc::int (Scm_Length args)]
          [argv::char** (Scm_ListToCStringArray args TRUE NULL)])
     (result (mecab-do argc argv))))

 (define-cproc %mecab-new (args::<list> options)
   (let* ([argc::int (Scm_Length args)]
          [argv::char** (Scm_ListToCStringArray args TRUE NULL)])
     (result (make-mecab (mecab-new argc argv) options))))

 (define-cproc %mecab-new2 (arg::<string> options)
   (result (make-mecab (mecab-new2 (Scm_GetString arg)) options)))

 (define-cproc mecab-version () ::<const-cstring> mecab-version)

 (define-cproc mecab-destroy (m::<mecab>) ::<void>
   (mecab-cleanup m))

 (define-cproc mecab-destroyed? (m::<mecab>) ::<boolean>
   (result (== (-> m m) NULL)))

 (define-cproc mecab-options (m::<mecab>)
   (result (-> m options)))

 (define-cproc %mecab-strerror (m::<mecab>) ::<const-cstring>
   (result (mecab-strerror (-> m m))))

 (define-cproc %mecab-strerror-with-null () ::<const-cstring>
   (result (mecab-strerror NULL)))

 (define-cproc mecab-get-partial (m::<mecab>) ::<int>
   (result (mecab-get-partial (-> m m))))

 (define-cproc mecab-set-partial (m::<mecab> partial::<int>) ::<void>
   (mecab-set-partial (-> m m) partial))

 (define-cproc mecab-get-theta (m::<mecab>) ::<float>
   (result (mecab-get-theta (-> m m))))

 (define-cproc mecab-set-theta (m::<mecab> theta::<float>) ::<void>
   (mecab-set-theta (-> m m) theta))

 (define-cproc mecab-get-lattice-level (m::<mecab>) ::<int>
   (result (mecab-get-lattice-level (-> m m))))

 (define-cproc mecab-set-lattice-level (m::<mecab> level::<int>) ::<void>
   (mecab-set-lattice-level (-> m m) level))

 (define-cproc mecab-get-all-morphs (m::<mecab>) ::<int>
   (result (mecab-get-all-morphs (-> m m))))

 (define-cproc mecab-set-all-morphs (m::<mecab> all_morphs::<int>) ::<void>
   (mecab-set-all-morphs (-> m m) all_morphs))

 (define-cproc %mecab-sparse-tostr (m::<mecab> str::<const-cstring>)
   ::<const-cstring>?
   (result (mecab-sparse-tostr (-> m m) str)))

 (define-cproc %mecab-sparse-tostr2 (m::<mecab> str::<const-cstring> len::<uint>)
   ::<const-cstring>?
   (result (mecab-sparse-tostr2 (-> m m) str len)))

 (define-cproc %mecab-nbest-sparse-tostr (m::<mecab> n::<uint> str::<const-cstring>)
   ::<const-cstring>?
   (result (mecab-nbest-sparse-tostr (-> m m) n str)))

 (define-cproc %mecab-nbest-sparse-tostr2 (m::<mecab> n::<uint> str::<const-cstring> len::<uint>)
   ::<const-cstring>?
   (result (mecab-nbest-sparse-tostr2 (-> m m) n str len)))

 (define-cproc %mecab-nbest-init (m::<mecab> str::<const-cstring>) ::<int>
   (result (mecab-nbest-init (-> m m) str)))

 (define-cproc %mecab-nbest-init2 (m::<mecab> str::<const-cstring> len::<uint>) ::<int>
   (result (mecab-nbest-init2 (-> m m) str len)))

 (define-cproc %mecab-nbest-next-tostr (m::<mecab>) ;; returns null at the end
;   (result (mecab-nbest-next-tostr (-> m m))))
" const char *s = mecab_nbest_next_tostr(m->m);
  return s ? SCM_MAKE_STR_COPYING(s) : SCM_FALSE;")

 (define-cproc mecab-nbest-next-tonode (m::<mecab>) ;; returns null at the end
   (result (make-mecab-node (mecab-nbest-next-tonode (-> m m)))))

 (define-cproc %mecab-sparse-tonode (m::<mecab> str::<const-cstring>)
   (result (make-mecab-node (mecab-sparse-tonode (-> m m) str))))

 (define-cproc %mecab-sparse-tonode2 (m::<mecab> str::<const-cstring> siz::<uint>)
   (result (make-mecab-node (mecab-sparse-tonode2 (-> m m) str siz))))

 (define-cproc mecab-dictionary-info (m::<mecab>)
   (result (make-mecab-dictionary-info (mecab-dictionary-info (-> m m)))))

 (define-cproc %mecab-format-node (m::<mecab> n::<mecab-node>) ::<const-cstring>?
   (result (mecab-format-node (-> m m) (-> n node))))

 (define-cproc %mecab-dict-index (args::<list>) ::<int>
   (let* ([argc::int (Scm_Length args)]
          [argv::char** (Scm_ListToCStringArray args TRUE NULL)])
     (result (mecab-dict-index argc argv))))

 (define-cproc %mecab-dict-gen (args::<list>) ::<int>
   (let* ([argc::int (Scm_Length args)]
          [argv::char** (Scm_ListToCStringArray args TRUE NULL)])
     (result (mecab-dict-gen argc argv))))

 (define-cproc %mecab-cost-train (args::<list>) ::<int>
   (let* ([argc::int (Scm_Length args)]
          [argv::char** (Scm_ListToCStringArray args TRUE NULL)])
     (result (mecab-cost-train argc argv))))

 (define-cproc %mecab-system-eval (args::<list>) ::<int>
   (let* ([argc::int (Scm_Length args)]
          [argv::char** (Scm_ListToCStringArray args TRUE NULL)])
     (result (mecab-system-eval argc argv))))

 (define-cproc %mecab-test-gen (args::<list>) ::<int>
   (let* ([argc::int (Scm_Length args)]
          [argv::char** (Scm_ListToCStringArray args TRUE NULL)])
     (result (mecab-test-gen argc argv))))

;;
;; mecab_node_t
;;
 (define-cproc mecab-node-prev (n::<mecab-node>)
   (result (make-mecab-node (-> (-> n node) prev))))

 (define-cproc mecab-node-next (n::<mecab-node>)
   (result (make-mecab-node (-> (-> n node) next))))

 (define-cproc mecab-node-enext (n::<mecab-node>)
   (result (make-mecab-node (-> (-> n node) enext))))

 (define-cproc mecab-node-bnext (n::<mecab-node>)
   (result (make-mecab-node (-> (-> n node) bnext))))

 (define-cproc %mecab-node-surface (n::<mecab-node>)
   (result (Scm-MakeString (-> (-> n node) surface)
                           (-> (-> n node) length) ;; size
                           -1 ;; Gauche will count the 'length' of this substring
                           SCM-STRING-COPYING)))

 (define-cproc %mecab-node-feature (n::<mecab-node>)
   ::<const-cstring> (result (-> (-> n node) feature)))

 (define-cproc mecab-node-length (n::<mecab-node>)
   ::<uint> (result (-> (-> n node) length)))

 (define-cproc mecab-node-rlength (n::<mecab-node>)
   ::<uint> (result (-> (-> n node) rlength)))

 (define-cproc mecab-node-id (n::<mecab-node>)
   ::<uint> (result (-> (-> n node) id)))

 (define-cproc mecab-node-rc-attr (n::<mecab-node>)
   ::<uint> (result (-> (-> n node) rcAttr)))

 (define-cproc mecab-node-lc-attr (n::<mecab-node>)
   ::<uint> (result (-> (-> n node) lcAttr)))

 (define-cproc mecab-node-posid (n::<mecab-node>)
   ::<uint> (result (-> (-> n node) posid)))

 (define-cproc mecab-node-char-type (n::<mecab-node>)
   ::<uint> (result (-> (-> n node) char-type)))

 (define-cproc %mecab-node-stat (n::<mecab-node>)
   ::<int> (result (-> (-> n node) stat)))

 (define-cproc mecab-node-best? (n::<mecab-node>)
   ::<boolean> (result (-> (-> n node) isbest)))

 (define-cproc mecab-node-alpha (n::<mecab-node>)
   ::<float> (result (-> (-> n node) alpha)))

 (define-cproc mecab-node-beta (n::<mecab-node>)
   ::<float> (result (-> (-> n node) beta)))

 (define-cproc mecab-node-prob (n::<mecab-node>)
   ::<float> (result (-> (-> n node) prob)))

 (define-cproc mecab-node-wcost (n::<mecab-node>)
   ::<int> (result (-> (-> n node) wcost)))

 (define-cproc mecab-node-cost (n::<mecab-node>)
   ::<int> (result (-> (-> n node) cost)))

;;
;; mecab_dictionary_info_t
;;
 (define-cproc mecab-dictionary-info-filename (dinfo::<mecab-dictionary-info>)
   ::<const-cstring> (result (-> (-> dinfo dic_info) filename)))

 (define-cproc mecab-dictionary-info-charset (dinfo::<mecab-dictionary-info>)
   ::<const-cstring> (result (-> (-> dinfo dic_info) charset)))

 (define-cproc mecab-dictionary-info-size (dinfo::<mecab-dictionary-info>)
   ::<uint> (result (-> (-> dinfo dic_info) size)))

 (define-cproc %mecab-dictionary-info-type (dinfo::<mecab-dictionary-info>)
   ::<int> (result (-> (-> dinfo dic_info) type)))

 (define-cproc mecab-dictionary-info-lsize (dinfo::<mecab-dictionary-info>)
   ::<uint> (result (-> (-> dinfo dic_info) lsize)))

 (define-cproc mecab-dictionary-info-rsize (dinfo::<mecab-dictionary-info>)
   ::<uint> (result (-> (-> dinfo dic_info) rsize)))

 (define-cproc mecab-dictionary-info-version (dinfo::<mecab-dictionary-info>)
   ::<uint> (result (-> (-> dinfo dic_info) version)))

 (define-cproc mecab-dictionary-info-next (dinfo::<mecab-dictionary-info>)
   (result (make-mecab-dictionary-info (-> (-> dinfo dic_info) next))))

 )

(define-macro (mecab? obj) `(is-a? ,obj <mecab>))
(define-macro (mecab-node? obj) `(is-a? ,obj <mecab-node>))
(define-macro (mecab-dictionary-info? obj) `(is-a? ,obj <mecab-dictionary-info>))

(define-method write-object ((m <mecab>) out)
  (format out "#<mecab ~s>" (mecab-options m)))
(define-method write-object ((m <mecab-node>) out)
  (format out "#<mecab-node>"))
(define-method write-object ((m <mecab-dictionary-info>) out)
  (format out "#<mecab-dictionary-info>"))

(define *mecab-options+*
  '((r rcfile FILE)
    (d dicdir DIR)
    (u userdic FILE)
    (l lattice-level INT)
    (D dictionary-info)
    (a all-morphs)
    (O output-format-type TYPE)
    (p partial)
    (F node-format STR)
    (U unk-format STR)
    (B bos-format STR)
    (E eos-format STR)
    (x unk-feature STR)
    (b input-buffer-size INT)
    (P dump-config)
    (M open-mutable-dictionary)
    (C allocate-sentence)
    (N nbest INT)
    (t theta FLOAT)
    (c cost-factor INT)
    (o output FILE)
    (v version)
    (h help)))

(define *mecab-options* (map cdr *mecab-options+*))

(define (cast argtype obj)
  (case argtype
    [(STR DIR FILE) (x->string obj)]
    [(INT FLOAT) obj]
    [(TYPE) (string->symbol (x->string obj))]
    [else obj]))

(define (requires-arg? option)
  (let1 opt (assoc option *mecab-options*)
    (if opt (= 2 (length opt)) #f)))

(define (argtype option)
  (cadr (or (assoc option *mecab-options*) (list #f #f))))

(define (long-option-name short-option-name)
  (cadr (or (assoc short-option-name *mecab-options+*) (list #f #f))))

(define (keyword-length keyword)
  (string-length (keyword->string keyword)))

(define (keyword->symbol keyword)
  (string->symbol (keyword->string keyword)))

(define (mecab-parse-options args)
  ;; eg. ("-Ochasen" :l 1 "--theta" "0.75")
  ;;     => (:output-format-type "chasen" :lattice-level 1 :theta "0.75")
  (let1 args* (append-map
               (lambda (arg)
                 (cond [(string? arg)
                        (if (string=? "" arg) '()
                            (append-map
                             (lambda (str)
                               (let1 len (string-length str)
                                 (if (<= 2 len)
                                     (if (eq? #\- (string-ref str 0))
                                         ;; --option, -X[arg]
                                         (if (eq? #\- (string-ref str 1))
                                             ;; --option
                                             (list (string->symbol (substring str 2 len)))
                                             ;; -X[arg]
                                             (let1 option (long-option-name (string->symbol (substring str 1 2)))
                                               (if (= len 2)
                                                   ;; -X
                                                   (list option)
                                                   ;; -Xarg
                                                   (list option (cast (argtype option) (substring str 2 len))))))
                                         (list str))
                                     (list str))))
                             (string-split arg #[ =])))]
                       [(keyword? arg)
                        (if (= 1 (keyword-length arg))
                            (list (long-option-name (keyword->symbol arg)))
                            (list (keyword->symbol arg)))]
                       [else
                        (list arg)]))
               (if (list? args) args (list args)))
    ;; eg. (:output-format-type "chasen" :lattice-level 1 :theta "0.75")
    ;;     => ((output-format-type chasen) (lattice-level 1) (theta 0.75))
    (let loop ((rest args*) (options '()))
      (if (null? rest)
          (reverse! options)
          (let1 option (car rest)
            (if (symbol? option)
                (if (requires-arg? option)
                    (loop (cddr rest) (cons (list option (cast (argtype option) (cadr rest))) options))
                    (loop (cdr rest) (cons (list option (if #f #f)) options)))
                (loop (cdr rest) options)))))))

(define (mecab . args) ;; inspired by leque's make-mecab
  (let* ([options (mecab-parse-options args)]
         [options-str (append-map (lambda (option+arg)
                                    (let* ([option (car option+arg)]
                                           [option-str (format "--~a" option)])
                                      (if (requires-arg? option)
                                          (list option-str (x->string (cadr option+arg)))
                                          (list option-str) )))
                                  options)])
    (%mecab-new options-str options)))

(define-reader-ctor 'mecab mecab)

;; Tagger
(define (mecab-tagger . args)
  (let1 m (apply mecab args)
    (define (parse-to-string str . args)
      (let-optionals* args ((len #f))
        (if len
            (mecab-sparse-tostr2 m str len)
            (mecab-sparse-tostr m str) )))

    (define (parse-to-node str) (mecab-sparse-tonode m str))

    ;; requires "-l 1" in option
    (define (parse-nbest n str) (mecab-nbest-sparse-tostr m n str))

    (define (parse-nbest-init str) (mecab-nbest-init m str))

    (define (next) (mecab-nbest-next-tostr m))

    (define (next-node) (mecab-nbest-next-tonode m))

    (define (format-node node) (mecab-format-node m node))

    (define (destroy) (mecab-destroy m))

    (lambda (m)
      (case m
        [(parse parse-to-string) parse-to-string]
        [(parse-to-node) parse-to-node]
        [(parse-nbest) parse-nbest]
        [(parse-nbest-init) parse-nbest-init]
        [(next) next]
        [(next-node) next-node]
        [(format-node) format-node]
        [(destroy) destroy]
        ))))

(define-class <mecab-tagger> () (m #f))

(define (mecab-make-tagger paramstr)
  (make <mecab-tagger> :mecab (mecab paramstr)))

(define (tagger-mecab tagger) (slot-ref tagger 'm))

(define-method parse ((tagger <mecab-tagger>) (str <string>))
  (mecab-sparse-tostr (tagger-mecab tagger) str))

(define-method parse ((tagger <mecab-tagger>) (str <string>) (len <integer>))
  (mecab-sparse-tostr2 (tagger-mecab tagger) str len))

(define-method parse-to-string ((tagger <mecab-tagger>) (str <string>))
  (mecab-sparse-tostr (tagger-mecab tagger) str))

(define-method parse-to-string ((tagger <mecab-tagger>) (str <string>) (len <integer>))
  (mecab-sparse-tostr2 (tagger-mecab tagger) str len))

(define-method parse-to-node ((tagger <mecab-tagger>) (str <string>))
  (mecab-sparse-tonode (tagger-mecab tagger) str))

(define-method parse-to-node ((tagger <mecab-tagger>) (str <string>) (len <integer>))
  (mecab-sparse-tonode2 (tagger-mecab tagger) str len))

(define-method parse-nbest ((tagger <mecab-tagger>) (n <integer>) (str <string>))
  (mecab-nbest-sparse-tostr (tagger-mecab tagger) n str))

(define-method parse-nbest ((tagger <mecab-tagger>) (n <integer>) (str <string>) (len <integer>))
  (mecab-nbest-sparse-tostr2 (tagger-mecab tagger) n str len))

(define-method parse-nbest-init ((tagger <mecab-tagger>) (str <string>))
  (mecab-nbest-init (tagger-mecab tagger) str))

(define-method parse-nbest-init ((tagger <mecab-tagger>) (str <string>) (len <integer>))
  (mecab-nbest-init2 (tagger-mecab tagger) str len))

(define-method next ((tagger <mecab-tagger>))
  (mecab-nbest-next-tostr (tagger-mecab tagger)))

(define-method next-node ((tagger <mecab-tagger>))
  (mecab-nbest-next-tonode (tagger-mecab tagger)))

(define-method format-node ((tagger <mecab-tagger>) (node <mecab-node>))
  (mecab-format-node (tagger-mecab tagger) node))

(provide "text/mecab")

;; Local variables:
;; mode: scheme
;; end:
