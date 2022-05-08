;; -*- coding:utf-8 -*-
;;
;; dictionary-dependent tests for mecab module <vol.1>
;;

(use gauche.test)

(test-start "mecab: dictionary-dependent tests <vol.1>")
(use text.mecab)
(test-module 'text.mecab)

(define m (mecab-new2 ""))

(test* "mecab-sparse-tostr"
       "太郎\t名詞,固有名詞,人名,名,*,*,太郎,タロウ,タロー\n\
        は\t助詞,係助詞,*,*,*,*,は,ハ,ワ\n\
        次郎\t名詞,固有名詞,人名,名,*,*,次郎,ジロウ,ジロー\n\
        が\t助詞,格助詞,一般,*,*,*,が,ガ,ガ\n\
        持っ\t動詞,自立,*,*,五段・タ行,連用タ接続,持つ,モッ,モッ\n\
        て\t助詞,接続助詞,*,*,*,*,て,テ,テ\n\
        いる\t動詞,非自立,*,*,一段,基本形,いる,イル,イル\n\
        本\t名詞,一般,*,*,*,*,本,ホン,ホン\n\
        を\t助詞,格助詞,一般,*,*,*,を,ヲ,ヲ\n\
        花\t名詞,一般,*,*,*,*,花,ハナ,ハナ\n\
        子\t名詞,接尾,一般,*,*,*,子,コ,コ\n\
        に\t助詞,格助詞,一般,*,*,*,に,ニ,ニ\n\
        渡し\t動詞,自立,*,*,五段・サ行,連用形,渡す,ワタシ,ワタシ\n\
        た\t助動詞,*,*,*,特殊・タ,基本形,た,タ,タ\n\
        。\t記号,句点,*,*,*,*,。,。,。\n\
        EOS\n"
       (mecab-sparse-tostr m "太郎は次郎が持っている本を花子に渡した。"))

(mecab-destroy m)

(test-end :exit-on-failure #t)
