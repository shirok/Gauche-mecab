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
       (mecab-sparse-tostr m "太郎は次郎が持っている本を花子に渡した。"))
(test* "mecab-strerror" #t (string? (mecab-strerror m)))

(test* "mecab-sparse-tostr"
       "太郎	名詞,人名,*,*,太郎,たろう,*\n\
        は	助詞,副助詞,*,*,は,は,*\n\
        次郎	名詞,人名,*,*,次郎,じろう,*\n\
        が	助詞,格助詞,*,*,が,が,*\n\
        持って	動詞,*,子音動詞タ行,タ系連用テ形,持つ,もって,代表表記:持つ\n\
        いる	接尾辞,動詞性接尾辞,母音動詞,基本形,いる,いる,*\n\
        本	名詞,普通名詞,*,*,本,ほん,漢字読み:音 代表表記:本\n\
        を	助詞,格助詞,*,*,を,を,*\n\
        花子	名詞,人名,*,*,花子,はなこ,*\n\
        に	助詞,格助詞,*,*,に,に,*\n\
        渡した	動詞,*,子音動詞サ行,タ形,渡す,わたした,付属動詞候補（基本） 代表表記:渡す\n\
        。	特殊,句点,*,*,。,。,*\n\
        EOS\n"
       (mecab-sparse-tostr m "太郎は次郎が持っている本を花子に渡した。"))

(mecab-destroy m)

(test-end)
