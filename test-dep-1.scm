;; -*- coding:euc-jp -*-
;;
;; dictionary-dependent tests for mecab module <vol.1>
;;

(use gauche.test)

(test-start "mecab: dictionary-dependent tests <vol.1>")
(use text.mecab)
(test-module 'text.mecab)

(define m (mecab-new2 ""))

(test-section "mecab-sparse-tostr")
(test* "mecab-sparse-tostr" #f
       (mecab-sparse-tostr m "��Ϻ�ϼ�Ϻ�����äƤ����ܤ�ֻҤ��Ϥ�����"))
(test* "mecab-strerror" #t (string? (mecab-strerror m)))

(test* "mecab-sparse-tostr"
       "��Ϻ	̾��,��̾,*,*,��Ϻ,����,*\n\
        ��	����,������,*,*,��,��,*\n\
        ��Ϻ	̾��,��̾,*,*,��Ϻ,����,*\n\
        ��	����,�ʽ���,*,*,��,��,*\n\
        ���ä�	ư��,*,�Ҳ�ư�쥿��,����Ϣ�ѥƷ�,����,��ä�,��ɽɽ��:����\n\
        ����	������,ư����������,�첻ư��,���ܷ�,����,����,*\n\
        ��	̾��,����̾��,*,*,��,�ۤ�,�����ɤ�:�� ��ɽɽ��:��\n\
        ��	����,�ʽ���,*,*,��,��,*\n\
        �ֻ�	̾��,��̾,*,*,�ֻ�,�Ϥʤ�,*\n\
        ��	����,�ʽ���,*,*,��,��,*\n\
        �Ϥ���	ư��,*,�Ҳ�ư�쥵��,����,�Ϥ�,�錄����,��°ư�����ʴ��ܡ� ��ɽɽ��:�Ϥ�\n\
        ��	�ü�,����,*,*,��,��,*\n\
        EOS\n"
       (mecab-sparse-tostr m "��Ϻ�ϼ�Ϻ�����äƤ����ܤ�ֻҤ��Ϥ�����"))

(mecab-destroy m)

(test-end)
