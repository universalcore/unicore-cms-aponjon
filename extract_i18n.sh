#!/bin/bash
find . -name '*.mo' -delete
mkdir -p unicorecmsmama/locale

pot-create -o unicorecmsmama/locale/unicorecmsmama.pot unicorecmsmama/

declare -a arr=(
    "eng_GB" "tha_TH" "ind_ID" "swa_TZ" "swa_KE" "fre_FR" "spa_AR" "spa_CO"
    "spa_MX" "hin_IN" "por_PT" "mal_IN" "guj_IN" "tel_IN" "tam_IN" "mar_IN"
    "ben_IN" "ben_BD" "fil_PH")

for lang in "${arr[@]}"
do
    mkdir -p "unicorecmsmama/locale/""$lang""/LC_MESSAGES"

    if [ ! -f "unicorecmsmama/locale/""$lang""/LC_MESSAGES/unicorecmsmama.po" ]; then
        msginit -l $lang -i unicorecmsmama/locale/unicorecmsmama.pot -o unicorecmsmama/locale/$lang/LC_MESSAGES/unicorecmsmama.po
    fi

    msgmerge --update unicorecmsmama/locale/$lang/LC_MESSAGES/unicorecmsmama.po unicorecmsmama/locale/unicorecmsmama.pot
    msgfmt unicorecmsmama/locale/$lang/LC_MESSAGES/*.po -o unicorecmsmama/locale/$lang/LC_MESSAGES/unicorecmsmama.mo
done
