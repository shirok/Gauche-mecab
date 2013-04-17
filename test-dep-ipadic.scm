;; -*- coding:euc-jp -*-
;;
;; dictionary-dependent tests for mecab module <vol.2>
;;
;;  using mecab-0.98pre1 <default:EUC-JP>
;;      + mecab-ipadic-2.7.0-20070801 <utf-8>
;;
;;  written by naoya_t

(use gauche.test)

(test-start "mecab: dictionary-dependent tests <vol.2>: ipadic")
(use text.mecab)
(test-module 'text.mecab)

(let1 m (mecab-new2 "")
  (test-section "mecab-sparse-tostr")
  (test* "�����Ĥ���"
         (string-join '("��\t̾��,����,*,*,*,*,��,����,����"
                        "��\t����,�ʽ���,����,*,*,*,��,��,��"
                        "�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������"
                        "��\t����,����,*,*,*,*,��,��,��"
                        "EOS"
                        "") "\n")
         (mecab-sparse-tostr m "�����Ĥ���"))

  (test-section "mecab-sparse-tostr2")
  (test* "\"�����Ĥ���\", len=6"
         (string-join '("��\t̾��,����,*,*,*,*,��,����,����"
                        "��\t����,�ʽ���,����,*,*,*,��,��,��"
                        "EOS"
                        "") "\n")
         (mecab-sparse-tostr2 m "�����Ĥ���" 6))

  (test-section "mecab-sparse-tonode, mecab-node-***")
  (let1 node (mecab-sparse-tonode m "�����Ĥ���")
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "no previous node" #f (mecab-node-prev node))
    (test* "next node" #t (mecab-node? (mecab-node-next node)))
    (test* "enext" #f (mecab-node? (mecab-node-enext node)))
    (test* "bnext" #f (mecab-node? (mecab-node-bnext node)))
    (test* "surface" "" (mecab-node-surface node))
    (test* "feature" "BOS/EOS,*,*,*,*,*,*,*,*" (mecab-node-feature node))
    (test* "length" 0 (mecab-node-length node))
    (test* "rlength" 0 (mecab-node-rlength node))
    (test* "id" 0 (mecab-node-id node))
    (test* "rc-attr" 0 (mecab-node-rc-attr node))
    (test* "lc-attr" 0 (mecab-node-lc-attr node))
    (test* "posid" 0 (mecab-node-posid node))
    (test* "char-type" 0 (mecab-node-char-type node))
    (test* "stat" 'mecab-bos-node (mecab-node-stat node))
    (test* "best?" #t (mecab-node-best? node))
    (test* "alpha" 0.0 (mecab-node-alpha node))
    (test* "beta" 0.0 (mecab-node-beta node))
    (test* "prob" 0.0 (mecab-node-prob node))
    (test* "wcost" 0 (mecab-node-wcost node))
    (test* "cost" 0 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "previous node" #t (mecab-node? (mecab-node-prev node)))
    (test* "next node" #t (mecab-node? (mecab-node-next node)))
    (test* "enext" #t (mecab-node? (mecab-node-enext node)))
    (test* "bnext" #f (mecab-node? (mecab-node-bnext node)))
    (test* "surface" "��" (mecab-node-surface node))
    (test* "feature" "̾��,����,*,*,*,*,��,����,����" (mecab-node-feature node))
    (test* "length" 3 (mecab-node-length node))
    (test* "rlength" 3 (mecab-node-rlength node))
    (test* "id" 1 (mecab-node-id node))
    (test* "rc-attr" 1285 (mecab-node-rc-attr node))
    (test* "lc-attr" 1285 (mecab-node-lc-attr node))
    (test* "posid" 38 (mecab-node-posid node))
    (test* "char-type" 2 (mecab-node-char-type node))
    (test* "stat" 'mecab-nor-node (mecab-node-stat node))
    (test* "best?" #t (mecab-node-best? node))
    (test* "alpha" 0.0 (mecab-node-alpha node))
    (test* "beta" 0.0 (mecab-node-beta node))
    (test* "prob" 0.0 (mecab-node-prob node))
    (test* "wcost" 7439 (mecab-node-wcost node))
    (test* "cost" 7156 (mecab-node-cost node))
    )

  (test-section "mecab-sparse-tonode2")
  (let1 node (mecab-sparse-tonode2 m "�����Ĥ���" 6)
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "feature" "BOS/EOS,*,*,*,*,*,*,*,*" (mecab-node-feature node))
    (test* "stat" 'mecab-bos-node (mecab-node-stat node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "surface" "��" (mecab-node-surface node))
    (test* "feature" "̾��,����,*,*,*,*,��,����,����" (mecab-node-feature node))
    (test* "stat" 'mecab-nor-node (mecab-node-stat node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "surface" "��" (mecab-node-surface node))
    (test* "feature" "����,�ʽ���,����,*,*,*,��,��,��" (mecab-node-feature node))
    (test* "stat" 'mecab-nor-node (mecab-node-stat node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "feature" "BOS/EOS,*,*,*,*,*,*,*,*" (mecab-node-feature node))
    (test* "stat" 'mecab-eos-node (mecab-node-stat node))
    (test* "no next node" #f (mecab-node-next node))
    )
;  (test-section "mecab-format-node")
;  (let1 node (mecab-sparse-tonode m "�����Ĥ���")
;   (test* "BOS" "" (mecab-format-node mecab node)))
  (mecab-destroy m))

(let ([m (mecab-new2 "-l 1")] ;;
      [input "�����Ĥ���"])
  (test-section "mecab-nbest-sparse-tostr")
  (test* #`",|input|, N=1"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-sparse-tostr m 1 input))
  (test* #`",|input|, N=2"
         (string-append
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
          )
         (mecab-nbest-sparse-tostr m 2 input))
  (test* #`",|input|, N=3"
         (string-append
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
          )
         (mecab-nbest-sparse-tostr m 3 input))

  (test-section "mecab-nbest-sparse-tostr2")
  (test* #`",|input|, N=1"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-sparse-tostr2 m 1 input 6))
  (test* #`",|input|, N=2"
         (string-append
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
          )
         (mecab-nbest-sparse-tostr2 m 2 input 6))
  (test* #`",|input|, N=3"
         (string-append
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
          "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
          )
         (mecab-nbest-sparse-tostr2 m 3 input 6))

  (test-section "mecab-nbest-init")
  (test* "init" 1 (mecab-nbest-init m input))
  (test-section "mecab-nbest-next-tostr")
  (test* "#1"
        "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
        (mecab-nbest-next-tostr m))
  (test* "#2"
        "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
        (mecab-nbest-next-tostr m))
  (test* "#3"
        "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
        (mecab-nbest-next-tostr m))
  (test* "#4"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,��³����,*,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  (test* "#5"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n��\t���ƻ�,��Ω,*,*,���ƻ졦��������,������³,�Ĥ�,����,����\n��\tư��,��Ω,*,*,����,Ϣ�ѷ�,����,��,��\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  (test* "#6"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,��³����,*,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  (test* "#7"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n��\t���ƻ�,��Ω,*,*,���ƻ졦��������,������³,�Ĥ�,����,����\n��\tư��,��Ω,*,*,����,Ϣ�ѷ�,����,��,��\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  (test* "#8"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t��³��,*,*,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  (test* "#9"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,��³����,*,*,*,*,��,��,��\n�Ĥ�\t���ƻ�,��Ω,*,*,���ƻ졦��������,���ܷ�,�Ĥ�,������,������\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  (test* "#10"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\n��\t���ƻ�,��Ω,*,*,���ƻ졦��������,������³,�Ĥ�,����,����\n��\tư��,��Ω,*,*,����,Ϣ�ѷ�,����,��,��\n��\t����,����,*,*,*,*,��,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  (dotimes (i 733)
    (mecab-nbest-next-tostr m))
  (test* "#744"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\tư��,����,*,*,���ʡ����,�θ���³�ü죲,����,��,��\n��\t̾��,��ͭ̾��,�ϰ�,����,*,*,��,����,����\n��\tư��,��Ω,*,*,����,̤����,����,��,��\n��\t̾��,������³,*,*,*,*,*\nEOS\n"
         (mecab-nbest-next-tostr m))
  ;; no more results...
  (test* "#745" #f (mecab-nbest-next-tostr m))
  (test* "mecab-strerror" #f (string=? "" (mecab-strerror m)))
  
  (test-section "mecab-nbest-init2")
  (test* "init2" 1 (mecab-nbest-init2 m input 6))
  (test* "#1"
        "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
        (mecab-nbest-next-tostr m))
  (test* "#2"
        "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
        (mecab-nbest-next-tostr m))
  (test* "#3"
        "��\t̾��,����,*,*,*,*,��,����,����\n��\t����,�ʽ���,����,*,*,*,��,��,��\nEOS\n"
        (mecab-nbest-next-tostr m))
  (dotimes (i 8) (mecab-nbest-next-tostr m))
  (test* "#12"
         "��\t̾��,����,*,*,*,*,��,����,����\n��\tư��,����,*,*,���ʡ����,�θ���³�ü죲,����,��,��\nEOS\n"
         (mecab-nbest-next-tostr m))
  ;; no more results...
  (test* "#13" #f (mecab-nbest-next-tostr m))
  (test* "mecab-strerror" #f (string=? "" (mecab-strerror m)))

  (test-section "mecab-nbest-next-tonode")
  (mecab-nbest-init m input)
  (test* "#1" #t (mecab-node? (mecab-nbest-next-tonode m)))
  (dotimes (i 742) (mecab-nbest-next-tonode m))
  (test* "#744" #t (mecab-node? (mecab-nbest-next-tonode m))); EOS
  ;; no more results...
  (test* "#745" #f (mecab-node? (mecab-nbest-next-tonode m)))
  (test* "mecab-strerror" #f (string=? "" (mecab-strerror m)))

  (mecab-destroy m))

;;
;; these values below may differ !!!
(test-section "mecab-dictionary-info, mecab-dictionary-info-***")
(let* ([m (mecab-new2 "")]
       [dinfo (mecab-dictionary-info m)])
  (test* "mecab-dictionary-info?" #t (mecab-dictionary-info? dinfo))
  (test* "mecab-dictionary-info-filename"
         "/usr/local/lib/mecab/dic/ipadic/sys.dic" (mecab-dictionary-info-filename dinfo))
  (test* "mecab-dictionary-info-charset"
         "utf8" (mecab-dictionary-info-charset dinfo))
  (test* "mecab-dictionary-info-size"
         392126 (mecab-dictionary-info-size dinfo))
  (test* "mecab-dictionary-info-type" 'mecab-sys-dic (mecab-dictionary-info-type dinfo))
  (test* "mecab-dictionary-info-lsize"
         1316 (mecab-dictionary-info-lsize dinfo))
  (test* "mecab-dictionary-info-rsize"
         1316 (mecab-dictionary-info-rsize dinfo))
  (test* "mecab-dictionary-info-version"
         102 (mecab-dictionary-info-version dinfo))
;  (let1 next-dinfo (mecab-dictionary-info-next dinfo)
;    (test* "has next?" #t (mecab-dictionary-info? next-dinfo)))
  (mecab-destroy m))


;;;;;;;;;;
;;
;; TO DO
;;
;;(test-section "mecab-do")
;;(test-section "mecab-dict-index")
;;(test-section "mecab-dict-gen")
;;(test-section "mecab-cost-train")
;;(test-section "mecab-system-eval")
;;(test-section "mecab-test-gen")

;;;
;;; tagger (message passing)
;;;
(test-section "tagger")
(let1 tagger (mecab-tagger "-l 1")
  (test* "tagger'parse-to-string"
         (string-join '("����\t̾��,�����ǽ,*,*,*,*,����,���祦,���硼"
                        "��\t����,������,*,*,*,*,��,��,��"
                        "��\tư��,��Ω,*,*,���ѡ�����,̤����,����,��,��"
                        "�ʤ�\t��ư��,*,*,*,�ü졦�ʥ�,���ܷ�,�ʤ�,�ʥ�,�ʥ�"
                        "��\t����,��³����,*,*,*,*,��,��,��"
                        "��\t����,������,*,*,*,*,��,��,��"
                        "EOS"
                        "") "\n")
         ([tagger'parse-to-string] "�����⤷�ʤ��Ȥ�"))

  (let1 node ([tagger'parse-to-node] "�����⤷�ʤ��Ȥ�")
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "" (mecab-node-surface node))
    (test* "mecab-node-feature" "BOS/EOS,*,*,*,*,*,*,*,*" (mecab-node-feature node))
    (test* "mecab-node-cost" 0 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "����" (mecab-node-surface node))
    (test* "mecab-node-feature" "̾��,�����ǽ,*,*,*,*,����,���祦,���硼" (mecab-node-feature node))
    (test* "mecab-node-cost" 3947 (mecab-node-cost node))
    ;;(test* "format-node" "" ([tagger'format-node] node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "��" (mecab-node-surface node))
    (test* "mecab-node-feature" "����,������,*,*,*,*,��,��,��" (mecab-node-feature node))
    (test* "mecab-node-cost" 5553 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "��" (mecab-node-surface node))
    (test* "mecab-node-feature" "ư��,��Ω,*,*,���ѡ�����,̤����,����,��,��" (mecab-node-feature node))
    (test* "mecab-node-cost" 11566 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "�ʤ�" (mecab-node-surface node))
    (test* "mecab-node-feature" "��ư��,*,*,*,�ü졦�ʥ�,���ܷ�,�ʤ�,�ʥ�,�ʥ�" (mecab-node-feature node))
    (test* "mecab-node-cost" 3601 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "��" (mecab-node-surface node))
    (test* "mecab-node-feature" "����,��³����,*,*,*,*,��,��,��" (mecab-node-feature node))
    (test* "mecab-node-cost" 4716 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "��" (mecab-node-surface node))
    (test* "mecab-node-feature" "����,������,*,*,*,*,��,��,��" (mecab-node-feature node))
    (test* "mecab-node-cost" 10676 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #t (mecab-node? node))
    (test* "mecab-node-surface" "" (mecab-node-surface node))
    (test* "mecab-node-feature" "BOS/EOS,*,*,*,*,*,*,*,*" (mecab-node-feature node))
    (test* "mecab-node-cost" 8292 (mecab-node-cost node))

    (set! node (mecab-node-next node))
    (test* "mecab-node?" #f (mecab-node? node))

    (tagger'destroy)
    ))

(test-end)
